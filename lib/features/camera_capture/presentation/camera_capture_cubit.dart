import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/permission/permission_service.dart';

/// State of the camera area.
///
/// Spec #001 ships no camera preview — the only real behaviour here is the
/// permission conversation (FR-023 to FR-027).
sealed class CameraCaptureState extends Equatable {
  const CameraCaptureState();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Nothing asked yet. This is the launch state: opening the area must NOT
/// trigger a permission prompt by itself.
class CameraCaptureIdle extends CameraCaptureState {
  const CameraCaptureIdle();
}

class CameraCaptureRequesting extends CameraCaptureState {
  const CameraCaptureRequesting();
}

/// Camera access granted — capture would be possible from Spec #003 onward.
class CameraCaptureReady extends CameraCaptureState {
  const CameraCaptureReady();
}

/// Access unavailable. Carries the failure so the view can render the right
/// localized explanation and offer the right way out.
class CameraCaptureBlocked extends CameraCaptureState {
  const CameraCaptureBlocked({
    required this.failure,
    required this.canRetry,
    required this.canOpenSettings,
  });

  final AppFailure failure;

  /// The user may be prompted again.
  final bool canRetry;

  /// A trip to system settings can actually change the outcome. False when the
  /// device policy restricts the permission — sending the user there would be
  /// a dead end.
  final bool canOpenSettings;

  @override
  List<Object?> get props => <Object?>[failure, canRetry, canOpenSettings];
}

class CameraCaptureCubit extends Cubit<CameraCaptureState> {
  CameraCaptureCubit({required PermissionService permissionService})
    : _permissions = permissionService,
      super(const CameraCaptureIdle());

  final PermissionService _permissions;

  /// Called when the user does the thing that needs the camera — never on
  /// route entry (Principle VI).
  Future<void> requestCameraAccess() async {
    emit(const CameraCaptureRequesting());
    _apply(await _permissions.request(AppPermission.camera));
  }

  /// Re-reads the status when the app resumes.
  ///
  /// Never cached across a background cycle: the user may have revoked access
  /// in system settings while away, and assuming the old answer is how a camera
  /// app crashes on resume.
  Future<void> refreshOnResume() async {
    if (state is CameraCaptureIdle) return;
    _apply(await _permissions.check(AppPermission.camera));
  }

  Future<void> openSystemSettings() => _permissions.openSettings();

  void _apply(PermissionState status) {
    switch (status) {
      case PermissionState.granted:
        emit(const CameraCaptureReady());
      case PermissionState.denied:
        emit(
          const CameraCaptureBlocked(
            failure: PermissionDenied(AppPermission.camera),
            canRetry: true,
            canOpenSettings: false,
          ),
        );
      case PermissionState.permanentlyDenied:
        emit(
          const CameraCaptureBlocked(
            failure: PermissionPermanentlyDenied(AppPermission.camera),
            canRetry: false,
            canOpenSettings: true,
          ),
        );
      case PermissionState.restricted:
        emit(
          const CameraCaptureBlocked(
            failure: PermissionPermanentlyDenied(AppPermission.camera),
            canRetry: false,
            // Blocked by device policy: system settings cannot help.
            canOpenSettings: false,
          ),
        );
    }
  }
}
