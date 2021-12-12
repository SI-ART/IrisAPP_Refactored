import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

class User {
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  Observable<String> userPicS = Observable('');

  @observable
  Observable<String> name = Observable('');

  /// Get user's uid
  String get uid {
    return auth.currentUser!.uid;
  }

  ///Verify user's status
  bool get userStatus {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  @action
  Future<String> get userName async {
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child("Nome")
        .once()
        .then((value) async {
      name.value = await value.value;
    });
    return name.value;
  }

  @action
  Future<String> get userPic async {
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child("Profile")
        .child("urlImageProfile")
        .once()
        .asObservable()
        .then((value) {
      userPicS.value = value.value;
    });
    return userPicS.value;
  }
}
