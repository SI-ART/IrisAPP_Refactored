import 'package:firebase_database/firebase_database.dart';

class StationDataModel {
  String? key;
  bool? status;

  StationDataModel.fromSnapshot(DataSnapshot snapshot) {
    status = snapshot.value['isOn'];
  }
}
