import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class StatefulScreen extends StatefulWidget {
  @override
  _StatefulScreenState createState() => _StatefulScreenState();
}

class _StatefulScreenState extends State<StatefulScreen> {
  bool _displayImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          OpacityAnimatedWidget.tween(
            opacityEnabled: 1,
            opacityDisabled: 0,
            enabled: _displayImage,
            child: Image.network("https://placekitten.com/g/300/300"),
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text(
              "show this",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _displayImage = !_displayImage;
              });
            },
          )
        ],
      ),
    );
  }
}
