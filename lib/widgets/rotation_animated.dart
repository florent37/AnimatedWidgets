import 'dart:math';

import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Rotation {
  final double x;
  final double y;
  final double z;

  const Rotation.radians({this.x = 0, this.y = 0, this.z = 0});
  Rotation.deg({double x = 0, double y = 0, double z = 0}) : this.radians(x: radians(x), y: radians(y), z: radians(z));
}

class RotationAnimatedWidget extends StatefulWidget {
  final List<Rotation> _values;
  final Duration duration;
  final bool enabled;
  final Widget child;
  final Curve curve;
  final Function(bool) animationFinished;

  RotationAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    List<Rotation> values = const [ const Rotation.radians(), const Rotation.radians(x: pi) ],
    this.enabled = true,
    this.animationFinished,
    this.curve = Curves.linear,
    @required this.child,
  }) : this._values = values,
        assert(values.length > 1);

  RotationAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    Rotation rotationEnabled = const Rotation.radians(),
    Rotation rotationDisabled = const Rotation.radians(x: pi),
    bool enabled = true,
    Function(bool) animationFinished,
    Curve curve = Curves.linear,
    @required Widget child,
  }) : this(duration: duration, enabled: enabled, curve: curve, child: child, animationFinished: animationFinished, values: [rotationDisabled, rotationEnabled]);

  List<Rotation> get values => _values;

  @override
  _TranslationAnimatedWidget createState() => _TranslationAnimatedWidget();
}

class _TranslationAnimatedWidget extends State<RotationAnimatedWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationXAnim;
  Animation<double> _rotationYAnim;
  Animation<double> _rotationZAnim;

  @override
  void didUpdateWidget(RotationAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationState();
  }

  void _updateAnimationState() {
    if (widget.enabled) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if(widget.animationFinished != null){
          widget.animationFinished(widget.enabled);
        }
      });

    _rotationXAnim = chainTweens(widget._values.map((it) => it.x).toList()).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
        setState(() {});
      });

    _rotationYAnim = chainTweens(widget._values.map((it) => it.y).toList()).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
        setState(() {});
      });

    _rotationZAnim = chainTweens(widget._values.map((it) => it.z).toList()).animate(
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
