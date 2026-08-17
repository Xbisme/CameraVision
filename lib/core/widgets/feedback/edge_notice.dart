import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_button.dart';
import '../core/pc_icon.dart';

/// The complex-edge hint: "Viền hơi phức tạp".
///
/// Amber and `scissors` — **never** red, never a warning triangle, never an
/// exclamation mark (FR-018). The target users are not technical, and a warning
/// would read as "your photo failed" when the photo is fine. The word for
/// imperfect output is *phức tạp*; *lỗi* is reserved for a genuine failure.
///
/// Two exits, both offered as equals: refine the edge, or use it as it is.
class EdgeNotice extends StatelessWidget {
  const EdgeNotice({
    required this.title,
    required this.body,
    required this.refineLabel,
    required this.acceptLabel,
    required this.onRefine,
    required this.onAccept,
    super.key,
  });

  final String title;
  final String body;
  final String refineLabel;
  final String acceptLabel;
  final VoidCallback onRefine;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.pcSpacing.sp6),
      decoration: ShapeDecoration(
        color: context.pcColors.cautionQuiet,
        shape: RoundedRectangleBorder(
          borderRadius: context.pcRadius.md,
          side: BorderSide(
            color: context.pcColors.caution.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              PcIcon.inline(
                PcIconData.scissors,
                color: context.pcColors.textCaution,
              ),
              SizedBox(width: context.pcSpacing.sp4),
              Expanded(
                child: Text(
                  title,
                  style: context.pcTypography.bodyStrong.copyWith(
                    color: context.pcColors.textCaution,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.pcSpacing.sp4),
          Text(body, style: context.pcTypography.body),
          SizedBox(height: context.pcSpacing.sp5),
          Row(
            children: <Widget>[
              PcButton(
                label: refineLabel,
                onPressed: onRefine,
                size: PcButtonSize.standard,
                icon: PcIconData.scissors,
              ),
              SizedBox(width: context.pcSpacing.sp4),
              PcButton(
                label: acceptLabel,
                onPressed: onAccept,
                variant: PcButtonVariant.quiet,
                size: PcButtonSize.standard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
