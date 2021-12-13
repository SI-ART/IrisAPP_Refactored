// ignore_for_file: non_constant_identifier_names, unused_field

part of 'station_list.dart';

mixin _$StationListService on _StationListService, Store {
  final _$StationList = Atom(name: '_StationListService.stations');

  final _$_StationActionController = ActionController(name: '_GatewayService');

  @override
  void onStationAdded(Event event, GatewayModel gatewayModel) {
    final _$actionInfo = _$_StationActionController.startAction(
        name: '_GatewayService.onStationAdded');
    try {
      return super.onStationAdded(event, gatewayModel);
    } finally {
      _$_StationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onStationRemoved(Event event) {
    final _$actionInfo = _$_StationActionController.startAction(
        name: '_GatewayService.onStationRemoved');
    try {
      return super.onStationRemoved(event);
    } finally {
      _$_StationActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onStationUpdated(Event event, GatewayModel gatewayModel) {
    final _$actionInfo = _$_StationActionController.startAction(
        name: '_GatewayService.onStationUpdated');
    try {
      return super.onStationUpdated(event, gatewayModel);
    } finally {
      _$_StationActionController.endAction(_$actionInfo);
    }
  }
}
