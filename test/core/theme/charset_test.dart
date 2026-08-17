@Tags(<String>['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/pc_context.dart';
import 'package:productcam/core/theme/pc_theme.dart';

/// Closes the missing-glyph edge case (spec Edge Cases, SC-004) in the second
/// of its two layers.
///
/// The first layer is the fallback: anything outside the shipped subset falls
/// to the platform default rather than a tofu box. But a fallback is a floor,
/// not a guarantee — it says what happens when a glyph is missing, not that one
/// never is.
///
/// This is the guarantee. A substituted or missing glyph renders visibly
/// differently from the correct one, so freezing the full Vietnamese diacritic
/// set as a reference image catches it with no extra tooling. If the subset
/// ranges are ever narrowed, or a weight is dropped, or the family name is
/// misspelled so Flutter silently synthesises a face, this golden moves.
///
/// **Baselines are generated on Linux CI, never locally** (research R6). Run
/// the `update-goldens` workflow_dispatch job to (re)create them.
void main() {
  // Every Vietnamese vowel-plus-tone combination the language actually uses,
  // grouped by base letter. This is the set that breaks an under-subset font.
  const List<String> vietnameseRows = <String>[
    'À Á Â Ã Ă Ạ Ả Ấ Ầ Ẩ Ẫ Ậ Ắ Ằ Ẳ Ẵ Ặ',
    'à á â ã ă ạ ả ấ ầ ẩ ẫ ậ ắ ằ ẳ ẵ ặ',
    'È É Ê Ẹ Ẻ Ẽ Ế Ề Ể Ễ Ệ Ì Í Ĩ Ỉ Ị',
    'è é ê ẹ ẻ ẽ ế ề ể ễ ệ ì í ĩ ỉ ị',
    'Ò Ó Ô Õ Ơ Ọ Ỏ Ố Ồ Ổ Ỗ Ộ Ớ Ờ Ở Ỡ Ợ',
    'ò ó ô õ ơ ọ ỏ ố ồ ổ ỗ ộ ớ ờ ở ỡ ợ',
    'Ù Ú Ũ Ư Ụ Ủ Ứ Ừ Ử Ữ Ự Ỳ Ý Ỵ Ỷ Ỹ',
    'ù ú ũ ư ụ ủ ứ ừ ử ữ ự ỳ ý ỵ ỷ ỹ',
    'Đ đ Ĩ ĩ Ũ ũ Ơ ơ Ư ư Ă ă',
  ];

  const String latinRow =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
  const String digitsRow = '0123456789 · × ₫ % ( ) — –';

  // Real product copy, not lorem. If these render wrong, the app does.
  const String proseSample = 'Ảnh có phần lông/tóc hoặc vùng trong suốt.';
  const List<String> monoSamples = <String>[
    'XONG',
    'CẦN XEM LẠI',
    'PNG · 1200×1200',
    '04 / 12',
    '2,4 MB · 1.200.000 ₫',
  ];

  testWidgets('the shipped subset renders Vietnamese with no substitution', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildPcTheme(),
        home: Builder(
          builder: (BuildContext context) {
            final ThemeData theme = Theme.of(context);
            return Scaffold(
              backgroundColor: context.pcColors.bgApp,
              body: Padding(
                padding: EdgeInsets.all(context.pcSpacing.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // --- prose face -------------------------------------
                    Text('Manrope', style: context.pcTypography.h3),
                    SizedBox(height: context.pcSpacing.sp4),
                    Text(latinRow, style: context.pcTypography.body),
                    Text(digitsRow, style: context.pcTypography.body),
                    for (final String row in vietnameseRows)
                      Text(row, style: context.pcTypography.body),
                    SizedBox(height: context.pcSpacing.sp5),
                    Text(proseSample, style: context.pcTypography.body),

                    SizedBox(height: context.pcSpacing.sp8),

                    // --- mono face --------------------------------------
                    // The face where an absent Vietnamese subset would hide
                    // until a badge appeared in production.
                    Text('IBM Plex Mono', style: context.pcTypography.h3),
                    SizedBox(height: context.pcSpacing.sp4),
                    for (final String sample in monoSamples)
                      Text(sample, style: context.pcTypography.readout),
                    SizedBox(height: context.pcSpacing.sp3),
                    for (final String row in vietnameseRows.take(4))
                      Text(row, style: context.pcTypography.readout),

                    SizedBox(height: context.pcSpacing.sp8),

                    // --- every embedded weight --------------------------
                    // A weight that is declared but not shipped gets
                    // synthesised, which looks close enough to miss by eye.
                    Text('Weights', style: context.pcTypography.h3),
                    SizedBox(height: context.pcSpacing.sp4),
                    Text('Ầ Ạ 400 regular', style: theme.textTheme.bodyLarge),
                    Text('Ầ Ạ 500 medium', style: context.pcTypography.caption),
                    Text('Ầ Ạ 600 semibold', style: context.pcTypography.h3),
                    Text('Ầ Ạ 700 bold', style: context.pcTypography.h1),
                    Text('Ầ Ạ 800 black', style: context.pcTypography.display),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/charset.png'),
    );
  });
}
