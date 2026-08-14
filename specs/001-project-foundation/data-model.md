# Phase 1 Data Model: Project Foundation

**Feature**: 001-project-foundation | **Date**: 2026-08-14

This spec has **no persisted data**. Everything below lives in memory for the lifetime of the process. Storage arrives in Spec #007.

---

## 1. `AppFailure` — the closed failure catalogue

A `sealed` class. Sealed matters: adding a variant makes every exhaustive `switch` over failures fail to compile until it is handled, which is how Principle III is enforced rather than merely stated.

The first six variants are dictated by the Error Code Catalog in `.claude/platform-channel-contract.md` v0.2.0 and **must stay in step with it** (FR-006). The rest come from this spec.

| Variant | Source | Fields | Meaning | Recovery offered to the user |
|---|---|---|---|---|
| `ModelLoadFailed` | contract (Android) | — | The bundled segmentation model could not be loaded | Suggest reinstalling the app |
| `UnsupportedOsVersion` | contract (iOS) | — | Device is below iOS 17.0 | Explain the OS requirement; feature blocked, app not crashed |
| `SegmenterNotInitialized` | contract (both) | — | A segmentation call was made before initialization | Programmer error — must not occur in production |
| `SegmentationFailed` | contract (both) | — | No subject could be separated | Offer retake, suggest a contrasting background |
| `OutOfMemory` | contract (both) | — | Not enough memory for full-resolution work | Offer retry at lower resolution |
| `ImageLoadFailed` | contract (both) | — | Input image is missing or unreadable | Offer retake |
| `PermissionDenied` | this spec | `permission` | The user declined a permission this time | Offer to ask again |
| `PermissionPermanentlyDenied` | this spec | `permission` | The user declined and the OS will not re-prompt | Offer a route to system settings |
| `StorageFull` | this spec | — | No space to write output | Ask the user to free space |
| `ExportFailed` | this spec | — | Writing or sharing the result failed | Offer retry |
| `Unknown` | this spec | `cause` | Anything unclassified | Generic apology plus retry |

**Rules**

- Every variant **must** have a localization key present in **both** `en` and `vi` — asserted by an automated test over the full variant set (FR-007, FR-030).
- `Unknown.cause` is for logs and diagnostics only. It **must never** be rendered (FR-008); the user sees the localized generic sentence.
- Variants carry no user-facing text themselves. Text lives in ARB, so the catalogue stays presentation-free and the domain layer holds no strings.
- Nothing in this spec produces the six contract-derived variants at runtime — no native call exists yet. They are defined and tested now so Specs #002/#002b/#004 have somewhere to report into.

---

## 2. `Result<T>` — the return shape of failable operations

A `sealed` class with two variants:

| Variant | Fields | Meaning |
|---|---|---|
| `Success<T>` | `value: T` | Operation succeeded |
| `FailureResult<T>` | `failure: AppFailure` | Operation failed with a catalogued condition |

**Rules**

- Any operation crossing a layer boundary that can fail returns `Result<T>` (FR-009). Callers must handle both cases; failure cannot silently propagate to the UI as an exception.
- Presentation converts `FailureResult` into a failure state carrying the `AppFailure`, never into a thrown error.
- `Result` is not a general-purpose functional type. No `map`/`flatMap` chain library is introduced (see research.md R6).

---

## 3. `Flavor` and `AppConfig` — build identity

`Flavor` is an enum with exactly two values: `development`, `production` (FR-015).

`AppConfig` is an immutable value supplied by the entry point:

| Field | development | production | Purpose |
|---|---|---|---|
| `flavor` | `development` | `production` | Identity of the running build |
| `appId` | `com.productcam.app.dev` | `com.productcam.app` | Matches the platform build config (FR-020) |
| `displayName` | `ProductCam Dev` | `ProductCam` | Distinguishes side-by-side installs (FR-016) |
| `showsDeveloperSurfaces` | `true` | `false` | Gates the navigation index (FR-022, FR-018) |
| `verboseLogging` | `true` | `false` | Diagnostic verbosity (FR-018) |

**Rules**

