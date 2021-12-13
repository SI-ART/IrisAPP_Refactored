part of 'station.dart';

mixin _$StationService on _StationService, Store {
  final _$currentScreen = Atom(name: '_StationService.currentScreen');

  @override
  int get currentScreen {
    _$currentScreen.reportRead();
    return super.currentScreen;
  }

  @override
  set currentScreen(int value) {
    _$currentScreen.reportWrite(value, super.currentScreen, () {
      super.currentScreen = value;
    });
  }

  // ignore: non_constant_identifier_names
  final _$_ScreenActionController = ActionController(name: '_StationService');

  @override
  void setScreen(int value) {
    final _$actionInfo = _$_ScreenActionController.startAction(
        name: '_StationService.setScreen');
    try {
      return super.setScreen(value);
    } finally {
      _$_ScreenActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: $currentScreen
    ''';
  }
}
