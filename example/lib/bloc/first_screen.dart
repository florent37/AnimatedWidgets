import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';

import 'first_screen_bloc.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FirstScreenBloc>(
      creator: (_context, _bag) => FirstScreenBloc(),
      child: FirstScreenView(),
    );
  }
}

class FirstScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirstScreenBloc>(context);

    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<FirstScreenViewState>(
            stream: bloc.viewState,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
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
              } else {
                return Container();
              }
            }));
  }

  Widget _buildInputButton({Function onClicked}) {
    return Center(
      child: TapScaleAnimated(
        scale: 0.3,
        onTap: () {
          onClicked();
        },
        child: Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            color: Colors.blue,
            child: Text(
              "animate",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
