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
        body: MyScreen()
      ),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: RaisedButton(
            onPressed: () {
              setState(() {
                enabled = !enabled;
              });
            },
            child: Text("animate"),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: TranslationAnimatedWidget(
            enabled: enabled,
            values: [Offset(0, 200), Offset(0, 0)],
            child: RaisedButton(
              onPressed: () {},
              child: Text("Dismiss"),
            ),
          ),
        ),
      ],
    );
  }
}

