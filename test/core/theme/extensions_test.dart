import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/extensions/pc_colors.dart';
import 'package:productcam/core/theme/extensions/pc_contour.dart';
import 'package:productcam/core/theme/extensions/pc_elevation.dart';
import 'package:productcam/core/theme/extensions/pc_motion.dart';
import 'package:productcam/core/theme/extensions/pc_radius.dart';
import 'package:productcam/core/theme/extensions/pc_spacing.dart';
import 'package:productcam/core/theme/extensions/pc_typography.dart';
import 'package:productcam/core/theme/pc_context.dart';
import 'package:productcam/core/theme/pc_theme.dart';

/// Guards the `ThemeExtension` layer.
///
/// The failure this file exists to catch is a `lerp` that returns `this`. It
/// compiles, it looks finished, and it silently disables every theme
/// transition — and a test that only reads values back would pass happily
/// (research R8). So each extension is asked to interpolate between two
/// genuinely different instances and must land somewhere in between.
void main() {
  group('all seven extensions are registered on the theme', () {
    testWidgets('and are reachable through the context getters', (
      WidgetTester tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildPcTheme(),
          home: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(ctx.pcColors, isA<PcColors>());
      expect(ctx.pcTypography, isA<PcTypography>());
      expect(ctx.pcSpacing, isA<PcSpacing>());
      expect(ctx.pcRadius, isA<PcRadius>());
      expect(ctx.pcElevation, isA<PcElevation>());
      expect(ctx.pcMotion, isA<PcMotion>());
      expect(ctx.pcContour, isA<PcContour>());
    });

    testWidgets('the theme is dark whichever slot Material picks', (
      WidgetTester tester,
    ) async {
      // FR-007: the app must not follow the device appearance. Both slots carry
      // the same theme, so a device in light mode still gets ink navy.
      final ThemeData theme = buildPcTheme();
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, PcColors.fromTokens().bgApp);
    });
  });

  group('PcColors', () {
    test('copyWith replaces only what it is given', () {
      final PcColors base = PcColors.fromTokens();
      final PcColors changed = base.copyWith(accent: const Color(0xFFFF0000));
      expect(changed.accent, const Color(0xFFFF0000));
      expect(changed.bgApp, base.bgApp);
      expect(changed.statusReview, base.statusReview);
    });

    test('lerp interpolates rather than snapping to an endpoint', () {
      final PcColors a = PcColors.fromTokens();
      final PcColors b = a.copyWith(
        bgApp: const Color(0xFFFFFFFF),
        accent: const Color(0xFF000000),
      );
      final PcColors mid = a.lerp(b, 0.5);

      expect(mid.bgApp, isNot(a.bgApp));
      expect(mid.bgApp, isNot(b.bgApp));
      expect(mid.accent, isNot(a.accent));
      expect(mid.accent, isNot(b.accent));
    });

    test('lerp at the endpoints returns the endpoints', () {
      final PcColors a = PcColors.fromTokens();
      final PcColors b = a.copyWith(bgApp: const Color(0xFFFFFFFF));
      expect(a.lerp(b, 0).bgApp, a.bgApp);
      expect(a.lerp(b, 1).bgApp, b.bgApp);
    });

    test('lerp against null keeps the receiver', () {
      final PcColors a = PcColors.fromTokens();
      expect(a.lerp(null, 0.5), same(a));
    });
  });

  group('PcSpacing', () {
    test('copyWith and lerp move numeric fields', () {
      final PcSpacing a = PcSpacing.fromTokens();
      final PcSpacing b = a.copyWith(sp6: 32);
      expect(b.sp6, 32);
      expect(b.gutter, a.gutter);
      expect(a.lerp(b, 0.5).sp6, closeTo(24, 0.0001));
    });

    test('the touch minimums survive a round trip', () {
      final PcSpacing a = PcSpacing.fromTokens();
      expect(a.touchMin, 44);
      expect(a.touchShutter, 80);
      expect(a.touchShutterHit, 104);
      expect(a.copyWith().touchShutterHit, 104);
    });
  });

  group('PcTypography', () {
    test('lerp interpolates the composed roles', () {
      final PcTypography a = PcTypography.fromTokens();
      final PcTypography b = a.copyWith(body: a.body.copyWith(fontSize: 32));
      expect(a.lerp(b, 0.5).body.fontSize, closeTo(24, 0.0001));
    });

    test('label tracking converts em to pixels per size', () {
      final PcTypography a = PcTypography.fromTokens();
      // .06em at 11px is 0.66px, not 0.06px.
      expect(a.labelTracking(11), closeTo(0.66, 0.0001));
      expect(a.labelTracking(13), closeTo(0.78, 0.0001));
    });
  });

  group('PcMotion', () {
    test('durations interpolate', () {
      final PcMotion a = PcMotion.fromTokens();
      final PcMotion b = a.copyWith(base: const Duration(milliseconds: 420));
      final PcMotion mid = a.lerp(b, 0.5);
      expect(mid.base.inMilliseconds, 320); // between 220 and 420
    });

    test('curves snap at the midpoint rather than pretending to blend', () {
      final PcMotion a = PcMotion.fromTokens();
      final PcMotion b = a.copyWith(easeSnap: Curves.bounceIn);
      expect(a.lerp(b, 0.25).easeSnap, a.easeSnap);
      expect(a.lerp(b, 0.75).easeSnap, b.easeSnap);
    });

    test('the transition shorthands resolve to existing pairs', () {
      final PcMotion a = PcMotion.fromTokens();
      expect(a.tPress.$1, a.instant);
      expect(a.tPress.$2, a.easeSnap);
      expect(a.tSheet.$1, a.base);
    });
  });

  group('PcRadius', () {
    test('lerp interpolates and sheets keep square bottom corners', () {
      final PcRadius a = PcRadius.fromTokens();
      final PcRadius b = a.copyWith(
        md: const BorderRadius.all(Radius.circular(28)),
      );
      expect(a.lerp(b, 0.5).md.topLeft.x, closeTo(21, 0.0001)); // 14 → 28
      expect(a.sheetTop.bottomLeft, Radius.zero);
    });
  });

  group('PcElevation', () {
    test('lerp interpolates shadows and gradients', () {
      final PcElevation a = PcElevation.fromTokens();
      final PcElevation b = a.copyWith(blurChromeSigma: 36);
      expect(a.lerp(b, 0.5).blurChromeSigma, closeTo(27, 0.0001)); // 18 → 36
      expect(a.lerp(b, 0.5).scrimTop, isA<LinearGradient>());
    });

    test('the accent glow keeps both layers through a lerp', () {
      // Collapsing the two-shadow glow to one would lose the 1px ring that
      // defines a locked edge.
      final PcElevation a = PcElevation.fromTokens();
      expect(a.lerp(a.copyWith(), 0.5).glowAccent, hasLength(2));
    });
  });

  group('PcContour', () {
    test('lerp interpolates widths and dash patterns', () {
      final PcContour a = PcContour.fromTokens();
      final PcContour b = a.copyWith(wCore: 6.5);
      expect(a.lerp(b, 0.5).wCore, closeTo(4.5, 0.0001)); // 2.5 → 6.5
      expect(a.lerp(b, 0.5).dashScan.$1, a.dashScan.$1);
    });

    test('the halo stays wider than the core across any interpolation', () {
      // The two-stroke guarantee must not have a window where it is false.
      final PcContour a = PcContour.fromTokens();
      final PcContour b = a.copyWith(wCore: 5, wHalo: 12);
      for (final double t in <double>[0, 0.25, 0.5, 0.75, 1]) {
        final PcContour c = a.lerp(b, t);
        expect(
          c.wHalo,
          greaterThan(c.wCore),
          reason: 'halo must stay wider at t=$t',
        );
      }
    });
  });
}
