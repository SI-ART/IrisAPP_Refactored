// ignore_for_file: unused_field, avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/constants.dart';
import 'package:local_auth/local_auth.dart';

class AlertDelete extends StatefulWidget {
  final GatewayModel gatewayModel;
  // ignore: use_key_in_widget_constructors
  const AlertDelete(this.gatewayModel);

  @override
  _AlertDelete createState() => _AlertDelete();
}

class _AlertDelete extends State<AlertDelete> {
  TextEditingController nameController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  late bool _canCheckBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool authenticad = false;

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  late String gateName;

  @override
  void initState() {
    gateName = widget.gatewayModel.name;
    _checkBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Atenção !!!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Schyler',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Você está preste a remover este Gateway, para confirmar digite $gateName.',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Schyler',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: widget.gatewayModel.name),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              nameController.text == widget.gatewayModel.name) {
                            _delete();
                          }
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 30,
            child: Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Autenticação';
      });
      authenticad = await auth.authenticate(
          localizedReason: 'Para deletar, confirme sua identidade',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
    }
  }

  Future<void> _delete() async {
    if (_canCheckBiometrics) {
      await _authenticate();
      if (authenticad) {
        _deleteGateway();
        Modular.to.navigate(Routes.gateway);
      }
    } else {
      _deleteGateway();
    }
  }

  void _deleteGateway() async {
    await ref.child(widget.gatewayModel.id).remove();
  }
}
