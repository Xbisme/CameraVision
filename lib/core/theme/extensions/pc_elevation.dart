// Written mechanically; the interesting decisions live in
// lib/core/theme/tokens/. This layer only exposes them through the theme so
// call sites never import a token directly.

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../tokens/pc_elevation.dart';

/// PcElevation — part of the ProductCam theme. Read it as `context.pcElevation`.
@immutable
class PcElevation extends ThemeExtension<PcElevation> {
  const PcElevation({
    required this.rim,
    required this.rimStrong,
    required this.shadowFloat,
    required this.shadowSheet,
    required this.shadowThumb,
    required this.glowAccent,
    required this.glowAccentSoft,
    required this.glowCaution,
    required this.scrimTop,
    required this.scrimBottom,
    required this.blurChromeSigma,
  });

  /// The one instance built from the ported design tokens.
  factory PcElevation.fromTokens() => const PcElevation(
    rim: PcElevationTokens.rim,
    rimStrong: PcElevationTokens.rimStrong,
    shadowFloat: PcElevationTokens.shadowFloat,
    shadowSheet: PcElevationTokens.shadowSheet,
    shadowThumb: PcElevationTokens.shadowThumb,
    glowAccent: PcElevationTokens.glowAccent,
    glowAccentSoft: PcElevationTokens.glowAccentSoft,
    glowCaution: PcElevationTokens.glowCaution,
    scrimTop: PcElevationTokens.scrimTop,
    scrimBottom: PcElevationTokens.scrimBottom,
    blurChromeSigma: PcElevationTokens.blurChromeSigma,
  );

  final BorderSide rim;
  final BorderSide rimStrong;
  final BoxShadow shadowFloat;
  final BoxShadow shadowSheet;
  final BoxShadow shadowThumb;
  final List<BoxShadow> glowAccent;
  final List<BoxShadow> glowAccentSoft;
  final List<BoxShadow> glowCaution;
  final LinearGradient scrimTop;
  final LinearGradient scrimBottom;
  final double blurChromeSigma;

  /// Colour matrix for the chrome glass's `saturate(1.1)` half. Not a field —
  /// it is a constant of the filter, not something a theme variant would move.
  List<double> get saturationMatrix => PcElevationTokens.saturationMatrix;

  @override
  PcElevation copyWith({
    BorderSide? rim,
    BorderSide? rimStrong,
    BoxShadow? shadowFloat,
    BoxShadow? shadowSheet,
    BoxShadow? shadowThumb,
    List<BoxShadow>? glowAccent,
    List<BoxShadow>? glowAccentSoft,
    List<BoxShadow>? glowCaution,
    LinearGradient? scrimTop,
    LinearGradient? scrimBottom,
    double? blurChromeSigma,
  }) {
    return PcElevation(
      rim: rim ?? this.rim,
      rimStrong: rimStrong ?? this.rimStrong,
      shadowFloat: shadowFloat ?? this.shadowFloat,
      shadowSheet: shadowSheet ?? this.shadowSheet,
      shadowThumb: shadowThumb ?? this.shadowThumb,
      glowAccent: glowAccent ?? this.glowAccent,
      glowAccentSoft: glowAccentSoft ?? this.glowAccentSoft,
      glowCaution: glowCaution ?? this.glowCaution,
      scrimTop: scrimTop ?? this.scrimTop,
      scrimBottom: scrimBottom ?? this.scrimBottom,
      blurChromeSigma: blurChromeSigma ?? this.blurChromeSigma,
    );
  }

  @override
  PcElevation lerp(PcElevation? other, double t) {
    if (other == null) return this;
    return PcElevation(
      rim: BorderSide.lerp(rim, other.rim, t),
      rimStrong: BorderSide.lerp(rimStrong, other.rimStrong, t),
      shadowFloat: BoxShadow.lerp(shadowFloat, other.shadowFloat, t)!,
      shadowSheet: BoxShadow.lerp(shadowSheet, other.shadowSheet, t)!,
      shadowThumb: BoxShadow.lerp(shadowThumb, other.shadowThumb, t)!,
      glowAccent: BoxShadow.lerpList(glowAccent, other.glowAccent, t)!,
      glowAccentSoft: BoxShadow.lerpList(
        glowAccentSoft,
        other.glowAccentSoft,
        t,
      )!,
      glowCaution: BoxShadow.lerpList(glowCaution, other.glowCaution, t)!,
      scrimTop: LinearGradient.lerp(scrimTop, other.scrimTop, t)!,
      scrimBottom: LinearGradient.lerp(scrimBottom, other.scrimBottom, t)!,
      blurChromeSigma: lerpDouble(blurChromeSigma, other.blurChromeSigma, t)!,
    );
  }
}
