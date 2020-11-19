import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TranslationAnimatedWidget extends StatefulWidget {
  final List<Offset> _values;
  final Duration duration;
  final Duration reverseDuration;
  final Duration delay;
  final bool enabled;
  final Curve curve;
  final Curve reverseCurve;
  final Widget child;
  final Function(bool) animationFinished;

  /// An translation animation using 2 values : enabled - disabled
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// translationDisabled : the default value of the widget
  /// translationEnabled : the animated value of the widget
  ///
  /// animationFinished : a callback called when the animation is finished
  TranslationAnimatedWidget.tween({
    Duration duration = const Duration(milliseconds: 500),
    Duration reverseDuration = const Duration(milliseconds: 500),
    Duration delay = const Duration(),
    Offset translationDisabled = const Offset(0, 200),
    Offset translationEnabled = const Offset(0, 0),
    bool enabled = true,
    Function(bool) animationFinished,
    Curve curve = Curves.linear,
    Curve reverseCurve = Curves.linear,
    @required Widget child,
  }) : this(
          duration: duration,
          reverseDuration: reverseDuration,
          enabled: enabled,
          curve: curve,
          reverseCurve: reverseCurve,
          delay: delay,
          child: child,
          animationFinished: animationFinished,
          values: [translationDisabled, translationEnabled],
        );

  /// An translation animation using 2-* values
  ///
  /// duration : the duration of the animation, including intermediate values
  /// delay : the delay before the animation starts
  /// enabled : determine if the animation is stopped or fired
  /// curve : An easing curve, see [Curve]
  ///
  /// values : list of [Offset] used for the animation,
  ///   - the first : will be the translationDisabled value
  ///   - intermediate values : intermediate values between translationDisabled & translationEnabled
  ///   - the last : will be the translationEnabled value
  ///
  /// animationFinished : a callback called when the animation is finished
  TranslationAnimatedWidget({
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 500),
    this.delay = const Duration(),
    List<Offset> values = const [const Offset(0, 0), const Offset(0, 200)],
    this.enabled = true,
    this.curve = Curves.linear,
    this.reverseCurve = Curves.linear,
    this.animationFinished,
    @required this.child,
  })  : this._values = values,
        assert(values.length > 1);

  List<Offset> get values => _values;

  @override
  createState() => _State();

  //except the boolean `enabled`
  bool isAnimationEqual(TranslationAnimatedWidget other) =>
      listEquals(values, other.values) && duration == other.duration && curve == other.curve && delay == other.delay;
}

class _State extends State<TranslationAnimatedWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _translationXAnim;
  Animation<double> _translationYAnim;

  @override
  void didUpdateWidget(TranslationAnimatedWidget oldWidget) {
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
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    )..addStatusListener((status) {
        if (widget.animationFinished != null) {
          widget.animationFinished(widget.enabled);
        }
      });

    _translationXAnim = chainTweens(
      widget.values.map((it) => it.dx).toList(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
    )..addListener(() {
        setState(() {});
      });

    _translationYAnim = chainTweens(
      widget.values.map((it) => it.dy).toList(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ),
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
