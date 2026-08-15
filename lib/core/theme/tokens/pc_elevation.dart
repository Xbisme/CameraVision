import 'package:flutter/painting.dart';

/// Elevation tokens — ported from the design bundle's `tokens/elevation.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §6.
/// 11 definitions.
///
/// Depth is rims and glow, not drop shadows. The three real shadows exist only
/// where a layer floats over the live camera feed or over content; applying one
/// to an ordinary surface contradicts the design even though the token exists.
///
/// ## ⚠️ Blur radii are derived, and still owe a visual sign-off (task T011)
///
/// The three systems disagree about what a blur number means:
///
/// * CSS `box-shadow`/`drop-shadow` third length is a *blur radius*, and the
///   Gaussian standard deviation it produces is about half of it (σ ≈ R / 2).
/// * CSS `filter: blur(R)` takes R as the standard deviation directly.
/// * Flutter's [BoxShadow.blurRadius] is converted internally by
///   `Shadow.convertRadiusToSigma`, i.e. σ = radius × 0.57735 + 0.5.
///
/// So copying a CSS number into `blurRadius` overshoots: CSS `20px` means
/// σ = 10, while Flutter's `blurRadius: 20` means σ ≈ 12.05 — about 20% too
/// much blur. Every value below is therefore *derived* to hit the CSS σ:
/// `blurRadius = (σ − 0.5) / 0.57735`, with the source and target recorded
/// beside it. That is strictly better than transcription, but research R10 asks
/// for the numbers to be matched against the bundle rendered in a browser
/// before they are considered final.
abstract final class PcElevationTokens {
  // --- Rims (2) -------------------------------------------------------------
  // CSS `inset` box-shadow has no Flutter equivalent; drawn as a hairline
  // border inside the shape.
  static const Color rimColor = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color rimStrongColor = Color.fromRGBO(255, 255, 255, 0.14);
  static const double rimWidth = 1;

  static const BorderSide rim = BorderSide(color: rimColor, width: rimWidth);
  static const BorderSide rimStrong = BorderSide(
    color: rimStrongColor,
    width: rimWidth,
  );

  // --- Shadows (3) ----------------------------------------------------------
  /// `0 6px 20px rgba(2,8,14,.45)` — CSS σ 10.
  static const BoxShadow shadowFloat = BoxShadow(
    color: Color.fromRGBO(2, 8, 14, 0.45),
    offset: Offset(0, 6),
    blurRadius: 16.45,
  );

  /// `0 -14px 44px rgba(2,8,14,.55)` — CSS σ 22.
  static const BoxShadow shadowSheet = BoxShadow(
    color: Color.fromRGBO(2, 8, 14, 0.55),
    offset: Offset(0, -14),
    blurRadius: 37.24,
  );

  /// `0 2px 8px rgba(2,8,14,.4)` — CSS σ 4.
  static const BoxShadow shadowThumb = BoxShadow(
    color: Color.fromRGBO(2, 8, 14, 0.4),
    offset: Offset(0, 2),
    blurRadius: 6.06,
  );

  // --- Glows (3) ------------------------------------------------------------
  /// `0 0 0 1px rgba(31,227,194,.55), 0 0 22px rgba(31,227,194,.28)`.
  /// **Two layered shadows, and it must stay two**: a 1px ring that defines the
  /// locked edge, plus a soft bloom. Collapsing them loses the ring.
  static const List<BoxShadow> glowAccent = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(31, 227, 194, 0.55), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(31, 227, 194, 0.28),
      blurRadius: 18.19, // CSS 22px → σ 11
    ),
  ];

  /// `0 0 18px rgba(31,227,194,.22)` — CSS σ 9.
  static const List<BoxShadow> glowAccentSoft = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(31, 227, 194, 0.22), blurRadius: 14.72),
  ];

  /// `0 0 0 1px rgba(255,176,32,.5), 0 0 18px rgba(255,176,32,.22)`.
  static const List<BoxShadow> glowCaution = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(255, 176, 32, 0.5), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(255, 176, 32, 0.22),
      blurRadius: 14.72, // CSS 18px → σ 9
    ),
  ];

  // --- Scrims (2) -----------------------------------------------------------
  // Legibility over the live feed comes from these, never from a solid bar.
  static const LinearGradient scrimTop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color.fromRGBO(4, 9, 15, 0.72),
      Color.fromRGBO(4, 9, 15, 0),
    ],
  );

  static const LinearGradient scrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: <Color>[
      Color.fromRGBO(4, 9, 15, 0.86),
      Color.fromRGBO(4, 9, 15, 0),
    ],
  );

  // --- Chrome blur (1) ------------------------------------------------------
  /// `backdrop-filter: blur(18px) saturate(1.1)`.
  ///
  /// The blur half is a direct port: CSS `filter: blur()` takes the standard
  /// deviation, which is what `ImageFilter.blur` wants too. The saturate half
  /// has no filter primitive in Flutter and is composed as a colour matrix.
  ///
  /// Glass is used **only** on controls sitting over the camera feed or a
  /// photo. A sheet over a solid background is solid (FR-011).
  static const double blurChromeSigma = 18;
  static const double blurChromeSaturation = 1.1;

  /// Saturation matrix for [blurChromeSaturation] (s = 1.1), built with the
  /// Rec. 709 luma weights (0.213, 0.715, 0.072) that the CSS filter spec
  /// defines for `saturate()`.
  ///
  /// Each row is `lum + s × (1 − lum)` on its own channel and `lum × (1 − s)`
  /// on the others, so every row sums to 1 and a grey stays exactly as grey as
  /// it started. Values above 1 on the diagonal are what pushes saturation up;
  /// a matrix whose diagonal is below 1 would be *de*saturating.
  static const List<double> saturationMatrix = <double>[
    1.0787, -0.0715, -0.0072, 0, 0, //
    -0.0213, 1.0285, -0.0072, 0, 0, //
    -0.0213, -0.0715, 1.0928, 0, 0, //
    0, 0, 0, 1, 0, //
  ];
}
