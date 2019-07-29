import 'dart:math';

import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Rotation {
  final double x;
  final double y;
  final double z;

  const Rotation.radians({this.x = 0, this.y = 0, this.z = 0});

  Rotation.deg({double x = 0, double y = 0, double z = 0})
      : this.radians(x: radians(x), y: radians(y), z: radians(z));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rotation &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}

class RotationAnimatedWidget extends StatefulWidget {
  final List<Rotation> _values;
  final Duration duration;
  final Duration delay;
  final bool enabled;
  final Widget child;
  final Curve curve;
  final Function(bool) animationFinished;

  /// An rotation animation using 2-* values : enabled - disabled
  ///
  /// Rotations can be
  /// - in in radians or degrees
  /// - in axis X, Y, Z
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// values : list of [Rotation] (degrees or rad) used for the animation,
  ///   - the first : will be the rotationDisabled value
  ///   - intermediate values : intermediate values between rotationDisabled & rotationEnabled
  ///   - the last : will be the rotationEnabled value
  ///
  /// animationFinished : a callback called when the animation is finished
  RotationAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    List<Rotation> values = const [
      const Rotation.radians(),
      const Rotation.radians(x: pi)
    ],
    this.enabled = true,
    this.delay = const Duration(),
    this.animationFinished,
    this.curve = Curves.linear,
    @required this.child,
  })  : this._values = values,
        assert(values.length > 1);

  /// An rotation animation using 2 values : enabled - disabled
  ///
  /// Rotations can be
  /// - in in radians or degrees
  /// - in axis X, Y, Z
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// rotationDisabled : the default value of the widget (see [Rotation])
  /// rotationEnabled : the animated value of the widget (see [Rotation])
  ///
  /// animationFinished : a callback called when the animation is finished
  RotationAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    Rotation rotationEnabled = const Rotation.radians(),
    Rotation rotationDisabled = const Rotation.radians(x: pi),
    bool enabled = true,
    Duration delay = const Duration(),
    Function(bool) animationFinished,
    Curve curve = Curves.linear,
    @required Widget child,
  }) : this(
            duration: duration,
            enabled: enabled,
            curve: curve,
            delay: delay,
            child: child,
            animationFinished: animationFinished,
            values: [rotationDisabled, rotationEnabled]);

  List<Rotation> get values => _values;

  @override
  createState() => _State();

  //except the boolean `enabled`
  bool isAnimationEqual(RotationAnimatedWidget other) =>
      listEquals(values, other.values) &&
      duration == other.duration &&
      curve == other.curve &&
      delay == other.delay;
}

class _State extends State<RotationAnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationXAnim;
  Animation<double> _rotationYAnim;
  Animation<double> _rotationZAnim;

  @override
  void didUpdateWidget(RotationAnimatedWidget oldWidget) {
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

    _rotationXAnim =
        chainTweens(widget._values.map((it) => it.x).toList()).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
            setState(() {});
          });

    _rotationYAnim =
        chainTweens(widget._values.map((it) => it.y).toList()).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
            setState(() {});
          });

    _rotationZAnim =
        chainTweens(widget._values.map((it) => it.z).toList()).animate(
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
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_rotationXAnim.value)
        ..rotateY(_rotationYAnim.value)
        ..rotateZ(_rotationZAnim.value),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
