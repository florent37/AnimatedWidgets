import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class RotationScreen extends StatefulWidget {
  @override
  _RotationScreenState createState() => _RotationScreenState();
}

class _RotationScreenState extends State<RotationScreen> {
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
            RotationAnimatedWidget(
              values: [Rotation.deg(), Rotation.deg(z: 90, x: 80)],
              enabled: _enabled,
              curve: Curves.easeIn,
              child: Container(
                height: 200,
                width: 200,
                child: FlutterLogo(
                  style: FlutterLogoStyle.markOnly,
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                "rotate",
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
