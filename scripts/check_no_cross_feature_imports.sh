#!/usr/bin/env bash
# Enforces Constitution Principle I / spec 001 FR-003:
# a feature MUST NOT reach into another feature's internals.
#
# This rule is the easiest one in the constitution to break by autocomplete, and
# nothing in the Dart analyzer catches it. Anything shared belongs in lib/core/.
set -uo pipefail

fail=0

# Every Dart file under lib/features/, with the feature that owns it.
while IFS= read -r file; do
  owner=$(printf '%s' "$file" | sed -E 's|^lib/features/([^/]+)/.*|\1|')

  # Imported feature names, from either import style. Matching is done on the
  # import target alone — matching the whole grep line would let the file's own
  # path (lib/features/<owner>/...) mask a genuine violation.
  imported=$(grep -oE "import '(package:productcam/features/[a-z_]+|(\.\./)+[a-z_]+)/" "$file" 2>/dev/null \
    | sed -E "s|.*features/([a-z_]+)/|\1|; s|.*/([a-z_]+)/\$|\1|" || true)

  while IFS= read -r target; do
    [ -z "$target" ] && continue
    [ "$target" = "$owner" ] && continue
    # A relative import that climbs out of features/ lands in core/ — allowed.
    [ "$target" = "core" ] && continue
    echo "✗ $file"
    echo "    '$owner' imports feature '$target' (Principle I / FR-003)"
    fail=1
  done <<< "$imported"
done < <(find lib/features -name '*.dart' -type f 2>/dev/null | sort)

if [ "$fail" -eq 0 ]; then
  echo "✓ no cross-feature imports"
else
  echo
  echo "  Anything shared between features belongs in lib/core/."
fi
exit "$fail"
