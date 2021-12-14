part of 'station_valve.dart';

mixin _$StationValveService on _StationValveService, Store {
  final _$status = Atom(name: '_StationValveService.status');

  @override
  bool get status {
    _$status.reportRead();
    return super.status;
  }

  @override
  set status(bool value) {
    _$status.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  // ignore: non_constant_identifier_names
  final _$_statusActionController =
      ActionController(name: '_StationValveService');

  @override
  void onStatusUpdate(StationValveModel value) {
    final _$actionInfo = _$_statusActionController.startAction(
        name: '_StationService.onStatusUpdate');
    try {
      return super.onStatusUpdate(value);
    } finally {
      _$_statusActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: $status
    ''';
  }
}
