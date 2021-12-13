import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:mobx/mobx.dart';

part 'station_list.g.dart';

class StationListService = _StationListService with _$StationListService;

abstract class _StationListService with Store {
  @observable
  ObservableList<StationModel> stations = ObservableList<StationModel>();

  @action
  void onStationAdded(Event event, GatewayModel gatewayModel) {
    stations.add(StationModel.fromSnapshot(event.snapshot, gatewayModel));
  }

  @action
  void onStationRemoved(Event event) {
    stations.removeWhere((station) => station.idS == event.snapshot.key);
  }

  @action
  void onStationUpdated(Event event, GatewayModel gatewayModel) {
    var oldStationValue =
        stations.singleWhere((station) => station.idS == event.snapshot.key);
    stations[stations.indexOf(oldStationValue)] =
        StationModel.fromSnapshot(event.snapshot, gatewayModel);
  }
}
