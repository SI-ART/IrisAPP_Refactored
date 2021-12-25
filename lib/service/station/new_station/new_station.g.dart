part of 'new_station.dart';

mixin _$NewStationService on _NewStationService, Store {
  final _$connectionText = Atom(name: '_NewStationService.connectionText');
  final _$initScan = Atom(name: '_NewStationService.initScan');
  final _$image = Atom(name: '_NewStationService.image');
  final _$isPicked = Atom(name: '_NewStationService.isPicked');

//vars
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
    _$initScan.reportWrite(value, super.connectionText, () {
      super.initScan = value;
    });
  }

  @override
  File get image {
    _$image.reportRead();
    return super.image!;
  }

  @override
  set image(File? value) {
    _$image.reportWrite(value, super.connectionText, () {
      super.image = value;
    });
  }

  @override
  bool get isPicked {
    _$isPicked.reportRead();
    return super.isPicked;
  }

  @override
  set isPicked(bool value) {
    _$isPicked.reportWrite(value, super.connectionText, () {
      super.isPicked = value;
    });
  }

//actions

  // ignore: non_constant_identifier_names
  final _$_BlueActionController = ActionController(name: '_NewStationService');

  @override
  void imgFromCamera() {
    final _$actionInfo = _$_BlueActionController.startAction(
        name: '_NewStationService.imgFromCamera');
    try {
      super.imgFromCamera();
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> connectToDevice(event, deviceName, deviceId) async {
    final _$actionInfo = _$_BlueActionController.startAction(
        name: '_NewStationService.connectToDevice');
    try {
      super.connectToDevice(event, deviceName, deviceId);
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> start(BuildContext context, GatewayModel gate) async {
    final _$actionInfo =
        _$_BlueActionController.startAction(name: '_NewStationService.start');
    try {
      super.start(context, gate);
    } finally {
      _$_BlueActionController.endAction(_$actionInfo);
    }
  }
}
