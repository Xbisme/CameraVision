@Tags(<String>['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/pc_context.dart';
import 'package:productcam/core/widgets/batch/batch_thumb.dart';
import 'package:productcam/core/widgets/batch/progress_trace.dart';
import 'package:productcam/core/widgets/camera/mode_toggle.dart';
import 'package:productcam/core/widgets/camera/readout.dart';
import 'package:productcam/core/widgets/camera/shutter_button.dart';
import 'package:productcam/core/widgets/core/pc_badge.dart';
import 'package:productcam/core/widgets/core/pc_button.dart';
import 'package:productcam/core/widgets/core/pc_chip.dart';
import 'package:productcam/core/widgets/core/pc_icon.dart';
import 'package:productcam/core/widgets/core/pc_icon_button.dart';
import 'package:productcam/core/widgets/core/pc_sheet.dart';
import 'package:productcam/core/widgets/core/pc_slider.dart';
import 'package:productcam/core/widgets/editor/background_swatch_picker.dart';
import 'package:productcam/core/widgets/editor/checker_surface.dart';
import 'package:productcam/core/widgets/feedback/edge_notice.dart';
import 'package:productcam/core/widgets/feedback/pc_toast.dart';
import 'package:productcam/core/widgets/shell/screen_header.dart';
import 'package:productcam/core/widgets/shell/thumb_band.dart';

import '../../support/pump.dart';

/// Reference images for every documented state of the shared kit.
///
/// `ContourOverlay`'s twelve live in `contour_overlay_test.dart`; the fifty-five
/// here cover the other eighteen components, for the sixty-seven in
/// `contracts/component-api.md`.
///
/// **Baselines are generated on Linux CI, never locally** (research R6). The
/// dev machine is macOS and text rasterizes differently, so one set of bytes
/// cannot satisfy both — CI is the single rendering target. Run the
/// `update-goldens` workflow_dispatch job to create or refresh them.
void main() {
  Future<void> golden(
    WidgetTester tester,
    String name,
    Widget child, {
    double width = 320,
    double? height,
  }) async {
    await pumpWithPcTheme(
      tester,
      SizedBox(width: width, height: height, child: child),
      // Frozen: a moving baseline is no baseline.
      reduceMotion: true,
    );
    await expectLater(
      find.byType(SizedBox).first,
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  group('PcButton — 4 variants × 2 press states (8)', () {
    for (final PcButtonVariant v in PcButtonVariant.values) {
      testWidgets('${v.name} default', (WidgetTester tester) async {
        await golden(
          tester,
          'button_${v.name}',
          Center(
            child: PcButton(label: 'Chấp nhận', onPressed: () {}, variant: v),
          ),
        );
      });

      testWidgets('${v.name} pressed', (WidgetTester tester) async {
        await pumpWithPcTheme(
          tester,
          SizedBox(
            width: 320,
            child: Center(
              child: PcButton(label: 'Chấp nhận', onPressed: () {}, variant: v),
            ),
          ),
          reduceMotion: true,
        );
        final TestGesture g = await tester.startGesture(
          tester.getCenter(find.byType(PcButton)),
        );
        await tester.pump();
        await expectLater(
          find.byType(SizedBox).first,
          matchesGoldenFile('goldens/button_${v.name}_pressed.png'),
        );
        await g.up();
      });
    }
  });

  group('PcIconButton — 3 variants × 2 sizes (6)', () {
    for (final PcIconButtonVariant v in PcIconButtonVariant.values) {
      for (final PcIconButtonSize s in PcIconButtonSize.values) {
        testWidgets('${v.name} ${s.name}', (WidgetTester tester) async {
          await golden(
            tester,
            'icon_button_${v.name}_${s.name}',
            Center(
              child: PcIconButton(
                icon: PcIconData.settings2,
                onPressed: () {},
                semanticsLabel: 'Cài đặt',
                variant: v,
                size: s,
              ),
            ),
            width: 120,
            height: 120,
          );
        });
      }
    }
  });

  group('PcChip — 3', () {
    testWidgets('unselected', (WidgetTester tester) async {
      await golden(
        tester,
        'chip_unselected',
        Center(
          child: PcChip(label: 'Hôm nay', selected: false, onTap: () {}),
        ),
      );
    });
    testWidgets('selected', (WidgetTester tester) async {
      await golden(
        tester,
        'chip_selected',
        Center(
          child: PcChip(label: 'Hôm nay', selected: true, onTap: () {}),
        ),
      );
    });
    testWidgets('with count', (WidgetTester tester) async {
      await golden(
        tester,
        'chip_count',
        Center(
          child: PcChip(
            label: 'Cần xem lại',
            selected: false,
            onTap: () {},
            count: 3,
          ),
        ),
      );
    });
  });

  group('PcBadge — 4 kinds', () {
    for (final PcBadgeKind k in PcBadgeKind.values) {
      testWidgets(k.name, (WidgetTester tester) async {
        await golden(
          tester,
          'badge_${k.name}',
          Center(
            child: PcBadge(text: 'cần xem lại', kind: k),
          ),
        );
      });
    }
  });

  group('PcSheet — 2', () {
    testWidgets('default', (WidgetTester tester) async {
      await golden(
        tester,
        'sheet_default',
        PcSheet(
          title: 'Xuất ảnh',
          onClose: () {},
          closeSemanticsLabel: 'Đóng',
          child: const Text('PNG · 1200×1200'),
        ),
      );
    });
    testWidgets('with actions', (WidgetTester tester) async {
      await golden(
        tester,
        'sheet_actions',
        PcSheet(
          title: 'Xuất ảnh',
          onClose: () {},
          closeSemanticsLabel: 'Đóng',
          actions: <Widget>[
            PcButton(
              label: 'Lưu vào máy',
              onPressed: () {},
              variant: PcButtonVariant.primary,
              size: PcButtonSize.standard,
            ),
          ],
          child: const Text('PNG · 1200×1200'),
        ),
      );
    });
  });

  group('PcIcon — the full vocabulary at all four sizes (1)', () {
    testWidgets('vocabulary sheet', (WidgetTester tester) async {
      await golden(
        tester,
        'icon_vocabulary',
        Builder(
          builder: (BuildContext context) => Wrap(
            spacing: context.pcSpacing.sp4,
            runSpacing: context.pcSpacing.sp4,
            children: <Widget>[
              for (final PcIconData i in PcIconData.values) PcIcon.chrome(i),
              for (final PcIconData i in PcIconData.values.take(6)) ...<Widget>[
                PcIcon.badge(i),
                PcIcon.inline(i),
                PcIcon.large(i),
              ],
            ],
          ),
        ),
        height: 320,
      );
    });
  });

  group('PcSlider — 2', () {
    testWidgets('idle', (WidgetTester tester) async {
      await golden(
        tester,
        'slider_idle',
        PcSlider(
          value: 3,
          min: -10,
          max: 10,
          onChanged: (_) {},
          semanticsLabel: 'Thu giãn viền',
          label: 'Thu / giãn viền',
          readout: '+3 PX',
        ),
      );
    });
    testWidgets('at minimum', (WidgetTester tester) async {
      await golden(
        tester,
        'slider_min',
        PcSlider(
          value: -10,
          min: -10,
          max: 10,
          onChanged: (_) {},
          semanticsLabel: 'Thu giãn viền',
          label: 'Thu / giãn viền',
          readout: '-10 PX',
        ),
      );
    });
  });

  group('Readout — 3', () {
    testWidgets('plain', (WidgetTester tester) async {
      await golden(
        tester,
        'readout_plain',
        const Center(child: Readout('png · 1200×1200')),
      );
    });
    testWidgets('with icon', (WidgetTester tester) async {
      await golden(
        tester,
        'readout_icon',
        const Center(child: Readout('04 / 12', icon: PcIconData.clock)),
      );
    });
    testWidgets('emphasised', (WidgetTester tester) async {
      await golden(
        tester,
        'readout_emphasis',
        const Center(child: Readout('đang xử lý 3 ảnh', emphasis: true)),
      );
    });
  });

  group('ShutterButton — 4', () {
    testWidgets('single unlocked', (WidgetTester tester) async {
      await golden(
        tester,
        'shutter_unlocked',
        Center(
          child: ShutterButton(onPressed: () {}, semanticsLabel: 'Chụp'),
        ),
        width: 160,
        height: 160,
      );
    });
    testWidgets('single locked', (WidgetTester tester) async {
      await golden(
        tester,
        'shutter_locked',
        Center(
          child: ShutterButton(
            onPressed: () {},
            semanticsLabel: 'Chụp',
            contourLocked: true,
          ),
        ),
        width: 160,
        height: 160,
      );
    });
    testWidgets('batch with count', (WidgetTester tester) async {
      await golden(
        tester,
        'shutter_batch',
        Center(
          child: ShutterButton(
            onPressed: () {},
            semanticsLabel: 'Chụp',
            shotCount: 4,
          ),
        ),
        width: 160,
        height: 160,
      );
    });
    testWidgets('disabled', (WidgetTester tester) async {
      await golden(
        tester,
        'shutter_disabled',
        const Center(
          child: ShutterButton(onPressed: null, semanticsLabel: 'Chụp'),
        ),
        width: 160,
        height: 160,
      );
    });
  });

  group('ModeToggle — 2', () {
    for (final PcCaptureMode m in PcCaptureMode.values) {
      testWidgets(m.name, (WidgetTester tester) async {
        await golden(
          tester,
          'mode_toggle_${m.name}',
          Center(
            child: ModeToggle(
              mode: m,
              onChanged: (_) {},
              singleLabel: 'Đơn',
              batchLabel: 'Loạt',
            ),
          ),
          width: 200,
          height: 100,
        );
      });
    }
  });

  group('CheckerSurface — 2', () {
    for (final PcCheckerVariant v in PcCheckerVariant.values) {
      testWidgets(v.name, (WidgetTester tester) async {
        await golden(
          tester,
          'checker_${v.name}',
          CheckerSurface(variant: v, child: const SizedBox.expand()),
          width: 160,
          height: 160,
        );
      });
    }
  });

  group('BackgroundSwatchPicker — 2', () {
    // A fixture list, not the product's seven. Those are Spec #005's (FR-022).
    const List<PcSwatch> fixture = <PcSwatch>[
      PcSwatch(label: 'Trong suốt', isTransparent: true),
      PcSwatch(label: 'Trắng', color: Color(0xFFFFFFFF)),
      PcSwatch(label: 'Kem', color: Color(0xFFF3ECE1)),
    ];

    testWidgets('none selected', (WidgetTester tester) async {
      await golden(
        tester,
        'swatches_none',
        const BackgroundSwatchPicker(
          swatches: fixture,
          selectedIndex: -1,
          onSelected: null,
        ),
        height: 80,
      );
    });
    testWidgets('one selected', (WidgetTester tester) async {
      await golden(
        tester,
        'swatches_selected',
        const BackgroundSwatchPicker(
          swatches: fixture,
          selectedIndex: 1,
          onSelected: null,
        ),
        height: 80,
      );
    });
  });

  group('BatchThumb — 5 statuses', () {
    for (final PcBatchItemStatus s in PcBatchItemStatus.values) {
      testWidgets(s.name, (WidgetTester tester) async {
        await golden(
          tester,
          'batch_thumb_${s.name}',
          BatchThumb(
            status: s,
            semanticsLabel: 'Ảnh 1',
            progress: 0.4,
            image: const CheckerSurface(child: SizedBox.expand()),
          ),
          width: 120,
          height: 120,
        );
      });
    }
  });

  group('ProgressTrace — 3', () {
    testWidgets('indeterminate', (WidgetTester tester) async {
      await golden(
        tester,
        'progress_indeterminate',
        const Center(child: ProgressTrace()),
        width: 100,
        height: 100,
      );
    });
    testWidgets('40 percent', (WidgetTester tester) async {
      await golden(
        tester,
        'progress_40',
        const Center(child: ProgressTrace(progress: 0.4)),
        width: 100,
        height: 100,
      );
    });
    testWidgets('complete', (WidgetTester tester) async {
      await golden(
        tester,
        'progress_complete',
        const Center(child: ProgressTrace(progress: 1)),
        width: 100,
        height: 100,
      );
    });
  });

  group('EdgeNotice — 1', () {
    testWidgets('complex edge hint', (WidgetTester tester) async {
      await golden(
        tester,
        'edge_notice',
        EdgeNotice(
          title: 'Viền hơi phức tạp',
          body:
              'Ảnh có phần lông/tóc hoặc vùng trong suốt. '
              'Bạn có thể dùng luôn, hoặc chỉnh viền cho gọn hơn.',
          refineLabel: 'Chỉnh viền',
          acceptLabel: 'Vẫn dùng',
          onRefine: () {},
          onAccept: () {},
        ),
        width: 360,
      );
    });
  });

  group('PcToast — 3 kinds', () {
    for (final PcToastKind k in PcToastKind.values) {
      testWidgets(k.name, (WidgetTester tester) async {
        await golden(
          tester,
          'toast_${k.name}',
          Center(
            child: PcToast(
              message: 'Đã lưu 6 ảnh vào máy',
              kind: k,
              actionLabel: 'Xem',
              onAction: () {},
            ),
          ),
          height: 100,
        );
      });
    }
  });

  group('ScreenHeader — 2', () {
    testWidgets('title only', (WidgetTester tester) async {
      await golden(
        tester,
        'header_title',
        const ScreenHeader(title: 'Lịch sử'),
        height: 80,
      );
    });
    testWidgets('with leading, readout and actions', (
      WidgetTester tester,
    ) async {
      await golden(
        tester,
        'header_full',
        ScreenHeader(
          title: 'Phiên chụp',
          leading: PcIconButton(
            icon: PcIconData.chevronLeft,
            onPressed: () {},
            semanticsLabel: 'Quay lại',
          ),
          readout: const Readout('04 / 12'),
          actions: <Widget>[
            PcIconButton(
              icon: PcIconData.settings2,
              onPressed: () {},
              semanticsLabel: 'Cài đặt',
            ),
          ],
        ),
        height: 80,
      );
    });
  });

  group('ThumbBand — 2', () {
    testWidgets('primary only', (WidgetTester tester) async {
      await golden(
        tester,
        'thumb_band_primary',
        ThumbBand(
          primary: ShutterButton(onPressed: () {}, semanticsLabel: 'Chụp'),
        ),
        height: 160,
      );
    });
    testWidgets('with secondary and trailing', (WidgetTester tester) async {
      await golden(
        tester,
        'thumb_band_full',
        ThumbBand(
          secondary: PcButton(
            label: 'Chụp thêm',
            onPressed: () {},
            size: PcButtonSize.standard,
          ),
          primary: ShutterButton(
            onPressed: () {},
            semanticsLabel: 'Chụp',
            contourLocked: true,
            shotCount: 4,
          ),
          trailing: PcIconButton(
            icon: PcIconData.download,
            onPressed: () {},
            semanticsLabel: 'Xuất tất cả',
          ),
        ),
        height: 160,
      );
    });
  });
}
