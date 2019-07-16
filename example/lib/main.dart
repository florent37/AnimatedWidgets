import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  enabled = !enabled;
                });
              },
              child: Text("animate"),
            ),
            RotationAnimatedWidget(
              enabled: enabled,
              values: [Rotation.deg(z: 0), Rotation.deg(z: 90)],
              child: SizeAnimatedWidget.tween(
                enabled: enabled,
                sizeDisabled: Size(200, 200),
                sizeEnabled: Size(300, 300),
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
