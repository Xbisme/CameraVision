import 'package:flutter/widgets.dart';

/// Radius tokens — ported 1:1 from the design bundle's `tokens/radius.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §5.
/// 9 definitions.
abstract final class PcRadiusTokens {
  // Raw values, kept so a caller that needs a single corner is not forced to
  // decompose a BorderRadius.
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double sheet = 24;
  static const double thumb = 12;
  static const double frame = 34;

  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius thumbAll = BorderRadius.all(Radius.circular(thumb));
  static const BorderRadius frameAll = BorderRadius.all(Radius.circular(frame));

  /// Sheets round their **top corners only** — the bottom edge meets the
  /// screen edge.
  static const BorderRadius sheetTop = BorderRadius.only(
    topLeft: Radius.circular(sheet),
    topRight: Radius.circular(sheet),
  );

  /// `--r-pill: 999px` is the CSS idiom for "fully rounded", not a measurement.
  /// Transcribing it as a literal 999-pixel radius would be a misreading, so it
  /// lands as the shape Flutter has for exactly this purpose.
  static const StadiumBorder pill = StadiumBorder();
}
