import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_icon.dart';

/// One selectable background. A flat colour, a gradient, or transparency.
///
/// The picker carries **no list of its own**: the seven fixed backgrounds are
/// Spec #005's, and building them here would be implementing an unwritten spec
/// (FR-022).
@immutable
class PcSwatch {
  const PcSwatch({
    required this.label,
    this.color,
    this.gradient,
    this.isTransparent = false,
  });

  /// Accessible name, supplied by the caller — never read from the catalogue.
  final String label;
  final Color? color;
  final Gradient? gradient;

  /// Renders as the checkerboard rather than as a fill.
  final bool isTransparent;
}

/// A row of background choices.
///
/// Selection is the mint ring plus tick — the same lock mark the viewfinder
/// used to promise the cutout, now confirming a choice.
class BackgroundSwatchPicker extends StatelessWidget {
  const BackgroundSwatchPicker({
    required this.swatches,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<PcSwatch> swatches;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.pcSpacing.touchComfortable,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: swatches.length,
        separatorBuilder: (_, _) => SizedBox(width: context.pcSpacing.sp4),
        itemBuilder: (BuildContext context, int i) {
          final PcSwatch s = swatches[i];
          final bool selected = i == selectedIndex;
          return Semantics(
            button: true,
            selected: selected,
            label: s.label,
            child: GestureDetector(
              onTap: () => onSelected?.call(i),
              child: Container(
                width: context.pcSpacing.touchComfortable,
                height: context.pcSpacing.touchComfortable,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: s.color,
                  gradient: s.gradient,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: selected
                          ? context.pcColors.borderAccent
                          : context.pcColors.borderHairline,
                      width: context.pcSpacing.strokeMedium,
                    ),
                  ),
                  shadows: selected ? context.pcElevation.glowAccentSoft : null,
                ),
                child: selected
                    ? PcIcon.badge(
                        PcIconData.check,
                        color: context.pcColors.textOnAccent,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
