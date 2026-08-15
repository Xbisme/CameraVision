import 'package:flutter/painting.dart';

/// Typography tokens — ported from the design bundle's `tokens/typography.css`
/// and `tokens/fonts.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §2–§3.
/// 33 + 2 definitions.
///
/// Manrope for everything a person wrote; IBM Plex Mono for machine facts,
/// uppercase. Prose is never set in mono and readouts are never set in Manrope
/// (FR-013).
///
/// **The CDN `@import` in `fonts.css` is deliberately not ported.** It fetches
/// both families over the network, which Principle VI forbids outright. Its
/// replacement is the six subset binaries in `assets/fonts/`.
abstract final class PcTypographyTokens {
  // --- Families (2) ---------------------------------------------------------
  // The CSS fallback stacks name web and desktop faces (`Be Vietnam Pro`,
  // `Segoe UI`, `system-ui`, `SFMono-Regular`) that cannot resolve on iOS or
  // Android. Reduced to the platform default, which is the only fallback that
  // can actually resolve — and which normal Vietnamese and English copy should
  // never reach, because the charset test proves the shipped subset covers it.
  static const String fontUi = 'Manrope';
  static const String fontMono = 'IBMPlexMono';

  // --- Sizes (9) ------------------------------------------------------------
  static const double fsDisplay = 34;
  static const double fsH1 = 26;
  static const double fsH2 = 21;
  static const double fsH3 = 18;
  static const double fsBodyLg = 17;
  static const double fsBody = 16;
  static const double fsBodySm = 14;
  static const double fsCaption = 13;
  static const double fsMicro = 11;

  // --- Line heights (4) -----------------------------------------------------
  // Unitless in CSS and a multiplier in Flutter — same meaning, direct port.
  static const double lhTight = 1.08;
  static const double lhSnug = 1.25;
  static const double lhBody = 1.45;
  static const double lhLoose = 1.6;

  // --- Weights (5) ----------------------------------------------------------
  static const FontWeight fwRegular = FontWeight.w400;
  static const FontWeight fwMedium = FontWeight.w500;
  static const FontWeight fwSemibold = FontWeight.w600;
  static const FontWeight fwBold = FontWeight.w700;
  static const FontWeight fwBlack = FontWeight.w800;

  // --- Tracking (5) — kept in `em`, converted per role ----------------------
  // CSS letter-spacing in `em` is relative to font size; Flutter's
  // `letterSpacing` is in logical pixels. Copying `0.08` straight across would
  // give roughly a thirteenth of the specified tracking, so every role
  // multiplies by its own size. The `em` values stay here so the origin is
  // visible at the call site of the conversion.
  static const double trackingDisplayEm = -0.02;
  static const double trackingTightEm = -0.01;
  static const double trackingNormalEm = 0;
  static const double trackingReadoutEm = 0.08;
  static const double trackingLabelEm = 0.06;

  /// `em` → logical pixels for a given size.
  static double track(double em, double fontSize) => em * fontSize;

  // --- Composed roles (10) --------------------------------------------------
  // The CSS `font:` shorthand carries family, weight, size and line-height but
  // **not** letter-spacing, so the role↔tracking pairing below comes from the
  // bundle readme's prose rules rather than from the shorthand: negative
  // tracking on display sizes, +0.08em on mono readouts, none on body copy.
  // Recorded here because it is a decision, not a transcription.

  static const TextStyle display = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwBlack,
    fontSize: fsDisplay,
    height: lhTight,
    letterSpacing: trackingDisplayEm * fsDisplay, // -0.68
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwBold,
    fontSize: fsH1,
    height: lhSnug,
    letterSpacing: trackingTightEm * fsH1, // -0.26
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwBold,
    fontSize: fsH2,
    height: lhSnug,
    letterSpacing: trackingTightEm * fsH2, // -0.21
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwSemibold,
    fontSize: fsH3,
    height: lhSnug,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwRegular,
    fontSize: fsBody,
    height: lhBody,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwSemibold,
    fontSize: fsBody,
    height: lhBody,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwMedium,
    fontSize: fsCaption,
    height: lhBody,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontUi,
    fontWeight: fwBold,
    fontSize: fsBody,
    height: 1,
  );

  /// Machine facts. Always uppercased at the widget level, never in the token —
  /// uppercasing is presentation, and a token that shouted would be unusable
  /// for anything else.
  static const TextStyle readout = TextStyle(
    fontFamily: fontMono,
    fontWeight: fwMedium,
    fontSize: fsCaption,
    height: 1,
    letterSpacing: trackingReadoutEm * fsCaption, // 1.04
  );

  static const TextStyle readoutSm = TextStyle(
    fontFamily: fontMono,
    fontWeight: fwMedium,
    fontSize: fsMicro,
    height: 1,
    letterSpacing: trackingReadoutEm * fsMicro, // 0.88
  );
}
