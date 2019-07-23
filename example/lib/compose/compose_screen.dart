import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class ComposeScreen extends StatefulWidget {
  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
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
            TranslationAnimatedWidget.tween(
              enabled: this._enabled,
              duration: Duration(milliseconds: 600),
              translationDisabled: Offset(2000, 0),
              translationEnabled: Offset(0, 0),
              child: OpacityAnimatedWidget.tween(
                  enabled: this._enabled,
                  opacityDisabled: 0,
                  opacityEnabled: 1,
                  duration: Duration(milliseconds: 1200),
                  child: Container(
                    height: 200,
                    width: 200,
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                    ),
                  )),
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                _enabled ? "dismiss" : "display",
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
