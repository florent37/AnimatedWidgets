import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/material.dart';

class ShakeAnimatedWidget extends StatefulWidget {
  final Duration shakeDuration;
  final double shakeAngle;
  final bool enabled;
  final Widget child;
  final Curve curve;

  const ShakeAnimatedWidget({
    this.shakeDuration = const Duration(milliseconds: 2000),
    this.shakeAngle = 0.015,
    this.curve = Curves.linear,
    this.enabled = true,
    @required this.child,
  });

  @override
  _ShakeAnimatedWidgetState createState() => _ShakeAnimatedWidgetState();
}

class _ShakeAnimatedWidgetState extends State<ShakeAnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void didUpdateWidget(ShakeAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _animationController.repeat();
    } else {
      _createAnimations();
    }
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController =
        AnimationController(duration: widget.shakeDuration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.forward();
            }
          });
  }

  @override
  void initState() {
    _createAnimations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: chainTweens([0.0, widget.shakeAngle, 0.0, -widget.shakeAngle, 0.0])
          .animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve),
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
