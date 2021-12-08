import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:mobx/mobx.dart';

class FirebaseGatewayRepository with Store {
  @observable
  ObservableList<GatewayModel> gates = ObservableList<GatewayModel>();

  @action
  void navigateToGateway(GatewayModel gatewayModel) {}

  @action
  void onGatewayAdded(Event event) {
    gates.add(GatewayModel.fromSnapshot(event.snapshot));
  }

  @action
  void onGatewayDeleted(Event event) {
    gates.removeWhere((gateway) => gateway.id == event.snapshot.key);
  }

  @action
  void onGatewayUpdated(Event event) {
    var oldGatewayValue =
        gates.singleWhere((gateway) => gateway.id == event.snapshot.key);

    gates[gates.indexOf(oldGatewayValue)] =
        GatewayModel.fromSnapshot(event.snapshot);
  }
}
