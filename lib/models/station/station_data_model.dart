import 'package:firebase_database/firebase_database.dart';

class StationDataModel {
  String? key;
  num? temps;
  num? umi;

  StationDataModel.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    temps = snapshot.value['temperature'];
    umi = snapshot.value['humidity'];
  }
}
