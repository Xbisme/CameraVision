import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';
import 'package:productcam/core/routing/routes.dart';

/// Development-only index listing every area (FR-022).
///
/// **Scaffolding with a defined end.** Four areas — review, background editor,
/// batch, export — are normally entered through a capture flow that does not
/// exist until Specs #004–#007. Without this list they could not be opened by
/// hand at all, so four of seven areas would go unverified.
///
/// It is registered by the development composition root only and is never
/// referenced by the production binary. An area drops off this list once the
/// spec that gives it a real entry point lands; when the list is empty, this
/// file and `lib/dev/` are deleted.
class NavigationIndexPage extends StatelessWidget {
  const NavigationIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<(String, String)> areas = <(String, String)>[
      (l10n.areaCameraCapture, AppRoutes.cameraCapture),
      (l10n.areaReview, AppRoutes.review),
      (l10n.areaBackgroundEditor, AppRoutes.backgroundEditor),
      (l10n.areaBatch, AppRoutes.batch),
      (l10n.areaExport, AppRoutes.export),
      (l10n.areaHistory, AppRoutes.history),
      (l10n.areaSettings, AppRoutes.settings),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.devNavigationIndexTitle)),
      body: Semantics(
        label: l10n.a11yDevNavigationIndex,
        child: ListView(
          children: <Widget>[
            for (final (String name, String path) in areas)
              ListTile(title: Text(name), onTap: () => context.push(path)),
          ],
        ),
      ),
    );
  }
}
