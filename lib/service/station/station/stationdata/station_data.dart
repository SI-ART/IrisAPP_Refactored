import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/station/station_data_model.dart';
import 'package:iris/service/user/user.dart';
import 'package:mobx/mobx.dart';

part 'station_data.g.dart';

class StationDataService = _StationDataService with _$StationDataService;

abstract class _StationDataService with Store {
  @observable
  num temp = 0;

  @observable
  num humi = 0;

  Future<StreamSubscription<Event>> getStatusStream(String sid, String gid,
      void Function(StationDataModel todo) onData) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(UserData.uid)
        .child("Gateway")
        .child(gid)
        .child("Station")
        .child(sid)
        .child('Data')
        .onValue
        .listen((Event event) {
      var todo = StationDataModel.fromSnapshot(event.snapshot);
      onData(todo);
    });
    return subscription;
  }

  @action
  void onDataUpdate(StationDataModel value) {
    temp = value.temps!;
    humi = value.umi!;
  }
}
