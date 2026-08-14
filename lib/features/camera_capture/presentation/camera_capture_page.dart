import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/core/error/failure_l10n.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';
import 'package:productcam/core/routing/routes.dart';

import 'camera_capture_cubit.dart';

/// The launch screen (FR-021). No onboarding, no gate, and — critically — no
/// permission prompt on entry.
///
/// This is the one placeholder that carries entry points to other areas:
/// settings and history are the only non-camera areas reachable in production
/// without a capture flow, so without these they would be unreachable there.
///
/// No styling is authored here; the design system lands in Spec #001b.
class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The user may have revoked camera access in system settings while away.
    if (state == AppLifecycleState.resumed && mounted) {
      unawaited(context.read<CameraCaptureCubit>().refreshOnResume());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.areaCameraCapture),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: l10n.areaHistory,
            onPressed: () => context.push(AppRoutes.history),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.areaSettings,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CameraCaptureCubit, CameraCaptureState>(
          builder: (BuildContext context, CameraCaptureState state) {
            return switch (state) {
              CameraCaptureIdle() => _Idle(l10n: l10n),
              CameraCaptureRequesting() => const CircularProgressIndicator(),
              CameraCaptureReady() => Text(l10n.areaCameraCapture),
              CameraCaptureBlocked() => _Blocked(state: state, l10n: l10n),
            };
          },
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(l10n.permissionCameraRationale, textAlign: TextAlign.center),
        // Just-in-time: the prompt is triggered by this action, not by opening
        // the screen (Principle VI, FR-023).
        TextButton(
          onPressed: () =>
              context.read<CameraCaptureCubit>().requestCameraAccess(),
          child: Text(l10n.cameraEnableAction),
        ),
      ],
    );
  }
}

class _Blocked extends StatelessWidget {
  const _Blocked({required this.state, required this.l10n});

  final CameraCaptureBlocked state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Always a localized sentence — never a code or platform message.
        Text(failureMessage(state.failure, l10n), textAlign: TextAlign.center),
        if (state.canRetry)
          TextButton(
            onPressed: () =>
                context.read<CameraCaptureCubit>().requestCameraAccess(),
            child: Text(l10n.permissionRetryAction),
          ),
        if (state.canOpenSettings)
          TextButton(
            onPressed: () =>
                context.read<CameraCaptureCubit>().openSystemSettings(),
            child: Text(l10n.permissionOpenSettingsAction),
          ),
      ],
    );
  }
}
