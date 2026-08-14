/// Which permission a permission failure refers to.
enum AppPermission { camera, photoLibrary }

/// The closed set of things that can go wrong.
///
/// Sealed on purpose: adding a variant breaks every exhaustive `switch` until
/// it is handled, which is how Principle III is enforced rather than merely
/// stated. The first six variants mirror the Error Code Catalog in
/// `.claude/platform-channel-contract.md` v0.2.0 and MUST stay in step with it.
///
/// Variants carry no user-facing text. Text lives in ARB, mapped by
/// `failure_l10n.dart`, so the domain layer holds no strings.
sealed class AppFailure {
  const AppFailure();
}

// --- From the platform channel contract --------------------------------------

/// Android: the bundled TFLite model could not be loaded.
class ModelLoadFailed extends AppFailure {
  const ModelLoadFailed();
}

/// iOS: the device is below iOS 17.0, so subject lifting is unavailable.
class UnsupportedOsVersion extends AppFailure {
  const UnsupportedOsVersion();
}

/// A segmentation call was made before `initSegmenter`. Programmer error —
/// this must not occur in production.
class SegmenterNotInitialized extends AppFailure {
  const SegmenterNotInitialized();
}

/// No subject could be separated from the background.
class SegmentationFailed extends AppFailure {
  const SegmentationFailed();
}

/// Not enough memory to process at full resolution.
class OutOfMemory extends AppFailure {
  const OutOfMemory();
}

/// The input image is missing or unreadable.
class ImageLoadFailed extends AppFailure {
  const ImageLoadFailed();
}

// --- Owned by this app --------------------------------------------------------

/// The user declined a permission, and can be asked again.
class PermissionDenied extends AppFailure {
  const PermissionDenied(this.permission);

  final AppPermission permission;
}

/// The user declined a permission and the OS will no longer prompt.
class PermissionPermanentlyDenied extends AppFailure {
  const PermissionPermanentlyDenied(this.permission);

  final AppPermission permission;
}

/// No space left to write output.
class StorageFull extends AppFailure {
  const StorageFull();
}

/// Writing or sharing the result failed.
class ExportFailed extends AppFailure {
  const ExportFailed();
}

/// Anything unclassified.
///
/// [cause] is for logs and diagnostics ONLY. It must never be rendered — the
/// user sees the localized generic message (FR-008).
class Unknown extends AppFailure {
  const Unknown(this.cause);

  final String cause;
}
