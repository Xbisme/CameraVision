import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';

/// FR-010, FR-011, FR-032, SC-002, SC-003.
void main() {
  Future<String> areaNameFor(WidgetTester tester, Locale? locale) async {
    late String name;
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (BuildContext context) {
            name = AppLocalizations.of(context).areaSettings;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return name;
  }

  testWidgets('a Vietnamese device shows Vietnamese', (WidgetTester t) async {
    expect(await areaNameFor(t, const Locale('vi')), equals('Cài đặt'));
  });

  testWidgets('an English device shows English', (WidgetTester t) async {
    expect(await areaNameFor(t, const Locale('en')), equals('Settings'));
  });

  testWidgets('an unsupported language falls back to English', (
    WidgetTester t,
  ) async {
    // Japanese is neither shipped locale — English is the fallback, not
    // Vietnamese, and not a blank.
    expect(await areaNameFor(t, const Locale('ja')), equals('Settings'));
  });

  test('exactly two locales are shipped', () {
    expect(
      AppLocalizations.supportedLocales.map((Locale l) => l.languageCode),
      unorderedEquals(<String>['en', 'vi']),
    );
  });
}
