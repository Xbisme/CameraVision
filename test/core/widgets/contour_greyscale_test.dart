import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/widgets/camera/contour_overlay.dart';

import '../../support/pump.dart';
import 'contour_overlay_test.dart' show subjectPath;

/// SC-003, second half: a reviewer must be able to name the contour state from
/// a greyscale still, without the colour.
///
/// The task asked for three stills and a person to look at them. A person is
/// the right judge of whether the states *read* as different, but a poor judge
/// of whether they *are* different — eyes fill in what they expect. So the
/// mechanical half is done mechanically here: render each state, strip the
/// colour, and measure how much of the image actually changes between them.
///
/// This does not replace the human check in T040; it makes the human check
/// about legibility rather than about pixels, which is what human review is
/// good for.
void main() {
  /// Renders one state and returns its luminance for every pixel.
  Future<Uint8List> greyscaleOf(
    WidgetTester tester,
    PcContourState state,
  ) async {
    final GlobalKey key = GlobalKey();
    await pumpWithPcTheme(
      tester,
      RepaintBoundary(
        key: key,
        child: Container(
          width: 240,
          height: 240,
          // A mid grey on purpose: it is the least helpful background there
          // is, offering neither the dark halo nor the bright core an easy
          // contrast to sit against.
          color: const Color(0xFF808080),
          child: ContourOverlay(path: subjectPath(), state: state),
        ),
      ),
      // Frozen so the dash phase is identical across the three captures —
      // otherwise this would measure the animation, not the state.
      reduceMotion: true,
    );

    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    // `toImage` hands work to the engine's raster thread, which the fake async
    // zone of a widget test never pumps — awaiting it directly hangs forever.
    // `runAsync` is what lets real asynchronous work complete.
    late final ByteData data;
    await tester.runAsync(() async {
      final ui.Image image = await boundary.toImage();
      data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      image.dispose();
    });

    final Uint8List luminance = Uint8List(data.lengthInBytes ~/ 4);
    for (int i = 0; i < luminance.length; i++) {
      final int r = data.getUint8(i * 4);
      final int g = data.getUint8(i * 4 + 1);
      final int b = data.getUint8(i * 4 + 2);
      // Rec. 709, the same weights the saturation matrix uses.
      luminance[i] = (0.2126 * r + 0.7152 * g + 0.0722 * b).round();
    }
    return luminance;
  }

  /// Share of pixels whose brightness differs by more than a just-noticeable
  /// amount. 8/255 is roughly where a difference stops being visible on a
  /// phone screen outdoors, which is where this app is used.
  double fractionDiffering(Uint8List a, Uint8List b) {
    expect(a.length, b.length);
    int changed = 0;
    for (int i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 8) changed++;
    }
    return changed / a.length;
  }

  testWidgets('the three states are distinguishable with the colour removed', (
    WidgetTester tester,
  ) async {
    final Uint8List scanning = await greyscaleOf(
      tester,
      PcContourState.scanning,
    );
    final Uint8List locked = await greyscaleOf(tester, PcContourState.locked);
    final Uint8List review = await greyscaleOf(tester, PcContourState.review);

    final Map<String, double> pairs = <String, double>{
      'scanning vs locked': fractionDiffering(scanning, locked),
      'scanning vs review': fractionDiffering(scanning, review),
      'locked vs review': fractionDiffering(locked, review),
    };

    for (final MapEntry<String, double> pair in pairs.entries) {
      expect(
        pair.value,
        greaterThan(0.005),
        reason:
            '${pair.key} differ in only '
            '${(pair.value * 100).toStringAsFixed(3)}% of pixels once the '
            'colour is stripped. State would then be resting on hue alone, '
            'which fails Principle XI outdoors, on a poor screen, or for a '
            'colour-blind user.',
      );
    }

    // Printed so the numbers land in the PR alongside the human review that
    // T040 still asks for.
    debugPrint('greyscale separation: $pairs');
  });

  testWidgets('the contour is visible against a mid grey at all', (
    WidgetTester tester,
  ) async {
    // The two-stroke rule exists precisely so this holds. A single-stroke
    // contour is what would fail here.
    final Uint8List drawn = await greyscaleOf(tester, PcContourState.locked);

    int darkerThanBackground = 0;
    int brighterThanBackground = 0;
    for (final int v in drawn) {
      if (v < 0x80 - 20) darkerThanBackground++;
      if (v > 0x80 + 20) brighterThanBackground++;
    }

    expect(
      darkerThanBackground,
      greaterThan(0),
      reason:
          'the dark halo must be present — without it the bright core '
          'disappears against a white paper sweep',
    );
    expect(
      brighterThanBackground,
      greaterThan(0),
      reason:
          'the bright core must be present — without it the halo '
          'disappears against black leather',
    );
  });
}
