import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import 'pc_icon.dart';

/// A filter or option chip.
///
/// Selection is a **mint ring plus a tick**, not a fill-colour swap — the same
/// lock mark the viewfinder uses to promise a cutout, reused so selection reads
/// as the machine confirming rather than as decoration. It also means selection
/// survives greyscale, which a colour swap would not (Constitution XI).
class PcChip extends StatelessWidget {
  const PcChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  /// Optional trailing count, e.g. a filter's match total. Rendered in mono,
  /// because it is a machine fact (FR-013).
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: context.pcSpacing.touchMin),
          padding: EdgeInsets.symmetric(horizontal: context.pcSpacing.sp5),
          decoration: ShapeDecoration(
            color: selected
                ? context.pcColors.accentQuiet
                : context.pcColors.bgSurfaceRaised,
            shape: context.pcRadius.pill.copyWith(
              side: BorderSide(
                color: selected
                    ? context.pcColors.borderAccent
                    : context.pcColors.borderHairline,
                width: context.pcSpacing.strokeHairline,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (selected) ...<Widget>[
                PcIcon.badge(
                  PcIconData.check,
                  color: context.pcColors.textAccent,
                ),
                SizedBox(width: context.pcSpacing.sp3),
              ],
              Text(
                label,
                style: context.pcTypography.caption.copyWith(
                  color: selected
                      ? context.pcColors.textAccent
                      : context.pcColors.textSecondary,
                ),
              ),
              if (count != null) ...<Widget>[
                SizedBox(width: context.pcSpacing.sp3),
                Text(
                  '$count',
                  style: context.pcTypography.readoutSm.copyWith(
                    color: context.pcColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
