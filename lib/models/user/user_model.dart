import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String _name = '';
  String _userPic = '';
  String _tokenDevice = '';

  UserModel(this._name, this._userPic, this._tokenDevice);

  String get name => _name;

  String get userPic => _userPic;

  String get tokenDevice => _tokenDevice;

  UserModel.fromSnap(DataSnapshot data) {
    _name = data.value['Nome'];
    _tokenDevice = data.value['token'];
    _userPic = data.value['urlImageProfile'];
  }
}
