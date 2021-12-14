import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/models/station/station_valve_model.dart';
import 'package:iris/service/user/user.dart';
import 'package:mobx/mobx.dart';

part 'station_valve.g.dart';

class StationValveService = _StationValveService with _$StationValveService;

abstract class _StationValveService with Store {
  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(User().uid)
      .child("Gateway");

  @observable
  bool status = false;

  Future<StreamSubscription<Event>> getStatusStream(String sid, String gid,
      void Function(StationDataModel todo) onData) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(User().uid)
        .child("Gateway")
        .child(gid)
        .child("Station")
        .child(sid)
        .onValue
        .listen((Event event) {
      var todo = StationDataModel.fromSnapshot(event.snapshot);
      onData(todo);
    });
    return subscription;
  }

  @action
  void onStatusUpdate(StationDataModel value) {
    status = value.status!;
  }

  void setOnDatabase(StationModel stationModel) {
    if (status) {
      ref
          .child(stationModel.id)
          .child('Station')
          .child(stationModel.idS)
          .update({
        'isOn': false,
      });
    } else {
      ref
          .child(stationModel.id)
          .child('Station')
          .child(stationModel.idS)
          .update({
        'isOn': true,
      });
    }
  }
}
