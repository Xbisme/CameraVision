import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productcam/app/app.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/routing/app_router.dart';

class _MockPermissionService extends Mock implements PermissionService {}

/// FR-021, FR-030 — the app launches to the camera area, and nothing prompts
/// for a permission on the way in.
void main() {
  setUpAll(() => registerFallbackValue(AppPermission.camera));

  testWidgets('launches to the camera area without prompting', (
    WidgetTester tester,
  ) async {
    final _MockPermissionService permissions = _MockPermissionService();

    await tester.pumpWidget(
      ProductCamApp(
        config: const AppConfig.production(),
        permissionService: permissions,
        router: buildRouter(),
      ),
    );
    await tester.pumpAndSettle();

    // The camera area is first, with no onboarding or gate before it.
    expect(find.text('Camera'), findsWidgets);

    // Nothing was asked for on the way in (Principle VI).
    verifyNever(() => permissions.request(any()));
  });

  testWidgets('production build renders in dark chrome', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProductCamApp(
        config: const AppConfig.production(),
        permissionService: _MockPermissionService(),
        router: buildRouter(),
      ),
    );
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.themeMode, equals(ThemeMode.dark));
  });
}
