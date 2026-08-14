import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/features/camera_capture/presentation/camera_capture_cubit.dart';

/// Root widget.
///
/// Deliberately carries **no visual design**: `ThemeMode.dark` is the only
/// visual decision made in Spec #001, because the design system — colours,
/// typography, spacing, motion — lands in Spec #001b and authoring interim
/// values here would be exactly the hardcoding Principle VII forbids.
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
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
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
