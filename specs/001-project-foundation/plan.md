# Implementation Plan: Project Foundation

**Branch**: `001-project-foundation` | **Date**: 2026-08-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-project-foundation/spec.md`

## Summary

Stand up the Flutter shell for ProductCam: a feature-first Clean Architecture skeleton for seven product areas, a closed failure type wired to localized text, English/Vietnamese localization driven entirely by the system locale, two side-by-side build flavors, portrait lock on all devices, just-in-time permissions, and a CI gate that fails on formatting drift, analyzer warnings, hardcoded style/text, or failing tests.

The approach is deliberately dependency-light and codegen-free: Dart 3 sealed classes for `Result`/`AppFailure` (no FP package), the SDK's own `gen-l10n` for translations, `flutter_bloc` for presentation state, `go_router` for a declarative route table, and `get_it` used **only** inside the composition root. Flavors are carried by separate entry points plus Gradle product flavors and iOS xcconfigs, so an optimized development build remains possible — a hard requirement for the on-device performance work that starts in Spec #003.

No camera, no native segmentation, no persistence, no visual design. Those are Specs #002/#002b, #003, #007 and #001b respectively.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (pinned — see [research.md](./research.md) R1; current stable 3.47.0 deliberately not adopted during bootstrap)

**Primary Dependencies**: flutter_bloc 9.1.1 · equatable 2.1.0 · get_it 9.2.1 · go_router 17.5.0 · intl 0.20.3 · permission_handler 13.0.1 · flutter_localizations (SDK). Dev: flutter_lints 6.0.0 · bloc_test 10.0.0 · mocktail 1.0.5

**Storage**: None. This spec persists nothing — no database, no preferences, no files. Local storage arrives in Spec #007.

**Testing**: flutter_test + bloc_test + mocktail. Golden tests intentionally deferred to Spec #001b (nothing visual is defined yet).

**Target Platform**: iOS 17.0+ and Android API 24+, phones and tablets, **portrait only on every device**

**Project Type**: Mobile application, single Flutter codebase, no backend

**Performance Goals**: Cold start to a rendered first screen under 2s on a mid-range Android device (SC-009). This is a regression tripwire, not a tuned target — the binding real-time budgets belong to Spec #003.

**Constraints**: Fully offline — no network call at runtime, including font, model, analytics, or crash-reporting fetches (Principle VI). No codegen/build_runner step. No third-party DI container behaviour outside the composition root.

**Scale/Scope**: 7 product areas as empty screens, ~9 failure conditions, 2 locales, 2 flavors, 2 platforms. No user-visible product capability ships in this spec.

## Constitution Check

*GATE: evaluated before Phase 0 and re-evaluated after Phase 1 design.*

Constitution v1.1.1. Each principle is a gate; a plan that cannot pass one must either change or be justified in Complexity Tracking.

| # | Principle | Verdict | How this plan satisfies it |
|---|---|---|---|
| I | Clean Architecture feature-first, no MVVM | **PASS** | `lib/core/` + `lib/features/<area>/{domain,data,presentation}`. Presentation state is a Cubit; no ViewModel layer exists. No UseCase classes — nothing here has multi-step orchestration. The "no cross-feature imports" half of this principle is enforced by `scripts/check_no_cross_feature_imports.sh` in CI, not left to review. |
| II | BLoC & unidirectional state | **PASS** | One Cubit per area, immutable states with `equatable`. `setState` is not used for anything derived from domain. |
| III | Typed failure (Result + AppFailure) | **PASS** | Sealed `AppFailure` covering the full contract catalogue plus permission/storage/export/unknown; sealed `Result<T>`; every variant maps to a localization key. Raw platform text never reaches the UI. |
| IV | Platform-channel contract is the source of truth | **PASS** | One boundary in `lib/core/platform/` carrying channel/method names and payload shapes from contract v0.2.0. No native code, no `Platform.isIOS` branching on behaviour. |
| V | Performance is an architectural constraint | **PASS (mostly N/A)** | No pipeline exists yet. The gate this spec must not fail is enabling future measurement: an optimized development build is buildable (R7), which is what on-device measurement requires. |
| VI | On-device, offline, no accounts, no backend | **PASS** | Zero runtime network calls. Fonts are not fetched — and are not bundled either, because the typography layer is Spec #001b; this spec ships the platform default font deliberately. |
| VII | Design system & theming, zero hardcoded style | **PASS** | No colours, text styles, spacing or durations are authored. `ThemeMode.dark` only. The CI script fails the build if any colour literal appears outside `lib/core/theme/`. |
| VIII | Design fidelity | **PASS (N/A)** | No screen is styled here, so there is nothing to diverge from. Bare placeholders are the explicit instruction so #001b is not pre-empted. |
| IX | No hardcoded display strings | **PASS** | ARB with `en` as template/fallback and `vi` shipped; every visible string including placeholder screen names and semantics labels comes from the generated accessor; CI fails on untranslated messages and on string literals under `lib/features/`. |
| X | No hardcoded config or magic values | **PASS** | Channel/method names, flavor values, and platform floors live in `lib/core/platform/` and `lib/core/config/`. `kDebugMode` is not used to distinguish flavors. |
| XI | Touch, contrast, state not by colour alone | **PARTIAL — deferred by design** | Placeholder screens have no touch targets or state indicators to size. What this spec does own is honoured: semantics labels are localized, and portrait lock is enforced natively so layout constraints are stable. Full compliance is Spec #001b's gate. |
| XII | Testing discipline | **PASS** | Failure→localization mapping test across both locales, plus a launch smoke test. Golden tests deferred with stated reason (nothing visual defined). |
| XIII | Simplicity & YAGNI | **PASS** | No build_runner, no FP package, no codegen DI, no version manager, no storage. Each was considered and rejected with rationale in research.md. |
| XIV | Dependency hygiene | **PASS** | Every version read from pub.dev on 2026-08-14; every package verified to exist; `flutter_localizations` correctly identified as an SDK package. Versions pinned, lockfile committed. |
| XV | Exactly two flavors | **PASS** | `development` + `production` only. Flavor is independent of build mode; production registers no development-only route. |

**Gate result: PASS.** One principle (XI) is partially deferred, and the reason is structural rather than a shortcut: its subject matter — touch sizing, contrast, state indication — does not exist until the design system lands in Spec #001b. Recorded in Complexity Tracking below rather than hidden.

**Post-Phase-1 re-evaluation**: unchanged. The Phase 1 artifacts (data model, contracts, quickstart) introduced no new dependency, no persistence, and no styling, so no gate moved.

## Project Structure

### Documentation (this feature)

```text
specs/001-project-foundation/
├── plan.md              # This file
├── spec.md              # Feature specification (3 clarifications recorded)
├── research.md          # Phase 0 output — 13 decisions, versions verified on pub.dev
├── data-model.md        # Phase 1 output — failure catalogue, config, routes, permissions
├── quickstart.md        # Phase 1 output — how to run and verify every acceptance criterion
├── contracts/           # Phase 1 output
│   ├── platform-channel.md   # Dart-side shape of the native boundary (unimplemented)
│   ├── routes.md             # Route table, incl. the development-only index
│   └── localization-keys.md  # Required ARB keys for both locales
├── checklists/
│   └── requirements.md  # Spec quality checklist (16/16)
└── tasks.md             # Created later by /speckit-tasks — NOT part of this command
```

### Source Code (repository root)

```text
lib/
├── main_development.dart          # entry point — development flavor
├── main_production.dart           # entry point — production flavor
├── app/
│   ├── app.dart                   # root widget: MaterialApp.router, ThemeMode.dark, locales
│   └── composition_root.dart      # the ONLY place get_it is read
├── core/
│   ├── config/
│   │   ├── app_config.dart        # flavor-dependent values (id, display name, dev surfaces)
│   │   └── flavor.dart            # development | production
│   ├── error/
│   │   ├── app_failure.dart       # sealed failure catalogue
│   │   ├── result.dart            # sealed Result<T>
│   │   └── failure_l10n.dart      # AppFailure -> localization key
│   ├── platform/
│   │   ├── segmentation_channel.dart   # channel + method names (contract v0.2.0)
│   │   └── segmentation_dto.dart       # payload shapes — no native call yet
│   ├── permission/
│   │   ├── permission_service.dart     # app-owned interface
│   │   └── permission_service_impl.dart# permission_handler adapter
│   ├── routing/
│   │   └── app_router.dart        # go_router table; dev index registered by dev root only
│   ├── l10n/
│   │   ├── app_en.arb             # template + fallback
│   │   └── app_vi.arb
│   ├── theme/                     # EMPTY in this spec — filled by Spec #001b
│   └── widgets/                   # EMPTY in this spec — filled by Spec #001b
├── features/
│   ├── camera_capture/{domain,data,presentation}/
│   ├── review/{domain,data,presentation}/
│   ├── background_editor/{domain,data,presentation}/
│   ├── batch/{domain,data,presentation}/
│   ├── export/{domain,data,presentation}/
│   ├── history/{domain,data,presentation}/
│   └── settings/{domain,data,presentation}/
└── dev/
    └── navigation_index_page.dart # development build only (FR-022)

