import '../error/app_failure.dart';

/// The app's own view of a permission's state.
///
/// Deliberately smaller than the platform package's enum. [restricted] is kept
/// separate from [permanentlyDenied] because offering a route to system
/// settings to someone blocked by device policy sends them somewhere that
/// cannot help them.
enum PermissionState { granted, denied, permanentlyDenied, restricted }

/// Features depend on this interface, never on the permission package, so
/// every state can be exercised in tests without a device.
abstract interface class PermissionService {
  /// Current state without prompting.
  Future<PermissionState> check(AppPermission permission);

  /// Prompts if the platform still allows it.
  ///
  /// Called only at the moment the user does something that needs the
  /// permission — never at launch (Principle VI, FR-023).
  Future<PermissionState> request(AppPermission permission);

  /// Opens the system settings page for this app.
  ///
  /// Only meaningful for [PermissionState.permanentlyDenied].
  Future<bool> openSettings();
}
