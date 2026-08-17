import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/pc_context.dart';
import '../../theme/tokens/pc_spacing.dart';

/// The closed set of glyphs the product ships.
///
/// An enum rather than a string path on purpose: an un-vendored glyph becomes a
/// compile error instead of a blank square discovered in production (FR-025).
/// It also caps the inventory — the full source set is over a thousand icons,
/// and app size is a named top-three risk here (FR-026a).
///
/// Vendored from the Lucide git tag `0.474.0`, the version the design bundle
/// pins. Note that `lucide-static@0.474.0` does **not** exist on npm — the
/// published versions skip from 0.473.0 to 0.477.0 — so the glyphs come from
/// the upstream repository at that tag instead. Same icons, same version, and
/// the only source that actually has it.
///
/// Each file is committed with `stroke-width="1.75"`; Lucide ships 2. That
/// rewrite is the whole reason vector glyphs were chosen over an icon font,
/// which bakes its stroke in and scales it with the type size.
enum PcIconData {
  camera('camera'),
  images('images'),
  layers('layers'),
  image('image'),
  zap('zap'),
  zapOff('zap-off'),
  refreshCw('refresh-cw'),
  rotateCcw('rotate-ccw'),
  rotateCw('rotate-cw'),
  grid3x3('grid-3x3'),
  settings2('settings-2'),
  check('check'),
  close('x'),

  /// The complex-edge mark. **Never** a warning triangle — the target users are
  /// not technical, and a warning would read as "your photo failed" when the
  /// photo is fine (FR-018).
  scissors('scissors'),

  download('download'),
  share2('share-2'),
  clock('clock'),
  search('search'),
  chevronLeft('chevron-left'),

  /// Upstream renamed this to `ellipsis`; the file keeps the design's name.
  moreHorizontal('more-horizontal'),

  loader('loader'),
  plus('plus'),
  undo2('undo-2'),
  signalHigh('signal-high'),
  wifi('wifi'),
  batteryFull('battery-full');

  const PcIconData(this.assetName);

  final String assetName;

  String get assetPath => 'assets/icons/$assetName.svg';
}

/// The single icon entry point for the entire product.
///
/// Everything goes through here so that swapping the icon set later touches one
/// file. Emoji and unicode characters standing in for glyphs are forbidden
/// anywhere in the app; the only permitted non-icon marks are typographic — the
/// middot in readouts and `×` in dimensions (FR-025).
///
/// Icons are monochrome and inherit the surrounding colour. They are never
/// coloured for decoration; colour follows state only — mint for locked or
/// confirmed, amber for review, coral for error.
class PcIcon extends StatelessWidget {
  const PcIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticsLabel,
    super.key,
  });

  /// Badge and readout size (14).
  const PcIcon.badge(this.icon, {this.color, this.semanticsLabel, super.key})
    : size = PcSpacingTokens.iconBadge;

  /// Inline-with-text size (18).
  const PcIcon.inline(this.icon, {this.color, this.semanticsLabel, super.key})
    : size = PcSpacingTokens.iconInline;

  /// Camera-chrome size (22).
  const PcIcon.chrome(this.icon, {this.color, this.semanticsLabel, super.key})
    : size = PcSpacingTokens.iconChrome;

  /// Large icon-button size (26).
  const PcIcon.large(this.icon, {this.color, this.semanticsLabel, super.key})
    : size = PcSpacingTokens.iconLarge;

  final PcIconData icon;
  final double? size;
  final Color? color;

  /// Only set this when the icon is the *only* thing conveying meaning. When it
  /// sits beside a label, the label is the accessible name and repeating it
  /// here makes a screen reader say everything twice.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final double resolved = size ?? PcSpacingTokens.iconInline;
    final Color tint =
        color ??
        DefaultTextStyle.of(context).style.color ??
        context.pcColors.textPrimary;

    return SvgPicture.asset(
      icon.assetPath,
      width: resolved,
      height: resolved,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: semanticsLabel == null,
    );
  }
}
