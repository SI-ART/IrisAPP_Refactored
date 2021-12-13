import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/user/user.dart';

class StationValveService {
  final StationModel stationModel;
  StationValveService(this.stationModel);

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(User().uid)
      .child("Gateway");

  bool status = false;

  Stream<bool> get statusStream {
    ref
        .child(stationModel.id)
        .child('Station')
        .child(stationModel.idS)
        .onValue
        .listen((event) {
      status = event.snapshot.value['isOn'];
    });
    return Stream.value(status);
  }

  void setOnDatabase() {
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
