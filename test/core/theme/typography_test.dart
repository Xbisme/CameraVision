import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productcam/core/theme/extensions/pc_typography.dart';
import 'package:productcam/core/theme/tokens/pc_typography.dart';

/// Guards the `em` → logical-pixel tracking conversion (T010) and the
/// prose/mono split (FR-013).
///
/// The conversion is the single most likely silent port error in this spec:
/// CSS letter-spacing in `em` is relative to font size, Flutter's is absolute,
/// and copying `0.08` across compiles fine while producing roughly a
/// thirteenth of the intended tracking. Nothing would look obviously broken —
/// the readouts would just quietly stop reading as instrument type.
void main() {
  final PcTypography type = PcTypography.fromTokens();

  group('tracking is converted per role, not copied', () {
    test('mono readouts carry +0.08em at their own size', () {
      expect(type.readout.fontSize, 13);
      expect(type.readout.letterSpacing, closeTo(0.08 * 13, 0.0001));

      expect(type.readoutSm.fontSize, 11);
      expect(type.readoutSm.letterSpacing, closeTo(0.08 * 11, 0.0001));
    });

    test('display sizes carry negative tracking', () {
      expect(type.display.letterSpacing, closeTo(-0.02 * 34, 0.0001));
      expect(type.h1.letterSpacing, closeTo(-0.01 * 26, 0.0001));
      expect(type.h2.letterSpacing, closeTo(-0.01 * 21, 0.0001));
    });

    test('body copy is untracked', () {
      // Tracking body text is a display-type habit that hurts reading.
      expect(type.body.letterSpacing, isNull);
      expect(type.bodyStrong.letterSpacing, isNull);
      expect(type.h3.letterSpacing, isNull);
    });

    test('label tracking scales with the size it is asked about', () {
      expect(type.labelTracking(11), closeTo(0.06 * 11, 0.0001));
      expect(type.labelTracking(13), closeTo(0.06 * 13, 0.0001));
      // The bug this catches: returning the em value regardless of size.
      expect(
        type.labelTracking(11),
        isNot(closeTo(type.labelTracking(13), 0.01)),
      );
    });
  });

  group('the prose/mono split holds (FR-013)', () {
    test('every prose role is Manrope', () {
      final List<TextStyle> prose = <TextStyle>[
        type.display,
        type.h1,
        type.h2,
        type.h3,
        type.body,
        type.bodyStrong,
        type.caption,
        type.button,
      ];
      for (final TextStyle style in prose) {
        expect(style.fontFamily, PcTypographyTokens.fontUi);
      }
    });

    test('every readout role is IBM Plex Mono', () {
      expect(type.readout.fontFamily, PcTypographyTokens.fontMono);
      expect(type.readoutSm.fontFamily, PcTypographyTokens.fontMono);
    });

    test('the two families are actually different', () {
      // Guards a copy-paste that would make readouts silently prose.
      expect(PcTypographyTokens.fontUi, isNot(PcTypographyTokens.fontMono));
    });
  });

  group('the shipped weights are the referenced weights (FR-015)', () {
    test('every weight a role asks for is one of the six embedded files', () {
      // pubspec ships Manrope 400/500/600/700/800 and IBMPlexMono 500. A role
      // asking for anything else would silently fall back to a synthesised
      // face, which is exactly the substitution SC-004 forbids.
      final Set<FontWeight> manrope = <FontWeight>{
        FontWeight.w400,
        FontWeight.w500,
        FontWeight.w600,
        FontWeight.w700,
        FontWeight.w800,
      };
      final Set<FontWeight> mono = <FontWeight>{FontWeight.w500};

      for (final TextStyle style in <TextStyle>[
        type.display,
        type.h1,
        type.h2,
        type.h3,
        type.body,
        type.bodyStrong,
        type.caption,
        type.button,
      ]) {
        expect(
          manrope,
          contains(style.fontWeight),
          reason: 'Manrope ${style.fontWeight} is not embedded',
        );
      }
      for (final TextStyle style in <TextStyle>[type.readout, type.readoutSm]) {
        expect(
          mono,
          contains(style.fontWeight),
          reason: 'IBMPlexMono ${style.fontWeight} is not embedded',
        );
      }
    });
  });
}
