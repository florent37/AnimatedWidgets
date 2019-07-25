import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OpacityAnimatedWidget extends StatefulWidget {
  final Widget child;
  final List<double> _values;
  final bool enabled;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final Function(bool) animationFinished;

  /// An opacity animation using 2-* values
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// values : list of double (between 1.0 and 0.0) used for the animation,
  ///   - the first : will be the opacityDisabled value
  ///   - intermediate values : intermediate values between opacityDisabled & opacityEnabled
  ///   - the last : will be the opacityEnabled value
  ///
  /// animationFinished : a callback called when the animation is finished
  OpacityAnimatedWidget({
    this.child,
    this.delay = const Duration(),
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 2),
    this.enabled = false,
    this.animationFinished,
    List<double> values = const [0, 1],
  })  : this._values = values,
        assert(values.length > 1);

  /// An opacity animation using 2 values : enabled - disabled
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// opacityDisabled : the default value of the widget (between 1.0 and 0.0)
  /// opacityEnabled : the animated value of the widget (between 1.0 and 0.0)
  ///
  /// animationFinished : a callback called when the animation is finished
  OpacityAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    double opacityEnabled = 1,
    double opacityDisabled = 0,
    bool enabled = true,
    Function(bool) animationFinished,
    Curve curve = Curves.linear,
    @required Widget child,
  }) : this(
            duration: duration,
            enabled: enabled,
            curve: curve,
            child: child,
            animationFinished: animationFinished,
            values: [opacityDisabled, opacityEnabled]);

  List<double> get values => _values;

  @override
  createState() => _State();

  //except the boolean `enabled`
  bool isAnimationEqual(OpacityAnimatedWidget other) =>
      listEquals(values, other.values) &&
      duration == other.duration &&
      curve == other.curve &&
      delay == other.delay;
}

class _State extends State<OpacityAnimatedWidget>
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
  void didUpdateWidget(OpacityAnimatedWidget oldWidget) {
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
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.animationFinished != null) {
            widget.animationFinished(widget.enabled);
          }
        }
      });

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
    return Opacity(
      opacity: _animation.value,
      child: widget.child,
    );
  }
}
