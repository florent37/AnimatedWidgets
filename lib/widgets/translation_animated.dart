import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/material.dart';

class TranslationAnimatedWidget extends StatefulWidget {
  final List<Offset> _values;
  final Duration duration;
  final bool enabled;
  final Curve curve;
  final Widget child;
  final Function(bool) animationFinished;

  TranslationAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    List<Offset> values = const [const Offset(0, 0), const Offset(0, 200)],
    this.enabled = true,
    this.curve = Curves.linear,
    this.animationFinished,
    @required this.child,
  })  : this._values = values,
        assert(values.length > 1);

  TranslationAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    Offset translationEnabled = const Offset(0, 0),
    Offset translationDisabled = const Offset(0, 200),
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
            values: [translationDisabled, translationEnabled]);

  List<Offset> get values => _values;

  @override
  createState() => _State();
}

class _State extends State<TranslationAnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _translationXAnim;
  Animation<double> _translationYAnim;

  @override
  void didUpdateWidget(TranslationAnimatedWidget oldWidget) {
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
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (widget.animationFinished != null) {
          widget.animationFinished(widget.enabled);
        }
      });

    _translationXAnim = chainTweens(
      widget.values.map((it) => it.dx).toList(),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    )..addListener(() {
        setState(() {});
      });

    _translationYAnim = chainTweens(
      widget.values.map((it) => it.dy).toList(),
    ).animate(
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
    return Transform.translate(
      offset: Offset(_translationXAnim.value, _translationYAnim.value),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
