part of 'new_gateway_service.dart';

mixin _$NewGatewayService on _NewGatewayService, Store {
  final _$connectionText = Atom(name: '_NewGatewayService.connectionText');
  final _$initScan = Atom(name: '_NewGatewayService.initScan');
  final _$goToChat = Atom(name: '_NewGatewayService.goToChat');

  @override
  String get connectionText {
    _$connectionText.reportRead();
    return super.connectionText;
  }

  @override
  set connectionText(String value) {
    _$connectionText.reportWrite(value, super.connectionText, () {
      super.connectionText = value;
    });
  }

  @override
  bool get initScan {
    _$initScan.reportRead();
    return super.initScan;
  }

  @override
  set initScan(bool value) {
    _$initScan.reportWrite(value, super.initScan, () {
      super.initScan = value;
    });
  }

  @override
  bool get goToChat {
    _$goToChat.reportRead();
    return super.goToChat;
  }

  @override
  set goToChat(bool value) {
    _$goToChat.reportWrite(value, super.goToChat, () {
      super.goToChat = value;
    });
  }

  // ignore: non_constant_identifier_names
  final _$_BlueActionController = ActionController(name: '_NewGatewayService');

  @override
  void connectToDevice(event, deviceName, deviceId) {
    final _$actionInfo = _$_BlueActionController.startAction(
        name: '_NewGatewayService.setScreen');
    try {
      return super.connectToDevice(event, deviceName, deviceId);
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }

  @override
  void submitAction(String data) {
    final _$actionInfo = _$_BlueActionController.startAction(
        name: '_NewGatewayService.setScreen');
    try {
      return super.submitAction(data);
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }

  @override
  void newServerMsg(String text) {
    final _$actionInfo = _$_BlueActionController.startAction(
        name: '_NewGatewayService.setScreen');
    try {
      return super.newServerMsg(text);
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }
}
