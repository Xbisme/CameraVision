import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_icon.dart';

/// A machine fact: a count, a dimension, a file size, a duration, a shot index.
///
/// Always mono, always uppercase, always at readout tracking. **Prose must
/// never be passed to it and it must never be used for prose** (FR-013) — the
/// mono voice is what makes the app read as an instrument rather than as
/// another consumer app.
///
/// [text] arrives pre-formatted: number formatting is locale-dependent and
/// belongs to the caller, not to a presentation widget.
class Readout extends StatelessWidget {
  const Readout(this.text, {this.icon, this.emphasis = false, super.key});

  final String text;
  final PcIconData? icon;

  /// Lifts the value to primary text. Used when the readout *is* the message,
  /// as in "Đang xử lý 3 ảnh".
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final Color colour = emphasis
        ? context.pcColors.textPrimary
        : context.pcColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          PcIcon.badge(icon!, color: colour),
          SizedBox(width: context.pcSpacing.sp3),
        ],
        Text(
          text.toUpperCase(),
          style: context.pcTypography.readout.copyWith(color: colour),
        ),
      ],
    );
  }
}
