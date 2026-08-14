# Contract: Localization Keys

**Feature**: 001-project-foundation
**Mechanism**: Flutter `gen-l10n` · template + fallback `app_en.arb` · shipped `app_vi.arb`

Every key below **must exist in both files**. A key present in one and missing in the other is a defect, not an accepted fallback (FR-014). The English fallback is a safety net, not a workflow.

**Source of the copy**: Vietnamese comes from the design bundle's wording. English is authored to the product's voice — short declarative statements, no marketing adjectives, no exclamation marks, no emoji — **not machine-translated** from the Vietnamese.

## Area names (FR-012)

Used by placeholder screens and by the development navigation index.

| Key | Purpose |
|---|---|
| `areaCameraCapture` | Camera |
| `areaReview` | Result |
| `areaBackgroundEditor` | Background & shadow |
| `areaBatch` | Shooting session |
| `areaExport` | Export |
| `areaHistory` | History |
| `areaSettings` | Settings |

## Failure messages (FR-007)

One key per `AppFailure` variant. Each states what happened and what the user can do — never a code, never a platform message (FR-008).

| Key | Variant |
|---|---|
| `failureModelLoadFailed` | `ModelLoadFailed` |
| `failureUnsupportedOsVersion` | `UnsupportedOsVersion` |
| `failureSegmenterNotInitialized` | `SegmenterNotInitialized` |
| `failureSegmentationFailed` | `SegmentationFailed` |
| `failureOutOfMemory` | `OutOfMemory` |
| `failureImageLoadFailed` | `ImageLoadFailed` |
| `failurePermissionDenied` | `PermissionDenied` |
| `failurePermissionPermanentlyDenied` | `PermissionPermanentlyDenied` |
| `failureStorageFull` | `StorageFull` |
| `failureExportFailed` | `ExportFailed` |
| `failureUnknown` | `Unknown` |

**Wording rule carried from the design system**: imperfect output is described as *complex*, not as an *error*. "Error" is reserved for a genuine processing failure that can be retried. The user is never blamed.

## Permission copy (FR-024, FR-025, FR-026)

| Key | Purpose |
|---|---|
| `permissionCameraRationale` | Why the camera is needed — must match what the app actually does |
| `permissionCameraDenied` | What is unavailable now, with a way to ask again |
| `permissionCameraPermanentlyDenied` | Explanation plus a route to system settings |
| `permissionCameraRestricted` | Blocked by device policy — no settings route offered, because it would not help |
| `permissionOpenSettingsAction` | Label for the system-settings action |
| `permissionRetryAction` | Label for the ask-again action |

## Accessibility labels (FR-012)

Semantics labels are user-facing text and follow the same rule — no literals in code.

| Key | Purpose |
|---|---|
| `a11yBack` | Back control |
| `a11yDevNavigationIndex` | The development navigation index (development build only) |

## Platform usage descriptions — NOT in ARB

`NSCameraUsageDescription` and `NSPhotoLibraryAddUsageDescription` live in the iOS `Info.plist` and are localized through iOS's own `InfoPlist.strings` mechanism, not through ARB. They are listed here so they are not forgotten: they must be present in **both** languages and must match `permissionCameraRationale` in substance (FR-024).

## Verification

- An automated test iterates **every** `AppFailure` variant and asserts a non-empty message resolves in `en` **and** `vi` (FR-030).
- CI treats `gen-l10n`'s untranslated-message report as a failure.
- `scripts/check_no_hardcode.sh` fails if a user-visible string literal appears under `lib/features/`.
