import '../l10n/generated/app_localizations.dart';
import 'app_failure.dart';

/// Turns a failure into text a person can read, in their own language.
///
/// The `switch` is exhaustive over the sealed [AppFailure], so adding a variant
/// stops the build until it is given a message — which is what makes FR-007
/// enforceable rather than aspirational.
///
/// [Unknown.cause] is never rendered: it exists for logs (FR-008).
String failureMessage(AppFailure failure, AppLocalizations l10n) {
  return switch (failure) {
    ModelLoadFailed() => l10n.failureModelLoadFailed,
    UnsupportedOsVersion() => l10n.failureUnsupportedOsVersion,
    SegmenterNotInitialized() => l10n.failureSegmenterNotInitialized,
    SegmentationFailed() => l10n.failureSegmentationFailed,
    OutOfMemory() => l10n.failureOutOfMemory,
    ImageLoadFailed() => l10n.failureImageLoadFailed,
    PermissionDenied() => l10n.failurePermissionDenied,
    PermissionPermanentlyDenied() => l10n.failurePermissionPermanentlyDenied,
    StorageFull() => l10n.failureStorageFull,
    ExportFailed() => l10n.failureExportFailed,
    Unknown() => l10n.failureUnknown,
  };
}

/// Every failure variant, for tests that must cover the whole catalogue.
///
/// Kept beside the mapping on purpose: a new variant added without extending
/// this list is caught by the exhaustive switch above, so the two cannot drift
/// apart silently.
const List<AppFailure> allFailureVariants = <AppFailure>[
  ModelLoadFailed(),
  UnsupportedOsVersion(),
  SegmenterNotInitialized(),
  SegmentationFailed(),
  OutOfMemory(),
  ImageLoadFailed(),
  PermissionDenied(AppPermission.camera),
  PermissionPermanentlyDenied(AppPermission.camera),
  StorageFull(),
  ExportFailed(),
  Unknown('diagnostic detail that must never be shown'),
];
