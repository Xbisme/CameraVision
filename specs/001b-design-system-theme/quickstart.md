# Quickstart: Verifying Design System & Theme

**Spec**: [spec.md](./spec.md) · **Plan**: [plan.md](./plan.md) · **Date**: 2026-08-14

How to run this spec's work and prove every success criterion. One section per criterion, in the order a reviewer would actually walk them.

## Prerequisites

- Flutter **3.44.4** / Dart **3.12.2** exactly (`flutter --version`). The pin is load-bearing here — golden baselines are renderer output (research R1).
- A device or simulator running iOS 17.0+ or Android API 24+.
- For the Android app-size figure only: an Android SDK. **Not installed on the dev machine as of 2026-08-14** — carried over from Spec #001 and still outstanding (research R15).
- `fonttools` for regenerating font subsets. Only needed if the subset ranges change; the committed binaries are the artifact.

```bash
flutter pub get
flutter gen-l10n
```

## Run the app

```bash
flutter run -t lib/main_development.dart --flavor development
```

The seven areas are unchanged from Spec #001 — still placeholders, now wearing the design system. Reach the other six through the development-only navigation index.

## Full check, as CI runs it

```bash
dart format --set-exit-if-changed .
flutter analyze
./scripts/check_no_hardcode.sh              # tightened to lib/core/theme/tokens/ (research R14)
./scripts/check_no_cross_feature_imports.sh
./scripts/check_l10n.sh
flutter test                                 # includes goldens on Linux
```

Locally on macOS, golden tests are excluded by default and run on CI instead:

```bash
flutter test --exclude-tags golden           # what a macOS dev runs day to day
```

This is a deliberate trade, not an oversight — see research R6. **Golden failures surface on the pull request, not on your machine.**

---

## SC-001 — Every source token is ported or explained

```bash
flutter test test/core/theme/token_catalogue_test.dart
```

Asserts the count and that every name in [contracts/token-catalogue.md](./contracts/token-catalogue.md) resolves. Then walk the catalogue by hand against the nine CSS files: **196 properties, zero unexplained.** The test cannot tell you a value is *correct* — only that it exists. Correctness is SC-006.

## SC-002 — One definition change moves everything

Pick three tokens of different kinds — say `--mint-500`, `--sp-6`, `--dur-base`. Change each in `lib/core/theme/tokens/`, hot-restart, and walk all seven areas.

**Pass**: every surface using that token moves together. **Fail**: anything is left behind — that is a hardcoded literal the CI gate did not catch.

## SC-003 — The contour survives any background

```bash
flutter test test/core/widgets/contour_overlay_test.dart
```

Twelve goldens: three states × four reference backgrounds (white studio paper, warm cardboard, black leather, backlit window). Then open the three greyscale stills and, without seeing the colour, name each state from its dash pattern alone. **3 out of 3 or it fails.**

Also confirm by eye that `review` reads as a hint, not a failure: amber, dotted, `scissors`. No red, no triangle, no exclamation mark.

## SC-004 — Vietnamese renders offline

1. Put the device in **airplane mode before first launch**.
2. Launch, set the device language to Vietnamese.
3. Display the diacritic reference string, including the uppercase mono badges `XONG` and `CẦN XEM LẠI`, and the đồng sign `₫`.

**Pass**: zero substituted or missing glyphs, in both the prose and the mono faces. The mono face matters most — it is the one where a missing Vietnamese subset would go unnoticed until a badge appears (research R4).

Confirm no font is fetched:

```bash
grep -rn "fonts.googleapis\|@import\|http" lib/ pubspec.yaml
```

Must return nothing outside comments.

## SC-005 — Every component state has a reference image

```bash
flutter test --tags golden
```

**67 golden cases across 19 components** — see [contracts/component-api.md](./contracts/component-api.md) for the per-component breakdown.

To prove the check actually bites, nudge one component's padding by 2px and re-run. It must fail and show what changed. Revert.

To refresh baselines after an intended change, use the `update-goldens` CI job (`workflow_dispatch`) — **not** `--update-goldens` on your machine, which would write macOS-rendered bytes into a Linux-authoritative baseline set.

## SC-006 — Components match the design bundle

