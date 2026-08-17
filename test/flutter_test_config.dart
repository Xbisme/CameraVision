import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs once before every test file in this package.
///
/// Without this, `flutter_test` renders text in its own placeholder font, and
/// every golden would verify layout while quietly hiding the typography — half
/// of what Spec #001b delivers (research R6). Loading the real embedded faces
/// is what makes a golden a check on the type as well as the boxes.
///
/// The fonts loaded here are the same six binaries the app ships, read straight
/// from `assets/fonts/`, so a test can never pass against a face the product
/// does not have.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('Manrope', <String>[
    'assets/fonts/Manrope-400.ttf',
    'assets/fonts/Manrope-500.ttf',
    'assets/fonts/Manrope-600.ttf',
    'assets/fonts/Manrope-700.ttf',
    'assets/fonts/Manrope-800.ttf',
  ]);
  await _loadFont('IBMPlexMono', <String>['assets/fonts/IBMPlexMono-500.ttf']);
  return testMain();
}

Future<void> _loadFont(String family, List<String> paths) async {
  final FontLoader loader = FontLoader(family);
  for (final String path in paths) {
    final File file = File(path);
    if (!file.existsSync()) {
      // Failing loudly beats rendering in the placeholder font and calling the
      // resulting baseline correct.
      throw StateError(
        'Missing font asset $path. Golden tests cannot produce a valid '
        'baseline without the real faces — see spec 001b task T028.',
      );
    }
    loader.addFont(
      file.readAsBytes().then(
        (List<int> bytes) => ByteData.sublistView(Uint8List.fromList(bytes)),
      ),
    );
  }
  await loader.load();
}