- `AppConfig` is constructed once in the entry point and injected. There is no global mutable flavor flag.
- Its values are **independent of build mode** — an optimized `development` build keeps `showsDeveloperSurfaces == true` (Principle XV, FR-017). `kDebugMode` must not appear in flavor decisions.
- `appId` and `displayName` are duplicated between Dart and the platform build files by necessity (Dart cannot set them). The duplication is asserted by review, and any change touches both.

---

## 4. `ProductArea` — the seven slices

An enum naming the seven areas, each with a route path and a localization key for its display name:

| Area | Route | Reachable in production (this spec) |
|---|---|---|
| `cameraCapture` | `/` | Yes — it is the launch screen (FR-021) |
| `settings` | `/settings` | Yes — reachable from camera |
| `history` | `/history` | Yes — reachable from camera |
| `review` | `/review` | No — needs a capture flow (Spec #004) |
| `backgroundEditor` | `/editor` | No — needs Spec #005 |
| `batch` | `/batch` | No — needs Spec #006 |
| `export` | `/export` | No — needs Spec #007 |

**Rules**

- All seven routes are registered in both flavors; what differs is only whether the **navigation index** exists to reach them by hand (FR-022).
- The four "No" rows are reachable in development only, via the index. They are not dead code — they are the destinations later specs wire up.
- Camera is the launch route with nothing before it: no onboarding, no gate (FR-021).
- Every area's display name comes from ARB (FR-012); the enum holds a key, never a literal.

---

## 5. Permission model

The app's own abstraction, so features never depend on the permission package directly (research.md R9).

**Permissions used**: `camera` (required to capture) and `photoLibrary` (used only when saving — no trigger exists in this spec).

**Status**, deliberately smaller than the package's own enum:

| Status | Meaning | What the UI does |
|---|---|---|
| `granted` | Access allowed | Proceed |
| `denied` | Refused, can ask again | Explain what is unavailable; offer to ask again (FR-025) |
| `permanentlyDenied` | Refused, OS will not re-prompt | Explain; offer a route to system settings (FR-026) |
| `restricted` | Blocked by device policy, user cannot grant | Explain; do **not** offer a settings route that cannot help |

**Lifecycle**

```
not requested ──(user enters an area needing it)──► request
     request ──► granted        ──► feature usable
     request ──► denied         ──► explain + retry available
     request ──► permanentlyDenied ──► explain + open system settings
     granted ──(revoked in system settings while backgrounded)──► re-checked on resume
```

**Rules**

- No permission is requested at launch or bundled with another (FR-023).
- Status is **re-read when the app resumes**, never cached across a background cycle — this is the edge case where a user revokes access in settings and returns (FR-027).
- `restricted` is treated as its own case rather than folded into `permanentlyDenied`, because offering a settings route to someone who is blocked by policy sends them somewhere that cannot help.
- Every status maps to a localized explanation; none surfaces a platform string.

---

## 6. Locale resolution

| Property | Value |
|---|---|
| Supported | `en`, `vi` |
| Template / source of truth | `en` |
| Fallback | `en` |
| Selection | Operating system only — no in-app setting, nothing stored (FR-032) |

**Rules**

- Device set to Vietnamese renders `vi`; anything else renders `en` (FR-010, FR-011).
- A key missing from either ARB is a **defect**, not an accepted state; the fallback exists as a safety net (FR-014). CI treats untranslated messages as a failure.
- Vietnamese copy originates from the design bundle; English is authored to the product's voice, not machine-translated (spec Assumptions).

---

## 7. Native boundary payloads (defined, not called)

Shapes only, mirroring platform-channel-contract v0.2.0. See [contracts/platform-channel.md](./contracts/platform-channel.md) for the full surface.

| Type | Fields |
|---|---|
| `SegmenterInfo` | `status`, `engine`, `engineLabel`, `modelSizeBytes` |
| `PreviewFrameResult` | `contourPoints: List<(double x, double y)>` (normalized 0.0–1.0), `confidence: double` |
| `CaptureResult` | `status`, `maskPngPath`, `confidence`, `processingTimeMs`, `edgeComplexityWarning` |

**Rules**

- Contour coordinates are **normalized 0.0–1.0, never pixels** — the contract is explicit, and a platform returning pixels is a contract violation (FR-005).
- These types are constructed in tests only during this spec. No channel invocation happens.
- Contract v0.2.0 is a **draft** pending the Spec #000 freeze; a change here costs a rename because nothing consumes these types yet.
