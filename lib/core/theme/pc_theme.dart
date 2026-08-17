import 'package:flutter/material.dart';

import 'extensions/pc_colors.dart';
import 'extensions/pc_contour.dart';
import 'extensions/pc_elevation.dart';
import 'extensions/pc_motion.dart';
import 'extensions/pc_radius.dart';
import 'extensions/pc_spacing.dart';
import 'extensions/pc_typography.dart';
import 'tokens/pc_colors.dart';
import 'tokens/pc_typography.dart';

/// Builds the one ProductCam theme.
///
/// There is exactly one, and it is dark. The design rejected a light UI
/// deliberately: the main surface is a live video feed, so the chrome has to
/// recede and let the subject dominate — and ink navy is also what makes the
/// mint contour readable, which a white shell would not (FR-007).
///
/// A light theme, a runtime appearance switch and a colour picker are all out
/// of scope, and adding one is a constitutional amendment rather than a
/// follow-up task.
///
/// The seven [ThemeExtension]s registered here are the whole point: call sites
/// read `context.pcColors` and friends, and never a token directly.
ThemeData buildPcTheme() {
  final PcColors colors = PcColors.fromTokens();
  final PcTypography type = PcTypography.fromTokens();

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colors.bgApp,
    canvasColor: colors.bgApp,

    // Mapping from the design bundle's own "Flutter mapping" table. Material's
    // colour roles are populated so framework widgets that slip through look
    // right, but ProductCam's own widgets read the extensions, not this.
    colorScheme: const ColorScheme.dark(
      primary: PcColorTokens.accent,
      onPrimary: PcColorTokens.textOnAccent,
      secondary: PcColorTokens.accentPress,
      onSecondary: PcColorTokens.textOnAccent,
      surface: PcColorTokens.bgApp,
      onSurface: PcColorTokens.textPrimary,
      surfaceContainer: PcColorTokens.bgSurface,
      surfaceContainerHigh: PcColorTokens.bgSurfaceRaised,
      error: PcColorTokens.danger,
      onError: PcColorTokens.textPrimary,
      outline: PcColorTokens.borderHairline,
      outlineVariant: PcColorTokens.borderSubtle,
    ),

    // `--caution` has no Material role — amber means "worth a look" here and
    // never failure, which is a distinction Material's palette does not carry.
    // It lives on PcColors instead.
    fontFamily: PcTypographyTokens.fontUi,

    textTheme:
        TextTheme(
          displaySmall: type.display,
          headlineMedium: type.h1,
          headlineSmall: type.h2,
          titleLarge: type.h3,
          titleMedium: type.bodyStrong,
          bodyLarge: type.body,
          bodyMedium: type.body,
          bodySmall: type.caption,
          labelLarge: type.button,
          // Mono readouts. Machine facts only — prose set in this role would
          // violate FR-013.
          labelSmall: type.readout,
        ).apply(
          bodyColor: PcColorTokens.textPrimary,
          displayColor: PcColorTokens.textPrimary,
        ),

    extensions: <ThemeExtension<dynamic>>[
      colors,
      type,
      PcSpacing.fromTokens(),
      PcRadius.fromTokens(),
      PcElevation.fromTokens(),
      PcMotion.fromTokens(),
      PcContour.fromTokens(),
    ],
  );
}
