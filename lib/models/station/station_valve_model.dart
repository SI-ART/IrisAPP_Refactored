import 'package:firebase_database/firebase_database.dart';

class StationValveModel {
  String? key;
  bool? status;

  StationValveModel.fromSnapshot(DataSnapshot snapshot) {
    status = snapshot.value['isOn'];
  }
}
