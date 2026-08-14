# Phase 0 Research: Project Foundation

**Feature**: 001-project-foundation | **Date**: 2026-08-14

All package versions below were read from **pub.dev on 2026-08-14**, and the Flutter/Dart versions from the official release manifest, as required by Constitution Principle XIV (versions come from the official source, never guessed). Nothing here is carried over from another project.

---

## R1 — Flutter and Dart version

**Decision**: Pin the project to the toolchain already installed on the development machine: **Flutter 3.44.4 / Dart 3.12.2**. Record the required version in the repository and make CI use the exact same one.

**Rationale**: Current official stable is Flutter 3.47.0 / Dart 3.13.0, released **2026-08-12 — two days ago**. Every package this spec needs already runs on 3.44.4 (the tightest floor is go_router at Dart ^3.10.0 / Flutter >=3.38.0), so upgrading buys nothing for #001 while adding the risk profile of a brand-new stable. The larger point is that the dev machine and CI must agree: a version mismatch is the classic source of "passes locally, fails in CI" and it is cheapest to nail down before a single line of code exists.

**Alternatives considered**:
- *Adopt 3.47.0 immediately* — attractive for runway, but a two-day-old stable during project bootstrap trades a real risk for a benefit nothing needs yet. Upgrading later is a one-line change plus a CI bump.
- *Leave the version unpinned* — rejected outright; it makes the CI gate (FR-028) meaningless because different runs could use different toolchains.
- *Introduce a version manager (fvm)* — deferred as YAGNI (Principle XIII). One project, one toolchain. Revisit only if a second Flutter project shares the machine.

**Follow-up**: Upgrading to 3.47.x is a deliberate, separately verified change, not a side effect of some other task.

---

## R2 — Presentation state management

**Decision**: `flutter_bloc` **9.1.1** (pulls `bloc` 9.2.1), with `equatable` **2.1.0** for value equality on states.

**Rationale**: Ratified in Principle II — BLoC is the presentation layer and there is no ViewModel. `equatable` matters more than it looks: bloc decides whether to rebuild by comparing states with `==`, so states without value equality either rebuild constantly or fail to rebuild at all. Hand-written `==` for every state is exactly the kind of repeated boilerplate that silently rots.

