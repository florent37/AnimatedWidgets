import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class SizeScreen extends StatefulWidget {
  @override
  _SizeScreenState createState() => _SizeScreenState();
}

class _SizeScreenState extends State<SizeScreen> {
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
            SizeAnimatedWidget(
              enabled: this._enabled,
              duration: Duration(milliseconds: 1500),
              values: [Size(100, 100),  Size(100, 150), Size(200, 150), Size(200, 200)],
              curve: Curves.linear,
              child: Container(
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
