import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../theme/extensions/pc_contour.dart';
import '../../theme/pc_context.dart';

/// The three states the contour can report.
///
/// State is carried by **dash pattern first and colour second**, so it survives
/// blown highlights, a greyscale screenshot, and colour-blindness
/// (Constitution XI). Removing the motion removes redundancy, not information —
/// which is what makes [ContourOverlay]'s reduced-motion path safe.
enum PcContourState {
  /// Edge found but not yet stable — hold still. Marching dashes.
  scanning,

  /// Edge is stable — shoot now. Solid, brighter, glowing, one pulse on entry.
  locked,

  /// Complex edge (fur, hair, glass) — usable, may want a manual pass.
  /// Amber dots. This is a hint and must never read as failure (FR-018).
  review,
}

/// Draws the subject's traced outline over whatever is behind it.
///
/// ## Two strokes, always
///
/// A 6px near-black halo goes down first, then a 2.5px mint core on top (3px
/// when locked). This is not decoration and it is not negotiable: the camera
/// can point at a white paper sweep, warm cardboard, black leather or a backlit
/// window, and a single-colour line vanishes against one of them. The
/// dark-under-bright pair survives all four (FR-016).
///
/// ## What this widget does not do
///
/// It does not touch the camera. [path] arrives from the caller in normalized
/// 0.0–1.0 coordinates and is scaled to the paint size here. Wiring it to a
/// live segmentation stream is Spec #003's job (FR-019) — building it here
/// against a supplied outline is what lets it be golden-tested at all.
class ContourOverlay extends StatefulWidget {
  const ContourOverlay({
    required this.path,
    required this.state,
    this.showFramingTicks = false,
    super.key,
  });

  /// The outline, in normalized 0.0–1.0 coordinates relative to the paint area.
  ///
  /// Normalized rather than pixel coordinates because the platform channel
  /// contract specifies ratios — a mask computed on a downsampled frame has to
  /// land correctly on a preview of any size.
  ///
  /// A null or empty path paints nothing and does not throw. A stray mark on
  /// the viewfinder is worse than no mark.
  final Path? path;

  final PcContourState state;

  /// Corner reticle ticks bracketing the subject.
  final bool showFramingTicks;

  @override
  State<ContourOverlay> createState() => _ContourOverlayState();
}

class _ContourOverlayState extends State<ContourOverlay>
    with TickerProviderStateMixin {
  /// Drives the dash march and the inner sweep (`pc-march`, `pc-sweep`).
  late final AnimationController _march;

  /// Fires once on entering [PcContourState.locked] (`pc-lock-pulse`).
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _march = AnimationController(vsync: this);
    _pulse = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final PcContour contour = context.pcContour;
    _march.duration = contour.march;
    _pulse.duration = context.pcMotion.slow;
    _syncAnimations();
  }

  @override
  void didUpdateWidget(ContourOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      // scanning → locked is the only transition that fires the pulse.
      if (widget.state == PcContourState.locked &&
          oldWidget.state == PcContourState.scanning &&
          !context.pcReduceMotion) {
        _pulse.forward(from: 0);
      }
      _syncAnimations();
    }
  }

  void _syncAnimations() {
    // Reduced motion stops every loop and pulse (FR-027a). The dash patterns
    // stay, so the three states remain tellable apart — that is the whole
    // reason this is safe to switch off.
    if (context.pcReduceMotion) {
      _march.stop();
      _pulse.stop();
      return;
    }
    if (widget.state == PcContourState.scanning) {
      if (!_march.isAnimating) _march.repeat();
    } else {
      _march.stop();
    }
  }

  @override
  void dispose() {
    _march.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Path? path = widget.path;
    if (path == null || path.getBounds().isEmpty) {
      return const SizedBox.expand();
    }

    // RepaintBoundary matters here more than anywhere else in the product:
    // in Spec #003 this repaints over a live camera feed, and without it the
    // whole subtree would repaint with every dash frame (Principle V).
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_march, _pulse]),
        builder: (BuildContext context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ContourPainter(
            path: path,
            state: widget.state,
            contour: context.pcContour,
            marchProgress: _march.value,
            pulseProgress: _pulse.value,
            showFramingTicks: widget.showFramingTicks,
            reduceMotion: context.pcReduceMotion,
          ),
        ),
      ),
    );
  }
}

class _ContourPainter extends CustomPainter {
  const _ContourPainter({
    required this.path,
    required this.state,
    required this.contour,
    required this.marchProgress,
    required this.pulseProgress,
    required this.showFramingTicks,
    required this.reduceMotion,
  });

  final Path path;
  final PcContourState state;
  final PcContour contour;
  final double marchProgress;
  final double pulseProgress;
  final bool showFramingTicks;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final Path scaled = path.transform(
      Matrix4.diagonal3Values(size.width, size.height, 1).storage,
    );

