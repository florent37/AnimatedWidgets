# animated_widgets_example


```
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
```