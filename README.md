# ProductCam

On-device background removal camera for product photos. Runs fully offline: no backend, no accounts, no network calls at runtime.

## Required toolchain

**Flutter 3.44.4 / Dart 3.12.2 — pinned.**

This is not a minimum, it is the version the project is built and tested with. CI uses the same one. Upgrading is a deliberate, separately verified change (see `specs/001-project-foundation/research.md` R1), never a side effect of another task.

```bash
flutter --version   # must report 3.44.4
flutter pub get
```

## Platform floors

| Platform | Minimum | Why |
|---|---|---|
| iOS | **17.0** | `VNGenerateForegroundInstanceMaskRequest` (subject lifting) is an iOS 17 API and is the entire segmentation engine on iOS |
| Android | **API 24** | Balances device reach against the real-time performance budget |

Portrait only, on phones and tablets alike.

## Running

```bash
flutter run --flavor development -t lib/main_development.dart
flutter run --flavor production  -t lib/main_production.dart

# Optimized development build — used for on-device performance measurement
flutter build apk --release --flavor development -t lib/main_development.dart
```

The two flavors install side by side as **ProductCam Dev** and **ProductCam**.

## Local gate (run before opening a PR)

```bash
dart format --set-exit-if-changed .
flutter analyze                              # zero warnings
./scripts/check_no_hardcode.sh               # no hardcoded colours or strings
./scripts/check_no_cross_feature_imports.sh  # features must not import each other
./scripts/check_l10n.sh                      # no missing translation keys
flutter test
```

## Project rules

The non-negotiable rules live in [`.specify/memory/constitution.md`](.specify/memory/constitution.md). The short version:

- Clean Architecture, feature-first, **BLoC — no MVVM**.
- **No hardcoding**: colours, text styles, spacing and durations only in `lib/core/theme/`; user-facing strings only in ARB; channel names, thresholds and config only in `lib/core/`.
- Fully offline. No runtime network call, including fonts and models.
- Performance is an architectural constraint, verified on real low-end hardware.

Day-to-day workflow: [`.claude/dev-workflow.md`](.claude/dev-workflow.md) · UI source of truth: [`.claude/design/`](.claude/design/)
