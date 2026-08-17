import 'package:flutter/animation.dart';

/// Motion tokens — ported 1:1 from the design bundle's `tokens/motion.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §7.
/// 16 definitions.
///
/// Motion is feedback, never decoration. Nothing animates longer than a shutter
/// press except the contour trace, which is a live status indicator rather than
/// an animation. Bounce, spring, parallax and decorative motion are forbidden
/// (Constitution XI) — someone shooting forty items in a row pays for every
/// frame in battery and in time.
abstract final class PcMotionTokens {
  // --- Durations ------------------------------------------------------------
  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration base = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 380);
  static const Duration lock = Duration(milliseconds: 180);
  static const Duration shutter = Duration(milliseconds: 110);

  /// The single loop in the product: the contour's dash march. It is a status
  /// light, not an animation, and it stops under reduced motion (FR-027a).
  static const Duration trace = Duration(milliseconds: 1100);

  // --- Curves ---------------------------------------------------------------
  /// For anything the finger caused.
  static const Cubic easeSnap = Cubic(0.2, 0.9, 0.2, 1);

  /// For entrances.
  static const Cubic easeOut = Cubic(0.16, 1, 0.3, 1);
  static const Cubic easeInOut = Cubic(0.4, 0, 0.2, 1);
  static const Curve easeLinear = Curves.linear;

  // --- Press scales ---------------------------------------------------------
  static const double pressScale = 0.955;
  static const double pressScaleShutter = 0.90;

  // --- Transitions ----------------------------------------------------------
  // CSS bundles property + duration + easing into one `transition` shorthand.
  // Flutter has no such object, so each one decomposes into the duration and
  // curve it was built from. Ported as pairs rather than dropped
  // (token-catalogue §7); the property each animates is chosen per widget.
  static const (Duration, Curve) tPress = (instant, easeSnap);
  static const (Duration, Curve) tColor = (fast, easeOut);
  static const (Duration, Curve) tSheet = (base, easeOut);
}
