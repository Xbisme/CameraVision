#!/usr/bin/env bash
# Enforces Constitution Principles VII (no hardcoded style) and IX (no hardcoded text).
#
# Colours, text styles, spacing and durations belong in lib/core/theme/ only.
# User-facing strings belong in ARB only.
#
# This is a tripwire, not a proof: it cannot see a colour built at runtime or a
# string assembled from parts. It catches the common case cheaply.
set -uo pipefail

fail=0

report() {
  echo "✗ $1"
  shift
  printf '%s\n' "$@" | sed 's/^/    /'
  fail=1
}

# --- 1. Colour literals outside the theme layer -------------------------------
colours=$(grep -rnE 'Color\(0x|Colors\.' lib/ --include='*.dart' \
  | grep -v '^lib/core/theme/' || true)
if [ -n "$colours" ]; then
  report "Hardcoded colours outside lib/core/theme/ (Principle VII):" "$colours"
fi

# --- 2. Inline text styles and magic durations outside the theme layer --------
styles=$(grep -rnE 'TextStyle\(|Duration\(milliseconds:|Duration\(seconds:' lib/ --include='*.dart' \
  | grep -v '^lib/core/theme/' || true)
if [ -n "$styles" ]; then
  report "Inline text styles or durations outside lib/core/theme/ (Principle VII):" "$styles"
fi

# --- 3. User-visible string literals inside features --------------------------
# Text('...'), Text("..."), and label/title/hint arguments with a literal.
strings=$(grep -rnE "(Text\(|label:|title:|hintText:|semanticsLabel:)[[:space:]]*['\"][^'\"]" \
  lib/features/ lib/dev/ --include='*.dart' 2>/dev/null || true)
if [ -n "$strings" ]; then
  report "Hardcoded user-facing strings — use AppLocalizations (Principle IX):" "$strings"
fi

if [ "$fail" -eq 0 ]; then
  echo "✓ no hardcoded colours, styles or strings"
fi
exit "$fail"
