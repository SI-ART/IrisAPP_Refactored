import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/models/user/user_model.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class User = UserData with _$UserData;

abstract class UserData with Store implements Disposable {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @observable
  UserModel _userStream = UserModel('', '', '');

  StreamSubscription? streamSubscription;

  /// Get user's uid
  static String get uid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  ///Verify user's status
  bool get userStatus {
    if (_auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  String get userEmail {
    return _auth.currentUser!.email!;
  }

  Future<StreamSubscription<Event>> getUserStream(
      void Function(UserModel todo) onData) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(UserData.uid)
        .child('Profile')
        .onValue
        .listen((Event event) {
      var todo = UserModel.fromSnap(event.snapshot);
      onData(todo);
    });
    return subscription;
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
  }

  String get userName {
    getUserStream(updateUserInfo)
        .then((StreamSubscription s) => streamSubscription = s);
    return _userStream.name;
  }

  String get userPic {
    return _userStream.userPic;
  }

  @action
  void updateUserInfo(UserModel data) {
    _userStream = data;
  }
}
