import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/features/camera_capture/presentation/camera_capture_cubit.dart';

class _MockPermissionService extends Mock implements PermissionService {}

/// FR-023 to FR-027 — every permission outcome must end somewhere usable, and
/// none of them may crash.
void main() {
  setUpAll(() => registerFallbackValue(AppPermission.camera));

  /// Builds a cubit over a freshly stubbed mock.
  ///
  /// Stubbing happens here rather than in a `setUp` because `blocTest` builds
  /// its bloc before the enclosing `setUp` has swapped in a new mock, which
  /// leaves the stub attached to the previous instance.
  CameraCaptureCubit cubitReturning(
    PermissionState onRequest, {
    PermissionState? onCheck,
    _MockPermissionService? into,
  }) {
    final _MockPermissionService permissions = into ?? _MockPermissionService();
    when(
      () => permissions.request(AppPermission.camera),
    ).thenAnswer((_) async => onRequest);
    when(
      () => permissions.check(AppPermission.camera),
    ).thenAnswer((_) async => onCheck ?? onRequest);
    return CameraCaptureCubit(permissionService: permissions);
  }

  test('opening the camera area does not request anything (FR-023)', () {
    final _MockPermissionService permissions = _MockPermissionService();
    final CameraCaptureCubit cubit = CameraCaptureCubit(
      permissionService: permissions,
    );

    // Just-in-time means the prompt is triggered by the user's action, never
    // by arriving on the screen.
    expect(cubit.state, isA<CameraCaptureIdle>());
    verifyNever(() => permissions.request(any()));
    verifyNever(() => permissions.check(any()));
  });

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'granted -> ready',
    build: () => cubitReturning(PermissionState.granted),
    act: (CameraCaptureCubit c) => c.requestCameraAccess(),
    expect: () => <Matcher>[
      isA<CameraCaptureRequesting>(),
      isA<CameraCaptureReady>(),
    ],
  );

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'denied -> blocked, retry offered, no settings route (FR-025)',
    build: () => cubitReturning(PermissionState.denied),
    act: (CameraCaptureCubit c) => c.requestCameraAccess(),
    expect: () => <Matcher>[
      isA<CameraCaptureRequesting>(),
      isA<CameraCaptureBlocked>()
          .having(
            (CameraCaptureBlocked s) => s.failure,
            'failure',
            isA<PermissionDenied>(),
          )
          .having((CameraCaptureBlocked s) => s.canRetry, 'canRetry', isTrue)
          .having(
            (CameraCaptureBlocked s) => s.canOpenSettings,
            'canOpenSettings',
            isFalse,
          ),
    ],
  );

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'permanently denied -> settings route offered, no pointless re-prompt (FR-026)',
    build: () => cubitReturning(PermissionState.permanentlyDenied),
    act: (CameraCaptureCubit c) => c.requestCameraAccess(),
    expect: () => <Matcher>[
      isA<CameraCaptureRequesting>(),
      isA<CameraCaptureBlocked>()
          .having(
            (CameraCaptureBlocked s) => s.failure,
            'failure',
            isA<PermissionPermanentlyDenied>(),
          )
          .having((CameraCaptureBlocked s) => s.canRetry, 'canRetry', isFalse)
          .having(
            (CameraCaptureBlocked s) => s.canOpenSettings,
            'canOpenSettings',
            isTrue,
          ),
    ],
  );

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'restricted -> explained, but NO settings route (it could not help)',
    build: () => cubitReturning(PermissionState.restricted),
    act: (CameraCaptureCubit c) => c.requestCameraAccess(),
    expect: () => <Matcher>[
      isA<CameraCaptureRequesting>(),
      isA<CameraCaptureBlocked>()
          .having((CameraCaptureBlocked s) => s.canRetry, 'canRetry', isFalse)
          .having(
            (CameraCaptureBlocked s) => s.canOpenSettings,
            'canOpenSettings',
            isFalse,
          ),
    ],
  );

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'access revoked while backgrounded is detected on resume',
    build: () => cubitReturning(
      PermissionState.granted,
      onCheck: PermissionState.permanentlyDenied,
    ),
    act: (CameraCaptureCubit c) async {
      await c.requestCameraAccess();
      // The user went to system settings and turned the camera off.
      await c.refreshOnResume();
    },
    expect: () => <Matcher>[
      isA<CameraCaptureRequesting>(),
      isA<CameraCaptureReady>(),
      isA<CameraCaptureBlocked>(),
    ],
  );

  blocTest<CameraCaptureCubit, CameraCaptureState>(
    'resume before anything was ever asked stays silent',
    build: () => cubitReturning(PermissionState.granted),
    act: (CameraCaptureCubit c) => c.refreshOnResume(),
    expect: () => const <Matcher>[],
  );
}
