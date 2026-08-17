import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

/// Progress as a traced ring — the same line the viewfinder draws around a
/// subject, applied to time. That reuse is what makes the contour a design
/// language rather than a single feature.
class ProgressTrace extends StatefulWidget {
  const ProgressTrace({
    this.progress,
    this.size,
    this.semanticsLabel,
    super.key,
  });

  /// `null` means indeterminate.
  final double? progress;
  final double? size;
  final String? semanticsLabel;

  @override
  State<ProgressTrace> createState() => _ProgressTraceState();
}

class _ProgressTraceState extends State<ProgressTrace>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spin.duration = context.pcMotion.trace;
    _sync();
  }

  @override
  void didUpdateWidget(ProgressTrace old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    // Under reduced motion the indeterminate ring holds a static arc rather
    // than spinning — still legibly "working", without the movement.
    if (widget.progress == null && !context.pcReduceMotion) {
      if (!_spin.isAnimating) _spin.repeat();
    } else {
      _spin.stop();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double d = widget.size ?? context.pcSpacing.iconLarge;
    return Semantics(
      label: widget.semanticsLabel,
      value: widget.progress == null
          ? null
          : '${(widget.progress! * 100).round()}%',
      child: SizedBox(
        width: d,
        height: d,
        child: AnimatedBuilder(
          animation: _spin,
          builder: (BuildContext context, _) => CustomPaint(
            painter: _TracePainter(
              progress: widget.progress,
              rotation: _spin.value,
              track: context.pcColors.bgTrack,
              accent: context.pcColors.accent,
              stroke: context.pcSpacing.strokeMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  const _TracePainter({
    required this.progress,
    required this.rotation,
    required this.track,
    required this.accent,
    required this.stroke,
  });

  final double? progress;
  final double rotation;
  final Color track;
  final Color accent;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Rect ring = rect.deflate(stroke);
    final Paint base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(ring, 0, math.pi * 2, false, base);

    final double sweep = progress == null
        ? math.pi * 0.6
        : math.pi * 2 * progress!.clamp(0, 1);
    final double start = -math.pi / 2 + rotation * math.pi * 2;
    canvas.drawArc(
      ring,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = accent,
    );
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.progress != progress ||
      old.rotation != rotation ||
      old.track != track ||
      old.accent != accent ||
      old.stroke != stroke;
}
