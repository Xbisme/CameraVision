import 'package:flutter/material.dart';

import 'extensions/pc_colors.dart';
import 'extensions/pc_contour.dart';
import 'extensions/pc_elevation.dart';
import 'extensions/pc_motion.dart';
import 'extensions/pc_radius.dart';
import 'extensions/pc_spacing.dart';
import 'extensions/pc_typography.dart';

/// The only way widgets reach design tokens.
///
/// Every getter throws rather than falling back if its extension is missing.
/// A silent fallback would mean a screen renders in framework defaults and
/// nobody notices until it ships — which is the exact failure this whole spec
/// exists to prevent (Constitution VII).
extension PcThemeContext on BuildContext {
  PcColors get pcColors => _read<PcColors>('PcColors');
  PcTypography get pcTypography => _read<PcTypography>('PcTypography');
  PcSpacing get pcSpacing => _read<PcSpacing>('PcSpacing');
  PcRadius get pcRadius => _read<PcRadius>('PcRadius');
  PcElevation get pcElevation => _read<PcElevation>('PcElevation');
  PcMotion get pcMotion => _read<PcMotion>('PcMotion');
  PcContour get pcContour => _read<PcContour>('PcContour');

  /// Whether the device has asked for reduced motion.
  ///
  /// Every looping or pulsing widget must consult this and hold its static
  /// appearance instead. Nothing is lost when it is true: contour states are
  /// separated by dash pattern, not by movement (FR-027a).
  bool get pcReduceMotion => MediaQuery.disableAnimationsOf(this);

  T _read<T>(String name) {
    final T? ext = Theme.of(this).extension<T>();
    assert(
      ext != null,
      'Missing $name on the current Theme. Widgets from lib/core/widgets/ '
      'require buildPcTheme(); wrapping them in a bare MaterialApp will not '
      'work. In tests, use the shared pumpWithPcTheme helper.',
    );
    return ext!;
  }
}