    _paintFill(canvas, scaled);

    final Path stroke = _strokePath(scaled);
    _paintHalo(canvas, stroke);
    _paintCore(canvas, stroke);

    if (state == PcContourState.locked && pulseProgress > 0) {
      _paintLockPulse(canvas, scaled);
    }
    if (showFramingTicks) {
      _paintFramingTicks(canvas, scaled.getBounds());
    }
  }

  /// Applies the state's dash pattern. Locked is solid, so it returns the path
  /// untouched rather than dashing with an infinite dash.
  Path _strokePath(Path scaled) {
    final (double, double)? pattern = switch (state) {
      PcContourState.scanning => contour.dashScan,
      PcContourState.review => contour.dashReview,
      PcContourState.locked => null,
    };
    if (pattern == null) return scaled;

    final (double dash, double gap) = pattern;
    // Only the scanning state marches. Review is dotted but still.
    final double phase = state == PcContourState.scanning && !reduceMotion
        ? marchProgress * (dash + gap)
        : 0;
    return _dash(scaled, dash, gap, phase);
  }

  /// Walks each subpath and keeps alternating runs. Flutter's `Paint` has no
  /// dash property, and owning the walk means the phase — the thing that
  /// animates — is directly controllable (research R11).
  static Path _dash(Path source, double dash, double gap, double phase) {
    final Path out = Path();
    final double period = dash + gap;
    if (period <= 0) return source;

    for (final PathMetric metric in source.computeMetrics()) {
      double distance = -(phase % period);
      while (distance < metric.length) {
        final double start = distance < 0 ? 0 : distance;
        final double end = distance + dash;
        if (end > 0 && start < metric.length) {
          out.addPath(
            metric.extractPath(start, end.clamp(0, metric.length)),
            Offset.zero,
          );
        }
        distance += period;
      }
    }
    return out;
  }

  void _paintFill(Canvas canvas, Path scaled) {
    final Color? fill = switch (state) {
      PcContourState.scanning => contour.fillScan,
      PcContourState.locked => contour.fillLock,
      PcContourState.review => null,
    };
    if (fill == null) return;
    canvas.drawPath(scaled, Paint()..color = fill);
  }

  /// The dark stroke that goes down first. Without it the mint core disappears
  /// against a white sweep; without the core the halo disappears against black
  /// leather. Neither survives alone.
  void _paintHalo(Canvas canvas, Path stroke) {
    canvas.drawPath(
      stroke,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = contour.wHalo
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = contour.halo,
    );
  }

  void _paintCore(Canvas canvas, Path stroke) {
    final (Color colour, double width) = switch (state) {
      PcContourState.scanning => (contour.core, contour.wCore),
      PcContourState.locked => (contour.coreLock, contour.wCoreLock),
      PcContourState.review => (contour.review, contour.wCore),
    };

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = colour;

    // A BoxShadow cannot follow an arbitrary path, so the CSS `drop-shadow`
    // glow becomes a MaskFilter on a second pass (research R9).
    if (state != PcContourState.scanning) {
      canvas.drawPath(
        stroke,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = state == PcContourState.locked
              ? contour.glowColor
              : contour.glowReviewColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, contour.glowSigma),
      );
    }

    canvas.drawPath(stroke, paint);
  }

  void _paintLockPulse(Canvas canvas, Path scaled) {
    // One 380ms ring that fades as it expands slightly — the confirmation the
    // user feels under their thumb as the shutter ring turns mint.
    final double t = pulseProgress;
    final Rect bounds = scaled.getBounds();
    canvas.save();
    canvas.translate(bounds.center.dx, bounds.center.dy);
    canvas.scale(1 + 0.015 * t);
    canvas.translate(-bounds.center.dx, -bounds.center.dy);
    canvas.drawPath(
      scaled,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = contour.wCoreLock
        ..color = contour.coreLock.withValues(alpha: 0.35 * (1 - t)),
    );
    canvas.restore();
  }

  void _paintFramingTicks(Canvas canvas, Rect b) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = contour.tickWidth
      ..strokeCap = StrokeCap.round
      ..color = contour.core;
    final double t = contour.tick;

    for (final (Offset corner, double dx, double dy)
        in <(Offset, double, double)>[
          (b.topLeft, 1, 1),
          (b.topRight, -1, 1),
          (b.bottomLeft, 1, -1),
          (b.bottomRight, -1, -1),
        ]) {
      canvas.drawLine(corner, corner.translate(dx * t, 0), paint);
      canvas.drawLine(corner, corner.translate(0, dy * t), paint);
    }
  }

  @override
  bool shouldRepaint(_ContourPainter old) =>
      old.path != path ||
      old.state != state ||
      old.marchProgress != marchProgress ||
      old.pulseProgress != pulseProgress ||
      old.showFramingTicks != showFramingTicks ||
      old.reduceMotion != reduceMotion;
}
