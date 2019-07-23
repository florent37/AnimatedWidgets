# animated_widgets

Easily add animations on your screen with AnimatedWidgets.

Optimized for MVVM using Bloc, updating the `enabled` value of the widget will forward or reverse the animation.

Available widgets : `TranslationAnimatedWidget`, `OpacityAnimatedWidget`, `RotationAnimatedWidget`, `ScaleAnimatedWidget`, `SizeAnimatedWidget`

For example : add a TranslationAnimatedWidget on a button, then activate it to display it !

```dart
TranslationAnimatedWidget(
    enabled: this.displayMyWidget, //update this boolean to forward/reverse the animation
    values: [
        Offset(0, 200), // disabled value value
        Offset(0, 250), //intermediate value
        Offset(0, 0) //enabled value
    ],
    child: /* your widget */
),
```

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/translation.gif)](https://www.github.com/florent37/AnimatedWidgets)


or using a `tween constructor`

```dart
RotationAnimatedWidget.tween(
    enabled: this.displayMyWidget, //update this boolean to forward/reverse the animation
    rotationDisabled: Rotation.degrees(z: 0),
    rotationEnabled: Rotation.degrees(z: 90),
    child: /* your widget */
),
```

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/rotation.gif)](https://www.github.com/florent37/AnimatedWidgets)

# Compose

Don't hesitate to compose them

```dart
TranslationAnimatedWidget.tween(
    enabled: this.displayMyWidget,
    translationDisabled: Offset(0, 200),
    translationEnabled: Offset(0, 0),
    child:
        OpacityAnimatedWidget.tween(
        enabled: this.displayMyWidget,
        opacityDisabled: 0,
        opacityEnabled: 1,
        child: /* your widget */
    ),
),
```

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/compose.gif)](https://www.github.com/florent37/AnimatedWidgets)

# Opacity

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/opacity.gif)](https://www.github.com/florent37/AnimatedWidgets)

Example using a `Stateful Widget`

```dart
class _StatefulScreenState extends State<StatefulScreen> {

  // will determine if the opacity animation is launched
  bool _display = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[


          //wrap your widget with OpacityAnimatedWidget
          OpacityAnimatedWidget.tween(
            opacityEnabled: 1, //define start value
            opacityDisabled: 0, //and end value
            enabled: _display, //bind with the boolean
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
              _display ? "hide logo" : "display logo",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {

                //will fire the animation
                _display = !_display;

              });
            },
          )
        ],
      ),
    );
  }
}
```

# Translation

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/translation.gif)](https://www.github.com/florent37/AnimatedWidgets)

Example using `bloc` pattern

```dart
class FirstScreenBloc extends Bloc {
  final _viewState = BehaviorSubject<FirstScreenViewState>.seeded(FirstScreenViewState());
  Observable<FirstScreenViewState> get viewState => _viewState;

  void onClicked() {
    _viewState.add(FirstScreenViewState(buttonVisible: true));
  }

  void onDismissClicked() {
    _viewState.add(FirstScreenViewState(buttonVisible: false));
  }

  @override
  void dispose() {
    _viewState.close();
  }
}

class FirstScreenViewState {
  final bool buttonVisible;

  const FirstScreenViewState({
    this.buttonVisible = false,
  });
}
```

```dart
class FirstScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirstScreenBloc>(context);

    return StreamBuilder<FirstScreenViewState>(
            stream: bloc.viewState,
            builder: (context, snapshot) {

                final viewState = snapshot.data;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildInputButton(onClicked: () {
                      bloc.onClicked();
                    }),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,

                      child: TranslationAnimatedWidget(
                        enabled: viewState.buttonVisible, //will forward/reverse the animation
                        curve: Curves.easeIn,
                        duration: Duration(seconds: 1),
                        values: [
                          Offset(0, 200),
                          Offset(0, -50),
                          Offset(0, 0),
                        ],
                        child: RaisedButton(
                          onPressed: () {
                            bloc.onDismissClicked();
                          },
                          child: Text("Dismiss"),
                        ),

                      ),
                    ),
                  ],
               );
            }
        );
  }
}
```

# Rotation

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/rotation.gif)](https://www.github.com/florent37/AnimatedWidgets)

```dart
RotationAnimatedWidget.tween(
    enabled: enabled,
    rotationDisabled: Rotation.deg(),
    rotationEnabled: Rotation.deg(z: 90, x: 80),
    child: /* your widget */
),

RotationAnimatedWidget.tween(
    enabled: enabled,
    rotation: Rotation.deg(),
    rotationEnabled: Rotation.deg(z: 90, x: 80),
    child: /* your widget */
),
```

# Scale

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/scale.gif)](https://www.github.com/florent37/AnimatedWidgets)

# Size

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/size.gif)](https://www.github.com/florent37/AnimatedWidgets)

# Custom Animated

[![screen](https://raw.githubusercontent.com/florent37/AnimatedWidgets/master/medias/custom.gif)](https://www.github.com/florent37/AnimatedWidgets)

## Getting Started with Flutter

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
