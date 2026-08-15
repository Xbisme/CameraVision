import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/pc_theme.dart';

/// Shared harness for every widget test in `lib/core/widgets/`.
///
/// Components read their values through `context.pcColors` and friends, so a
/// bare `MaterialApp` will assert. This wraps the subject in the real theme —
/// the same one the app ships, not a test double — because a golden taken
/// against a stand-in theme would prove nothing about the product.
Future<void> pumpWithPcTheme(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(360, 640),
  bool reduceMotion = false,
  double textScale = 1,
}) async {
  tester.view
    ..physicalSize = size * tester.view.devicePixelRatio
    ..devicePixelRatio = tester.view.devicePixelRatio;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: buildPcTheme(),
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(
          disableAnimations: reduceMotion,
          textScaler: TextScaler.linear(textScale),
          size: size,
        ),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

/// The four backgrounds the design names as the range that breaks a
/// single-stroke contour: a white paper sweep, warm cardboard, black leather,
/// and a backlit window.
///
/// These are flat stand-ins rather than photographs — the design bundle ships
/// no product photography (its own "Open gaps" §4), and a solid or gradient
/// fill is actually the harsher test, since a photo's texture gives a line
/// edges to catch on that a flat field does not.
enum ReferenceBackground {
  whitePaper(Color(0xFFFAFAF8)),
  warmCardboard(Color(0xFFC8A87C)),
  blackLeather(Color(0xFF14100E)),
  backlitWindow(Color(0xFFEFF4F8));

  const ReferenceBackground(this.colour);
  final Color colour;
}
