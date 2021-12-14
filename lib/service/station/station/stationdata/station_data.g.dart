part of 'station_data.dart';

mixin _$StationDataService on _StationDataService, Store {
  final _$temp = Atom(name: '_StationData.temp');
    final _$humi = Atom(name: '_StationData.humi');

  @override
  num get temp {
    _$temp.reportRead();
    return super.temp;
  }

  @override
  set temp(num value) {
    _$temp.reportWrite(value, super.temp, () {
      super.temp = value;
    });
  }

    @override
  num get humi {
    _$humi.reportRead();
    return super.humi;
  }

  @override
  set humi(num value) {
    _$humi.reportWrite(value, super.humi, () {
      super.humi = value;
    });
  }


  // ignore: non_constant_identifier_names
  final _$_dataActionController =
      ActionController(name: '_StationData');

  @override
  void onDataUpdate(StationDataModel value) {
    final _$actionInfo = _$_dataActionController.startAction(
        name: '_StationData.onStatusUpdate');
    try {
      return super.onDataUpdate(value);
    } finally {
      _$_dataActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: $temp, $humi
    ''';
  }
}
