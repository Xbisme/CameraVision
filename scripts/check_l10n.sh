#!/usr/bin/env bash
# Enforces spec 001 FR-014: no key may be missing from any locale.
#
# The English fallback is a safety net, not a workflow — a key present in
# app_en.arb but absent from app_vi.arb ships English text to a Vietnamese user.
#
# The report path is configured in l10n.yaml, NOT passed on the command line:
# when l10n.yaml exists, `flutter gen-l10n` ignores CLI arguments entirely.
set -uo pipefail

REPORT="build/untranslated_messages.json"
rm -f "$REPORT"

if ! flutter gen-l10n >/dev/null 2>&1; then
  echo "✗ flutter gen-l10n failed"
  flutter gen-l10n
  exit 1
fi

if [ -f "$REPORT" ] && [ "$(tr -d '[:space:]' < "$REPORT")" != "{}" ]; then
  echo "✗ Missing translations (FR-014):"
  sed 's/^/    /' "$REPORT"
  echo
  echo "  Every key must exist in BOTH app_en.arb and app_vi.arb."
  exit 1
fi

echo "✓ all keys present in every locale"
exit 0
