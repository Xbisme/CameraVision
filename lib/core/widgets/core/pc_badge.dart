import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import 'pc_icon.dart';

enum PcBadgeKind {
  neutral,

  /// Mint. Machine confirmation — done, locked, selected.
  accent,

  /// Amber. "Worth a look", **never** failure (FR-010).
  caution,

  /// Coral. A genuine processing failure that can be retried.
  danger,
}

/// A short uppercase status marker: `XONG`, `CẦN XEM LẠI`, `PNG · 1200×1200`.
///
/// Set in mono with readout tracking, because badges carry machine facts
/// (FR-013). Every non-neutral kind pairs its colour with a glyph, so the
/// meaning does not rest on hue alone (Constitution XI).
class PcBadge extends StatelessWidget {
  const PcBadge({
    required this.text,
    this.kind = PcBadgeKind.neutral,
    this.icon,
    super.key,
  });

  final String text;
  final PcBadgeKind kind;

  /// Overrides the default glyph for the kind. Neutral badges have none.
  final PcIconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, PcIconData? mark) = switch (kind) {
      PcBadgeKind.neutral => (
        context.pcColors.textSecondary,
        context.pcColors.bgSurfaceRaised,
        null,
      ),
      PcBadgeKind.accent => (
        context.pcColors.textAccent,
        context.pcColors.accentQuiet,
        PcIconData.check,
      ),
      PcBadgeKind.caution => (
        context.pcColors.textCaution,
        context.pcColors.cautionQuiet,
        PcIconData.scissors,
      ),
      PcBadgeKind.danger => (
        context.pcColors.textDanger,
        context.pcColors.dangerQuiet,
        PcIconData.refreshCw,
      ),
    };
    final PcIconData? glyph = icon ?? mark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.pcSpacing.sp4,
        vertical: context.pcSpacing.sp2,
      ),
      decoration: ShapeDecoration(color: bg, shape: context.pcRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (glyph != null) ...<Widget>[
            PcIcon.badge(glyph, color: fg),
            SizedBox(width: context.pcSpacing.sp2),
          ],
          Text(
            text.toUpperCase(),
            style: context.pcTypography.readoutSm.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
