import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/theme/pc_theme.dart';
import 'package:productcam/core/theme/tokens/pc_spacing.dart';
import 'package:productcam/features/camera_capture/presentation/camera_capture_cubit.dart';

/// Root widget.
///
/// Carries the ProductCam theme from Spec #001b. The app is locked to
/// `ThemeMode.dark` and both slots get the same theme, so it never follows the
/// device's light/dark setting — a camera app whose main surface is a live
/// video feed cannot be white (FR-007).
///
/// Language comes from the operating system only: `supportedLocales` is
/// declared and nothing else. There is no locale override and no stored
/// preference (FR-032), which is also why this spec needs no storage at all.
class ProductCamApp extends StatelessWidget {
  const ProductCamApp({
    required this.config,
    required this.router,
    required this.permissionService,
    super.key,
  });

  final AppConfig config;
  final GoRouter router;
  final PermissionService permissionService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCaptureCubit>(
      create: (_) => CameraCaptureCubit(permissionService: permissionService),
      child: MaterialApp.router(
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).areaCameraCapture,
        themeMode: ThemeMode.dark,
        theme: buildPcTheme(),
        darkTheme: buildPcTheme(),
        // Enlarged text is honoured up to the cap and stops there. Beyond it
        // the fixed 56px header and 132px thumb band would have to stretch,
        // and the shutter would stop being where the thumb expects it
        // (FR-015a). Clamping at the root beats thirty components each
        // defending themselves and one of them forgetting.
        builder: (BuildContext context, Widget? child) =>
            MediaQuery.withClampedTextScaling(
              maxScaleFactor: PcSpacingTokens.maxTextScaleFactor,
              child: child ?? const SizedBox.shrink(),
            ),
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
