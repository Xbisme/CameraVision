import '../error/app_failure.dart';

/// The single boundary to native segmentation code.
///
/// Shaped from `.claude/platform-channel-contract.md` **v0.2.0 (draft)**.
/// Nothing is invoked yet: the iOS engine lands in Spec #002b, the Android
/// engine in Spec #002, and the real-time pipeline in Spec #003. Fixing the
/// names and shapes here means those specs add behaviour instead of inventing
/// structure — and gives Spec #000 (contract freeze) something concrete to
/// review.
///
/// Channel and method names live here as constants; string literals at call
/// sites are forbidden (Principle X).
abstract final class SegmentationChannel {
  /// Method channel for request/response calls.
  static const String channelName = 'com.productcam.app/segmentation';

  /// Event channel for the real-time overlay stream (Spec #003).
  static const String streamChannelName =
      'com.productcam.app/segmentation_stream';

  /// Called once when the camera area opens, before any preview work.
  static const String initSegmenter = 'initSegmenter';

  /// Real-time overlay. Frames are downsampled on the Dart side before being
  /// sent — full-resolution frames never cross this boundary.
  static const String previewFrame = 'previewFrame';

  /// Full-resolution segmentation of a captured still.
  static const String captureAndSegment = 'captureAndSegment';

  /// Releases native resources when the camera area is left.
  static const String dispose = 'dispose';
}

/// Error codes the native side may return, per the contract's catalogue.
abstract final class SegmentationErrorCode {
  static const String modelLoadFailed = 'MODEL_LOAD_FAILED';
  static const String unsupportedOsVersion = 'UNSUPPORTED_OS_VERSION';
  static const String segmenterNotInitialized = 'SEGMENTER_NOT_INITIALIZED';
  static const String segmentationFailed = 'SEGMENTATION_FAILED';
  static const String outOfMemory = 'OUT_OF_MEMORY';
  static const String imageLoadFailed = 'IMAGE_LOAD_FAILED';
}

/// Maps a native error code onto the app's failure catalogue.
///
/// An unrecognized code becomes [Unknown] and is rendered through the localized
/// generic message — raw native text must never reach the user (FR-008). The
/// original code is kept in [Unknown.cause] for logs only.
AppFailure mapSegmentationErrorCode(String code, {String? message}) {
  return switch (code) {
    SegmentationErrorCode.modelLoadFailed => const ModelLoadFailed(),
    SegmentationErrorCode.unsupportedOsVersion => const UnsupportedOsVersion(),
    SegmentationErrorCode.segmenterNotInitialized =>
      const SegmenterNotInitialized(),
    SegmentationErrorCode.segmentationFailed => const SegmentationFailed(),
    SegmentationErrorCode.outOfMemory => const OutOfMemory(),
    SegmentationErrorCode.imageLoadFailed => const ImageLoadFailed(),
    _ => Unknown('$code${message == null ? '' : ': $message'}'),
  };
}
