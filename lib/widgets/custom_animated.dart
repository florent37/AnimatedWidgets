import 'package:flutter/material.dart';

typedef CustomBuilder = Widget Function(BuildContext context, double percent);

class CustomAnimatedWidget extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final CustomBuilder builder;
  final bool enabled;
  final Curve curve;
  final Function(bool)? animationFinished;

  /// A custom animation using a builder
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// builder : called at each tick to provide the animated widget, giving the actual percentage (0.0 - 1.0)
  ///
  /// animationFinished : a callback called when the animation is finished
  CustomAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    required this.builder,
    this.enabled = true,
    this.delay = const Duration(),
    this.animationFinished,
    this.curve = Curves.linear,
  });

  @override
  createState() => _CustomAnimatedWidget();

  //except the boolean `enabled`
  bool isAnimationEqual(CustomAnimatedWidget other) =>
      duration == other.duration && curve == other.curve && delay == other.delay;
}

class _CustomAnimatedWidget extends State<CustomAnimatedWidget> with TickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _customAnim;

  @override
  void didUpdateWidget(CustomAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimationEqual(oldWidget)) {
      if (widget.enabled != oldWidget.enabled) {
        _updateAnimationState();
      }
    } else {
      _createAnimations();
      if (widget.enabled != oldWidget.enabled) {
        _updateAnimationState();
      }
    }
  }

  void _updateAnimationState() async {
    if (widget.enabled) {
      await Future.delayed(widget.delay);
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (widget.animationFinished != null) {
          widget.animationFinished!(widget.enabled);
        }
      });

    _customAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: widget.curve),
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
    _animationController!.dispose();
    super.dispose();
  }
}
