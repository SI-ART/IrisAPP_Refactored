// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iris/models/station/mapmodel.dart';
import 'package:iris/service/user/user.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

part 'station_map.g.dart';

class StationMapS = _StationMapS with _$StationMapS;

abstract class _StationMapS with Store {
  final MapZoomPanBehavior zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: const MapLatLng(-23.343953, -51.183709),
      toolbarSettings: const MapToolbarSettings(
        direction: Axis.vertical,
        position: MapToolbarPosition.bottomRight,
      ),
      enableDoubleTapZooming: true,
      maxZoomLevel: 20,
      zoomLevel: 2,
      minZoomLevel: 1);
  final MapTileLayerController mapController = MapTileLayerController();
  AnimationController? animationController;
  Animation<double>? animation;
  Color? layerColor;
  final List<double>? dashArray = <double>[0, 0];

  @observable
  ObservableList<MapModel> maps = ObservableList<MapModel>();

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  void setlocation() {
    layerColor = const Color.fromRGBO(167, 61, 233, 1.0);

    _updateMarkers();
  }

  void _updateMarkers() {
    mapController.clearMarkers();
    for (int i = 0; i < maps.length; i++) {
      mapController.insertMarker(i);
    }
  }

  Future<StreamSubscription<Event>> onMapListen(
      String sid, String gid, void Function(MapModel todo) onData) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(UserData.uid)
        .child("Gateway")
        .child(gid)
        .child("Station")
        .child(sid)
        .child('Data')
        .onValue
        .listen((Event event) {
      var todo = MapModel.fromSnapshot(event.snapshot);
      onData(todo);
    });
    return subscription;
  }

  @action
  void onMapUpdate(MapModel value) {
    maps.add(value);
    layerColor = const Color.fromRGBO(167, 61, 233, 1.0);
    _updateMarkers();
  }
}
