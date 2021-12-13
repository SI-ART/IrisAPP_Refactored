import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:iris/models/gateway/gateway_model.dart';

class StationModel extends GatewayModel {
  String? _idS;
  String? _nameS;
  String? _urlImageS;
  bool? _isOnS;
  bool? _isConnectedS;
  bool? _isSelectedS = false;
  Rssi? _rssi;
  Icon? _networkIcon;

  StationModel(
      GatewayModel gatewayModel,
      this._idS,
      this._nameS,
      this._urlImageS,
      this._isOnS,
      this._isConnectedS,
      this._isSelectedS,
      this._rssi,
      this._networkIcon)
      : super(gatewayModel.id, gatewayModel.name, gatewayModel.desc,
            gatewayModel.isOn);

  String get idS => _idS!;

  String get nameS => _nameS!;

  String get urlImageS => _urlImageS!;

  Icon get networkIcon => _networkIcon!;

  bool get isOnS => _isOnS!;

  Rssi get rssi => _rssi!;

  bool get isConnectedS => _isConnectedS!;

  bool get isSelectS => _isSelectedS!;

  set isSelectS(bool value) => value = _isSelectedS!;

  factory StationModel.fromSnapshot(
      DataSnapshot snapshot, GatewayModel gatewayModel) {
    Rssi? rssiset;
    Icon? networkIconset;

    switch (snapshot.value['rssi']) {
      case 0:
        {
          networkIconset = const Icon(
              CommunityMaterialIcons.network_strength_off,
              color: Colors.black26,
              size: 30);
          rssiset = Rssi.inative;
          break;
        }
      case 1:
        {
          networkIconset = const Icon(CommunityMaterialIcons.network_strength_1,
              color: Colors.red, size: 30);
          rssiset = Rssi.bad;
          break;
        }
      case 2:
        {
          networkIconset = const Icon(CommunityMaterialIcons.network_strength_2,
              color: Colors.orange, size: 30);
          rssiset = Rssi.moderate;
          break;
        }
      case 3:
        {
          networkIconset = const Icon(CommunityMaterialIcons.network_strength_3,
              color: Colors.amber, size: 30);
          rssiset = Rssi.good;
          break;
        }
      case 4:
        {
          networkIconset = const Icon(CommunityMaterialIcons.network_strength_4,
              color: Colors.green, size: 30);
          rssiset = Rssi.excellent;
          break;
        }
    }
    return StationModel(
      gatewayModel,
      snapshot.key,
      snapshot.value['Name'],
      snapshot.value['urlImage'],
      snapshot.value['isOn'],
      snapshot.value['isConnected'],
      false,
      rssiset,
      networkIconset,
    );
  }
}

enum Rssi {
  ///Statios is inative
  inative,

  ///bad connection
  bad,

  ///moderate connection
  moderate,

  ///good connection
  good,

  ///excellent connection
  excellent,
}
