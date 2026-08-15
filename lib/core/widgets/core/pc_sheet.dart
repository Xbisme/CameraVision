import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import 'pc_icon.dart';
import 'pc_icon_button.dart';

/// A bottom sheet.
///
/// Top corners only, and **opaque**: glass is for controls floating over the
/// camera feed or a photo, and a sheet sits over a solid screen (FR-011).
class PcSheet extends StatelessWidget {
  const PcSheet({
    required this.title,
    required this.child,
    required this.onClose,
    required this.closeSemanticsLabel,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final Widget child;
  final VoidCallback onClose;

  /// The close control is icon-only, so it needs its own name (Principle XI).
  final String closeSemanticsLabel;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: context.pcColors.bgSheet,
        shape: RoundedRectangleBorder(borderRadius: context.pcRadius.sheetTop),
        shadows: <BoxShadow>[context.pcElevation.shadowSheet],
      ),
      padding: EdgeInsets.all(context.pcSpacing.sheetPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(title, style: context.pcTypography.h3)),
              PcIconButton(
                icon: PcIconData.close,
                onPressed: onClose,
                semanticsLabel: closeSemanticsLabel,
              ),
            ],
          ),
          SizedBox(height: context.pcSpacing.sp5),
          child,
          if (actions.isNotEmpty) ...<Widget>[
            SizedBox(height: context.pcSpacing.sp7),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                for (final Widget a in actions) ...<Widget>[
                  a,
                  SizedBox(width: context.pcSpacing.sp4),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
