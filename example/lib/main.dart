import 'package:flutter/material.dart';

import 'bloc/first_screen.dart';
import 'complete/complete_screen.dart';
import 'compose/compose_screen.dart';
import 'custom/custom_screen.dart';
import 'rotation/rotation_screen.dart';
import 'scale/scale_screen.dart';
import 'shake/shake_screen.dart';
import 'size/size_screen.dart';
import 'statefull/statefull_screen.dart';

void main() => runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("With Bloc"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FirstScreen()));
            },
          ),
          ListTile(
            title: Text("Stateless"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StatefulScreen()));
            },
          ),
          ListTile(
            title: Text("Rotation"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RotationScreen()));
            },
          ),
          ListTile(
            title: Text("Compose"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ComposeScreen()));
            },
          ),
          ListTile(
            title: Text("Scale"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ScaleScreen()));
            },
          ),
          ListTile(
            title: Text("Size"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SizeScreen()));
            },
          ),
          ListTile(
            title: Text("Custom"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CustomScreen()));
            },
          ),
          ListTile(
            title: Text("Shake"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ShakeScreen()));
            },
          ),
          ListTile(
            title: Text("Complete"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompleteScreen()));
            },
          )
        ],
      ),
    );
  }
}
