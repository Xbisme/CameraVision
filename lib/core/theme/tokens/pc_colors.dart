import 'package:flutter/painting.dart';

/// Colour tokens — ported 1:1 from the design bundle's `tokens/colors.css`.
///
/// See `specs/001b-design-system-theme/contracts/token-catalogue.md` §1.
/// 77 definitions: 39 base ramp entries, then 38 semantic aliases.
///
/// The semantic table is law, not preference (Constitution VII):
/// mint is the **only** signal colour and is spent on machine feedback and the
/// one primary action per screen; amber means "worth a look" and **never**
/// failure; coral is failure only. At most two background values per screen.
///
/// Alpha utilities use `Color.fromRGBO` so the source percentage survives
/// exactly. Rounding `.04` to a convenient hex byte is the drift FR-004 forbids.
abstract final class PcColorTokens {
  // ==========================================================================
  // BASE RAMPS (39)
  // ==========================================================================

  // --- ink: the cool navy-graphite viewfinder chrome (13) -------------------
  static const Color ink950 = Color(0xFF04090F);
  static const Color ink900 = Color(0xFF08121C);
  static const Color ink850 = Color(0xFF0C1826);
  static const Color ink800 = Color(0xFF112232);
  static const Color ink700 = Color(0xFF1A2F42);
  static const Color ink600 = Color(0xFF274155);
  static const Color ink500 = Color(0xFF3B5A70);
  static const Color ink400 = Color(0xFF5C7C93);
  static const Color ink300 = Color(0xFF8AA6B8);
  static const Color ink200 = Color(0xFFB9CCD8);
  static const Color ink100 = Color(0xFFDCE7ED);
  static const Color ink050 = Color(0xFFF1F6F8);
  static const Color white = Color(0xFFFFFFFF);

  // --- mint: the signal colour — contour, focus, confirm, progress (7) ------
  // Blue was rejected: it is the category default and a common colour in real
  // products and packaging, so it competes with the subject.
  static const Color mint050 = Color(0xFFE4FFF9);
  static const Color mint200 = Color(0xFF9DF7E5);
  static const Color mint400 = Color(0xFF56F0D6);
  static const Color mint500 = Color(0xFF1FE3C2);
  static const Color mint600 = Color(0xFF10B79C);
  static const Color mint700 = Color(0xFF0A8A76);
  static const Color mint900 = Color(0xFF053F36);

  // --- amber: "cần xem lại" — complex edges, touch-up hints. NEVER red (5) --
  static const Color amber050 = Color(0xFFFFF4DE);
  static const Color amber300 = Color(0xFFFFD48A);
  static const Color amber500 = Color(0xFFFFB020);
  static const Color amber700 = Color(0xFFA86A00);
  static const Color amber900 = Color(0xFF3D2700);

  // --- coral: hard failure only (3) ----------------------------------------
  static const Color coral050 = Color(0xFFFFE9E9);
  static const Color coral500 = Color(0xFFFF5A5F);
  static const Color coral700 = Color(0xFFB3272C);

  // --- checkerboard: industry-standard transparency values (4) -------------
  // The Photoshop/Figma figures. The design explicitly forbids redesigning this
  // convention — it is the one symbol already in sellers' eyes from other tools.
  static const Color checkerA = Color(0xFFFFFFFF);
  static const Color checkerB = Color(0xFFD8DEE3);
  static const Color checkerADark = Color(0xFF2A3A48);
  static const Color checkerBDark = Color(0xFF1E2C38);

  // --- alpha utilities (7) --------------------------------------------------
  static const Color alphaWhite04 = Color.fromRGBO(255, 255, 255, 0.04);
  static const Color alphaWhite08 = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color alphaWhite14 = Color.fromRGBO(255, 255, 255, 0.14);
  static const Color alphaWhite24 = Color.fromRGBO(255, 255, 255, 0.24);
  static const Color alphaInk40 = Color.fromRGBO(4, 9, 15, 0.4);
  static const Color alphaInk64 = Color.fromRGBO(4, 9, 15, 0.64);
  static const Color alphaInk88 = Color.fromRGBO(4, 9, 15, 0.88);

  // ==========================================================================
  // SEMANTIC ALIASES (38)
  // Each points at a ramp entry. None restates a hex — `accent` *is* `mint500`,
  // not a second copy of the same value.
  // ==========================================================================

  // --- surfaces (9) ---------------------------------------------------------
  static const Color bgShell = ink950;
  static const Color bgApp = ink900;
  static const Color bgSurface = ink850;
  static const Color bgSurfaceRaised = ink800;
  static const Color bgSheet = ink850;
  static const Color bgInput = ink800;
  static const Color bgTrack = ink700;
  static const Color bgScrim = alphaInk64;
  static const Color bgGlass = Color.fromRGBO(8, 18, 28, 0.62);

  // --- light surfaces (2) ---------------------------------------------------
  // Used only in the export/handoff preview (Spec #007). Ported now because
  // FR-003 forbids dropping a token merely because its consumer is unwritten.
  static const Color bgLight = ink050;
  static const Color bgLightSurface = white;

  // --- text (8) -------------------------------------------------------------
  static const Color textPrimary = ink050;
  static const Color textSecondary = ink300;
  static const Color textMuted = ink400;
  static const Color textInverse = ink900;
  static const Color textOnAccent = ink950;
  static const Color textAccent = mint400;
  static const Color textCaution = amber300;
  static const Color textDanger = coral500;

  // --- accent / interactive (9) --------------------------------------------
  static const Color accent = mint500;

  /// ⚠️ PORTED BUT UNUSED. The design's own note is that hover exists only for
  /// the desktop preview of the bundle. This is a touch product; wiring a hover
  /// callback to it would be a Principle XI violation dressed as thoroughness.
  static const Color accentHover = mint400;

  static const Color accentPress = mint600;
  static const Color accentQuiet = Color.fromRGBO(31, 227, 194, 0.14);
  static const Color accentQuietStrong = Color.fromRGBO(31, 227, 194, 0.26);
  static const Color caution = amber500;
  static const Color cautionQuiet = Color.fromRGBO(255, 176, 32, 0.16);
  static const Color danger = coral500;
  static const Color dangerQuiet = Color.fromRGBO(255, 90, 95, 0.16);

  // --- borders: hairlines only (5) -----------------------------------------
  // No 2px outlines exist except the contour and selection rings.
  static const Color borderHairline = alphaWhite08;
  static const Color borderSubtle = alphaWhite14;
  static const Color borderStrong = alphaWhite24;
  static const Color borderAccent = mint500;
  static const Color borderFocus = mint400;

  // --- batch item status (5) -----------------------------------------------
  // Every one of these pairs with a non-colour mark at the widget level —
  // colour alone never carries state (Constitution XI).
  static const Color statusQueued = ink400;
  static const Color statusWorking = mint400;
  static const Color statusDone = mint500;
  static const Color statusReview = amber500;
  static const Color statusError = coral500;
}
