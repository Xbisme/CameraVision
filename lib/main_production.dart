import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productcam/app/app.dart';
import 'package:productcam/app/composition_root.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/routing/app_router.dart';

/// Entry point for the **production** flavor.
///
/// No developer routes are passed, and `lib/dev/` is not imported anywhere in
/// this file's reachable graph — the navigation index cannot ship (FR-018).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  const AppConfig config = AppConfig.production();
  await configureDependencies(config);

  runApp(
    ProductCamApp(
      config: config,
      permissionService: sl<PermissionService>(),
      router: buildRouter(),
    ),
  );
}
