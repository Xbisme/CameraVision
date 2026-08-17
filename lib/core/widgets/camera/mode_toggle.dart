import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

enum PcCaptureMode { single, batch }

/// Đơn ↔ Loạt. Glass, because it sits over the live feed.
class ModeToggle extends StatelessWidget {
  const ModeToggle({
    required this.mode,
    required this.onChanged,
    required this.singleLabel,
    required this.batchLabel,
    super.key,
  });

  final PcCaptureMode mode;
  final ValueChanged<PcCaptureMode>? onChanged;
  final String singleLabel;
  final String batchLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.pcSpacing.touchMin),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: context.pcElevation.blurChromeSigma,
          sigmaY: context.pcElevation.blurChromeSigma,
        ),
        child: Container(
          height: context.pcSpacing.touchMin,
          padding: EdgeInsets.all(context.pcSpacing.sp1),
          decoration: ShapeDecoration(
            color: context.pcColors.bgGlass,
            shape: context.pcRadius.pill.copyWith(
              side: BorderSide(color: context.pcColors.borderSubtle),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _Half(
                label: singleLabel,
                selected: mode == PcCaptureMode.single,
                onTap: () => onChanged?.call(PcCaptureMode.single),
              ),
              _Half(
                label: batchLabel,
                selected: mode == PcCaptureMode.batch,
                onTap: () => onChanged?.call(PcCaptureMode.batch),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Half extends StatelessWidget {
  const _Half({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (Duration duration, Curve curve) = context.pcMotion.tSheet;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: context.pcReduceMotion ? Duration.zero : duration,
          curve: curve,
          constraints: BoxConstraints(minWidth: context.pcSpacing.touchMin),
          padding: EdgeInsets.symmetric(horizontal: context.pcSpacing.sp5),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: selected ? context.pcColors.accent : null,
            shape: context.pcRadius.pill,
          ),
          child: Text(
            label,
            style: context.pcTypography.caption.copyWith(
              color: selected
                  ? context.pcColors.textOnAccent
                  : context.pcColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
