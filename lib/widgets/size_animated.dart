import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SizeAnimatedWidget extends StatefulWidget {
  final Widget child;
  final List<Size> _values;
  final bool enabled;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final Function(bool) animationFinished;

  /// A size animation using 2-* values
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// values : list of double (between 1.0 and 0.0) used for the animation,
  ///   - the first : will be the sizeDisabled value
  ///   - intermediate values : intermediate values between sizeDisabled & sizeEnabled
  ///   - the last : will be the sizeEnabled value
  ///
  /// animationFinished : a callback called when the animation is finished
  SizeAnimatedWidget({
    this.child,
    this.delay = const Duration(),
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 2),
    this.enabled = false,
    this.animationFinished,
    List<Size> values = const [Size(0, 0), Size(100, 0)],
  })  : this._values = values,
        assert(values.length > 1);

  /// An size animation using 2 values : enabled - disabled
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// sizeDisabled : the default value of the widget
  /// sizeEnabled : the animated value of the widget
  ///
  /// animationFinished : a callback called when the animation is finished
  SizeAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = const Duration(milliseconds: 500),
    Size sizeEnabled = const Size(100, 100),
    Size sizeDisabled = const Size(0, 0),
    bool enabled = true,
    Function(bool) animationFinished,
    Curve curve = Curves.linear,
    @required Widget child,
  }) : this(
          duration: duration,
          enabled: enabled,
          curve: curve,
          child: child,
          delay: delay,
          animationFinished: animationFinished,
          values: [sizeDisabled, sizeEnabled],
        );

  List<Size> get values => _values;

  @override
  createState() => _State();

  //except the boolean `enabled`
  bool isAnimationEqual(SizeAnimatedWidget other) =>
      listEquals(values, other.values) &&
      duration == other.duration &&
      curve == other.curve &&
      delay == other.delay;
}

class _State extends State<SizeAnimatedWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animationWidth;
  Animation<double> _animationHeight;

  @override
  void initState() {
    super.initState();
    _createAnimations();
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(SizeAnimatedWidget oldWidget) {
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

    _animationWidth =
        chainTweens(widget.values.map((it) => it.width).toList()).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
            setState(() {});
          });

    _animationHeight =
        chainTweens(widget.values.map((it) => it.height).toList()).animate(
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
    return Container(
      width: _animationWidth.value,
      height: _animationHeight.value,
      child: widget.child,
    );
  }
}
