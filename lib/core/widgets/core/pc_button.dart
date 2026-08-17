import 'package:flutter/material.dart';

import '../../theme/pc_context.dart';
import 'pc_icon.dart';

/// Which job a button is doing, and therefore which colour it may spend.
///
/// The semantic-colour law is not styling preference (FR-010): mint is the
/// **only** signal colour, so at most one [primary] may appear on a screen. A
/// second one means neither is primary.
enum PcButtonVariant {
  /// The one primary action on a screen. Mint.
  primary,

  /// Everything else. Raised surface with a rim.
  secondary,

  /// Tertiary, typically inside a sheet. Transparent with a hairline.
  quiet,

  /// Destructive only — and never inside the bottom action band (FR-024).
  danger,
}

enum PcButtonSize {
  /// 56 — the comfortable touch target.
  comfortable,

  /// 44 — the hard minimum. Nothing smaller exists.
  standard,
}

/// The product's button.
///
/// Labels are 1–3 words: they are read at arm's length while the user is
/// holding a product in the other hand.
class PcButton extends StatefulWidget {
  const PcButton({
    required this.label,
    required this.onPressed,
    this.variant = PcButtonVariant.secondary,
    this.size = PcButtonSize.comfortable,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  /// Display text, supplied by the caller. This widget never reads the
  /// translation catalogue itself (FR-021).
  final String label;

  /// A null callback disables the button.
  final VoidCallback? onPressed;

  final PcButtonVariant variant;
  final PcButtonSize size;
  final PcIconData? icon;
  final bool isLoading;
  final bool expand;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  State<PcButton> createState() => _PcButtonState();
}

class _PcButtonState extends State<PcButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    assert(
      !_isInsideThumbBand(context) || widget.variant != PcButtonVariant.danger,
      'A danger button may not live in the bottom action band. That band holds '
      'every primary action and is pressed without looking; putting a '
      'destructive action there is how a batch gets deleted by accident '
      '(FR-024).',
    );

    final double height = switch (widget.size) {
      PcButtonSize.comfortable => context.pcSpacing.touchComfortable,
      PcButtonSize.standard => context.pcSpacing.touchMin,
    };

    final (Color? bg, Color fg, BorderSide? border) = _palette(context);
    final (Duration duration, Curve curve) = context.pcMotion.tPress;

    return Semantics(
      button: true,
      enabled: widget._enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: widget._enabled
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapUp: widget._enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        onTapCancel: widget._enabled
            ? () => setState(() => _pressed = false)
            : null,
        onTap: widget._enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? context.pcMotion.pressScale : 1,
          duration: context.pcReduceMotion ? Duration.zero : duration,
          curve: curve,
          child: AnimatedContainer(
            duration: context.pcReduceMotion ? Duration.zero : duration,
            curve: curve,
            height: height,
            width: widget.expand ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: context.pcSpacing.sp7),
            decoration: ShapeDecoration(
              color: widget._enabled ? bg : bg?.withValues(alpha: 0.38),
              shape: context.pcRadius.pill.copyWith(
                side: border ?? BorderSide.none,
              ),
            ),
            child: Row(
              mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.isLoading)
                  _Spinner(colour: fg)
                else if (widget.icon != null)
                  PcIcon.inline(widget.icon!, color: fg),
                if (widget.isLoading || widget.icon != null)
                  SizedBox(width: context.pcSpacing.sp4),
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pcTypography.button.copyWith(
                      color: widget._enabled ? fg : fg.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (Color?, Color, BorderSide?) _palette(BuildContext context) {
    final PcColorsShorthand c = PcColorsShorthand(context);
    return switch (widget.variant) {
      PcButtonVariant.primary => (
        _pressed ? c.accentPress : c.accent,
        c.textOnAccent,
        null,
      ),
      PcButtonVariant.secondary => (
        c.bgSurfaceRaised,
        c.textPrimary,
        context.pcElevation.rim,
      ),
      // Quiet has no fill at all. `null` rather than a transparent colour so
      // the widget layer stays free of raw literals (Principle VII).
      PcButtonVariant.quiet => (
        null,
        c.textSecondary,
        BorderSide(color: c.borderHairline),
      ),
      PcButtonVariant.danger => (c.danger, c.textPrimary, null),
    };
  }

  /// Walks up for a [ThumbBandScope]. The band publishes one so a button can
  /// refuse to be destructive inside it without either widget importing the
  /// other's file.
  bool _isInsideThumbBand(BuildContext context) =>
      ThumbBandScope.maybeOf(context) != null;
}

/// Published by the bottom action band so its children can tell they are in it.
class ThumbBandScope extends InheritedWidget {
  const ThumbBandScope({required super.child, super.key});

  static ThumbBandScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThumbBandScope>();

  @override
  bool updateShouldNotify(ThumbBandScope oldWidget) => false;
}

/// Convenience so the palette switch reads as a table rather than as seven
/// repetitions of `context.pcColors`.
class PcColorsShorthand {
  PcColorsShorthand(BuildContext context)
    : accent = context.pcColors.accent,
      accentPress = context.pcColors.accentPress,
      textOnAccent = context.pcColors.textOnAccent,
      textPrimary = context.pcColors.textPrimary,
      textSecondary = context.pcColors.textSecondary,
      bgSurfaceRaised = context.pcColors.bgSurfaceRaised,
      borderHairline = context.pcColors.borderHairline,
      danger = context.pcColors.danger;

  final Color accent;
  final Color accentPress;
  final Color textOnAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color bgSurfaceRaised;
  final Color borderHairline;
  final Color danger;
}

class _Spinner extends StatelessWidget {
  const _Spinner({required this.colour});

  final Color colour;

  @override
  Widget build(BuildContext context) {
    final double d = context.pcSpacing.iconInline;
    return SizedBox(
      width: d,
      height: d,
      child: CircularProgressIndicator(
        strokeWidth: context.pcSpacing.strokeMedium,
        color: colour,
      ),
    );
  }
}
