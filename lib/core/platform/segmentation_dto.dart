import 'package:equatable/equatable.dart';

/// Payload shapes for the native segmentation boundary, mirroring
/// `.claude/platform-channel-contract.md` v0.2.0.
///
/// Defined and unit-testable now; no channel call is made until Specs
/// #002/#002b/#003.

/// Response of `initSegmenter`.
///
/// [engineLabel] and [modelSizeBytes] exist so the Settings area can report
/// what is actually running. Dart must not hardcode either (Principle X).
class SegmenterInfo extends Equatable {
  const SegmenterInfo({
    required this.status,
    required this.engine,
    required this.engineLabel,
    required this.modelSizeBytes,
  });

  factory SegmenterInfo.fromMap(Map<Object?, Object?> map) {
    return SegmenterInfo(
      status: map['status']! as String,
      engine: map['engine']! as String,
      engineLabel: map['engine_label']! as String,
      // 0 on iOS: a system API, nothing bundled.
      modelSizeBytes: map['model_size_bytes']! as int,
    );
  }

  final String status;
  final String engine;
  final String engineLabel;
  final int modelSizeBytes;

  @override
  List<Object?> get props => <Object?>[
    status,
    engine,
    engineLabel,
    modelSizeBytes,
  ];
}

/// A single contour vertex.
///
/// Coordinates are **normalized 0.0–1.0, never pixels** — Dart scales them to
/// the preview size. A platform returning pixels violates the contract.
class ContourPoint extends Equatable {
  const ContourPoint(this.x, this.y);

  final double x;
  final double y;

  @override
  List<Object?> get props => <Object?>[x, y];
}

/// Response of `previewFrame`.
///
/// An empty [contourPoints] with `confidence == 0` means "no clear subject".
/// That is not a failure: the overlay simply hides.
class PreviewFrameResult extends Equatable {
  const PreviewFrameResult({
    required this.contourPoints,
    required this.confidence,
  });

  factory PreviewFrameResult.fromMap(Map<Object?, Object?> map) {
    final List<Object?> raw =
        (map['contour_points'] as List<Object?>?) ?? <Object?>[];
    return PreviewFrameResult(
      contourPoints: raw
          .map((Object? p) {
            final List<Object?> pair = p! as List<Object?>;
            return ContourPoint(
              (pair[0]! as num).toDouble(),
              (pair[1]! as num).toDouble(),
            );
          })
          .toList(growable: false),
      confidence: (map['confidence']! as num).toDouble(),
    );
  }

  final List<ContourPoint> contourPoints;
  final double confidence;

  bool get hasSubject => contourPoints.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[contourPoints, confidence];
}

/// Response of `captureAndSegment`.
class CaptureResult extends Equatable {
  const CaptureResult({
    required this.status,
    required this.maskPngPath,
    required this.confidence,
    required this.processingTimeMs,
    required this.edgeComplexityWarning,
  });

  factory CaptureResult.fromMap(Map<Object?, Object?> map) {
    return CaptureResult(
      status: map['status']! as String,
      maskPngPath: map['mask_png_path']! as String,
      confidence: (map['confidence']! as num).toDouble(),
      processingTimeMs: map['processing_time_ms']! as int,
      // true -> the review area shows the amber edge notice, never a red error.
      edgeComplexityWarning: map['edge_complexity_warning']! as bool,
    );
  }

  final String status;
  final String maskPngPath;
  final double confidence;
  final int processingTimeMs;
  final bool edgeComplexityWarning;

  @override
  List<Object?> get props => <Object?>[
    status,
    maskPngPath,
    confidence,
    processingTimeMs,
    edgeComplexityWarning,
  ];
}
