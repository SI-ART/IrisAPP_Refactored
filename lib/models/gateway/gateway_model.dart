import 'package:firebase_database/firebase_database.dart';

class GatewayModel {
  String? _id;
  String? _name;
  String? _desc;
  bool? _isOn;

  GatewayModel(this._id, this._name, this._desc, this._isOn);

  GatewayModel.map(dynamic obj) {
    _id = obj['id'];
    _name = obj['Name'];
    _desc = obj['Desc'];
    _isOn = obj['isOn'];
  }

  String get id => _id!;

  String get name => _name!;

  String get desc => _desc!;

  bool get isOn => _isOn!;

  GatewayModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['Name'];
    _desc = snapshot.value['Desc'];
    _isOn = snapshot.value['isOn'];
  }
}
