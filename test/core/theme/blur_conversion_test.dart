import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/tokens/pc_contour.dart';
import 'package:productcam/core/theme/tokens/pc_elevation.dart';

/// Locks the CSS→Flutter blur conversion (research R10, task T011).
///
/// Three systems disagree about what a "blur" number means:
///
///  * CSS `box-shadow` / `drop-shadow`: the third length is a blur *radius*,
///    and the Gaussian it produces has σ ≈ radius / 2.
///  * CSS `filter: blur(R)`: R **is** σ.
///  * Flutter `BoxShadow.blurRadius`: converted by
///    `Shadow.convertRadiusToSigma`, i.e. σ = radius × 0.57735 + 0.5.
///
/// So the design's numbers cannot be copied across. Each token below is
/// *derived* to land on the CSS σ, and this file asserts it actually does. If
/// the Flutter SDK ever changes that constant, every shadow in the product
/// would quietly shift by ~20% and nothing else would notice — this fails
/// instead.
void main() {
  /// The CSS blur radius each token was ported from, and the σ it implies.
  /// `box-shadow` and `drop-shadow` both use the radius ≈ 2σ convention.
  const Map<String, (double cssRadius, double targetSigma)> fromBoxShadowCss =
      <String, (double, double)>{
        'shadow-float': (20, 10),
        'shadow-sheet': (44, 22),
        'shadow-thumb': (8, 4),
        'glow-accent bloom': (22, 11),
        'glow-accent-soft': (18, 9),
        'glow-caution bloom': (18, 9),
        'contour-glow': (6, 3),
      };

  test('the SDK conversion is still the one these values were derived for', () {
    // Two anchor points pin the affine formula; if either moves, the constant
    // or the offset changed.
    expect(Shadow.convertRadiusToSigma(0), 0);
    expect(Shadow.convertRadiusToSigma(1), closeTo(1.07735, 1e-5));
    expect(Shadow.convertRadiusToSigma(100), closeTo(58.235, 1e-3));
  });

  test('every CSS radius maps to half of itself as sigma', () {
    // The premise of the whole port: the design's box-shadow numbers mean
    // σ = radius / 2. Stated as a test so it is not folk knowledge.
    for (final MapEntry<String, (double, double)> e
        in fromBoxShadowCss.entries) {
      final (double cssRadius, double targetSigma) = e.value;
      expect(
        cssRadius / 2,
        targetSigma,
        reason: '${e.key}: the CSS radius and the target sigma disagree',
      );
    }
  });

  test('each ported BoxShadow renders at the sigma the CSS asked for', () {
    final Map<String, (BoxShadow, double)> ported =
        <String, (BoxShadow, double)>{
          'shadow-float': (PcElevationTokens.shadowFloat, 10),
          'shadow-sheet': (PcElevationTokens.shadowSheet, 22),
          'shadow-thumb': (PcElevationTokens.shadowThumb, 4),
          'glow-accent bloom': (PcElevationTokens.glowAccent.last, 11),
          'glow-accent-soft': (PcElevationTokens.glowAccentSoft.single, 9),
          'glow-caution bloom': (PcElevationTokens.glowCaution.last, 9),
        };

    for (final MapEntry<String, (BoxShadow, double)> e in ported.entries) {
      final (BoxShadow shadow, double targetSigma) = e.value;
      expect(
        shadow.blurSigma,
        closeTo(targetSigma, 0.01),
        reason:
            '${e.key} renders at σ ${shadow.blurSigma.toStringAsFixed(4)} '
            'but the design asks for σ $targetSigma. Copying the CSS number '
            'straight into blurRadius is the mistake this guards against — it '
            'overshoots by about 20%.',
      );
    }
  });

  test('the 1px rings on the two glows are spread, not blur', () {
    // `0 0 0 1px` is a hard ring that defines a locked edge. Blurring it would
    // dissolve exactly the thing it is there to draw.
    expect(PcElevationTokens.glowAccent.first.spreadRadius, 1);
    expect(PcElevationTokens.glowAccent.first.blurRadius, 0);
    expect(PcElevationTokens.glowCaution.first.spreadRadius, 1);
    expect(PcElevationTokens.glowCaution.first.blurRadius, 0);
  });

  test('the contour glow passes sigma directly, with no radius conversion', () {
    // The contour glow is a MaskFilter on an arbitrary path rather than a
    // BoxShadow, so it takes σ as-is. CSS drop-shadow(0 0 6px) is σ 3.
    expect(PcContourTokens.glowSigma, 3);
  });

  test('the chrome blur passes sigma directly too', () {
    // `filter: blur(18px)` — here the CSS length already *is* σ, so this one
    // must NOT be halved. Getting this backwards is the easiest mistake in the
    // whole port, because it looks like the same word.
    expect(PcElevationTokens.blurChromeSigma, 18);
  });
}
