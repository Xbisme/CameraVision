import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

/// A value slider.
///
/// [semanticsLabel] is **required** even though the visible [label] is not:
/// the design uses unlabelled sliders inside sheets, which is precisely why the
/// accessible name cannot also be optional (Principle XI).
class PcSlider extends StatelessWidget {
  const PcSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.semanticsLabel,
    this.label,
    this.readout,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String semanticsLabel;
  final String? label;

  /// Pre-formatted machine fact shown beside the label — set in mono, because
  /// that is what it is (FR-013).
  final String? readout;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      label: semanticsLabel,
      value: readout,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (label != null || readout != null)
            Row(
              children: <Widget>[
                if (label != null)
                  Expanded(
                    child: Text(label!, style: context.pcTypography.caption),
                  ),
                if (readout != null)
                  Text(
                    readout!,
                    style: context.pcTypography.readout.copyWith(
                      color: context.pcColors.textSecondary,
                    ),
                  ),
              ],
            ),
          SizedBox(
            // The painted thumb is smaller, but the hit area is not allowed to
            // be (FR-023).
            height: context.pcSpacing.touchMin,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: context.pcColors.accent,
                inactiveTrackColor: context.pcColors.bgTrack,
                thumbColor: context.pcColors.accent,
                overlayColor: context.pcColors.accentQuiet,
                trackHeight: context.pcSpacing.sp2,
              ),
              child: ExcludeSemantics(
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
