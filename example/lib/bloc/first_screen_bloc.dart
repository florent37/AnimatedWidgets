import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

export 'package:bloc_provider/bloc_provider.dart';

class FirstScreenViewState {
  final bool buttonVisible;

  const FirstScreenViewState({
    this.buttonVisible = false,
  });
}

class FirstScreenBloc extends Bloc {
  final _viewState = BehaviorSubject<FirstScreenViewState>.seeded(FirstScreenViewState());
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
