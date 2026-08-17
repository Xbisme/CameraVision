import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/widgets/camera/contour_overlay.dart';

import '../../support/pump.dart';

/// A stand-in subject outline: a rounded bottle-ish silhouette in normalized
/// 0.0–1.0 coordinates, with a curve on one side and a corner on the other so
/// the dash walk has both to handle.
Path subjectPath() {
  return Path()
    ..moveTo(0.35, 0.15)
    ..lineTo(0.65, 0.15)
    ..lineTo(0.65, 0.35)
    ..cubicTo(0.85, 0.45, 0.85, 0.60, 0.82, 0.80)
    ..lineTo(0.78, 0.88)
    ..lineTo(0.22, 0.88)
    ..lineTo(0.18, 0.80)
    ..cubicTo(0.15, 0.60, 0.15, 0.45, 0.35, 0.35)
    ..close();
}

void main() {
  group('behaviour', () {
    testWidgets('a null path paints nothing and does not throw', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        const SizedBox(
          width: 200,
          height: 200,
          child: ContourOverlay(path: null, state: PcContourState.scanning),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsNothing);
    });

    testWidgets('a degenerate path paints nothing and does not throw', (
      WidgetTester tester,
    ) async {
      // An empty Path has empty bounds — the shape a segmentation engine
      // returns when it finds no subject at all.
      await pumpWithPcTheme(
        tester,
        SizedBox(
          width: 200,
          height: 200,
          child: ContourOverlay(path: Path(), state: PcContourState.locked),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('scanning runs a loop, and the other states do not', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        SizedBox(
          width: 200,
          height: 200,
          child: ContourOverlay(
            path: subjectPath(),
            state: PcContourState.scanning,
          ),
        ),
      );
      // A running loop means pumpAndSettle would never settle.
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
      await pumpWithPcTheme(
        tester,
        SizedBox(
          width: 200,
          height: 200,
          child: ContourOverlay(
            path: subjectPath(),
            state: PcContourState.review,
          ),
        ),
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('reduced motion stops the loop entirely (FR-027a)', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        SizedBox(
          width: 200,
          height: 200,
          child: ContourOverlay(
            path: subjectPath(),
            state: PcContourState.scanning,
          ),
        ),
        reduceMotion: true,
      );
      // Nothing animates, and the widget still renders — the dash pattern is
      // what carries the state, so no meaning was lost with the movement.
      expect(tester.hasRunningAnimations, isFalse);
      expect(find.byType(ContourOverlay), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('goldens — 3 states × 4 reference backgrounds (SC-003)', () {
    for (final ReferenceBackground bg in ReferenceBackground.values) {
      for (final PcContourState state in PcContourState.values) {
        testWidgets('${state.name} on ${bg.name}', tags: <String>['golden'], (
          WidgetTester tester,
        ) async {
          await pumpWithPcTheme(
            tester,
            Container(
              width: 280,
              height: 280,
              color: bg.colour,
              child: ContourOverlay(
                path: subjectPath(),
                state: state,
                showFramingTicks: state == PcContourState.locked,
              ),
            ),
            // Frozen so the marching dash lands in the same place every run;
            // a moving baseline would be no baseline at all.
            reduceMotion: true,
          );
          await expectLater(
            find.byType(ContourOverlay),
            matchesGoldenFile('goldens/contour_${state.name}_${bg.name}.png'),
          );
        });
      }
    }
  });
}
