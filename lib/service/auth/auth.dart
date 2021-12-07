import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/models/auth/auth_model.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  ///Create a new User
  Future<void> signUp(AuthModel authModel) async {
    if (authModel.email.isEmpty || authModel.password.isEmpty) {
      ScaffoldMessenger.of(authModel.context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Verifique os campos!'),
        ),
      );
    } else {
      if (authModel.password.length >= 6) {
        try {
          await auth
              .createUserWithEmailAndPassword(
                  email: authModel.email, password: authModel.password)
              .then((_) {
            Modular.to.navigate(Routes.gateway);
          });

          String uid = FirebaseAuth.instance.currentUser!.uid;

          FirebaseDatabase.instance.reference().child('Users').child(uid);
        } catch (e) {
          ScaffoldMessenger.of(authModel.context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content:
                  Text('Não Foi possivel cadastrar-se com suas Credenciais!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(authModel.context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('"Verifique se sua senha tem mais de 6 caracter!'),
          ),
        );
      }
    }
  }

  ///Login
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    if (password.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Verifique os campos!'),
        ),
      );
    } else {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Modular.to.navigate(Routes.gateway));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content:
                Text('Não Foi possivel fazer o login com suas Credenciais!'),
          ),
        );
      }
    }
  }

  ///Sign out
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  ///Reset Password
  Future<void> resetPassword(String email) async {
    auth.sendPasswordResetEmail(email: email);
  }

  /// Get user's uid
  Future<String> uid() async {
    return auth.currentUser!.uid;
  }

  ///Verify user's status
  Future<bool> get userStatus async {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
