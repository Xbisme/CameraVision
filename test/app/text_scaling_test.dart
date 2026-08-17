import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productcam/app/app.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/routing/app_router.dart';
import 'package:productcam/core/routing/routes.dart';
import 'package:productcam/core/theme/tokens/pc_spacing.dart';

class _MockPermissionService extends Mock implements PermissionService {}

/// FR-015a / SC-012 — enlarged system text is honoured up to 1.3× and capped
/// there, and no area breaks on the way.
///
/// The cap is applied once at the root rather than per component, so this walks
/// the real app rather than a harness. Two failures matter: text that keeps
/// growing past the cap, and a layout that overflows because it did.
void main() {
  setUpAll(() => registerFallbackValue(AppPermission.camera));

  /// The seven areas from Spec #001. `/dev` is deliberately absent: the
  /// developer index is registered only by `main_development.dart`, so the
  /// production build cannot reference `lib/dev/` at all. Driving the router
  /// directly reaches every area without needing it.
  const List<String> areas = <String>[
    AppRoutes.cameraCapture,
    AppRoutes.review,
    AppRoutes.backgroundEditor,
    AppRoutes.batch,
    AppRoutes.export,
    AppRoutes.history,
    AppRoutes.settings,
  ];

  Future<GoRouter> pumpApp(WidgetTester tester, double deviceScale) async {
    final GoRouter router = buildRouter();
    await tester.pumpWidget(
      MediaQuery(
        // What the operating system reports — deliberately far past the cap,
        // because the point is that the app refuses to follow it all the way.
        data: MediaQueryData(textScaler: TextScaler.linear(deviceScale)),
        child: ProductCamApp(
          config: const AppConfig.development(),
          permissionService: _MockPermissionService(),
          router: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('text stops growing at the cap however far the device goes', (
    WidgetTester tester,
  ) async {
    for (final double deviceScale in <double>[1.0, 1.3, 2.0, 3.1]) {
      await pumpApp(tester, deviceScale);

      final BuildContext context = tester.element(find.byType(Scaffold).first);
      final double effective =
          MediaQuery.textScalerOf(context).scale(100) / 100;

      expect(
        effective,
        lessThanOrEqualTo(PcSpacingTokens.maxTextScaleFactor + 0.0001),
        reason:
            'the device asked for ${deviceScale}x; the app must cap at '
            '${PcSpacingTokens.maxTextScaleFactor}x, or the fixed 56/132 bands '
            'would have to stretch and the shutter would move',
      );
      // Below the cap the setting must be honoured, not quietly ignored —
      // capping is not the same as refusing.
      expect(
        effective,
        closeTo(deviceScale.clamp(0, PcSpacingTokens.maxTextScaleFactor), 1e-4),
      );
    }
  });

  testWidgets('no area overflows at the largest text size the OS can ask for', (
    WidgetTester tester,
  ) async {
    // A RenderFlex overflow surfaces as a FlutterError during paint, so
    // collecting errors is how one is *caught* rather than left as a yellow
    // stripe nobody is looking at.
    final List<Object> errors = <Object>[];
    final FlutterExceptionHandler? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails d) => errors.add(d.exception);

    final GoRouter router = await pumpApp(tester, 3.1);

    for (final String route in areas) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(
        find.byType(Scaffold),
        findsWidgets,
        reason: '$route rendered nothing at 3.1x',
      );
    }

    FlutterError.onError = previous;
    tester.takeException();

    final List<Object> overflows = errors
        .where((Object e) => e.toString().contains('overflow'))
        .toList();
    expect(
      overflows,
      isEmpty,
      reason:
          'layout overflowed with the OS at its largest text setting:\n'
          '${overflows.join('\n')}',
    );
  });

  testWidgets('every area is reachable and none of them throws (SC-011)', (
    WidgetTester tester,
  ) async {
    // The other half of SC-011: appearance changed, capability did not. Each
    // area still opens and still dead-ends nowhere.
    final GoRouter router = await pumpApp(tester, 1.3);

    for (final String route in areas) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$route threw');
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
