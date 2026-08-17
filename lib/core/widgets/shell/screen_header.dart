import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

/// The fixed 56px header band.
///
/// It does **not** grow with text scale. Enlarged text is honoured to 1.3× and
/// capped at the root (FR-015a); the band itself stays put, because a header
/// that grows pushes the thumb band off the reachable part of the screen.
class ScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  const ScreenHeader({
    required this.title,
    this.leading,
    this.actions = const <Widget>[],
    this.readout,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  /// Optional machine fact, right-aligned — e.g. a shot count.
  final Widget? readout;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.pcSpacing.barHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.pcSpacing.gutter),
        child: Row(
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              SizedBox(width: context.pcSpacing.sp4),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.pcTypography.h3,
              ),
            ),
            if (readout != null) ...<Widget>[
              readout!,
              SizedBox(width: context.pcSpacing.sp4),
            ],
            for (final Widget a in actions) a,
          ],
        ),
      ),
    );
  }
}
