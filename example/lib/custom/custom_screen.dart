import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatefulWidget {
  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
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
            CustomAnimatedWidget(
              enabled: this._enabled,
              duration: Duration(seconds: 3),
              curve: Curves.easeOut,
              builder: (context, percent) {
                final int displayedDate = (2018 * percent).floor();
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: Text(
                      "current year : $displayedDate",
                      style: TextStyle(color: Colors.blue),
                    ));
              },
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
