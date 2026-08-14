import 'package:permission_handler/permission_handler.dart' as ph;

import '../error/app_failure.dart';
import 'permission_service.dart';

/// Adapter over `permission_handler`, mapping its statuses onto the four states
/// the app actually distinguishes.
class PermissionServiceImpl implements PermissionService {
  const PermissionServiceImpl();

  @override
  Future<PermissionState> check(AppPermission permission) async {
    return _map(await _platform(permission).status);
  }

  @override
  Future<PermissionState> request(AppPermission permission) async {
    return _map(await _platform(permission).request());
  }

  @override
  Future<bool> openSettings() => ph.openAppSettings();

  ph.Permission _platform(AppPermission permission) {
    return switch (permission) {
      AppPermission.camera => ph.Permission.camera,
      // Saving to the gallery only ever needs add-only access.
      AppPermission.photoLibrary => ph.Permission.photosAddOnly,
    };
  }

  PermissionState _map(ph.PermissionStatus status) {
    return switch (status) {
      ph.PermissionStatus.granted ||
      ph.PermissionStatus.limited ||
      ph.PermissionStatus.provisional => PermissionState.granted,
      ph.PermissionStatus.permanentlyDenied =>
        PermissionState.permanentlyDenied,
      ph.PermissionStatus.restricted => PermissionState.restricted,
      ph.PermissionStatus.denied => PermissionState.denied,
    };
  }
}
