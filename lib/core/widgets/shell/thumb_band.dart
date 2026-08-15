import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_button.dart';

/// The fixed 132px bottom band that holds every primary action.
///
/// It exists so the app stays usable one-handed while the other hand holds a
/// product. Two rules follow from that and both are enforced rather than
/// documented:
///
///  * it does not grow or shrink, so the shutter is always where the thumb
///    expects it;
///  * **nothing destructive may live here** (FR-024). It publishes a
///    [ThumbBandScope] so a [PcButton] can assert against being placed inside
///    it with the danger variant — a delete button under the thumb, pressed
///    without looking, is how a batch disappears.
class ThumbBand extends StatelessWidget {
  const ThumbBand({
    required this.primary,
    this.secondary,
    this.trailing,
    super.key,
  });

  /// The single primary action. Mint is spent here and nowhere else on screen.
  final Widget primary;

  final Widget? secondary;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ThumbBandScope(
      child: Container(
        height: context.pcSpacing.thumbBand,
        padding: EdgeInsets.symmetric(horizontal: context.pcSpacing.gutter),
        decoration: BoxDecoration(gradient: context.pcElevation.scrimBottom),
        // The side slots flex and the primary does not. Reserving a fixed
        // 104 on each side overflows a 320dp phone — 104 × 3 plus two 16
        // gutters is 344 — and the thing that must never be squeezed is the
        // shutter's hit target, not the secondary actions beside it.
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(alignment: Alignment.centerLeft, child: secondary),
            ),
            primary,
            Expanded(
              child: Align(alignment: Alignment.centerRight, child: trailing),
            ),
          ],
        ),
      ),
    );
  }
}
