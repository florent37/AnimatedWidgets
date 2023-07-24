import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class StatefulScreen extends StatefulWidget {
  @override
  _StatefulScreenState createState() => _StatefulScreenState();
}

class _StatefulScreenState extends State<StatefulScreen> {
  bool _display = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            OpacityAnimatedWidget.tween(
              opacityEnabled: 1,
              opacityDisabled: 0,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 900),
              enabled: _display,
              child: Container(
                height: 200,
                width: 200,
                child: FlutterLogo(
                  style: FlutterLogoStyle.stacked,
                ),
              ),
            ),
            ElevatedButton(
              child: Text(
                _display ? "hide logo" : "display logo",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _display = !_display;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
