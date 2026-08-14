import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/error/app_failure.dart';
import 'package:productcam/core/error/failure_l10n.dart';
import 'package:productcam/core/l10n/generated/app_localizations.dart';

/// FR-007, FR-030, SC-004.
///
/// This is the test that makes "every failure is explained in the user's
/// language" enforceable. Adding an [AppFailure] variant without a message in
/// BOTH locales fails here — and adding one without touching `failureMessage`
/// at all fails to compile, because the mapping switch is exhaustive.
void main() {
  group('every AppFailure variant has a message in every shipped locale', () {
    for (final Locale locale in AppLocalizations.supportedLocales) {
      test('locale ${locale.languageCode}', () async {
        final AppLocalizations l10n = await AppLocalizations.delegate.load(
          locale,
        );

        for (final AppFailure failure in allFailureVariants) {
          final String message = failureMessage(failure, l10n);

          expect(
            message.trim(),
            isNotEmpty,
            reason: '${failure.runtimeType} has no message in $locale',
          );
        }
      });
    }
  });

  test('the two locales ship genuinely different text, not a copy', () async {
    final AppLocalizations en = await AppLocalizations.delegate.load(
      const Locale('en'),
    );
    final AppLocalizations vi = await AppLocalizations.delegate.load(
      const Locale('vi'),
    );

    // Guards against a Vietnamese ARB that was created by copying English —
    // which would pass the emptiness check above while shipping English text
    // to Vietnamese users.
    for (final AppFailure failure in allFailureVariants) {
      expect(
        failureMessage(failure, vi),
        isNot(equals(failureMessage(failure, en))),
        reason: '${failure.runtimeType} is identical in both locales',
      );
    }
  });

  test('Unknown never leaks its diagnostic cause to the user', () async {
    final AppLocalizations en = await AppLocalizations.delegate.load(
      const Locale('en'),
    );

    const String secret = 'PlatformException(code: 42, stack trace ...)';
    final String message = failureMessage(const Unknown(secret), en);

    // FR-008: the cause exists for logs only.
    expect(message.contains(secret), isFalse);
    expect(message, equals(en.failureUnknown));
  });
}
