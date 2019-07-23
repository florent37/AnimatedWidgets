import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class ScaleScreen extends StatefulWidget {
  @override
  _ScaleScreenState createState() => _ScaleScreenState();
}

class _ScaleScreenState extends State<ScaleScreen> {
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
            ScaleAnimatedWidget.tween(
              enabled: this._enabled,
              duration: Duration(milliseconds: 600),
              scaleDisabled: 0.5,
              scaleEnabled: 1,
              curve: Curves.linear,
              child: Container(
                height: 200,
                width: 200,
                child: FlutterLogo(
                  style: FlutterLogoStyle.stacked,
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                _enabled ? "reverse" : "forward",
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
