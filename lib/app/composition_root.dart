import 'package:get_it/get_it.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/permission/permission_service_impl.dart';

/// The single place dependencies are wired.
///
/// **This is the only file permitted to read the service locator** (Principle
/// I). Everywhere else, dependencies arrive through constructors — which is
/// what keeps cubits testable with plain arguments and no locator setup.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  await sl.reset();

  sl
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<PermissionService>(
      () => const PermissionServiceImpl(),
    );
}
