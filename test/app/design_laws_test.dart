import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:productcam/app/app.dart';
import 'package:productcam/core/config/app_config.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/permission/permission_service.dart';
import 'package:productcam/core/routing/app_router.dart';
import 'package:productcam/core/routing/routes.dart';
import 'package:productcam/core/theme/extensions/pc_colors.dart';
import 'package:productcam/core/widgets/core/pc_button.dart';

class _MockPermissionService extends Mock implements PermissionService {}

/// The three design laws with no automated gate — until now.
///
/// FR-009, FR-010 and FR-027 were written expecting a human to check them on a
/// walkthrough. That is the weakest kind of guarantee: it holds until the first
/// busy review. Each one turns out to be mechanically checkable, so it is
/// checked mechanically. A reviewer's eyes are still better at *taste*; they
/// are worse at counting.
void main() {
  setUpAll(() => registerFallbackValue(AppPermission.camera));

  const List<String> areas = <String>[
    AppRoutes.cameraCapture,
    AppRoutes.review,
    AppRoutes.backgroundEditor,
    AppRoutes.batch,
    AppRoutes.export,
    AppRoutes.history,
    AppRoutes.settings,
  ];

  Future<GoRouter> pumpApp(WidgetTester tester) async {
    final GoRouter router = buildRouter();
    await tester.pumpWidget(
      ProductCamApp(
        config: const AppConfig.development(),
        permissionService: _MockPermissionService(),
        router: router,
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  group('FR-009 — at most two background values on a screen', () {
    testWidgets('every area stays within the two-surface budget', (
      WidgetTester tester,
    ) async {
      final PcColors palette = PcColors.fromTokens();

      // Only the surface family counts. Text, accents, borders and status
      // colours are not backgrounds, and the scrim is a gradient over the feed
      // rather than a surface of its own.
      final Map<Color, String> surfaces = <Color, String>{
        palette.bgShell: 'bg-shell',
        palette.bgApp: 'bg-app',
        palette.bgSurface: 'bg-surface',
        palette.bgSurfaceRaised: 'bg-surface-raised',
        palette.bgSheet: 'bg-sheet',
        palette.bgInput: 'bg-input',
        palette.bgTrack: 'bg-track',
      };

      final GoRouter router = await pumpApp(tester);

      for (final String route in areas) {
        router.go(route);
        await tester.pumpAndSettle();

        final Set<String> used = <String>{};
        void visit(RenderObject node) {
          Color? fill;
          if (node is RenderDecoratedBox) {
            final Decoration d = node.decoration;
            if (d is BoxDecoration) fill = d.color;
            if (d is ShapeDecoration) fill = d.color;
          } else if (node is RenderPhysicalModel) {
            fill = node.color;
          }
          if (fill != null && surfaces.containsKey(fill)) {
            used.add(surfaces[fill]!);
          }
          node.visitChildren(visit);
        }

        for (final RenderView view in tester.binding.renderViews) {
          visit(view);
        }

        expect(
          used.length,
          lessThanOrEqualTo(2),
          reason:
              'area $route paints ${used.length} surface values '
              '(${used.join(', ')}). The design allows two — a third makes the '
              'chrome start competing with the subject.',
        );
      }
    });
  });

  group('FR-010 — mint is spent on one primary action per screen', () {
    testWidgets('no area mounts two primary buttons at once', (
      WidgetTester tester,
    ) async {
      final GoRouter router = await pumpApp(tester);

      for (final String route in areas) {
        router.go(route);
        await tester.pumpAndSettle();

        final int primaries = tester
            .widgetList<PcButton>(find.byType(PcButton))
            .where((PcButton b) => b.variant == PcButtonVariant.primary)
            .length;

        expect(
          primaries,
          lessThanOrEqualTo(1),
          reason:
              'area $route mounts $primaries primary buttons. Mint is the '
              'single signal colour; two primaries means neither is primary.',
        );
      }
    });
  });

  group('FR-027 — motion is feedback, never decoration', () {
    test('no widget reaches for a bounce, spring or elastic curve', () {
      // Grepping the source is the right instrument here: these curves are
      // banned by name, and a runtime check would only catch the code paths a
      // test happens to walk.
      final RegExp banned = RegExp(
        r'Curves\.(bounce|elastic)\w*|SpringSimulation|SpringDescription|'
        r'ParallaxOffset|\bparallax\b',
        caseSensitive: false,
      );

      final List<String> offenders = <String>[];
      for (final FileSystemEntity e in Directory(
        'lib',
      ).listSync(recursive: true)) {
        if (e is! File || !e.path.endsWith('.dart')) continue;
        final List<String> lines = e.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          // Skip comments — the prohibition is discussed in doc comments, and
          // discussing it is not doing it.
          if (line.trimLeft().startsWith('//') ||
              line.trimLeft().startsWith('///') ||
              line.trimLeft().startsWith('*')) {
            continue;
          }
          if (banned.hasMatch(line)) {
            offenders.add('${e.path}:${i + 1}: ${line.trim()}');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'decorative motion is forbidden — battery and speed both '
            'matter to someone shooting forty items in a row:\n'
            '${offenders.join('\n')}',
      );
    });

    test(
      'every animation duration in the product comes from the token set',
      () {
        // A literal Duration outside the token layer is already caught by
        // check_no_hardcode.sh. This asserts the complementary half: the seven
        // durations the design defines are the only ones that exist, so nobody
        // can introduce a fourteenth by composing two.
        final File motion = File('lib/core/theme/tokens/pc_motion.dart');
        final Iterable<RegExpMatch> durations = RegExp(
          r'Duration\(milliseconds: (\d+)\)',
        ).allMatches(motion.readAsStringSync());
        final Set<String> values = durations
            .map((RegExpMatch m) => m.group(1)!)
            .toSet();

        expect(
          values,
          <String>{'90', '140', '220', '380', '1100', '180', '110'},
          reason:
              'the motion vocabulary changed; that is a design decision, not '
              'an implementation one',
        );
      },
    );
  });

  group('SC-011 — appearance changed, capability did not', () {
    test('no product capability slipped in with the design system', () {
      // Spec #001b ships a look, not a feature. The cheapest way for that to
      // stop being true is a dependency: the moment `camera` or `share_plus`
      // appears, someone has started Spec #003 or #007 inside this branch.
      final String pubspec = File('pubspec.yaml').readAsStringSync();
      const List<String> notYet = <String>[
        'camera:',
        'image:',
        'gal:',
        'share_plus:',
        'path_provider:',
        'hive',
        'drift',
        'sqflite',
      ];
      for (final String dep in notYet) {
        expect(
          pubspec.contains(dep),
          isFalse,
          reason:
              '$dep belongs to a later spec. This one adds appearance and '
              'nothing else.',
        );
      }
    });

    test('nothing in lib/ reaches for a camera, a file or the network', () {
      final RegExp capability = RegExp(
        r'\bCameraController\b|\bImagePicker\b|\bHttpClient\b|'
        r'package:http/|\bFile\(|getApplicationDocumentsDirectory',
      );
      final List<String> offenders = <String>[];
      for (final FileSystemEntity e in Directory(
        'lib',
      ).listSync(recursive: true)) {
        if (e is! File || !e.path.endsWith('.dart')) continue;
        final List<String> lines = e.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          if (line.trimLeft().startsWith('//')) continue;
          if (capability.hasMatch(line)) {
            offenders.add('${e.path}:${i + 1}: ${line.trim()}');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'the app still offers no camera, no cutout, no export and no '
            'storage — and no network at all (Principle VI):\n'
            '${offenders.join('\n')}',
      );
    });
  });
}
