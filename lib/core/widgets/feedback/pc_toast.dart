import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_icon.dart';

enum PcToastKind {
  /// Confirmation — "Đã lưu 6 ảnh vào máy".
  neutral,

  /// Worth a look. Amber, never failure.
  caution,

  /// A genuine failure that can be retried — "1 ảnh xử lý chưa xong".
  error,
}

/// A non-blocking confirmation. One line, at most one action.
///
/// Glass, because it floats over content. Enters with the fade-up motion
/// (`pc-fade-up`), and does not move at all under reduced motion.
class PcToast extends StatelessWidget {
  const PcToast({
    required this.message,
    this.kind = PcToastKind.neutral,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final PcToastKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final (Color tint, PcIconData glyph) = switch (kind) {
      PcToastKind.neutral => (context.pcColors.textAccent, PcIconData.check),
      PcToastKind.caution => (
        context.pcColors.textCaution,
        PcIconData.scissors,
      ),
      PcToastKind.error => (context.pcColors.textDanger, PcIconData.refreshCw),
    };

    return ClipRRect(
      borderRadius: context.pcRadius.md,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: context.pcElevation.blurChromeSigma,
          sigmaY: context.pcElevation.blurChromeSigma,
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: context.pcSpacing.touchMin),
          padding: EdgeInsets.symmetric(
            horizontal: context.pcSpacing.sp6,
            vertical: context.pcSpacing.sp4,
          ),
          decoration: ShapeDecoration(
            color: context.pcColors.bgGlass,
            shape: RoundedRectangleBorder(
              borderRadius: context.pcRadius.md,
              side: BorderSide(color: context.pcColors.borderSubtle),
            ),
            shadows: <BoxShadow>[context.pcElevation.shadowFloat],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PcIcon.inline(glyph, color: tint),
              SizedBox(width: context.pcSpacing.sp4),
              Flexible(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.pcTypography.body,
                ),
              ),
              if (actionLabel != null) ...<Widget>[
                SizedBox(width: context.pcSpacing.sp5),
                Semantics(
                  button: true,
                  label: actionLabel,
                  child: GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: context.pcTypography.bodyStrong.copyWith(
                        color: context.pcColors.textAccent,
                      ),
                    ),
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
