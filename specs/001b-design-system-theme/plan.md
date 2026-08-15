# Implementation Plan: Design System & Theme

**Branch**: `001b-design-system-theme` | **Date**: 2026-08-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001b-design-system-theme/spec.md`

## Summary

Move the ProductCam design system out of `.claude/design/` and into the app: **196 CSS custom properties across nine token files** become seven Dart token files, exposed through seven `ThemeExtension`s on one locked-dark `ThemeData`; six subset font binaries replace a CDN `@import`; 26 vector icons land behind a single `PcIcon` entry point; and nineteen shared widgets are built so that Specs #004–#008 assemble screens instead of authoring styles.

The approach is deliberately mechanical where it can be and calibrated where it cannot. Most of the port is a literal transcription — a hex string becomes a `Color`, a `px` becomes a `double`, a `cubic-bezier` becomes a `Cubic`. Five constructs have no Flutter equivalent and need a documented substitution rather than a copy: the conic-gradient checkerboard, the `drop-shadow` glows, the `backdrop-filter` blur-plus-saturate, the composed `font:` shorthands, and the `transition` shorthands. One of those five — blur and shadow radii — cannot be transcribed numerically at all, because CSS and Flutter disagree on what a blur radius means; those values get calibrated against the bundle by eye and the calibrated numbers recorded next to the token.

Exactly one new runtime dependency (`flutter_svg`) and zero new dev dependencies. Golden coverage uses Flutter's own `matchesGoldenFile` — the package that used to be the obvious choice for this, `golden_toolkit`, has been discontinued since 2023.

No product capability ships. The seven placeholder areas from Spec #001 gain appearance and nothing else.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 — unchanged from Spec #001 and pinned for the same reason. Golden baselines make the pin load-bearing rather than merely tidy.

**Primary Dependencies**: Unchanged from Spec #001, plus **one addition**: `flutter_svg 2.3.0` (publisher `flutter.dev`, Flutter Favorite, all six platforms). No new dev dependency — see [research.md](./research.md) R6 for why `golden_toolkit` is not adopted.

**Storage**: None. This spec persists nothing. Local storage still arrives in Spec #007.

**Testing**: `flutter_test` with built-in `matchesGoldenFile`, plus a `test/flutter_test_config.dart` that loads the real embedded fonts so goldens show ProductCam's type rather than the test placeholder font. Golden baselines are Linux-authoritative (R6). `bloc_test` and `mocktail` are untouched — this spec adds no bloc.

**Target Platform**: iOS 17.0+ and Android API 24+, phones and tablets, portrait only on every device.

**Project Type**: Mobile application, single Flutter codebase, no backend.

**Performance Goals**: No runtime pipeline exists yet, so there is no frame budget to hit. The two things this spec must not do are inflate the app and allocate on every frame: fonts add **≤ 1.5 MB** installed (SC-008), and token lookup is a `ThemeExtension` read with `const` values, so no `Color`, `TextStyle`, or `BoxShadow` is constructed during paint.

**Constraints**: Fully offline — the CDN `@import` in `tokens/fonts.css` is the one thing in the design bundle that cannot be ported as written (Principle VI). No codegen and no `build_runner`. Locked to `ThemeMode.dark`; no light theme, no runtime switch. Text scaling honoured to 1.3× and capped there. Reduced motion stops every loop.

**Scale/Scope**: 196 token definitions + 5 keyframes → 7 token files, 7 `ThemeExtension`s, 19 shared widgets, 26 icons, 6 font binaries, and **67 golden cases** across the components' documented states. Zero user-visible product capability.

## Constitution Check

*GATE: evaluated before Phase 0 and re-evaluated after Phase 1 design.*

Constitution v1.1.1. Each principle is a gate; a plan that cannot pass one must either change or be justified in Complexity Tracking.

| # | Principle | Verdict | How this plan satisfies it |
|---|---|---|---|
| I | Clean Architecture feature-first, no MVVM | **PASS** | Everything lands in `lib/core/theme/` and `lib/core/widgets/` — shared infrastructure, which is exactly what `core/` is for. No feature folder is touched beyond the theme reaching the seven existing placeholder pages. No domain, no data layer, no ViewModel. |
| II | BLoC & unidirectional state | **PASS (N/A)** | No bloc is added or changed. Component state is widget-local (press, animation controllers) and never derived from domain, so there is nothing for a bloc to own. |
| III | Typed failure | **PASS (N/A)** | Nothing here can fail at runtime in a way the user must be told about. A missing asset is a build-time defect caught by tests, not an `AppFailure`. |
| IV | Platform-channel contract is source of truth | **PASS (N/A)** | No native code, no channel call. `ContourOverlay` takes a `Path` from its caller; the contract's contour payload is Spec #003's problem. |
| V | Performance is an architectural constraint | **PASS** | Token values are `const`, so no allocation during paint. `ContourOverlay` repaints only when its inputs change and lives behind a `RepaintBoundary`. App-size delta is measured and recorded (SC-008), which matters here because Android's model already owns most of the size budget. |
| VI | On-device, offline, no accounts, no backend | **PASS** | The design bundle's `@import` from a font CDN is replaced by six embedded binaries. A test asserts zero network-capable font loading. No package added here can reach the network. |
| VII | Design system & theming, zero hardcoded style | **PASS** | This principle *is* the spec. `lib/core/theme/tokens/` is the only place raw literals appear, and the CI gate is tightened from `lib/core/theme/` to `lib/core/theme/tokens/` to match — the current script is looser than the constitution (R14). |
| VIII | Design fidelity | **PASS** | Every value traces to a named token in the bundle; [contracts/token-catalogue.md](./contracts/token-catalogue.md) is the line-by-line audit that makes "no silent drops" checkable rather than asserted. Where the bundle's own index points at folders that do not exist on disk, the plan points at what does. |
| IX | No hardcoded display strings | **PASS** | Components receive display text as parameters (FR-021) and never read the ARB, so this spec adds no keys and cannot leak a literal. Screens that supply the text are later specs. |
| X | No hardcoded config or magic values | **PASS** | Sizes, durations and stroke widths are tokens, not magic numbers at call sites. The 1.3× text cap and the icon inventory are named constants in the theme layer. |
| XI | Touch, contrast, state not by colour alone | **PASS** | This is the principle Spec #001 deferred, and it is settled here: 44/56/80-in-104 enforced per component and asserted in tests; contour states separated by dash pattern so they survive greyscale (SC-003); reduced motion honoured with state meaning preserved (FR-027a); text scaling capped rather than ignored (FR-015a). Semantics labels are supplied by callers, matching FR-021 — and `semanticsLabel` is a **required** parameter on all three controls that render no visible text (`PcIconButton`, `ShutterButton`, `PcSlider`), so an unnamed control cannot be constructed at all. |
| XII | Testing discipline | **PASS** | Golden tests for every component state — the specific obligation this principle names for the design system. Plus a token-catalogue audit test, `copyWith`/`lerp` tests per extension, and touch-size assertions. Deterministic: no network, no camera, no wall-clock. |
| XIII | Simplicity & YAGNI | **PASS** | One new dependency, chosen over hand-porting 26 icon paths. No codegen, no theme-generation tooling, no component playground app. Components carry no content that belongs to Specs #005/#006 (FR-022). |
| XIV | Dependency hygiene | **PASS** | `flutter_svg 2.3.0` verified on pub.dev on 2026-08-14: exists under that exact name, published by `flutter.dev`, Flutter Favorite, supports both target platforms, no runtime network access. Version pinned, lockfile committed. `golden_toolkit` was checked and rejected because pub.dev marks it discontinued. |
| XV | Exactly two flavors | **PASS (N/A)** | Flavor configuration is untouched. The theme is identical in both, which is correct — a development build that looks different from production would defeat the on-device visual checks. |

**Gate result: PASS.** No principle is deferred and no violation needs justification, so Complexity Tracking below is empty. This is the spec that clears Principle XI's deferral recorded in Spec #001's plan.

**Post-Phase-1 re-evaluation**: unchanged. Phase 1 produced a token catalogue, a component API contract, a data model and a quickstart — all documentation. No dependency, persistence, or native surface was introduced, so no gate moved. The one thing Phase 1 sharpened is Principle XIV's evidence: the token catalogue makes the substitution list explicit, which is what keeps Principle VIII checkable at review time.

## Project Structure

### Documentation (this feature)

```text
specs/001b-design-system-theme/
├── plan.md                      # This file
├── spec.md                      # Feature specification (8 clarifications recorded)
├── research.md                  # Phase 0 output — 15 decisions
├── data-model.md                # Phase 1 output — token groups, component states
├── quickstart.md                # Phase 1 output — how to verify every success criterion
├── contracts/                   # Phase 1 output
│   ├── token-catalogue.md       # All 196 source tokens → Dart, incl. substitutions
│   └── component-api.md         # The 19 shared widgets: inputs, states, touch rules
├── checklists/
│   └── requirements.md          # Spec quality checklist (16/16)
└── tasks.md                     # Created later by /speckit-tasks — NOT part of this command
```

### Source Code (repository root)

```text
lib/core/theme/
├── tokens/                        # THE ONLY PLACE RAW VISUAL LITERALS MAY APPEAR
│   ├── pc_colors.dart             # 77 colour definitions (ramps + semantic aliases)
│   ├── pc_typography.dart         # 33 — sizes, heights, weights, tracking, 10 composed roles
│   ├── pc_spacing.dart            # 28 — scale, gutters, touch minimums, fixed bands
│   ├── pc_radius.dart             # 9
│   ├── pc_elevation.dart          # 11 — rims, shadows, glows, scrims, chrome blur
│   ├── pc_motion.dart             # 16 — durations, curves, press scales
│   └── pc_contour.dart            # 20 — two-stroke contour, dash patterns, checkerboard
├── extensions/                    # ThemeExtension wrappers — no literals
│   ├── pc_colors.dart             # PcColors
│   ├── pc_typography.dart         # PcTypography
│   ├── pc_spacing.dart            # PcSpacing
│   ├── pc_radius.dart             # PcRadius
│   ├── pc_elevation.dart          # PcElevation
│   ├── pc_motion.dart             # PcMotion
│   └── pc_contour.dart            # PcContour
├── pc_theme.dart                  # buildPcTheme() — one dark ThemeData, 7 extensions registered
└── pc_context.dart                # context.pcColors, context.pcSpacing, …

