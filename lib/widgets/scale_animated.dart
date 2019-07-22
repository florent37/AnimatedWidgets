import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/material.dart';

class ScaleAnimatedWidget extends StatefulWidget {
  final Widget child;
  final List<double> _values;
  final bool enabled;
  final Duration duration;
  final Curve curve;
  final Duration delay;

  ScaleAnimatedWidget({
    this.child,
    this.delay = const Duration(),
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 2),
    this.enabled = false,
    List<double> values = const [0, 1],
  })  : this._values = values,
        assert(values.length > 1);

  ScaleAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    double scaleEnabled = 1,
    double scaleDisabled = 0,
    bool enabled = true,
    Curve curve = Curves.linear,
    @required Widget child,
  }) : this(
            duration: duration,
            enabled: enabled,
            curve: curve,
            child: child,
            values: [scaleDisabled, scaleEnabled]);

  List<double> get values => _values;

  @override
  createState() => _State();
}

class _State extends State<ScaleAnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _createAnimations();
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(ScaleAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationState();
  }

  void _updateAnimationState() async {
    if (widget.enabled ?? false) {
      await Future.delayed(widget.delay);
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = chainTweens(widget.values).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _animation.value,
      child: widget.child,
    );
  }
}