**Alternatives considered**:
- *Hand-written `==`/`hashCode`* — no dependency, but one forgotten field produces a UI that stops updating, and the bug looks like a bloc bug rather than an equality bug.
- *Freezed (codegen)* — genuinely nice, but drags in `build_runner` and a generation step for seven placeholder screens. Reconsider when real state classes exist (#003 onward), not now.

---

## R3 — Dependency injection

**Decision**: `get_it` **9.2.1**, with **all registrations written by hand in a single composition root**. No `injectable`, no `build_runner`.

**Rationale**: Principle I mandates constructor injection with a manual composition root and forbids reflection-based DI. `get_it` is a service locator, so the discipline is a rule rather than a mechanism: **it is read only in the composition root**, and every class receives its dependencies through its constructor. That keeps blocs testable with plain constructor arguments and no locator setup.

**Alternatives considered**:
- *`injectable` codegen* — removes hand-written registrations at the cost of a code-generation step and annotations spread across the codebase; with roughly a dozen registrations this is pure overhead.
- *No container at all, pure manual wiring* — genuinely viable today and arguably purest, but the wiring becomes unwieldy once repositories, isolates, and the platform boundary arrive (#003+).

**Risk to watch in review**: `get_it` makes it easy to call the locator from anywhere. Any read outside the composition root is a review rejection.

---

## R4 — Navigation

**Decision**: `go_router` **17.5.0** (maintained by the Flutter team in `flutter/packages`). Declarative route table, with the development-only navigation index registered as a route that exists only in the development composition root.

**Rationale**: The clarified requirement (FR-022) is that a navigation index exists in development and is **absent** from production. With a declarative route table, "absent" means the route is never registered — a structural guarantee, not a hidden widget. Raw `Navigator` would express the same thing as scattered conditionals.

**Alternatives considered**:
- *Raw `Navigator` 1.0* — no dependency, but the dev-only route becomes an `if` at every push site.
- *`auto_route`* — codegen again, and it solves problems (deep links, guards) this app does not have.

**Constraint noted**: go_router 17.5.0 requires Dart ^3.10.0 and Flutter >=3.38.0 — satisfied by the R1 pin, and the reason R1 cannot drop below Flutter 3.38.

---

## R5 — Localization

**Decision**: Flutter's **built-in `gen-l10n`** (`flutter_localizations` from the SDK + ARB files + `intl` **0.20.3**). `en` is the template and fallback locale; `vi` is the second shipped locale. No third-party localization package.

**Rationale**: Principle XIV prefers first-party when capability is equivalent, and here it is better than equivalent: `gen-l10n` is part of the SDK, generates a typed accessor (so a missing key is a compile error, not a runtime blank), and needs no extra dependency. `flutter_localizations` is an SDK package and correctly has no pub.dev entry.

**How the two clarified language rules are enforced**:
- *System-only language* (FR-032): the app supplies `supportedLocales: [en, vi]` and no locale override, so resolution is entirely the platform's. Nothing is stored — consistent with this spec having no persistence at all.
- *No missing keys* (FR-014): `gen-l10n` reports untranslated messages; the CI gate treats that report as a failure rather than a warning, which is what makes the English fallback a safety net instead of a habit.

**Alternatives considered**:
- *`easy_localization` / `slang`* — more features (runtime locale switching, namespaces) that FR-032 explicitly does not want.
- *Hand-rolled maps* — no compile-time safety; a typo becomes an empty label at runtime.

---

## R6 — Result and failure type

**Decision**: **Dart 3 sealed classes** — a `sealed class AppFailure` with one variant per catalogued condition, and a `sealed class Result<T>` with `Success<T>` / `FailureResult<T>`. **No `dartz`, no `fpdart`.**

**Rationale**: Sealed classes give exhaustive `switch` checking at compile time, which is exactly the guarantee Principle III wants: adding a failure condition breaks every place that maps failures until each one handles it. A functional-programming package would add `Either` semantics, currying, and a vocabulary the rest of the team does not need for a nine-case error catalogue.

**Alternatives considered**:
- *`dartz` / `fpdart`* — real value on codebases that already think in FP; here it is a dependency and a learning tax for one type.
- *Throwing typed exceptions* — Dart cannot enforce that a caller handles them, so failures reach the UI as crashes. Directly contrary to Principle III.

---

## R7 — Flavor mechanism

**Decision**: Three coordinated layers:
1. **Separate entry points** — `lib/main_development.dart` and `lib/main_production.dart`, each building the app with its own configuration object from `lib/core/config/`.
2. **Android** — `productFlavors` in Gradle supplying `applicationIdSuffix .dev` and the display name.
3. **iOS** — one `.xcconfig` per flavor plus a scheme per flavor, supplying bundle id and display name.

Run with `flutter run --flavor development -t lib/main_development.dart`.

**Rationale**: The identity requirements (FR-016, FR-020) are enforced by the platform build system — an app id and display name simply cannot come from Dart. Entry points then carry the flavor into Dart without any global mutable flag. This satisfies the ratified rule that **flavor is independent of build mode**: `flutter build apk --release --flavor development` produces an optimized development build, which is exactly what performance measurement needs (Principle V and XV).

**Alternatives considered**:
- *`--dart-define` only* — cannot change the Android application id or the iOS bundle id, so side-by-side installation (FR-016) is impossible.
- *`kDebugMode` to distinguish flavors* — explicitly forbidden by Principle XV, and it would make an optimized development build indistinguishable from production.

**Consequence for the dev-only navigation index**: it is registered by the development entry point's composition root only. The production binary never references it, which is a stronger guarantee than a runtime check.

---

## R8 — Portrait lock

**Decision**: Lock in **both** places — natively (`android:screenOrientation="portrait"` in the manifest; only portrait in `UISupportedInterfaceOrientations` on iOS, including the iPad key) **and** in Dart via `SystemChrome.setPreferredOrientations` before `runApp`.

**Rationale**: The Dart call alone leaves a window during startup where the platform may still lay out in landscape, producing a visible flash on a device held sideways. The native declaration alone is the real lock, but the Dart call keeps behaviour explicit and testable from the app side. iPad specifically requires the separate iPad orientation key, otherwise a tablet still rotates — the exact device class FR-031 is about.

**Alternatives considered**:
- *Dart only* — startup flash, and on iPad the platform can override.
- *Native only* — works, but the constraint becomes invisible in the Dart codebase.

---

## R9 — Permissions

**Decision**: `permission_handler` **13.0.1**, wrapped behind an app-owned interface in `lib/core/` so features depend on the app's own permission abstraction, not on the package.

**Rationale**: Principle VI requires just-in-time requests, and FR-026 requires the permanently-denied path to route to system settings — `permission_handler` provides both the `permanentlyDenied` status and `openAppSettings()`. Wrapping it matters for testability: blocs must be able to exercise granted / denied / permanently-denied without a real device.

**Platform declarations still required**: `NSCameraUsageDescription` and `NSPhotoLibraryAddUsageDescription` on iOS with reasons matching what the app actually does (FR-024), and the corresponding Android manifest permissions. Photo-library permission is wired and testable but has **no user-facing trigger** in this spec — nothing saves an image until Spec #007.

**Alternatives considered**:
- *Calling platform APIs directly* — re-implements a well-maintained package for no gain.
- *Requesting both permissions at first launch* — forbidden by Principle VI and by FR-023.

---

## R10 — Enforcing "no hardcoded style or text"

**Decision**: **Three focused repository scripts run in CI**, each named for exactly what it guards, paired with `flutter_lints` **6.0.0** for the standard analyzer rule set:

| Script | Fails on | Enforces |
|---|---|---|
| `scripts/check_no_hardcode.sh` | colour literals outside `lib/core/theme/`; user-visible string literals under `lib/features/` | Principles VII, IX |
| `scripts/check_no_cross_feature_imports.sh` | an import in `lib/features/<a>/` reaching into `lib/features/<b>/` | Principle I, FR-003 |
| `scripts/check_l10n.sh` | a non-empty `gen-l10n` untranslated-messages report | FR-014 |

The split is deliberate: one script doing three unrelated jobs makes a CI failure ambiguous, and the l10n check has nothing to do with hardcoding.

**Why the cross-feature import check exists at all**: Principle I forbids one feature reaching into another's internals, and with seven sibling directories under `lib/features/` this is the easiest rule in the constitution to break by autocomplete. Nothing in the analyzer catches it, and a review will miss it once the import list is long enough.

**Rationale**: This was researched specifically, because the constitution's strongest rule needs real enforcement. **There is no official Dart/Flutter lint that forbids hardcoded colours or user-facing strings** — `flutter_lints` has nothing equivalent. The spec's own acceptance criteria are already expressed as greps, so making that grep the CI gate keeps the rule and its enforcement identical, with zero dependencies.

**Alternatives considered**:
- *`custom_lint` 0.8.1* (verified to exist) with hand-written rules — nicer developer experience (in-editor warnings) but means authoring and maintaining lint plugins during a bootstrap spec. Worth revisiting once #001b lands the real token layer and the rule has more surface to police.
- *Code review only* — this is precisely the rule that erodes fastest without automation.

**Known limitation, stated rather than hidden**: a grep is a blunt instrument. It will not catch a colour built at runtime or a string assembled from parts, and it can false-positive on comments. It is a tripwire for the common case, not a proof.

---

## R11 — Continuous integration

**Decision**: **GitHub Actions** (the repository is `github.com/Xbisme/CameraVision`), using `subosito/flutter-action` — verified to exist, actively maintained — **pinned to the same Flutter version as R1**, running: format check → analyze → no-hardcode script → tests.

**Rationale**: The repository is already on GitHub, so this adds no new service. Pinning the action's Flutter version to R1 is the whole point; an action that silently tracks the latest stable would reintroduce the drift R1 exists to prevent.

**Scope note**: CI runs analysis and tests only. It does **not** build iOS or Android artifacts in this spec — that needs signing setup and is not required by any acceptance criterion. Real-device builds stay manual, which the workflow already mandates for native-touching specs.

---

## R12 — Shape of the native boundary (no implementation)

**Decision**: Create `lib/core/platform/` holding the channel name, method names, and request/response data shapes from **platform-channel-contract v0.2.0**, plus the failure codes it can return — and **no native code and no live invocation**.

**Rationale**: FR-005 asks for the boundary to exist so later specs add behaviour instead of inventing structure. Fixing names and payload shapes now also gives Spec #000 (contract freeze) something concrete to review.

**Risk, explicitly accepted**: contract v0.2.0 is still a **draft**; Spec #000 has not frozen it. Because nothing implements the boundary here, a change costs a rename in one directory. This is exactly why the boundary is worth defining before the engines and not after.

---

## R13 — Testing stack

**Decision**: `flutter_test` (SDK) + `bloc_test` **10.0.0** + `mocktail` **1.0.5**.

**Rationale**: `bloc_test` is the canonical way to assert state sequences and is maintained alongside `bloc` itself. `mocktail` is chosen over `mockito` because it needs no code generation — consistent with the no-`build_runner` stance in R2/R3.

**Scope for this spec** (FR-030): a test that every `AppFailure` variant maps to a localization key that exists in **both** locales, and a smoke test that the app launches and renders its first screen. **Golden tests are deliberately excluded** — there is nothing visual to pin until Spec #001b defines the token layer, and goldens taken of bare placeholder screens would all be invalidated by that spec.

---

## Summary of pinned versions

| Package | Version | Role |
|---|---|---|
| Flutter / Dart | 3.44.4 / 3.12.2 | toolchain, pinned (R1) |
| flutter_bloc | 9.1.1 | presentation state |
| equatable | 2.1.0 | value equality for states |
| get_it | 9.2.1 | composition root only |
| go_router | 17.5.0 | declarative routes |
| intl | 0.20.3 | locale-aware formatting |
| permission_handler | 13.0.1 | camera + photo library |
| flutter_lints | 6.0.0 | analyzer rules (dev) |
| bloc_test | 10.0.0 | bloc state assertions (dev) |
| mocktail | 1.0.5 | test doubles, no codegen (dev) |

`flutter_localizations` comes from the SDK and correctly has no pub.dev entry. `custom_lint` 0.8.1 was verified to exist but is **not adopted** in this spec (R10).

**No unresolved NEEDS CLARIFICATION items remain.**
