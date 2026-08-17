/// Spacing tokens — ported 1:1 from the design bundle's `tokens/spacing.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §4.
/// 28 definitions. This file is inside `lib/core/theme/tokens/`, the only
/// directory in the repository where raw visual literals are permitted
/// (Constitution VII).
///
/// The touch values are hard minimums, not suggestions. The shutter is pressed
/// hundreds of times in a batch session, one-handed, without looking.
abstract final class PcSpacingTokens {
  // --- 4px scale (--sp-1 … --sp-12) ----------------------------------------
  static const double sp1 = 2;
  static const double sp2 = 4;
  static const double sp3 = 6;
  static const double sp4 = 8;
  static const double sp5 = 12;
  static const double sp6 = 16;
  static const double sp7 = 20;
  static const double sp8 = 24;
  static const double sp9 = 32;
  static const double sp10 = 40;
  static const double sp11 = 48;
  static const double sp12 = 64;

  // --- Gutters --------------------------------------------------------------
  static const double gutter = 16;
  static const double gutterWide = 20;
  static const double sheetPad = 20;

  // --- Touch (Constitution XI — hard minimums) ------------------------------
  static const double touchMin = 44;
  static const double touchComfortable = 56;
  static const double touchShutter = 80;
  static const double touchShutterHit = 104;

  /// Nothing may be tappable within this radius of the shutter. Not a CSS
  /// token — it is stated in the bundle readme's shutter spec and belongs with
  /// the other touch rules rather than buried in the widget.
  static const double shutterExclusion = 12;

  // --- Fixed bands ----------------------------------------------------------
  /// Bottom band holding every primary action, so the app stays one-handed.
  /// Never grows with text scale, and never holds a destructive action.
  static const double thumbBand = 132;
  static const double barHeight = 56;
  static const double tabbarHeight = 64;

  // --- Safe areas -----------------------------------------------------------
  // ⚠️ REFERENCE ONLY — DO NOT USE FOR LAYOUT.
  // The bundle hardcodes these because a browser cannot ask a phone about its
  // notch. Real insets come from `MediaQuery.viewPaddingOf(context)`. Laying
  // out against these constants breaks every device whose insets differ, which
  // is most of them. Ported because the catalogue forbids silent drops
  // (FR-003), not because anything should read them.
  static const double safeTopReference = 44;
  static const double safeBottomReference = 34;

  // --- Grid -----------------------------------------------------------------
  /// Photo thumbnails sit tight: the photos are the interface, and chrome
  /// between them is waste.
  static const double gridGap = 6;

  // --- Strokes --------------------------------------------------------------
  static const double strokeHairline = 1;
  static const double strokeMedium = 1.5;
  static const double strokeIcon = 1.75;

  // --- Icon sizes -----------------------------------------------------------
  // From the bundle readme's iconography section rather than a CSS custom
  // property, which is why they are not in the 196-token count. They belong
  // here all the same: a component writing `size: 22` inline is exactly the
  // magic number Principle X forbids.
  static const double iconBadge = 14;
  static const double iconInline = 18;
  static const double iconChrome = 22;
  static const double iconLarge = 26;

  // --- Text scaling ---------------------------------------------------------
  /// Enlarged text is honoured up to here and capped (FR-015a). Beyond this the
  /// fixed 56/132 bands would have to stretch, and the shutter would stop being
  /// where the thumb expects it. Not a CSS token — it is this project's answer
  /// to a question the prototype never had to face.
  static const double maxTextScaleFactor = 1.3;
}
