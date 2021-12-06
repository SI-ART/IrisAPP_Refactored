import 'package:flutter/material.dart';

class AuthModel {
  String email;
  String password;
  String name;
  BuildContext context;

  AuthModel(this.email, this.password, this.name, this.context);
}
