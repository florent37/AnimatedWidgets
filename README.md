# animated_widgets

Easily add animations on your screen with AnimatedWidgets.
Add always your animated widgets in your component's tree, then activate them when you want to activate the animations.

For example : add a TranslationAnimatedWidget on a button, then activate it to display it !

```dart
TranslationAnimatedWidget(
    enabled: enabled,
    values: [
        Offset(0, 200),  //enabled value
        Offset(0, 250),  //intermediate value
        Offset(0, 0) // disabled value value
    ],
    child: /* your widget */
),
```

# Opacity

Example with a Stateful Widget

```
class _StatefulScreenState extends State<StatefulScreen> {

  // will determine if the opacity animation is launched
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


          //wrap your widget with OpacityAnimatedWidget
          OpacityAnimatedWidget.tween(
            opacityEnabled: 1, //define start value
            opacityDisabled: 0, //and end value
            enabled: _displayImage, //bind with the boolean
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

                //will fire the animation
                _displayImage = !_displayImage;

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

Example with bloc pattern

```
class FirstScreenBloc extends Bloc {
  final _viewState = BehaviorSubject<FirstScreenViewState>();
  Observable<FirstScreenViewState> get viewState => _viewState;

  FirstScreenBloc() {
    _viewState.add(FirstScreenViewState(buttonVisible: false));
  }

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
    this.buttonVisible,
  });
}
```

```
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
                        enabled: viewState.buttonVisible,
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

# Scale

# Size

# Custom Animated



```dart
class _MyScreenState extends State<MyScreen> {

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: TapScaleAnimated(
            scale: 0.3,
            onTap: () {
              setState(() {
                enabled = !enabled;
              });
            },
            child: Container(height:100, width: 100, color: Colors.blue, child: Text("animate")),
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
```

## Getting Started with Flutter

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
