// Written mechanically; the interesting decisions live in
// lib/core/theme/tokens/. This layer only exposes them through the theme so
// call sites never import a token directly.

import 'package:flutter/material.dart';

import '../tokens/pc_typography.dart';

/// PcTypography — part of the ProductCam theme. Read it as `context.pcTypography`.
@immutable
class PcTypography extends ThemeExtension<PcTypography> {
  const PcTypography({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.body,
    required this.bodyStrong,
    required this.caption,
    required this.button,
    required this.readout,
    required this.readoutSm,
  });

  /// The one instance built from the ported design tokens.
  factory PcTypography.fromTokens() => const PcTypography(
    display: PcTypographyTokens.display,
    h1: PcTypographyTokens.h1,
    h2: PcTypographyTokens.h2,
    h3: PcTypographyTokens.h3,
    body: PcTypographyTokens.body,
    bodyStrong: PcTypographyTokens.bodyStrong,
    caption: PcTypographyTokens.caption,
    button: PcTypographyTokens.button,
    readout: PcTypographyTokens.readout,
    readoutSm: PcTypographyTokens.readoutSm,
  );

  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle body;
  final TextStyle bodyStrong;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle readout;
  final TextStyle readoutSm;

  /// Tracking for uppercase labels and badges (`--tracking-label`, .06em),
  /// applied per size because CSS `em` is relative and Flutter's is not.
  double labelTracking(double fontSize) =>
      PcTypographyTokens.track(PcTypographyTokens.trackingLabelEm, fontSize);

  @override
  PcTypography copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? caption,
    TextStyle? button,
    TextStyle? readout,
    TextStyle? readoutSm,
  }) {
    return PcTypography(
      display: display ?? this.display,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      caption: caption ?? this.caption,
      button: button ?? this.button,
      readout: readout ?? this.readout,
      readoutSm: readoutSm ?? this.readoutSm,
    );
  }

  @override
  PcTypography lerp(PcTypography? other, double t) {
    if (other == null) return this;
    return PcTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyStrong: TextStyle.lerp(bodyStrong, other.bodyStrong, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      readout: TextStyle.lerp(readout, other.readout, t)!,
      readoutSm: TextStyle.lerp(readoutSm, other.readoutSm, t)!,
    );
  }
}
