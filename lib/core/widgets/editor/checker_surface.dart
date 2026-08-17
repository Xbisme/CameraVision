import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

/// Which checkerboard pair to paint.
enum PcCheckerVariant {
  /// Default — any cutout previewed at size. The Photoshop/Figma values, which
  /// are already in sellers' eyes from other tools.
  light,

  /// Grid thumbnails only, where a small white patch surrounded by the ink
  /// shell glares.
  dark,
}

/// The transparency surface a cutout sits on.
///
/// The design explicitly refused to redesign this convention: inventing a new
/// symbol for transparency would be a net loss, because this one is already
/// understood. So the values are not adjustable and the variant rule is fixed
/// (FR-022a).
class CheckerSurface extends StatelessWidget {
  const CheckerSurface({
    required this.child,
    this.variant = PcCheckerVariant.light,
    super.key,
  });

  final Widget child;
  final PcCheckerVariant variant;

  @override
  Widget build(BuildContext context) {
    final (Color a, Color b) = switch (variant) {
      PcCheckerVariant.light => context.pcContour.checkerLight,
      PcCheckerVariant.dark => context.pcContour.checkerDark,
    };
    return CustomPaint(
      painter: _CheckerPainter(a: a, b: b, tile: context.pcContour.checkerSize),
      child: child,
    );
  }
}

class _CheckerPainter extends CustomPainter {
  const _CheckerPainter({required this.a, required this.b, required this.tile});

  final Color a;
  final Color b;

  /// The full repeating tile. It contains four quadrants, so each square is
  /// half this — 8px for the design's 16px tile.
  final double tile;

  @override
  void paint(Canvas canvas, Size size) {
    final double half = tile / 2;
    canvas.drawRect(Offset.zero & size, Paint()..color = a);
    final Paint alt = Paint()..color = b;
    for (double y = 0; y < size.height; y += half) {
      for (double x = 0; x < size.width; x += half) {
        final bool odd = ((x / half).floor() + (y / half).floor()).isOdd;
        if (odd) canvas.drawRect(Rect.fromLTWH(x, y, half, half), alt);
      }
    }
  }

  @override
  bool shouldRepaint(_CheckerPainter old) =>
      old.a != a || old.b != b || old.tile != tile;
}