lib/core/widgets/
├── core/          pc_button · pc_icon_button · pc_chip · pc_badge · pc_sheet · pc_icon · pc_slider
├── camera/        contour_overlay · shutter_button · mode_toggle · readout
├── editor/        checker_surface · background_swatch_picker
├── batch/         batch_thumb · progress_trace
├── feedback/      edge_notice · pc_toast
└── shell/         screen_header · thumb_band

lib/app/app.dart                   # ThemeData.dark() → buildPcTheme(); text-scale clamp added

assets/
├── fonts/                         # 6 subset TTF binaries (Latin + Vietnamese)
└── icons/                         # 26 SVG glyphs, the design's working vocabulary only

test/
├── flutter_test_config.dart       # loads the real fonts so goldens show real type
├── core/theme/
│   ├── token_catalogue_test.dart  # every catalogued token is reachable — guards SC-001
│   └── extensions_test.dart       # copyWith / lerp per extension
└── core/widgets/
    ├── <component>_test.dart      # behaviour + touch-size assertions
    └── goldens/                   # committed reference images

scripts/
├── check_no_hardcode.sh           # tightened: lib/core/theme/ → lib/core/theme/tokens/
└── update_goldens.sh              # regenerate baselines in the authoritative environment
```

**Structure Decision**: Everything lands in `lib/core/`, which Spec #001 already established as the home for cross-feature infrastructure. The split between `tokens/` and `extensions/` is not decoration — it is what makes the CI gate expressible as a single path prefix, and therefore what makes Principle VII enforceable instead of merely stated. Widget subfolders mirror the design bundle's own grouping (`core`/`camera`/`editor`/`batch`/`feedback`) so a reviewer can hold the bundle and the source tree side by side; `shell/` is added for the two elements that come from the bundle's screen shell rather than its primitive set.

## Complexity Tracking

> No Constitution Check violations. This section is intentionally empty.
