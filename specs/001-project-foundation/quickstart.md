# Quickstart: Verifying Project Foundation

**Feature**: 001-project-foundation | **Date**: 2026-08-14

How to run the shell and verify every acceptance criterion in [spec.md](./spec.md). This is a validation guide — implementation belongs in `tasks.md`.

## Prerequisites

| Requirement | Value |
|---|---|
| Flutter / Dart | **3.44.4 / 3.12.2** (pinned — see [research.md](./research.md) R1) |
| iOS device or simulator | iOS 17.0+ |
| Android device or emulator | API 24+ |
| For SC-005 and SC-009 | A **physical mid-range Android device** — an emulator cannot demonstrate side-by-side installs meaningfully or give a trustworthy cold-start figure |

```bash
flutter --version     # must report 3.44.4
flutter pub get
```

## Running

```bash
# Development flavor
flutter run --flavor development -t lib/main_development.dart

# Production flavor
flutter run --flavor production  -t lib/main_production.dart

# Optimized development build — the case that proves flavor is independent of
# build mode (FR-017); this is the build later specs measure performance on
flutter build apk --release --flavor development -t lib/main_development.dart
```

## Verifying each acceptance criterion

### SC-001 — All seven areas reachable, zero crashes

1. Launch the **development** build. The camera area appears first, with no onboarding and **no permission prompt** (FR-021, FR-023).
2. Open the navigation index and visit all seven areas, returning from each.
3. Launch the **production** build and confirm the navigation index does not exist anywhere.

**Pass**: seven areas visited and exited without a crash; production has no index.

### SC-002 / SC-003 — Language

```bash
# Vietnamese
adb shell settings put system system_locales vi-VN   # or change it in Settings
# English / other: set the device to en-US, then to a third language (e.g. ja-JP)
```

Relaunch after each change and walk all seven areas.

**Pass**: `vi` device shows Vietnamese; `en` and the unrelated language both show English; no screen mixes languages; no key names or blanks appear.

### SC-004 — Every failure produces a human sentence in both languages

```bash
flutter test test/core/error/failure_l10n_test.dart
```

**Pass**: every `AppFailure` variant resolves to a non-empty message in `en` and `vi`. Adding a variant without adding both messages fails this test.

### SC-005 — Two builds side by side

Install both flavors on one physical Android device.

**Pass**: two entries appear — "ProductCam" and "ProductCam Dev" — and both launch independently.

### SC-006 — Permission paths

On a **fresh install** (uninstall first; permission state survives reinstall on some devices):

1. Launch — no prompt appears.
2. Trigger the camera area's capture-permission path — the prompt appears with a reason matching what the app does.
3. **Deny** — the app stays usable, states what is unavailable, offers to ask again.
4. Deny again so the OS stops prompting — the app explains and offers a route to system settings, and does **not** re-prompt pointlessly.
5. Grant, background the app, revoke camera access in system settings, return — the app detects the loss on resume rather than assuming access.

**Pass**: no crash on any path; every path ends on a usable screen with a stated next step.

### SC-007 — Extensibility

Walk through (without committing) adding an eighth area and a third language.

**Pass**: the eighth area is a new folder plus a route entry; the third language is one new ARB file. Neither requires editing an existing screen.

### SC-008 — The CI gate actually fails

Introduce each of the following deliberately, confirm CI fails, then revert:

```bash
# 1. formatting drift
dart format --set-exit-if-changed .

# 2. an analyzer warning (e.g. an unused import)
flutter analyze

# 3. hardcoded colour or string
./scripts/check_no_hardcode.sh

# 4. an import from one feature into another
./scripts/check_no_cross_feature_imports.sh

# 5. a key present in app_en.arb but missing from app_vi.arb
./scripts/check_l10n.sh

# 6. a failing test
flutter test
```

**Pass**: all six fail the build when violated. A gate that has never been seen failing has not been verified.

### SC-009 — Cold start under 2s

On a physical mid-range Android device, force-stop the app and launch it, several times.

**Pass**: first screen renders in under 2 seconds. **Record the exact device model and Android version alongside the figure** — "mid-range" is not defined project-wide yet, so an unattributed number cannot be compared against the next one. Treat this as a regression tripwire, not a tuned target; real budgets arrive in Spec #003.

### FR-031 — Portrait lock

Rotate the device on a phone **and** on a tablet, in every area.

**Pass**: the app stays portrait, with no rotation flash at startup and no rotation on iPad. Screens fill a tablet-sized portrait viewport without clipping or stranding content.

## Full local gate (run before opening a PR)

```bash
dart format --set-exit-if-changed .
flutter analyze                              # zero warnings
./scripts/check_no_hardcode.sh               # Principles VII + IX
./scripts/check_no_cross_feature_imports.sh  # Principle I / FR-003
./scripts/check_l10n.sh                      # FR-014
flutter test
```

## What this spec does NOT deliver

Do not expect, and do not test for: any camera preview, contour overlay, cutout, background change, export, or history; any visual design — screens are intentionally bare until Spec #001b; any native segmentation code; any data surviving a restart.
