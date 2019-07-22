import 'package:animated_widgets/core/chain_tweens.dart';
import 'package:flutter/material.dart';

class TapScaleAnimated extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final double scale;
  final Curve curve;
  final Duration duration;
  final HitTestBehavior behavior;

  TapScaleAnimated(
      {this.child,
      @required this.onTap,
      this.scale = 0.9,
      this.behavior = HitTestBehavior.deferToChild,
      this.duration = const Duration(milliseconds: 240),
      this.curve = Curves.easeIn});

  @override
  createState() => _State();
}

class _State extends State<TapScaleAnimated>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _createAnimations();
  }

  void _createAnimations() {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = chainTweens([1.0, widget.scale]).animate(
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
    return GestureDetector(
      behavior: this.widget.behavior,
      onTapDown: (details) {
        //print("onTapDown");
        _animationController.forward();
      },
      onTapUp: (details) async {
        //print("onTapUp");

        await Future.delayed(Duration(
            milliseconds: (widget.duration.inMilliseconds * 0.9).floor()));
        _animationController.reverse();
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: Transform.scale(
        scale: _animation.value,
        child: widget.child,
      ),
    );
  }
}
