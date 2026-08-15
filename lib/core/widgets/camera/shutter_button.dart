import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';

/// The shutter.
///
/// 80px visible disc inside a 104px hit target, with nothing tappable within
/// 12px of it (FR-023). Those numbers are the design's, and they are hard: the
/// button is pressed hundreds of times in a batch session, one-handed, without
/// looking.
///
/// **The ring is a status light.** It is white while scanning and turns mint
/// with a glow the instant the contour locks — the confirmation happens under
/// the user's thumb, so they never have to look away from the product to know
/// the cutout will work.
///
/// [semanticsLabel] is **required**: this renders no text at all, and an
/// unnamed button is unusable with a screen reader (Principle XI). It is also
/// the most-pressed control in the product.
class ShutterButton extends StatefulWidget {
  const ShutterButton({
    required this.onPressed,
    required this.semanticsLabel,
    this.contourLocked = false,
    this.shotCount,
    super.key,
  });

  final VoidCallback? onPressed;
  final String semanticsLabel;
  final bool contourLocked;

  /// Batch mode only: the running shot count, shown in mono so the user never
  /// has to leave the viewfinder to check it.
  final int? shotCount;

  @override
  State<ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    final bool locked = widget.contourLocked;
    final (Duration duration, Curve curve) = context.pcMotion.tPress;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticsLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: SizedBox(
          // The hit target is larger than the disc, deliberately.
          width: context.pcSpacing.touchShutterHit,
          height: context.pcSpacing.touchShutterHit,
          child: Center(
            child: AnimatedScale(
              scale: _pressed ? context.pcMotion.pressScaleShutter : 1,
              duration: context.pcReduceMotion ? Duration.zero : duration,
              curve: curve,
              child: AnimatedContainer(
                duration: context.pcReduceMotion
                    ? Duration.zero
                    : context.pcMotion.lock,
                curve: curve,
                width: context.pcSpacing.touchShutter,
                height: context.pcSpacing.touchShutter,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: context.pcColors.bgGlass,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: locked
                          ? context.pcColors.accent
                          : context.pcColors.white,
                      width: context.pcSpacing.strokeIcon,
                    ),
                  ),
                  shadows: locked ? context.pcElevation.glowAccent : null,
                ),
                child: widget.shotCount == null
                    ? null
                    : Text(
                        widget.shotCount!.toString().padLeft(2, '0'),
                        style: context.pcTypography.readout.copyWith(
                          color: context.pcColors.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
