# Contract: Native Segmentation Boundary (Dart side)

**Feature**: 001-project-foundation | **Status**: shape defined, **not implemented**
**Derived from**: `.claude/platform-channel-contract.md` **v0.2.0 (draft — Spec #000 has not frozen it)**

This spec fixes the Dart-side surface so Specs #002 (Android/Kotlin), #002b (iOS/Swift) and #003 add behaviour instead of inventing structure. **No native code is written here and no channel call is made at runtime.**

If Spec #000 changes the contract, this file and `lib/core/platform/` change with it — cheaply, because nothing consumes them yet. That is the point of defining the boundary before the engines.

## Channel identifiers

All names are constants in `lib/core/platform/`; string literals at call sites are forbidden (Principle X).

| Purpose | Value |
|---|---|
| Method channel | `com.productcam.app/segmentation` |
| Event channel (real-time overlay, Spec #003) | `com.productcam.app/segmentation_stream` |

## Methods

### `initSegmenter()`

Called once when the camera area opens, before any preview work.

**Request**: no arguments

**Response** → `SegmenterInfo`

| Field | Type | Notes |
|---|---|---|
| `status` | String | `ready` |
| `engine` | String | `vision_framework` \| `tflite_modnet_v1` |
| `engineLabel` | String | Human-readable, shown in Settings (e.g. `Vision · Subject lifting`) |
| `modelSizeBytes` | int | `0` on iOS — system API, nothing bundled |

`engineLabel` and `modelSizeBytes` exist so the Settings screen reports what is actually running. Dart **must not** hardcode either value (Principle X).

**Failures**: `MODEL_LOAD_FAILED` (Android) · `UNSUPPORTED_OS_VERSION` (iOS, below 17.0)

---

### `previewFrame(bytes, width, height, rotation)`

Real-time overlay. Implemented in Spec #003.

**Request**

| Field | Type | Notes |
|---|---|---|
| `bytes` | Uint8List | **Already downsampled on the Dart side** — full-resolution frames are never sent |
| `width`, `height` | int | Dimensions of the downsampled frame |
| `rotation` | int | Device/sensor rotation |

**Response** → `PreviewFrameResult`

| Field | Type | Notes |
|---|---|---|
| `contourPoints` | List of (x, y) | **Normalized 0.0–1.0, never pixels.** Dart scales to the preview size |
| `confidence` | double | 0.0–1.0 |

An empty `contourPoints` with `confidence: 0.0` means "no clear subject" — this is **not** a failure; the overlay simply hides.

**Failures**: `SEGMENTER_NOT_INITIALIZED`

**Constraints carried forward** (binding from Spec #003, recorded here so they are not rediscovered): the response must arrive within **150 ms** in Balanced mode on a mid-range device; call frequency is throttled **by Dart**, never by native, so both platforms behave identically; the work runs off the UI thread on both sides.

---

### `captureAndSegment(imagePath)`

Full-resolution segmentation of a still image. Implemented in Spec #004.

**Request**: `imagePath` (String) — local file path

**Response** → `CaptureResult`

| Field | Type | Notes |
|---|---|---|
| `status` | String | `success` |
| `maskPngPath` | String | Grayscale alpha mask PNG; Dart composites it |
| `confidence` | double | 0.0–1.0 |
| `processingTimeMs` | int | For measurement |
| `edgeComplexityWarning` | bool | `true` → the review screen shows the amber edge notice |

**Failures**: `SEGMENTATION_FAILED` · `OUT_OF_MEMORY` · `IMAGE_LOAD_FAILED`

---

### `dispose()`

Releases native resources when the camera area is left. No arguments, no response payload.

## Error code mapping

Every native code maps to exactly one `AppFailure` variant. This mapping is the reason the failure catalogue in [data-model.md](../data-model.md) has the shape it does.

| Native code | `AppFailure` variant | Platform |
|---|---|---|
| `MODEL_LOAD_FAILED` | `ModelLoadFailed` | Android |
| `UNSUPPORTED_OS_VERSION` | `UnsupportedOsVersion` | iOS |
| `SEGMENTER_NOT_INITIALIZED` | `SegmenterNotInitialized` | both |
| `SEGMENTATION_FAILED` | `SegmentationFailed` | both |
| `OUT_OF_MEMORY` | `OutOfMemory` | both |
| `IMAGE_LOAD_FAILED` | `ImageLoadFailed` | both |
| *anything unrecognized* | `Unknown(cause)` | both |

An unrecognized code must **never** reach the user as raw text (FR-008). It becomes `Unknown` and is rendered through the localized generic message, with the original kept for logs only.

## What is explicitly NOT in this spec

- No Swift or Kotlin implementation (Specs #002b / #002).
- No live invocation of any method; the wrapper exists and is unit-testable with a mocked channel, nothing more.
- No `Platform.isIOS` branching on behaviour. The two engines differ natively; the Dart interface is identical for both (Principle IV).