test/
├── core/
│   ├── error/failure_l10n_test.dart    # every variant, both locales
│   └── permission/permission_service_test.dart
├── features/camera_capture/…_cubit_test.dart
└── app/app_smoke_test.dart

android/app/build.gradle           # productFlavors: development (.dev suffix), production
android/app/src/main/AndroidManifest.xml   # portrait lock, camera permission
ios/Flutter/Development.xcconfig
ios/Flutter/Production.xcconfig    # bundle id, display name
ios/Runner/Info.plist              # portrait-only incl. iPad, usage descriptions
scripts/check_no_hardcode.sh       # CI gate for Principles VII + IX
scripts/check_no_cross_feature_imports.sh  # CI gate for Principle I / FR-003
scripts/check_l10n.sh              # CI gate for FR-014 (no missing keys)
ios/Podfile                        # iOS deployment target 17.0
ios/Runner/{en,vi}.lproj/InfoPlist.strings # localized usage descriptions
.github/workflows/ci.yml           # format -> analyze -> no-hardcode -> test
.gitignore
l10n.yaml                          # gen-l10n config, template locale = en
analysis_options.yaml              # flutter_lints 6.0.0
```

**Structure Decision**: Feature-first Clean Architecture as ratified in Principle I, with the seven areas mirroring `.claude/screen-inventory.md` one-to-one. Two directories are created **intentionally empty** — `core/theme/` and `core/widgets/` — because Spec #001b owns them; creating them now fixes their location so #001b adds files rather than moving things. The `lib/dev/` directory is scaffolding: it holds only the navigation index, is referenced solely by `main_development.dart`, and is expected to shrink to nothing as later specs give each area a real entry point.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Principle XI partially deferred (touch sizing, contrast, state-not-by-colour-alone) | Its subject matter does not exist yet: placeholder screens have no touch targets, no status indicators, no palette. The parts this spec can own — localized semantics labels, portrait lock — are done. | Inventing interim touch sizes and colours to "comply" would author exactly the hardcoded values Principle VII forbids, and Spec #001b would delete them. Deferring is the compliant choice, not the lazy one. |
| A `lib/dev/` directory with a navigation surface that ships in one flavor | The four flow-only areas cannot be reached without a capture action, which does not exist until Spec #004. Without it, four of seven areas would be unverifiable by hand. | Temporary buttons on the camera screen (rejected: pollutes a production screen and tends to survive to release) or route-only tests with no manual reachability (rejected: nobody would notice a broken screen until #004). Confining it to the development entry point makes shipping it structurally impossible. |
