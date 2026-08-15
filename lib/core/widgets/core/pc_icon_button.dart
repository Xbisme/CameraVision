import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import 'pc_icon.dart';

enum PcIconButtonVariant {
  /// Blurred glass. Permitted **only** over the camera feed or a photo; on an
  /// opaque screen it is a solid or quiet button instead (FR-011).
  glass,
  solid,
  quiet,
}

enum PcIconButtonSize {
  /// 44 target, 22 glyph.
  md,

  /// 56 target, 26 glyph.
  lg,
}

/// An icon-only control.
///
/// [semanticsLabel] is **required**, not optional: an icon-only button with no
/// accessible name is unusable with a screen reader, and Principle XI forbids
/// it. Making it required means one cannot be built by accident.
class PcIconButton extends StatefulWidget {
  const PcIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    this.variant = PcIconButtonVariant.quiet,
    this.size = PcIconButtonSize.md,
    this.tint,
    super.key,
  });

  final PcIconData icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final PcIconButtonVariant variant;
  final PcIconButtonSize size;
  final Color? tint;

  @override
  State<PcIconButton> createState() => _PcIconButtonState();
}

class _PcIconButtonState extends State<PcIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    final double target = switch (widget.size) {
      PcIconButtonSize.md => context.pcSpacing.touchMin,
      PcIconButtonSize.lg => context.pcSpacing.touchComfortable,
    };
    final double glyph = switch (widget.size) {
      PcIconButtonSize.md => context.pcSpacing.iconChrome,
      PcIconButtonSize.lg => context.pcSpacing.iconLarge,
    };
    final (Duration duration, Curve curve) = context.pcMotion.tPress;

    Widget content = Container(
      width: target,
      height: target,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: switch (widget.variant) {
          PcIconButtonVariant.glass => context.pcColors.bgGlass,
          PcIconButtonVariant.solid => context.pcColors.bgSurfaceRaised,
          PcIconButtonVariant.quiet => null,
        },
        shape: const CircleBorder(),
      ),
      child: PcIcon(
        widget.icon,
        size: glyph,
        color: enabled
            ? (widget.tint ?? context.pcColors.textPrimary)
            : context.pcColors.textMuted,
      ),
    );

    if (widget.variant == PcIconButtonVariant.glass) {
      content = ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: context.pcElevation.blurChromeSigma,
            sigmaY: context.pcElevation.blurChromeSigma,
          ),
          child: content,
        ),
      );
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? context.pcMotion.pressScale : 1,
          duration: context.pcReduceMotion ? Duration.zero : duration,
          curve: curve,
          child: content,
        ),
      ),
    );
  }
}
