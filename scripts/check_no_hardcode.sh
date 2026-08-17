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

# The exemption is lib/core/theme/tokens/ — NOT all of lib/core/theme/.
# Constitution VII permits raw literals in the token files only; the
# ThemeExtension wrappers and pc_theme.dart must reference tokens by name.
# Spec 001b research R14: the wider exemption used until then would have let a
# stray literal into an extension and called it a pass.
TOKENS='^lib/core/theme/tokens/'

# --- 1. Colour literals outside the token layer -------------------------------
# The leading boundary matters: a bare `Colors\.` also matches the tail of
# `PcColors.fromTokens()`, which is the correct way to read the palette and
# must not be reported. Only Flutter's own `Colors.` swatch class is a defect.
colours=$(grep -rnE '(^|[^[:alnum:]_])(Color\(0x|Colors\.)' lib/ --include='*.dart' \
  | grep -vE "$TOKENS" || true)
if [ -n "$colours" ]; then
  report "Hardcoded colours outside lib/core/theme/tokens/ (Principle VII):" "$colours"
fi

# --- 2. Inline text styles and magic durations outside the token layer --------
styles=$(grep -rnE 'TextStyle\(|Duration\(milliseconds:|Duration\(seconds:' lib/ --include='*.dart' \
  | grep -vE "$TOKENS" || true)
if [ -n "$styles" ]; then
  report "Inline text styles or durations outside lib/core/theme/tokens/ (Principle VII):" "$styles"
fi

# --- 2b. Discrete measurements outside the token layer ------------------------
# Spacing, sizing and radii must be tokens. Only *standalone* numeric literals
# count: the digit must follow an opening bracket, a colon, a comma or a space.
# Token names carry digits too — `context.pcSpacing.sp5` is the correct way to
# spend a value and must keep passing, or the gate becomes something people
# switch off rather than obey.
# Two shapes, because the opening bracket is consumed by the alternation:
#   1. the number is the first argument   — EdgeInsets.all(13)
#   2. the number appears later in the list — SizedBox(width: 22)
measures=$(grep -rnE '(EdgeInsets\.(all|symmetric|only|fromLTRB)\(|SizedBox\(|BorderRadius\.circular\(|Radius\.circular\()([[:space:]]*[0-9]|[^)]*[[:space:]:,(][0-9])' \
  lib/ --include='*.dart' \
  | grep -vE "$TOKENS" || true)
if [ -n "$measures" ]; then
  report "Hardcoded measurements outside lib/core/theme/tokens/ (Principle VII):" "$measures"
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
