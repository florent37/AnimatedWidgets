import 'package:flutter/material.dart';

typedef CustomBuilder = Widget Function(BuildContext context, double percent);

class CustomAnimatedWidget extends StatefulWidget {
  final Duration duration;
  final CustomBuilder builder;
  final bool enabled;
  final Widget child;
  final Curve curve;
  final Function(bool) animationFinished;

  CustomAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    @required this.builder,
    this.enabled = true,
    this.animationFinished,
    this.curve = Curves.linear,
    @required this.child,
  });

  @override
  createState() => _CustomAnimatedWidget();
}

class _CustomAnimatedWidget extends State<CustomAnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _customAnim;

  @override
  void didUpdateWidget(CustomAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationState();
  }

  void _updateAnimationState() {
    if (widget.enabled ?? false) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (widget.animationFinished != null) {
              widget.animationFinished(widget.enabled);
            }
          });

    _customAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
        setState(() {});
      });

    _updateAnimationState();
  }

  @override
  void initState() {
    _createAnimations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var percent = _customAnim.value;
    return widget.builder(context, percent);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
