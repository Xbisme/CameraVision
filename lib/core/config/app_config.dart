import 'package:equatable/equatable.dart';

import 'flavor.dart';

/// Flavor-dependent values, built once by the entry point and injected.
///
/// Deliberately NOT derived from `kDebugMode`: flavor and build mode are
/// independent (Principle XV). A release build of the development flavor keeps
/// [showsDeveloperSurfaces] true, which is what on-device performance
/// measurement needs — a debug build is too slow to measure anything real.
class AppConfig extends Equatable {
  const AppConfig({
    required this.flavor,
    required this.appId,
    required this.displayName,
    required this.showsDeveloperSurfaces,
    required this.verboseLogging,
  });

  /// Values mirror android/app/build.gradle.kts and ios/Flutter/*.xcconfig.
  /// Dart cannot set the platform identity, so the two must be changed together.
  const AppConfig.development()
    : flavor = Flavor.development,
      appId = 'com.productcam.app.dev',
      displayName = 'ProductCam Dev',
      showsDeveloperSurfaces = true,
      verboseLogging = true;

  const AppConfig.production()
    : flavor = Flavor.production,
      appId = 'com.productcam.app',
      displayName = 'ProductCam',
      showsDeveloperSurfaces = false,
      verboseLogging = false;

  final Flavor flavor;
  final String appId;
  final String displayName;

  /// Gates the navigation index. In production the route is never registered,
  /// so absence is structural rather than a runtime check (FR-018).
  final bool showsDeveloperSurfaces;

  final bool verboseLogging;

  @override
  List<Object?> get props => <Object?>[
    flavor,
    appId,
    displayName,
    showsDeveloperSurfaces,
    verboseLogging,
  ];
}
