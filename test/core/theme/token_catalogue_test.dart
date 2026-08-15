import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/tokens/pc_colors.dart';
import 'package:productcam/core/theme/tokens/pc_contour.dart';
import 'package:productcam/core/theme/tokens/pc_elevation.dart';
import 'package:productcam/core/theme/tokens/pc_motion.dart';
import 'package:productcam/core/theme/tokens/pc_radius.dart';
import 'package:productcam/core/theme/tokens/pc_spacing.dart';
import 'package:productcam/core/theme/tokens/pc_typography.dart';

/// Guards SC-001 / FR-003: every custom property in the nine design-system
/// source files is either ported or explained, and none is silently dropped.
///
/// The maps below are keyed by the **CSS token name**, so this file reads as
/// the audit in `contracts/token-catalogue.md` rather than as a Dart inventory.
/// Two things fail here:
///
///  * deleting a token — the file stops compiling, because the map references
///    the member directly;
///  * quietly dropping one from the port — the group count no longer matches.
///
/// What it deliberately cannot check is whether a value is *correct*. That is
/// SC-006's job, by comparing golden output against the design bundle.
void main() {
  group('token catalogue — colors.css (77)', () {
    final Map<String, Object?> ramps = <String, Object?>{
      // ink (13)
      '--ink-950': PcColorTokens.ink950,
      '--ink-900': PcColorTokens.ink900,
      '--ink-850': PcColorTokens.ink850,
      '--ink-800': PcColorTokens.ink800,
      '--ink-700': PcColorTokens.ink700,
      '--ink-600': PcColorTokens.ink600,
      '--ink-500': PcColorTokens.ink500,
      '--ink-400': PcColorTokens.ink400,
      '--ink-300': PcColorTokens.ink300,
      '--ink-200': PcColorTokens.ink200,
      '--ink-100': PcColorTokens.ink100,
      '--ink-050': PcColorTokens.ink050,
      '--white': PcColorTokens.white,
      // mint (7)
      '--mint-050': PcColorTokens.mint050,
      '--mint-200': PcColorTokens.mint200,
      '--mint-400': PcColorTokens.mint400,
      '--mint-500': PcColorTokens.mint500,
      '--mint-600': PcColorTokens.mint600,
      '--mint-700': PcColorTokens.mint700,
      '--mint-900': PcColorTokens.mint900,
      // amber (5)
      '--amber-050': PcColorTokens.amber050,
      '--amber-300': PcColorTokens.amber300,
      '--amber-500': PcColorTokens.amber500,
      '--amber-700': PcColorTokens.amber700,
      '--amber-900': PcColorTokens.amber900,
      // coral (3)
      '--coral-050': PcColorTokens.coral050,
      '--coral-500': PcColorTokens.coral500,
      '--coral-700': PcColorTokens.coral700,
      // checkerboard (4)
      '--checker-a': PcColorTokens.checkerA,
      '--checker-b': PcColorTokens.checkerB,
      '--checker-a-dark': PcColorTokens.checkerADark,
      '--checker-b-dark': PcColorTokens.checkerBDark,
      // alpha utilities (7)
      '--alpha-white-04': PcColorTokens.alphaWhite04,
      '--alpha-white-08': PcColorTokens.alphaWhite08,
      '--alpha-white-14': PcColorTokens.alphaWhite14,
      '--alpha-white-24': PcColorTokens.alphaWhite24,
      '--alpha-ink-40': PcColorTokens.alphaInk40,
      '--alpha-ink-64': PcColorTokens.alphaInk64,
      '--alpha-ink-88': PcColorTokens.alphaInk88,
    };

    final Map<String, Object?> semantic = <String, Object?>{
      // surfaces (9)
      '--bg-shell': PcColorTokens.bgShell,
      '--bg-app': PcColorTokens.bgApp,
      '--bg-surface': PcColorTokens.bgSurface,
      '--bg-surface-raised': PcColorTokens.bgSurfaceRaised,
      '--bg-sheet': PcColorTokens.bgSheet,
      '--bg-input': PcColorTokens.bgInput,
      '--bg-track': PcColorTokens.bgTrack,
      '--bg-scrim': PcColorTokens.bgScrim,
      '--bg-glass': PcColorTokens.bgGlass,
      // light surfaces (2)
      '--bg-light': PcColorTokens.bgLight,
      '--bg-light-surface': PcColorTokens.bgLightSurface,
      // text (8)
      '--text-primary': PcColorTokens.textPrimary,
      '--text-secondary': PcColorTokens.textSecondary,
      '--text-muted': PcColorTokens.textMuted,
      '--text-inverse': PcColorTokens.textInverse,
      '--text-on-accent': PcColorTokens.textOnAccent,
      '--text-accent': PcColorTokens.textAccent,
      '--text-caution': PcColorTokens.textCaution,
      '--text-danger': PcColorTokens.textDanger,
      // accent / interactive (9)
      '--accent': PcColorTokens.accent,
      '--accent-hover': PcColorTokens.accentHover,
      '--accent-press': PcColorTokens.accentPress,
      '--accent-quiet': PcColorTokens.accentQuiet,
      '--accent-quiet-strong': PcColorTokens.accentQuietStrong,
      '--caution': PcColorTokens.caution,
      '--caution-quiet': PcColorTokens.cautionQuiet,
      '--danger': PcColorTokens.danger,
      '--danger-quiet': PcColorTokens.dangerQuiet,
      // borders (5)
      '--border-hairline': PcColorTokens.borderHairline,
      '--border-subtle': PcColorTokens.borderSubtle,
      '--border-strong': PcColorTokens.borderStrong,
      '--border-accent': PcColorTokens.borderAccent,
      '--border-focus': PcColorTokens.borderFocus,
      // batch status (5)
      '--status-queued': PcColorTokens.statusQueued,
      '--status-working': PcColorTokens.statusWorking,
      '--status-done': PcColorTokens.statusDone,
      '--status-review': PcColorTokens.statusReview,
      '--status-error': PcColorTokens.statusError,
    };

    test('39 base ramp entries', () => expect(ramps, hasLength(39)));
    test('38 semantic aliases', () => expect(semantic, hasLength(38)));
    test('77 total, all resolved', () {
      expect(ramps.length + semantic.length, 77);
      expect(
        <String, Object?>{...ramps, ...semantic}.values,
        everyElement(isNotNull),
      );
    });

    test('semantic aliases point at ramp entries, never a fresh value', () {
      // A restated hex is the failure mode: it looks right until someone
      // changes the ramp and one place does not move (FR-006).
      expect(PcColorTokens.accent, same(PcColorTokens.mint500));
      expect(PcColorTokens.bgApp, same(PcColorTokens.ink900));
      expect(PcColorTokens.statusReview, same(PcColorTokens.amber500));
      expect(PcColorTokens.textOnAccent, same(PcColorTokens.ink950));
    });

    test('alpha utilities keep their source percentage exactly', () {
      // Rounding .04 to a convenient byte is the drift FR-004 forbids.
      expect(PcColorTokens.alphaWhite04.a, closeTo(0.04, 0.0001));
      expect(PcColorTokens.alphaWhite08.a, closeTo(0.08, 0.0001));
      expect(PcColorTokens.alphaWhite14.a, closeTo(0.14, 0.0001));
      expect(PcColorTokens.alphaWhite24.a, closeTo(0.24, 0.0001));
      expect(PcColorTokens.alphaInk40.a, closeTo(0.40, 0.0001));
      expect(PcColorTokens.alphaInk64.a, closeTo(0.64, 0.0001));
      expect(PcColorTokens.alphaInk88.a, closeTo(0.88, 0.0001));
    });
  });

  group('token catalogue — typography.css + fonts.css (33 + 2)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      // families, from fonts.css (2)
      '--font-ui': PcTypographyTokens.fontUi,
      '--font-mono': PcTypographyTokens.fontMono,
      // sizes (9)
      '--fs-display': PcTypographyTokens.fsDisplay,
      '--fs-h1': PcTypographyTokens.fsH1,
      '--fs-h2': PcTypographyTokens.fsH2,
      '--fs-h3': PcTypographyTokens.fsH3,
      '--fs-body-lg': PcTypographyTokens.fsBodyLg,
      '--fs-body': PcTypographyTokens.fsBody,
      '--fs-body-sm': PcTypographyTokens.fsBodySm,
      '--fs-caption': PcTypographyTokens.fsCaption,
      '--fs-micro': PcTypographyTokens.fsMicro,
      // line heights (4)
      '--lh-tight': PcTypographyTokens.lhTight,
      '--lh-snug': PcTypographyTokens.lhSnug,
      '--lh-body': PcTypographyTokens.lhBody,
      '--lh-loose': PcTypographyTokens.lhLoose,
      // weights (5)
      '--fw-regular': PcTypographyTokens.fwRegular,
      '--fw-medium': PcTypographyTokens.fwMedium,
      '--fw-semibold': PcTypographyTokens.fwSemibold,
      '--fw-bold': PcTypographyTokens.fwBold,
      '--fw-black': PcTypographyTokens.fwBlack,
      // tracking (5)
      '--tracking-display': PcTypographyTokens.trackingDisplayEm,
      '--tracking-tight': PcTypographyTokens.trackingTightEm,
      '--tracking-normal': PcTypographyTokens.trackingNormalEm,
      '--tracking-readout': PcTypographyTokens.trackingReadoutEm,
      '--tracking-label': PcTypographyTokens.trackingLabelEm,
      // composed roles (10)
      '--type-display': PcTypographyTokens.display,
      '--type-h1': PcTypographyTokens.h1,
      '--type-h2': PcTypographyTokens.h2,
      '--type-h3': PcTypographyTokens.h3,
      '--type-body': PcTypographyTokens.body,
      '--type-body-strong': PcTypographyTokens.bodyStrong,
      '--type-caption': PcTypographyTokens.caption,
      '--type-button': PcTypographyTokens.button,
      '--type-readout': PcTypographyTokens.readout,
      '--type-readout-sm': PcTypographyTokens.readoutSm,
    };

    test('35 tokens, all resolved', () {
      expect(tokens, hasLength(35));
      expect(tokens.values, everyElement(isNotNull));
    });

    test('tracking is converted from em to logical pixels', () {
      // Copying 0.08 straight across would give roughly a thirteenth of the
      // specified tracking — the single most likely silent port error.
      expect(PcTypographyTokens.readout.letterSpacing, closeTo(1.04, 0.0001));
      expect(PcTypographyTokens.readoutSm.letterSpacing, closeTo(0.88, 0.0001));
      expect(PcTypographyTokens.display.letterSpacing, closeTo(-0.68, 0.0001));
      expect(PcTypographyTokens.h1.letterSpacing, closeTo(-0.26, 0.0001));
      expect(PcTypographyTokens.h2.letterSpacing, closeTo(-0.21, 0.0001));
    });

    test('prose is never mono and readouts are never prose (FR-013)', () {
      const List<TextStyle> prose = <TextStyle>[
        PcTypographyTokens.display,
        PcTypographyTokens.h1,
        PcTypographyTokens.h2,
        PcTypographyTokens.h3,
        PcTypographyTokens.body,
        PcTypographyTokens.bodyStrong,
        PcTypographyTokens.caption,
        PcTypographyTokens.button,
      ];
      for (final TextStyle style in prose) {
        expect(style.fontFamily, PcTypographyTokens.fontUi);
      }
      expect(
        PcTypographyTokens.readout.fontFamily,
        PcTypographyTokens.fontMono,
      );
      expect(
        PcTypographyTokens.readoutSm.fontFamily,
        PcTypographyTokens.fontMono,
      );
    });
  });

  group('token catalogue — spacing.css (28)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      '--sp-1': PcSpacingTokens.sp1,
      '--sp-2': PcSpacingTokens.sp2,
      '--sp-3': PcSpacingTokens.sp3,
      '--sp-4': PcSpacingTokens.sp4,
      '--sp-5': PcSpacingTokens.sp5,
      '--sp-6': PcSpacingTokens.sp6,
      '--sp-7': PcSpacingTokens.sp7,
      '--sp-8': PcSpacingTokens.sp8,
      '--sp-9': PcSpacingTokens.sp9,
      '--sp-10': PcSpacingTokens.sp10,
      '--sp-11': PcSpacingTokens.sp11,
      '--sp-12': PcSpacingTokens.sp12,
      '--gutter': PcSpacingTokens.gutter,
      '--gutter-wide': PcSpacingTokens.gutterWide,
      '--sheet-pad': PcSpacingTokens.sheetPad,
      '--touch-min': PcSpacingTokens.touchMin,
      '--touch-comfortable': PcSpacingTokens.touchComfortable,
      '--touch-shutter': PcSpacingTokens.touchShutter,
      '--touch-shutter-hit': PcSpacingTokens.touchShutterHit,
      '--thumb-band': PcSpacingTokens.thumbBand,
      '--bar-height': PcSpacingTokens.barHeight,
      '--tabbar-height': PcSpacingTokens.tabbarHeight,
      '--safe-top': PcSpacingTokens.safeTopReference,
      '--safe-bottom': PcSpacingTokens.safeBottomReference,
      '--grid-gap': PcSpacingTokens.gridGap,
      '--stroke-hairline': PcSpacingTokens.strokeHairline,
      '--stroke-medium': PcSpacingTokens.strokeMedium,
      '--stroke-icon': PcSpacingTokens.strokeIcon,
    };

    test('28 tokens, all resolved', () {
      expect(tokens, hasLength(28));
      expect(tokens.values, everyElement(isNotNull));
    });

    test('touch minimums are the constitutional values', () {
      expect(PcSpacingTokens.touchMin, 44);
      expect(PcSpacingTokens.touchComfortable, 56);
      expect(PcSpacingTokens.touchShutter, 80);
      expect(PcSpacingTokens.touchShutterHit, 104);
    });

    test('fixed bands do not drift', () {
      expect(PcSpacingTokens.barHeight, 56);
      expect(PcSpacingTokens.thumbBand, 132);
      expect(PcSpacingTokens.gutter, 16);
      expect(PcSpacingTokens.gridGap, 6);
    });
  });

  group('token catalogue — radius.css (9)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      '--r-xs': PcRadiusTokens.xs,
      '--r-sm': PcRadiusTokens.sm,
      '--r-md': PcRadiusTokens.md,
      '--r-lg': PcRadiusTokens.lg,
      '--r-xl': PcRadiusTokens.xl,
      '--r-sheet': PcRadiusTokens.sheet,
      '--r-pill': PcRadiusTokens.pill,
      '--r-thumb': PcRadiusTokens.thumb,
      '--r-frame': PcRadiusTokens.frame,
    };

    test('9 tokens, all resolved', () {
      expect(tokens, hasLength(9));
      expect(tokens.values, everyElement(isNotNull));
    });

    test('sheets round their top corners only', () {
      expect(PcRadiusTokens.sheetTop.bottomLeft, Radius.zero);
      expect(PcRadiusTokens.sheetTop.bottomRight, Radius.zero);
      expect(PcRadiusTokens.sheetTop.topLeft.x, PcRadiusTokens.sheet);
    });
  });

  group('token catalogue — elevation.css (11)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      '--rim': PcElevationTokens.rim,
      '--rim-strong': PcElevationTokens.rimStrong,
      '--shadow-float': PcElevationTokens.shadowFloat,
      '--shadow-sheet': PcElevationTokens.shadowSheet,
      '--shadow-thumb': PcElevationTokens.shadowThumb,
      '--glow-accent': PcElevationTokens.glowAccent,
      '--glow-accent-soft': PcElevationTokens.glowAccentSoft,
      '--glow-caution': PcElevationTokens.glowCaution,
      '--scrim-top': PcElevationTokens.scrimTop,
      '--scrim-bottom': PcElevationTokens.scrimBottom,
      '--blur-chrome': PcElevationTokens.blurChromeSigma,
    };

    test('11 tokens, all resolved', () {
      expect(tokens, hasLength(11));
      expect(tokens.values, everyElement(isNotNull));
    });

    test('the accent glow stays two layered shadows', () {
      // A 1px ring plus a soft bloom. Collapsing them loses the ring that
      // defines the locked edge.
      expect(PcElevationTokens.glowAccent, hasLength(2));
      expect(PcElevationTokens.glowAccent.first.spreadRadius, 1);
      expect(PcElevationTokens.glowAccent.last.blurRadius, greaterThan(0));
      expect(PcElevationTokens.glowCaution, hasLength(2));
    });

    test('the saturation matrix preserves grey', () {
      // Every row must sum to 1, or "saturate" would also shift brightness.
      const List<double> m = PcElevationTokens.saturationMatrix;
      for (int row = 0; row < 3; row++) {
        final double sum = m[row * 5] + m[row * 5 + 1] + m[row * 5 + 2];
        expect(sum, closeTo(1.0, 0.001), reason: 'row $row must sum to 1');
      }
      // And it must actually saturate, not desaturate.
      expect(m[0], greaterThan(1.0));
    });
  });

  group('token catalogue — motion.css (16)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      '--dur-instant': PcMotionTokens.instant,
      '--dur-fast': PcMotionTokens.fast,
      '--dur-base': PcMotionTokens.base,
      '--dur-slow': PcMotionTokens.slow,
      '--dur-trace': PcMotionTokens.trace,
      '--dur-lock': PcMotionTokens.lock,
      '--dur-shutter': PcMotionTokens.shutter,
      '--ease-snap': PcMotionTokens.easeSnap,
      '--ease-out': PcMotionTokens.easeOut,
      '--ease-in-out': PcMotionTokens.easeInOut,
      '--ease-linear': PcMotionTokens.easeLinear,
      '--press-scale': PcMotionTokens.pressScale,
      '--press-scale-shutter': PcMotionTokens.pressScaleShutter,
      '--t-press': PcMotionTokens.tPress,
      '--t-color': PcMotionTokens.tColor,
      '--t-sheet': PcMotionTokens.tSheet,
    };

    test('16 tokens, all resolved', () {
      expect(tokens, hasLength(16));
      expect(tokens.values, everyElement(isNotNull));
    });

    test(
      'transition shorthands decompose into existing duration+curve pairs',
      () {
        // Ported rather than dropped — the audit must not read these as missing.
        expect(PcMotionTokens.tPress.$1, PcMotionTokens.instant);
        expect(PcMotionTokens.tPress.$2, PcMotionTokens.easeSnap);
        expect(PcMotionTokens.tColor.$1, PcMotionTokens.fast);
        expect(PcMotionTokens.tSheet.$1, PcMotionTokens.base);
      },
    );
  });

  group('token catalogue — contour.css (20)', () {
    final Map<String, Object?> tokens = <String, Object?>{
      '--contour-core': PcContourTokens.core,
      '--contour-core-lock': PcContourTokens.coreLock,
      '--contour-halo': PcContourTokens.halo,
      '--contour-review': PcContourTokens.review,
      '--contour-error': PcContourTokens.error,
      '--contour-w-core': PcContourTokens.wCore,
      '--contour-w-halo': PcContourTokens.wHalo,
      '--contour-w-core-lock': PcContourTokens.wCoreLock,
      '--contour-dash-scan': PcContourTokens.dashScan,
      '--contour-dash-review': PcContourTokens.dashReview,
      '--contour-march': PcContourTokens.march,
      '--contour-tick': PcContourTokens.tick,
      '--contour-tick-w': PcContourTokens.tickWidth,
      '--contour-fill-scan': PcContourTokens.fillScan,
      '--contour-fill-lock': PcContourTokens.fillLock,
      '--contour-glow': PcContourTokens.glowColor,
      '--contour-glow-review': PcContourTokens.glowReviewColor,
      '--checker-size': PcContourTokens.checkerSize,
      '--checker-light': PcContourTokens.checkerLight,
      '--checker-dark': PcContourTokens.checkerDark,
    };

    test('20 tokens, all resolved', () {
      expect(tokens, hasLength(20));
      expect(tokens.values, everyElement(isNotNull));
    });

    test('the halo is always wider than the core', () {
      // The two-stroke invariant in numeric form. If this ever inverts, the
      // contour stops surviving a white background (FR-016).
      expect(PcContourTokens.wHalo, greaterThan(PcContourTokens.wCore));
      expect(PcContourTokens.wHalo, greaterThan(PcContourTokens.wCoreLock));
      expect(PcContourTokens.wCoreLock, greaterThan(PcContourTokens.wCore));
    });

    test('the two dash patterns are distinguishable without colour', () {
      // Principle XI: state may not rest on hue alone.
      expect(PcContourTokens.dashScan, isNot(PcContourTokens.dashReview));
    });

    test('the checkerboard keeps the industry-standard light values', () {
      expect(PcContourTokens.checkerLight.$1, PcColorTokens.checkerA);
      expect(PcContourTokens.checkerLight.$2, PcColorTokens.checkerB);
      expect(PcContourTokens.checkerSize, 16);
    });
  });

  test('196 properties accounted for across the nine source files', () {
    // The number that must hold. Group counts are asserted individually above;
    // this is the total the catalogue commits to.
    const Map<String, int> perFile = <String, int>{
      'colors.css': 77,
      'typography.css + fonts.css': 35,
      'spacing.css': 28,
      'radius.css': 9,
      'elevation.css': 11,
      'motion.css': 16,
      'contour.css': 20,
      'base.css': 0, // 8 element-default rules, zero custom properties
    };
    expect(perFile.values.reduce((int a, int b) => a + b), 196);
  });
}
