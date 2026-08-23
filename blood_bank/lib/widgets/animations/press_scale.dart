import 'package:flutter/material.dart';

/// Wraps [child] so it slightly scales down on tap-down and springs back
/// on release, giving buttons/cards a tactile, physical feel.
///
/// If [onTap] is null, this widget simply renders [child] without
/// intercepting gestures (so it won't block taps meant for children).
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleAmount;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleAmount = 0.96,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedScale(
      scale: _pressed ? widget.scaleAmount : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: widget.child,
    );

    if (widget.onTap == null) return content;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: content,
    );
  }
}
