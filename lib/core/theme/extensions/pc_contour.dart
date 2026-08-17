// Written mechanically; the interesting decisions live in
// lib/core/theme/tokens/. This layer only exposes them through the theme so
// call sites never import a token directly.

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../tokens/pc_contour.dart';

/// PcContour — part of the ProductCam theme. Read it as `context.pcContour`.
@immutable
class PcContour extends ThemeExtension<PcContour> {
  const PcContour({
    required this.core,
    required this.coreLock,
    required this.halo,
    required this.review,
    required this.error,
    required this.wCore,
    required this.wHalo,
    required this.wCoreLock,
    required this.dashScan,
    required this.dashReview,
    required this.march,
    required this.tick,
    required this.tickWidth,
    required this.fillScan,
    required this.fillLock,
    required this.glowSigma,
    required this.glowColor,
    required this.glowReviewColor,
    required this.checkerSize,
    required this.checkerLight,
    required this.checkerDark,
  });

  /// The one instance built from the ported design tokens.
  factory PcContour.fromTokens() => const PcContour(
    core: PcContourTokens.core,
    coreLock: PcContourTokens.coreLock,
    halo: PcContourTokens.halo,
    review: PcContourTokens.review,
    error: PcContourTokens.error,
    wCore: PcContourTokens.wCore,
    wHalo: PcContourTokens.wHalo,
    wCoreLock: PcContourTokens.wCoreLock,
    dashScan: PcContourTokens.dashScan,
    dashReview: PcContourTokens.dashReview,
    march: PcContourTokens.march,
    tick: PcContourTokens.tick,
    tickWidth: PcContourTokens.tickWidth,
    fillScan: PcContourTokens.fillScan,
    fillLock: PcContourTokens.fillLock,
    glowSigma: PcContourTokens.glowSigma,
    glowColor: PcContourTokens.glowColor,
    glowReviewColor: PcContourTokens.glowReviewColor,
    checkerSize: PcContourTokens.checkerSize,
    checkerLight: PcContourTokens.checkerLight,
    checkerDark: PcContourTokens.checkerDark,
  );

  final Color core;
  final Color coreLock;
  final Color halo;
  final Color review;
  final Color error;
  final double wCore;
  final double wHalo;
  final double wCoreLock;
  final (double, double) dashScan;
  final (double, double) dashReview;
  final Duration march;
  final double tick;
  final double tickWidth;
  final Color fillScan;
  final Color fillLock;
  final double glowSigma;
  final Color glowColor;
  final Color glowReviewColor;
  final double checkerSize;
  final (Color, Color) checkerLight;
  final (Color, Color) checkerDark;

  // There is no field for a single-stroke contour, and none may be added.
  // [wHalo] is painted first and [wCore] on top, always — a single line
  // disappears against a white paper sweep or black leather, which is exactly
  // the range a product photographer works across (FR-016).

  @override
  PcContour copyWith({
    Color? core,
    Color? coreLock,
    Color? halo,
    Color? review,
    Color? error,
    double? wCore,
    double? wHalo,
    double? wCoreLock,
    (double, double)? dashScan,
    (double, double)? dashReview,
    Duration? march,
    double? tick,
    double? tickWidth,
    Color? fillScan,
    Color? fillLock,
    double? glowSigma,
    Color? glowColor,
    Color? glowReviewColor,
    double? checkerSize,
    (Color, Color)? checkerLight,
    (Color, Color)? checkerDark,
  }) {
    return PcContour(
      core: core ?? this.core,
      coreLock: coreLock ?? this.coreLock,
      halo: halo ?? this.halo,
      review: review ?? this.review,
      error: error ?? this.error,
      wCore: wCore ?? this.wCore,
      wHalo: wHalo ?? this.wHalo,
      wCoreLock: wCoreLock ?? this.wCoreLock,
      dashScan: dashScan ?? this.dashScan,
      dashReview: dashReview ?? this.dashReview,
      march: march ?? this.march,
      tick: tick ?? this.tick,
      tickWidth: tickWidth ?? this.tickWidth,
      fillScan: fillScan ?? this.fillScan,
      fillLock: fillLock ?? this.fillLock,
      glowSigma: glowSigma ?? this.glowSigma,
      glowColor: glowColor ?? this.glowColor,
      glowReviewColor: glowReviewColor ?? this.glowReviewColor,
      checkerSize: checkerSize ?? this.checkerSize,
      checkerLight: checkerLight ?? this.checkerLight,
      checkerDark: checkerDark ?? this.checkerDark,
    );
  }

  @override
  PcContour lerp(PcContour? other, double t) {
    if (other == null) return this;
    return PcContour(
      core: Color.lerp(core, other.core, t)!,
      coreLock: Color.lerp(coreLock, other.coreLock, t)!,
      halo: Color.lerp(halo, other.halo, t)!,
      review: Color.lerp(review, other.review, t)!,
      error: Color.lerp(error, other.error, t)!,
      wCore: lerpDouble(wCore, other.wCore, t)!,
      wHalo: lerpDouble(wHalo, other.wHalo, t)!,
      wCoreLock: lerpDouble(wCoreLock, other.wCoreLock, t)!,
      dashScan: (
        lerpDouble(dashScan.$1, other.dashScan.$1, t)!,
        lerpDouble(dashScan.$2, other.dashScan.$2, t)!,
      ),
      dashReview: (
        lerpDouble(dashReview.$1, other.dashReview.$1, t)!,
        lerpDouble(dashReview.$2, other.dashReview.$2, t)!,
      ),
      march: t < 0.5 ? march : other.march,
      tick: lerpDouble(tick, other.tick, t)!,
      tickWidth: lerpDouble(tickWidth, other.tickWidth, t)!,
      fillScan: Color.lerp(fillScan, other.fillScan, t)!,
      fillLock: Color.lerp(fillLock, other.fillLock, t)!,
      glowSigma: lerpDouble(glowSigma, other.glowSigma, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      glowReviewColor: Color.lerp(glowReviewColor, other.glowReviewColor, t)!,
      checkerSize: lerpDouble(checkerSize, other.checkerSize, t)!,
      checkerLight: (
        Color.lerp(checkerLight.$1, other.checkerLight.$1, t)!,
        Color.lerp(checkerLight.$2, other.checkerLight.$2, t)!,
      ),
      checkerDark: (
        Color.lerp(checkerDark.$1, other.checkerDark.$1, t)!,
        Color.lerp(checkerDark.$2, other.checkerDark.$2, t)!,
      ),
    );
  }
}
