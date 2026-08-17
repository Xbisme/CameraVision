import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import '../core/pc_icon.dart';
import 'progress_trace.dart';

/// The five states a photo moves through in a batch session.
///
/// Each pairs a colour with a **non-colour mark**, so the state survives
/// greyscale and colour-blindness (Constitution XI). Populated in Spec #006;
/// dressed here.
enum PcBatchItemStatus {
  queued,
  working,
  done,

  /// Complex edge. Amber, and it must never read as failure — the word for
  /// imperfect output is *phức tạp*, not *lỗi* (FR-018).
  review,

  /// A genuine processing failure that can be retried. The only status
  /// permitted coral.
  error,
}

/// One photo tile in the session grid.
class BatchThumb extends StatelessWidget {
  const BatchThumb({
    required this.status,
    required this.semanticsLabel,
    this.image,
    this.onTap,
    this.progress,
    super.key,
  });

  final PcBatchItemStatus status;
  final String semanticsLabel;
  final Widget? image;
  final VoidCallback? onTap;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final (Color tint, PcIconData? mark) = switch (status) {
      PcBatchItemStatus.queued => (context.pcColors.statusQueued, null),
      PcBatchItemStatus.working => (context.pcColors.statusWorking, null),
      PcBatchItemStatus.done => (context.pcColors.statusDone, PcIconData.check),
      PcBatchItemStatus.review => (
        context.pcColors.statusReview,
        PcIconData.scissors,
      ),
      PcBatchItemStatus.error => (
        context.pcColors.statusError,
        PcIconData.refreshCw,
      ),
    };

    return Semantics(
      button: onTap != null,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: ShapeDecoration(
            color: context.pcColors.bgSurfaceRaised,
            shape: RoundedRectangleBorder(
              borderRadius: context.pcRadius.thumb,
              side: BorderSide(
                color: tint,
                width: context.pcSpacing.strokeHairline,
              ),
            ),
            shadows: <BoxShadow>[context.pcElevation.shadowThumb],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (image != null)
                Opacity(
                  // Queued reads as "not yet" by being dimmed, which is a
                  // second channel alongside its colour.
                  opacity: status == PcBatchItemStatus.queued ? 0.45 : 1,
                  child: image!,
                ),
              if (status == PcBatchItemStatus.working)
                Center(
                  child: ProgressTrace(
                    progress: progress,
                    semanticsLabel: semanticsLabel,
                  ),
                ),
              if (mark != null)
                Positioned(
                  right: context.pcSpacing.sp3,
                  bottom: context.pcSpacing.sp3,
                  child: Container(
                    padding: EdgeInsets.all(context.pcSpacing.sp2),
                    decoration: ShapeDecoration(
                      color: context.pcColors.bgScrim,
                      shape: const CircleBorder(),
                    ),
                    child: PcIcon.badge(mark, color: tint),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
