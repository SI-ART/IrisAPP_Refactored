import 'package:firebase_database/firebase_database.dart';

class MapModel {
  double? _latitude;
  double? _longitude;
  String? key;

  MapModel(this.key, this._latitude, this._longitude);

  MapModel.map(dynamic obj) {
    _latitude = obj['latitude'];
    _longitude = obj['longitude'];
  }

  double get latitude => _latitude!;
  double get longitude => _longitude!;

  MapModel.fromSnapshot(DataSnapshot data) {
    key = data.key;
    _latitude = data.value['latitude'];
    _longitude = data.value['longitude'];
  }
}
