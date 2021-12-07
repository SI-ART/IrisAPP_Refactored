import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iris',
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.gateway
          : Modular.initialRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
    ).modular(); //added by extension
  }
}
