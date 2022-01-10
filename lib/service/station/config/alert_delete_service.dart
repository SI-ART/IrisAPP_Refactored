import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/user/user.dart';
import 'package:local_auth/local_auth.dart';

class AlertDeleteService {
  TextEditingController nameController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  bool? _canCheckBiometrics;
  bool authenticad = false;

  final fs = FirebaseFirestore.instance
      .collection('Users')
      .doc(UserData.uid)
      .collection('Gateway');

  final refstorage = FirebaseStorage.instance
      .ref()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  StationModel? stationModel;

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      throw Exception(e);
    }

    _canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> _authenticate() async {
    try {
      authenticad = await auth.authenticate(
          localizedReason: 'Para deletar, confirme sua identidade',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> delete(StationModel stationModel) async {
    this.stationModel = stationModel;
    if (_canCheckBiometrics!) {
      await _authenticate();
      if (authenticad) {
        await _deleteStationOnRT();
        await __deleteStationOnST();
        await __deleteStationOnFS();
        Modular.to.navigate('/gateway');
      }
    } else {
      await _deleteStationOnRT();
      await __deleteStationOnST();
      await __deleteStationOnFS();
      Modular.to.navigate('/gateway');
    }
  }

  Future<void> __deleteStationOnFS() async {
    await fs
        .doc(stationModel!.id)
        .collection('Station')
        .doc(stationModel!.idS)
        .delete();
  }

  Future<void> __deleteStationOnST() async {
    await refstorage
        .child(stationModel!.id)
        .child('Station')
        .child(stationModel!.idS)
        .delete();
  }

  Future<void> _deleteStationOnRT() async {
    await ref
        .child(stationModel!.id)
        .child('Station')
        .child(stationModel!.idS)
        .remove();
    await ref.child(stationModel!.id).update({
      'refresh': true,
    });
  }
}
