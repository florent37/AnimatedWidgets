import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class ShakeScreen extends StatefulWidget {
  @override
  _ShakeScreenState createState() => _ShakeScreenState();
}

class _ShakeScreenState extends State<ShakeScreen> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ShakeAnimatedWidget(
              enabled: this._enabled,
              duration: Duration(milliseconds: 1500),
              shakeAngle: Rotation.deg(z: 10),
              curve: Curves.linear,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue)
                ),
                child: FlutterLogo(
                  style: FlutterLogoStyle.stacked,
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                _enabled ? "pause" : "start",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _enabled = !_enabled;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
