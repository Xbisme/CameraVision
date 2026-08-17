import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/widgets/batch/batch_thumb.dart';
import 'package:productcam/core/widgets/camera/mode_toggle.dart';
import 'package:productcam/core/widgets/camera/readout.dart';
import 'package:productcam/core/widgets/camera/shutter_button.dart';
import 'package:productcam/core/widgets/core/pc_badge.dart';
import 'package:productcam/core/widgets/core/pc_button.dart';
import 'package:productcam/core/widgets/core/pc_chip.dart';
import 'package:productcam/core/widgets/core/pc_icon.dart';
import 'package:productcam/core/widgets/core/pc_icon_button.dart';
import 'package:productcam/core/widgets/core/pc_slider.dart';
import 'package:productcam/core/widgets/shell/screen_header.dart';
import 'package:productcam/core/widgets/shell/thumb_band.dart';

import '../../support/pump.dart';

void main() {
  group('touch targets meet the hard minimums (FR-023, SC-007)', () {
    // These assert the *rendered hit area*, not the painted size. A 24px glyph
    // inside a 44px target passes; a 44px-looking button with a 30px hit area
    // fails. That distinction is the whole point — the design's numbers are
    // about what a thumb can hit outdoors, not about what looks right.

    testWidgets('PcButton comfortable is 56, standard is 44', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PcButton(label: 'Chấp nhận', onPressed: () {}),
            PcButton(
              label: 'Chụp lại',
              onPressed: () {},
              size: PcButtonSize.standard,
            ),
          ],
        ),
      );
      final List<Size> sizes = tester
          .widgetList<PcButton>(find.byType(PcButton))
          .map((PcButton b) => tester.getSize(find.byWidget(b)))
          .toList();
      expect(sizes[0].height, 56);
      expect(sizes[1].height, 44);
    });

    testWidgets('PcIconButton md is 44 and lg is 56', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PcIconButton(
              icon: PcIconData.settings2,
              onPressed: () {},
              semanticsLabel: 'Cài đặt',
            ),
            PcIconButton(
              icon: PcIconData.images,
              onPressed: () {},
              semanticsLabel: 'Thư viện',
              size: PcIconButtonSize.lg,
            ),
          ],
        ),
      );
      final List<Size> sizes = tester
          .widgetList<PcIconButton>(find.byType(PcIconButton))
          .map((PcIconButton b) => tester.getSize(find.byWidget(b)))
          .toList();
      expect(sizes[0], const Size(44, 44));
      expect(sizes[1], const Size(56, 56));
    });

    testWidgets('the shutter is 80 visible inside a 104 hit target', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        ShutterButton(onPressed: () {}, semanticsLabel: 'Chụp'),
      );
      // The hit target.
      expect(
        tester.getSize(find.byType(ShutterButton)),
        const Size(104, 104),
        reason: 'the shutter hit area must be 104, larger than the disc',
      );
      // The visible disc.
      final Size disc = tester.getSize(
        find
            .descendant(
              of: find.byType(ShutterButton),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      expect(disc, const Size(80, 80));
    });

    testWidgets('PcChip and PcSlider clear 44', (WidgetTester tester) async {
      await pumpWithPcTheme(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PcChip(label: 'Hôm nay', selected: false, onTap: () {}),
            PcSlider(
              value: 0.5,
              min: 0,
              max: 1,
              onChanged: (_) {},
              semanticsLabel: 'Độ mềm',
            ),
          ],
        ),
      );
      expect(
        tester.getSize(find.byType(PcChip)).height,
        greaterThanOrEqualTo(44),
      );
      expect(
        tester.getSize(find.byType(PcSlider)).height,
        greaterThanOrEqualTo(44),
      );
    });

    testWidgets('each half of the mode toggle clears 44', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        ModeToggle(
          mode: PcCaptureMode.single,
          onChanged: (_) {},
          singleLabel: 'Đơn',
          batchLabel: 'Loạt',
        ),
      );
      expect(tester.getSize(find.byType(ModeToggle)).height, 44);
    });
  });

  group('fixed bands do not move (FR-015a)', () {
    testWidgets('header stays 56 and the band stays 132 at 1.3x text', (
      WidgetTester tester,
    ) async {
      for (final double scale in <double>[1.0, 1.3]) {
        await pumpWithPcTheme(
          tester,
          Column(
            children: <Widget>[
              const ScreenHeader(title: 'Lịch sử'),
              const Spacer(),
              ThumbBand(
                primary: ShutterButton(
                  onPressed: () {},
                  semanticsLabel: 'Chụp',
                ),
              ),
            ],
          ),
          textScale: scale,
        );
        expect(
          tester.getSize(find.byType(ScreenHeader)).height,
          56,
          reason: 'header must not grow at ${scale}x',
        );
        expect(
          tester.getSize(find.byType(ThumbBand)).height,
          132,
          reason: 'thumb band must not grow at ${scale}x',
        );
      }
    });
  });

  group('the extremes of the supported device range (T067a)', () {
    // 320dp is the narrowest screen the Android API 24 floor admits; the tablet
    // case matters because Spec #001 locked portrait and gave tablets the phone
    // layout, so nothing here may stretch into a shape the design never saw.
    const Size narrowPhone = Size(320, 568);
    const Size tabletPortrait = Size(768, 1024);

    for (final (String name, Size size) in <(String, Size)>[
      ('320dp phone', narrowPhone),
      ('tablet portrait', tabletPortrait),
    ]) {
      testWidgets('the fixed bands hold their size on a $name', (
        WidgetTester tester,
      ) async {
        await pumpWithPcTheme(
          tester,
          Column(
            children: <Widget>[
              const ScreenHeader(title: 'Phiên chụp'),
              const Spacer(),
              ThumbBand(
                primary: ShutterButton(
                  onPressed: () {},
                  semanticsLabel: 'Chụp',
                ),
              ),
            ],
          ),
          size: size,
        );

        expect(tester.getSize(find.byType(ScreenHeader)).height, 56);
        expect(tester.getSize(find.byType(ThumbBand)).height, 132);
        // 56 header + 132 band leaves this much for content. If it ever goes
        // negative or near-zero the fixed-band decision has outgrown the
        // smallest device it claims to support.
        expect(
          size.height - 56 - 132,
          greaterThan(200),
          reason: 'content area must stay usable on a $name',
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('the shutter keeps its full hit target on a $name', (
        WidgetTester tester,
      ) async {
        await pumpWithPcTheme(
          tester,
          ThumbBand(
            secondary: PcButton(
              label: 'Chụp thêm',
              onPressed: () {},
              size: PcButtonSize.standard,
            ),
            primary: ShutterButton(onPressed: () {}, semanticsLabel: 'Chụp'),
          ),
          size: size,
        );
        // The band packs a secondary action beside the shutter. On the narrow
        // phone that is where a squeeze would show up first.
        expect(
          tester.getSize(find.byType(ShutterButton)),
          const Size(104, 104),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('accessible names on text-free controls (Principle XI)', () {
    // The three controls that render no text cannot be constructed without a
    // label — `semanticsLabel` is a required parameter on each. This asserts
    // the label actually reaches the semantics tree, which the type system
    // cannot.
    testWidgets('PcIconButton, ShutterButton and PcSlider expose their name', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PcIconButton(
              icon: PcIconData.download,
              onPressed: () {},
              semanticsLabel: 'Lưu vào máy',
            ),
            ShutterButton(onPressed: () {}, semanticsLabel: 'Chụp ảnh'),
            PcSlider(
              value: 0,
              min: 0,
              max: 10,
              onChanged: (_) {},
              semanticsLabel: 'Thu giãn viền',
            ),
          ],
        ),
      );
      expect(find.bySemanticsLabel('Lưu vào máy'), findsOneWidget);
      expect(find.bySemanticsLabel('Chụp ảnh'), findsOneWidget);
      expect(find.bySemanticsLabel('Thu giãn viền'), findsOneWidget);
    });
  });

  group('the thumb band refuses destructive actions (FR-024)', () {
    testWidgets('a danger button inside the band trips an assertion', (
      WidgetTester tester,
    ) async {
      // Collect errors directly: the failed build also produces a cascading
      // layout error, and `takeException()` folds multiple exceptions into a
      // summary string that no longer names the cause.
      final List<Object> errors = <Object>[];
      final FlutterExceptionHandler? previous = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails d) => errors.add(d.exception);

      await pumpWithPcTheme(
        tester,
        ThumbBand(
          primary: PcButton(
            label: 'Xoá',
            onPressed: () {},
            variant: PcButtonVariant.danger,
          ),
        ),
      );

      FlutterError.onError = previous;
      tester.takeException();

      // A delete button under the thumb, pressed without looking, is how a
      // batch disappears. The band must not allow it even in a prototype.
      expect(
        errors.whereType<AssertionError>().any(
          (AssertionError e) => e.toString().contains('bottom action band'),
        ),
        isTrue,
        reason: 'the band must reject a destructive action by name',
      );
    });

    testWidgets('the same button outside the band is fine', (
      WidgetTester tester,
    ) async {
      await pumpWithPcTheme(
        tester,
        PcButton(
          label: 'Xoá',
          onPressed: () {},
          variant: PcButtonVariant.danger,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('the icon set is closed and complete (FR-025, FR-026a)', () {
    test('every enum value has a vendored asset, and none is orphaned', () {
      final Set<String> declared = PcIconData.values
          .map((PcIconData i) => i.assetName)
          .toSet();
      final Set<String> onDisk = Directory('assets/icons')
          .listSync()
          .whereType<File>()
          .where((File f) => f.path.endsWith('.svg'))
          .map((File f) => f.uri.pathSegments.last.replaceAll('.svg', ''))
          .toSet();

      expect(
        declared.difference(onDisk),
        isEmpty,
        reason: 'enum values with no asset would render as a blank square',
      );
      expect(
        onDisk.difference(declared),
        isEmpty,
        reason:
            'orphan assets are weight nothing can draw — app size is a '
            'named top-three risk on this project',
      );
      expect(declared, hasLength(26));
    });

    test('every vendored glyph carries the design stroke of 1.75', () {
      // Lucide ships stroke-width="2". Rewriting it is the entire reason
      // vector glyphs were chosen over an icon font, which bakes the stroke in.
      for (final FileSystemEntity e in Directory('assets/icons').listSync()) {
        if (e is! File || !e.path.endsWith('.svg')) continue;
        final String svg = e.readAsStringSync();
        expect(
          svg,
          contains('stroke-width="1.75"'),
          reason: '${e.path} is not at the design stroke',
        );
        expect(
          svg,
          contains('stroke="currentColor"'),
          reason: '${e.path} must inherit the surrounding colour',
        );
      }
    });
  });

  group('machine facts are uppercased by the widget, not the token', () {
    testWidgets('Readout shouts its input', (WidgetTester tester) async {
      await pumpWithPcTheme(tester, const Readout('png · 1200×1200'));
      expect(find.text('PNG · 1200×1200'), findsOneWidget);
    });

    testWidgets('PcBadge shouts too', (WidgetTester tester) async {
      await pumpWithPcTheme(
        tester,
        const PcBadge(text: 'cần xem lại', kind: PcBadgeKind.caution),
      );
      expect(find.text('CẦN XEM LẠI'), findsOneWidget);
    });
  });

  group('batch statuses never rest on colour alone (Principle XI)', () {
    testWidgets('done, review and error each carry a glyph', (
      WidgetTester tester,
    ) async {
      for (final PcBatchItemStatus s in <PcBatchItemStatus>[
        PcBatchItemStatus.done,
        PcBatchItemStatus.review,
        PcBatchItemStatus.error,
      ]) {
        await pumpWithPcTheme(
          tester,
          SizedBox(
            width: 120,
            height: 120,
            child: BatchThumb(status: s, semanticsLabel: 'Ảnh 1'),
          ),
        );
        expect(
          find.byType(PcIcon),
          findsWidgets,
          reason: '$s must carry a non-colour mark',
        );
      }
    });
  });
}
