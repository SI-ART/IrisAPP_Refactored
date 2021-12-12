part of 'gateway.dart';

mixin _$GatewayService on _GatewayService, Store {
  final _$currentScreen = Atom(name: '_GatewayService.currentScreen');

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
  final _$_ScreenActionController = ActionController(name: '_GatewayService');

  @override
  void setScreen(int value) {
    final _$actionInfo = _$_ScreenActionController.startAction(
        name: '_GatewayService.setScreen');
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
