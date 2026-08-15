import 'package:flutter/painting.dart';

import 'pc_colors.dart';
import 'pc_motion.dart';

/// Contour and checkerboard tokens — ported from the design bundle's
/// `tokens/contour.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §8.
/// 20 definitions, plus five `@keyframes` that are behaviour rather than values
/// and are realised in the widgets (listed at the bottom of this doc comment).
///
/// ## The two-stroke rule is an invariant, not a style
///
/// The contour is drawn twice — [wHalo] (6) underneath in [halo], then [wCore]
/// (2.5) on top in [core]. **There is no token for a single-stroke contour and
/// none may be added.** The camera can point at anything: a white paper sweep,
/// warm cardboard, black leather, a backlit window. A single-colour line
/// disappears against one of them, and that range is exactly what a product
/// photographer works across all day (FR-016).
///
/// State is carried by dash pattern and motion, **not by hue** — so it survives
/// blown highlights, greyscale and colour-blindness (Constitution XI).
///
/// Keyframes realised elsewhere: `pc-march` and `pc-sweep` and `pc-lock-pulse`
/// in `ContourOverlay`, `pc-trace-spin` in `ProgressTrace`, `pc-fade-up` in
/// `PcToast` and `PcSheet`.
abstract final class PcContourTokens {
  // --- Colours (5) ----------------------------------------------------------
  static const Color core = PcColorTokens.mint500;
  static const Color coreLock = Color(0xFFEAFFFA);
  static const Color halo = Color.fromRGBO(4, 9, 15, 0.62);
  static const Color review = PcColorTokens.amber500;
  static const Color error = PcColorTokens.coral500;

  // --- Stroke widths (3) ----------------------------------------------------
  static const double wCore = 2.5;
  static const double wHalo = 6;
  static const double wCoreLock = 3;

  // --- Dash patterns (2) ----------------------------------------------------
  // (dash, gap) in logical pixels, consumed by the PathMetric walk.
  static const (double, double) dashScan = (12, 9);
  static const (double, double) dashReview = (2, 7);

  // --- March (1) ------------------------------------------------------------
  /// Aliases `--dur-trace`. The only loop in the product, and it is a status
  /// light rather than an animation — it stops under reduced motion (FR-027a).
  static const Duration march = PcMotionTokens.trace;

  // --- Framing ticks (2) ----------------------------------------------------
  // The instrument reticle bracketing the subject.
  static const double tick = 20;
  static const double tickWidth = 3;

  // --- State fills (2) ------------------------------------------------------
  static const Color fillScan = Color.fromRGBO(31, 227, 194, 0.06);
  static const Color fillLock = Color.fromRGBO(31, 227, 194, 0.12);

  // --- Glows (2) ------------------------------------------------------------
  // CSS `drop-shadow(0 0 6px …)` follows the box-shadow convention, so its
  // blur radius of 6 is σ 3. A BoxShadow cannot follow an arbitrary path, so
  // these are applied as a MaskFilter on the painted contour instead — one of
  // the documented substitutions (research R9), and still owed the visual
  // sign-off in T011 along with the other blur values.
  static const double glowSigma = 3;
  static const Color glowColor = Color.fromRGBO(31, 227, 194, 0.55);
  static const Color glowReviewColor = Color.fromRGBO(255, 176, 32, 0.5);

  // --- Checkerboard (3) -----------------------------------------------------
  /// The repeating tile is 16px and contains four 8px quadrants. CSS expresses
  /// this as a `repeating-conic-gradient`; Flutter paints the tile once and
  /// repeats it with an `ImageShader` in `TileMode.repeated` (research R9).
  static const double checkerSize = 16;

  /// Light is the default wherever a cutout is previewed at size — these are
  /// the Photoshop/Figma values sellers already recognise, and the design
  /// explicitly forbids redesigning the convention (FR-022a).
  static const (Color, Color) checkerLight = (
    PcColorTokens.checkerA,
    PcColorTokens.checkerB,
  );

  /// Dark is for grid thumbnails only, where a small white patch surrounded by
  /// the ink shell glares.
  static const (Color, Color) checkerDark = (
    PcColorTokens.checkerADark,
    PcColorTokens.checkerBDark,
  );
}
