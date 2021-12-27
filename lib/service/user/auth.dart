// ignore_for_file: use_rethrow_when_possible

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/models/auth/auth_model.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
          await auth.createUserWithEmailAndPassword(
              email: authModel.email, password: authModel.password);
          await onSucessLogin(authModel);
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

  Future<void> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);
      await onSucessLoginSites();
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message);
      throw e;
    }
  }

  Future<void> onSucessLogin(AuthModel authModel) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child('Profile')
        .set({'Nome': authModel.name, 'token': '', 'urlImageProfile': ''});
    Modular.to.navigate(Routes.gateway);
  }

  Future<void> onSucessLoginSites() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(uid)
        .child('Profile')
        .set({
      'Nome': auth.currentUser!.displayName,
      'token': '',
      'urlImageProfile': ''
    });
    Modular.to.navigate(Routes.gateway);
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
}
