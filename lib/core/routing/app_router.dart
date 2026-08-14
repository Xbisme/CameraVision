import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/features/background_editor/presentation/background_editor_page.dart';
import 'package:productcam/features/batch/presentation/batch_page.dart';
import 'package:productcam/features/camera_capture/presentation/camera_capture_page.dart';
import 'package:productcam/features/export/presentation/export_page.dart';
import 'package:productcam/features/history/presentation/history_page.dart';
import 'package:productcam/features/review/presentation/review_page.dart';
import 'package:productcam/features/settings/presentation/settings_page.dart';

import 'routes.dart';

/// Builds the route table.
///
/// All seven area routes exist in both flavors — what differs is whether a
/// manual path to them exists. Four of them (review, editor, batch, export) are
/// only entered through a capture flow that does not exist until Specs
/// #004–#007, so until then the development-only index is the only way to
/// reach them by hand.
///
/// There is deliberately **no route-level permission guard**: permission is
/// requested when the user does the thing that needs it, so opening `/` must
/// never trigger a prompt (Principle VI, FR-023).
///
/// [developerRoutes] is passed in by the **development** composition root only.
/// This file deliberately does not import `lib/dev/`, so the production binary
/// contains no reference to developer surfaces at all — absence by construction
/// rather than by a runtime flag (FR-018).
GoRouter buildRouter({List<RouteBase> developerRoutes = const <RouteBase>[]}) {
  return GoRouter(
    initialLocation: AppRoutes.cameraCapture,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.cameraCapture,
        builder: (BuildContext context, GoRouterState state) =>
            const CameraCapturePage(),
      ),
      GoRoute(
        path: AppRoutes.review,
        builder: (BuildContext context, GoRouterState state) =>
            const ReviewPage(),
      ),
      GoRoute(
        path: AppRoutes.backgroundEditor,
        builder: (BuildContext context, GoRouterState state) =>
            const BackgroundEditorPage(),
      ),
      GoRoute(
        path: AppRoutes.batch,
        builder: (BuildContext context, GoRouterState state) =>
            const BatchPage(),
      ),
      GoRoute(
        path: AppRoutes.export,
        builder: (BuildContext context, GoRouterState state) =>
            const ExportPage(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (BuildContext context, GoRouterState state) =>
            const HistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
      ...developerRoutes,
    ],
  );
}
