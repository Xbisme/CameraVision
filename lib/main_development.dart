import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/app/app.dart';
import 'package:productcam/app/composition_root.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/routing/app_router.dart';
import 'package:productcam/core/routing/routes.dart';
import 'package:productcam/dev/navigation_index_page.dart';

/// Entry point for the **development** flavor.
///
/// This is the only entry point that imports `lib/dev/`, which is what makes
/// developer surfaces absent from production by construction rather than by a
/// runtime check (FR-018).
///
/// Note this is independent of build mode: `flutter build --release --flavor
/// development` still lands here, and still registers the developer index.
/// That combination is deliberate — performance is measured on optimized
/// builds, never on debug ones (Principle V, FR-017).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait is also locked natively; this keeps the constraint visible and
  // testable from the Dart side (FR-031).
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  const AppConfig config = AppConfig.development();
  await configureDependencies(config);

  runApp(
    ProductCamApp(
      config: config,
      permissionService: sl<PermissionService>(),
      router: buildRouter(
        developerRoutes: <RouteBase>[
          GoRoute(
            path: AppRoutes.developerIndex,
            builder: (BuildContext context, GoRouterState state) =>
                const NavigationIndexPage(),
          ),
        ],
      ),
    ),
  );
}
