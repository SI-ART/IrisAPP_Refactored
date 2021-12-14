import 'package:firebase_database/firebase_database.dart';

class StationDataModel {
  String? key;
  num? temps;
  num? umi;

  StationDataModel.fromSnapshot(DataSnapshot snapshot) {
    temps = snapshot.value['temperature'];
    umi = snapshot.value['humidity'];
  }
}
