import 'package:flutter/material.dart';
import 'package:iris/utilities/globals.dart';
import 'package:mobx/mobx.dart';

part 'gateway.g.dart';

class GatewayService = _GatewayService with _$GatewayService;

abstract class _GatewayService with Store {
  @observable
  int currentScreen = 1;

  @action
  void setScreen(int value) {
    currentScreen = value;
  }

  BoxDecoration colorsIsTrue = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Global.greenspri.withOpacity(0.5),
        blurRadius: 20.0,
        spreadRadius: 0.0,
        offset: const Offset(
          0.0,
          20.0,
        ),
      )
    ],
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Global.greensec, Global.greenspri],
    ),
    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
  );

  BoxDecoration colorsIsFalse = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Global.white, Global.white],
    ),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );

  Color colorIconIsTrue = Global.white;
  Color colorIconIsFalse = Global.black_opacity;
}
