import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/core/routing/app_router.dart';
import 'package:productcam/core/routing/routes.dart';

/// FR-018, FR-022 — the developer navigation index must not exist in production.
void main() {
  List<String> pathsOf(GoRouter router) {
    return router.configuration.routes
        .whereType<GoRoute>()
        .map((GoRoute r) => r.path)
        .toList();
  }

  test('production route table contains no developer index', () {
    final List<String> paths = pathsOf(buildRouter());

    expect(paths, isNot(contains(AppRoutes.developerIndex)));
  });

  test('production still registers all seven product areas', () {
    final List<String> paths = pathsOf(buildRouter());

    // All seven exist in both flavors; what differs is only whether a manual
    // path to them exists. As Specs #004-#007 land, each gains a real entry
    // point and drops off the developer index.
    expect(
      paths,
      containsAll(<String>[
        AppRoutes.cameraCapture,
        AppRoutes.review,
        AppRoutes.backgroundEditor,
        AppRoutes.batch,
        AppRoutes.export,
        AppRoutes.history,
        AppRoutes.settings,
      ]),
    );
  });

  test('developer index is registered only when passed in explicitly', () {
    final GoRouter router = buildRouter(
      developerRoutes: <RouteBase>[
        GoRoute(
          path: AppRoutes.developerIndex,
          builder: (BuildContext context, GoRouterState state) =>
              const SizedBox.shrink(),
        ),
      ],
    );

    expect(pathsOf(router), contains(AppRoutes.developerIndex));
  });

  test('the camera area is the launch route', () {
    expect(buildRouter().configuration.routes.first, isA<GoRoute>());
    expect(
      (buildRouter().configuration.routes.first as GoRoute).path,
      equals(AppRoutes.cameraCapture),
    );
  });
}
