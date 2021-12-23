part of 'station_map.dart';

mixin _$StationMapS on _StationMapS, Store {
  final _$maps = Atom(name: '_StationMapS.maps');

  @override
  ObservableList<MapModel> get maps {
    _$maps.reportRead();
    return super.maps;
  }

  @override
  set maps(ObservableList<MapModel> value) {
    _$maps.reportWrite(value, super.maps, () {
      super.maps = value;
    });
  }

  // ignore: non_constant_identifier_names
  final _$_statusActionController = ActionController(name: '_StationMapS');

  @override
  void onMapUpdate(MapModel value) {
    final _$actionInfo =
        _$_statusActionController.startAction(name: '_StationMapS.onMapUpdate');
    try {
      return super.onMapUpdate(value);
    } finally {
      _$_statusActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: $maps
    ''';
  }
}
