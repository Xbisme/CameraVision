---

description: "Task list for 001-project-foundation"
---

# Tasks: Project Foundation

**Input**: Design documents from `/specs/001-project-foundation/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/](./contracts/)

**Tests**: Test tasks are included because the specification requires them (FR-030: failure→localization mapping across both locales, plus a launch smoke test). Golden tests are deliberately excluded — nothing visual is defined until Spec #001b.

**Organization**: Tasks are grouped by user story so each can be implemented and verified independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on incomplete work)
- **[Story]**: US1–US5, mapping to the user stories in spec.md
- Every task names the exact file path it touches

## Path Conventions

Single Flutter codebase at repository root: `lib/`, `test/`, `android/`, `ios/`, `scripts/`, `.github/`. Structure follows the tree in [plan.md](./plan.md).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Bring the project into existence with the pinned toolchain and the verified dependency set.

- [X] T001 Create the Flutter project in place at repository root with `flutter create --org com.productcam --platforms=ios,android --project-name productcam .`, keeping the existing `.claude/`, `.specify/`, `specs/` and `LICENSE` untouched — note that this generates `README.md`, `.gitignore` and `analysis_options.yaml`, which T002, T005 and T006 then overwrite
- [X] T002 Pin the toolchain to Flutter 3.44.4 / Dart 3.12.2 in `pubspec.yaml` (`environment.sdk`, `environment.flutter`) and document the exact required version in `README.md` per research.md R1
- [X] T003 Add runtime dependencies to `pubspec.yaml` at the versions verified in research.md — flutter_bloc 9.1.1, equatable 2.1.0, get_it 9.2.1, go_router 17.5.0, intl 0.20.3, permission_handler 13.0.1, flutter_localizations (SDK) — then run `flutter pub get` and commit `pubspec.lock`
- [X] T004 [P] Add dev dependencies to `pubspec.yaml` — flutter_lints 6.0.0, bloc_test 10.0.0, mocktail 1.0.5
- [X] T005 [P] Configure the analyzer in `analysis_options.yaml` to include `package:flutter_lints/flutter.yaml` and to treat analyzer warnings as build-failing
- [X] T006 [P] Write `.gitignore` covering `build/`, `.dart_tool/`, `.flutter-plugins*`, `ios/Pods/`, `ios/.symlinks/`, `*.iml`, `.idea/`, `*.g.dart` caches and local env files
- [X] T007 Create the directory skeleton from plan.md under `lib/` — `app/`, `core/{config,error,platform,permission,routing,l10n,theme,widgets}`, `features/<area>/{domain,data,presentation}` for all seven areas, `dev/` — placing `.gitkeep` in `lib/core/theme/` and `lib/core/widgets/` so Spec #001b adds files rather than creating directories
- [X] T008 [P] Write the three repository guard scripts, each exiting non-zero with the offending `file:line` list (research.md R10):
  - `scripts/check_no_hardcode.sh` — colour literals (`Color(0x`, `Colors.`) outside `lib/core/theme/`, and user-visible string literals under `lib/features/` (Principles VII, IX)
  - `scripts/check_no_cross_feature_imports.sh` — any import in `lib/features/<a>/` that reaches into `lib/features/<b>/` where `a != b`, enforcing FR-003 and Principle I
  - `scripts/check_l10n.sh` — runs `gen-l10n` and fails if the untranslated-messages report is non-empty (FR-014)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The shared primitives every user story builds on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T009 [P] Define the `Flavor` enum (`development`, `production`) in `lib/core/config/flavor.dart`
- [X] T010 Define the immutable `AppConfig` in `lib/core/config/app_config.dart` with `flavor`, `appId`, `displayName`, `showsDeveloperSurfaces`, `verboseLogging`, and named constructors for each flavor per data-model.md §3 — no `kDebugMode` anywhere in this file
- [X] T011 [P] Define `sealed class Result<T>` with `Success<T>` and `FailureResult<T>` in `lib/core/error/result.dart` per data-model.md §2
- [X] T012 Create the root widget in `lib/app/app.dart` — `MaterialApp.router` with `themeMode: ThemeMode.dark`, no authored colours, text styles, spacing or durations (Principle VII), taking `AppConfig` by constructor
- [X] T013 Create the composition root in `lib/app/composition_root.dart` registering dependencies in `get_it`, taking `AppConfig` as input; this is the **only** file permitted to read the locator (research.md R3)
- [X] T014 Create both entry points — `lib/main_development.dart` and `lib/main_production.dart` — each building `AppConfig` for its flavor, calling the composition root, and running the app
- [X] T015 Configure `gen-l10n` in `l10n.yaml` with `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`, `untranslated-messages-file` enabled, and create `lib/core/l10n/app_en.arb` holding the seven area-name keys from contracts/localization-keys.md
- [X] T016 [P] Lock portrait natively — `android:screenOrientation="portrait"` in `android/app/src/main/AndroidManifest.xml`, and portrait-only `UISupportedInterfaceOrientations` **including the iPad key** in `ios/Runner/Info.plist` (research.md R8, FR-031)
- [X] T017 Call `SystemChrome.setPreferredOrientations` for portrait before `runApp` in both entry points, so the constraint is explicit in Dart as well as native
- [X] T018 [P] Define the native boundary in `lib/core/platform/segmentation_channel.dart` — channel and method name constants from contracts/platform-channel.md, with **no channel invocation**
- [X] T019 [P] Define the payload shapes `SegmenterInfo`, `PreviewFrameResult`, `CaptureResult` in `lib/core/platform/segmentation_dto.dart` per data-model.md §7, with contour points normalized 0.0–1.0

---

## Phase 3: User Story 1 — The app opens and every area is reachable (Priority: P1)

**Goal**: A walkable shell — camera first, all seven areas reachable in development, no navigation index in production.

**Independent test**: Launch the development build, visit all seven areas via the navigation index and return from each; launch the production build and confirm the index is absent.

- [X] T020 [P] [US1] Create the camera capture placeholder page and its minimal cubit in `lib/features/camera_capture/presentation/`, displaying the localized area name only
- [X] T021 [P] [US1] Create the review placeholder page and minimal cubit in `lib/features/review/presentation/`
- [X] T022 [P] [US1] Create the background editor placeholder page and minimal cubit in `lib/features/background_editor/presentation/`
- [X] T023 [P] [US1] Create the batch placeholder page and minimal cubit in `lib/features/batch/presentation/`
- [X] T024 [P] [US1] Create the export placeholder page and minimal cubit in `lib/features/export/presentation/`
- [X] T025 [P] [US1] Create the history placeholder page and minimal cubit in `lib/features/history/presentation/`
- [X] T026 [P] [US1] Create the settings placeholder page and minimal cubit in `lib/features/settings/presentation/`
- [X] T027 [US1] Build the `go_router` table in `lib/core/routing/app_router.dart` with the seven routes from contracts/routes.md, `/` as the launch route, accepting a flag for whether developer routes are registered
- [X] T028 [US1] Create the development navigation index page in `lib/dev/navigation_index_page.dart` listing all seven areas by their **localized** names and navigating to each
- [X] T029 [US1] Register the `/dev` route from the development composition root only, so the production binary never references `lib/dev/` (FR-018, FR-022)
- [X] T030 [US1] Add entry points from the camera area to settings and history in `lib/features/camera_capture/presentation/` — the one deliberate exception to "placeholders show only their own name", because without them those two areas would be unreachable in the production build (spec Assumptions, FR-022)
- [X] T031 [P] [US1] Write the launch smoke test in `test/app/app_smoke_test.dart` asserting the app builds and renders the camera area first with no permission prompt
- [X] T032 [P] [US1] Write a router test in `test/core/routing/app_router_test.dart` asserting the production route table contains **no** `/dev` entry, the development table does, and that leaving an area and returning restores the prior navigation position (US1 acceptance scenario 4)

**Checkpoint**: Seven areas walkable in development; production shows no index.

---

## Phase 4: User Story 2 — The app speaks the user's language (Priority: P1)

**Goal**: Vietnamese on Vietnamese devices, English everywhere else, with no untranslated fragment anywhere.

**Independent test**: Switch the device between Vietnamese, English and a third language, relaunching each time, and walk all seven areas.

- [X] T033 [US2] Create `lib/core/l10n/app_vi.arb` with the Vietnamese area names, taking the wording from the design bundle (`.claude/design/`)
- [X] T034 [US2] Author the English area names in `lib/core/l10n/app_en.arb` to the product voice — short declarative, no marketing adjectives, no exclamation marks — rather than translating the Vietnamese (spec Assumptions)
- [X] T035 [US2] Wire `localizationsDelegates` and `supportedLocales: [en, vi]` in `lib/app/app.dart`, with **no locale override and no stored preference**, so resolution is entirely the platform's (FR-032)
- [X] T036 [P] [US2] Add the accessibility label keys `a11yBack` and `a11yDevNavigationIndex` to both ARB files per contracts/localization-keys.md, and use them in `lib/dev/navigation_index_page.dart` and the shared back control
- [X] T037 [P] [US2] Write a locale resolution test in `test/core/l10n/locale_resolution_test.dart` asserting `vi` renders Vietnamese, `en` renders English, and an unsupported locale falls back to English
- [X] T038 [US2] Verify `scripts/check_l10n.sh` (created in T008) fails when a key is present in `app_en.arb` but missing from `app_vi.arb`, by removing one key temporarily and confirming a non-zero exit — this is what keeps the English fallback a safety net rather than a habit (FR-014)

**Checkpoint**: Both languages complete across all seven areas; a missing key fails the build.

---

## Phase 5: User Story 3 — Permission requests are honest and never dead-end (Priority: P2)

**Goal**: Nothing asked at launch; camera asked when needed; every denial path ends somewhere usable.

**Independent test**: Fresh install, then exercise grant, deny, permanent-deny, and revoke-while-backgrounded.

- [X] T039 [P] [US3] Define the app-owned permission abstraction in `lib/core/permission/permission_service.dart` — `AppPermission` (`camera`, `photoLibrary`) and `PermissionStatus` (`granted`, `denied`, `permanentlyDenied`, `restricted`) per data-model.md §5
- [X] T040 [US3] Implement the adapter in `lib/core/permission/permission_service_impl.dart` over `permission_handler`, mapping its statuses onto the four app statuses and exposing an open-system-settings action
- [X] T041 [US3] Register the permission service in `lib/app/composition_root.dart` and inject it into the camera capture cubit by constructor
- [X] T042 [US3] Implement the just-in-time camera permission flow in `lib/features/camera_capture/presentation/` — requested only on the action that needs it, never on route entry (FR-023)
- [X] T043 [US3] Handle the denial paths in the camera area — `denied` offers a retry, `permanentlyDenied` offers a route to system settings, `restricted` explains without offering a settings route that cannot help
- [X] T044 [US3] Re-read permission status on app resume in `lib/features/camera_capture/presentation/`, never caching across a background cycle, so revocation in system settings is detected on return
- [X] T045 [P] [US3] Add the permission copy keys from contracts/localization-keys.md to `app_en.arb` and `app_vi.arb`, with reasons matching what the app actually does (FR-024)
- [X] T046 [P] [US3] Declare `NSCameraUsageDescription` and `NSPhotoLibraryAddUsageDescription` in `ios/Runner/Info.plist` and the camera permission in `android/app/src/main/AndroidManifest.xml`; localize the iOS strings by adding English and Vietnamese to the Xcode project's localizations and creating `ios/Runner/en.lproj/InfoPlist.strings` and `ios/Runner/vi.lproj/InfoPlist.strings` — note this is iOS's own mechanism, separate from ARB (contracts/localization-keys.md)
- [X] T047 [P] [US3] Write permission tests in `test/core/permission/permission_service_test.dart` and a camera cubit test in `test/features/camera_capture/camera_capture_cubit_test.dart` covering all four statuses with `mocktail` doubles

**Checkpoint**: No launch prompt; all four permission outcomes end on a usable screen without a crash.

---

## Phase 6: User Story 4 — Two builds of the app coexist on one device (Priority: P2)

**Goal**: Development and production installable side by side, distinguishable by name, with an optimized development build possible.

**Independent test**: Install both on one physical Android device; confirm two entries, both launch, and neither replaces the other.

- [X] T048 [US4] Add `productFlavors` for `development` (with `applicationIdSuffix ".dev"`) and `production` in `android/app/build.gradle`, plus per-flavor display names, and set `minSdkVersion 24` (FR-019, FR-020)
- [X] T049 [US4] Create `ios/Flutter/Development.xcconfig` and `ios/Flutter/Production.xcconfig` supplying bundle identifier and display name, and add one Xcode scheme per flavor
- [X] T050 [US4] Set the iOS deployment target to 17.0 in `ios/Podfile` and the Xcode project, so builds below the ratified floor are impossible (FR-019)
- [ ] T051 [US4] (Android only — iOS equivalent already verified: release build of the development flavor produces com.productcam.app.dev) Verify the optimized development build with `flutter build apk --release --flavor development -t lib/main_development.dart` and confirm `showsDeveloperSurfaces` stays true — the concrete proof that flavor is independent of build mode (FR-017)
- [ ] T052 [US4] Verify on a physical Android device that both flavors install simultaneously and appear as "ProductCam" and "ProductCam Dev", recording the result in the PR (FR-016, SC-005)

**Checkpoint**: Two named builds coexisting on one device; optimized development build runs.

---

## Phase 7: User Story 5 — Failures are explained, never dumped (Priority: P3)

**Goal**: Every failure the app can represent reaches the user as a localized sentence.

**Independent test**: Exercise every failure variant through its test double and confirm a localized message in both languages.

- [X] T053 [US5] Define `sealed class AppFailure` with all eleven variants from data-model.md §1 in `lib/core/error/app_failure.dart`, covering the full contract error catalogue plus permission, storage, export and unknown
- [X] T054 [US5] Implement the `AppFailure` → localization key mapping in `lib/core/error/failure_l10n.dart` using an exhaustive `switch`, so adding a variant fails to compile until it is handled
- [X] T055 [P] [US5] Add the eleven failure message keys to `app_en.arb` and `app_vi.arb` per contracts/localization-keys.md, describing imperfect output as *complex* rather than as an *error* and never blaming the user
- [X] T056 [US5] Map native error codes to `AppFailure` variants in `lib/core/platform/segmentation_channel.dart` per the mapping table in contracts/platform-channel.md, with unrecognized codes becoming `Unknown(cause)` and the cause never rendered (FR-008)
- [X] T057 [P] [US5] Write the exhaustive mapping test in `test/core/error/failure_l10n_test.dart` iterating **every** `AppFailure` variant and asserting a non-empty message resolves in both `en` and `vi` (FR-030, SC-004)

**Checkpoint**: Every failure variant has human text in both languages, enforced by a test.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [X] T058 Create the CI workflow in `.github/workflows/ci.yml` using `subosito/flutter-action` **pinned to Flutter 3.44.4**, running format check → analyze → `scripts/check_no_hardcode.sh` → `scripts/check_no_cross_feature_imports.sh` → `scripts/check_l10n.sh` → `flutter test` (research.md R11)
- [X] T059 Verify the CI gate actually fails by deliberately introducing, one at a time and reverting each: formatting drift, an analyzer warning, a hardcoded colour, a cross-feature import, a key missing from `app_vi.arb`, and a failing test (SC-008, FR-003, FR-014)
- [ ] T060 Walk the full [quickstart.md](./quickstart.md) verification on real devices and record the cold-start figure **together with the exact device model and OS version** in the PR (SC-009)
- [X] T061 [P] Update `.claude/project-context.md` Current Focus to reflect Spec #001 landing, per the Per-Spec Hygiene checklist in `.claude/dev-workflow.md`
- [X] T062 [P] Update the status of Spec #001 in `.claude/sdd-roadmap.md`
- [X] T063 [P] Add the Spec #001 entry to `.claude/changelog.md` in the documented format

---

## Dependencies

**Phase order**: Setup → Foundational → US1 → US2 → US3 → US4 → US5 → Polish

**Cross-story dependencies** — stated plainly rather than pretending every story is free-standing:

- **US1 depends on Foundational T015** for the area-name keys its placeholder pages display. The ARB pipeline and English template live in Foundational precisely so US1 is not blocked on the whole of US2.
- **US1 depends on Foundational T010/T014** (`AppConfig` and the two entry points) for the development-only route gating. What US4 adds is the *platform* configuration that makes the two builds installable side by side.
- **US2 completes what Foundational T015 started** — the second language, the resolution rules, and the missing-key gate.
- **US3 and US4 are independent of each other** and can proceed in parallel once US1 exists.
- **US5 is independent of US2's area names** but shares the ARB files, so T055 touches the same two files as T033/T034/T045 — sequence these, do not parallelize across stories.
- **T056 depends on T053** (the variants must exist before native codes map onto them).

## Parallel Execution Opportunities

- **Phase 1**: T004, T005, T006, T008 in parallel after T003.
- **Phase 2**: T009, T011, T016, T018, T019 in parallel; T010, T012, T013, T014, T017 are sequential because they touch shared wiring.
- **Phase 3**: T020–T026 are seven independent files — the widest parallel block in the spec. T031 and T032 in parallel afterwards.
- **Phase 5**: T045, T046, T047 in parallel after T044.
- **Phase 8**: T061, T062, T063 in parallel.

**Do not parallelize** any two tasks that write `app_en.arb` or `app_vi.arb` (T033, T034, T036, T045, T055) — same files, guaranteed conflict.

## Implementation Strategy

**MVP = Phase 1 + Phase 2 + US1.** That yields an installable app that launches to the camera area and walks all seven areas — the first thing worth demonstrating, and the point at which the seven-area structure is proven rather than assumed.

**Then, in order of what de-risks most:**

1. **US2** immediately after US1, while there are only seven strings. Retrofitting localization after screens accumulate is the expensive path, and it is exactly the mistake the ratified rules exist to prevent.
2. **US4** next, because side-by-side installs are the precondition for the on-device performance measurement every later spec depends on.
3. **US3**, which needs real devices and physical permission states to verify properly.
4. **US5** last — it is defined and tested here, but nothing produces the six contract-derived failures until Specs #002/#002b/#004 exist.

**A note carried from planning**: the native boundary (T018, T019, T056) is shaped from platform channel contract **v0.2.0, still a draft**. Spec #000 has not frozen it. Nothing consumes these types yet, so a contract change costs a rename in one directory — but #000 must freeze before Spec #002/#002b begin.
