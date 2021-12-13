import 'package:firebase_database/firebase_database.dart';

class StationDataModel {
  String? key;
  bool? status;
  double? temps;
  int? umi;

  StationDataModel.fromSnapshot(DataSnapshot snapshot) {
    temps = snapshot.value['temperature'];
    umi = snapshot.value['humidity'];
    status = snapshot.value['isOn'];
  }
}