Open the bundle prototype beside the reference images:

- `.claude/design/project/ProductCam App.html` — click-through, seven screens
- `.claude/design/project/pc-screens.jsx` — Camera · Kết quả · Lịch sử · Cài đặt

Compare fixed bands (56 header, 132 thumb band, 16 gutter, 6 grid gap), touch sizes, corner radii, and the 1.75 icon stroke.

Note the bundle's `readme.md` index names `components/`, `guidelines/` and `ui_kits/` folders — **those are not on disk**; the sources are compiled into `_ds_bundle.js`. The two files above are the readable visual references.

## SC-007 — Touch minimums hold

```bash
flutter test test/core/widgets/
```

Every interactive component asserts its rendered **hit area**, not its painted size — a 24px icon inside a 44px target passes; a 44px-looking button with a 30px hit area fails. The shutter asserts all three: 80 visible, 104 hit, and nothing tappable within 12px.

## SC-008 — Fonts cost ≤ 1.5 MB

```bash
flutter build ios --release --flavor development
flutter build apk --release --flavor development   # needs the Android SDK
ls -la assets/fonts/
```

Compare installed size against the Spec #001 baseline, **per platform** — the two do not compress assets identically. Record the delta and the six per-file sizes in the PR.

If Vietnamese coverage cannot fit inside 1.5 MB, the budget is what gets revisited, not the coverage (spec Assumptions).

## SC-009 — A screen can be built with zero authored values

Assemble one scratch screen from the shared kit only. **Pass**: no colour, text size, spacing value, radius or duration is written anywhere in it. Delete the scratch screen afterwards — it is proof, not a deliverable.

## SC-010 — The gates reject drift

```bash
# 1. Hardcoded colour in a feature
echo '  final c = const Color(0xFFFF0000);' >> lib/features/settings/presentation/settings_page.dart
./scripts/check_no_hardcode.sh          # must fail and name the file
git checkout lib/features/

# 2. A literal inside the theme layer but outside tokens/
echo '  static const x = Color(0xFF00FF00);' >> lib/core/theme/pc_theme.dart
./scripts/check_no_hardcode.sh          # must ALSO fail — this is what R14 tightened
git checkout lib/core/theme/
```

The second case is the one that matters. Before the tightening in research R14, the gate exempted all of `lib/core/theme/` and would have passed it.

## SC-011 — No capability was added

Walk all seven areas. There must still be **no camera, no cutout, no export, no new screen** — only appearance. If anything became functional, this spec overran into #003 or #004.

## SC-012 — Layout holds at 1.3× text

Set the device text size to maximum, then walk all seven areas plus a screen built from the shared kit.

**Pass**: text grows to 1.3× and stops there; no label clips, truncates unintentionally, or overlaps; the header still measures 56 and the thumb band still measures 132.

## Reduced motion (FR-027a)

Turn on the system's reduce-motion setting and open a screen with a contour and a `ProgressTrace`.

**Pass**: the marching dashes stop, the lock pulse does not fire, the trace holds a static arc — and the three contour states are still distinguishable from their dash patterns alone. If any two states become identical, the reduced-motion path has thrown away meaning rather than motion.

---

## Definition of Done

- [ ] `dart format`, `flutter analyze`, all three guard scripts, and `flutter test` pass on CI
- [ ] SC-001 … SC-012 verified as above, on a real device for SC-004, SC-008, SC-012 and reduced motion
- [ ] Token catalogue walked by hand: 196 properties accounted for
- [ ] App-size delta recorded per platform, with the six per-file font sizes
- [ ] 67 golden baselines committed, generated by the CI job
- [ ] `.claude/project-context.md`, `sdd-roadmap.md` and `changelog.md` updated (dev-workflow Per-Spec Hygiene)
- [ ] Any UI divergence from the design recorded in `.claude/decisions/`

**Known carry-overs, to state in the PR rather than leave implied**

- The Android app-size figure needs an Android SDK that is not installed yet. Second spec in a row to need it; it becomes blocking at Spec #002.
- `.claude/dev-workflow.md` and Constitution Principle VIII both point at a `ui_kits/productcam-app/` folder that does not exist on disk. The workflow doc can be fixed directly; the constitution needs an amendment.
