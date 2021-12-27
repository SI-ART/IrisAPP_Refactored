// ignore_for_file: avoid_print

import 'package:flutter/services.dart';

class IrisRepository {
  static const MethodChannel _platformCall = MethodChannel('iris');

  ///check bluetooth status
  static Future<bool> get bluetoothStatus async {
    try {
      bool btisOn = await _platformCall.invokeMethod('checkBlueStatus');
      return btisOn;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  ///enable bluetooth
  static Future<bool> get enableBluetooth async {
    try {
      bool btisOn = await _platformCall.invokeMethod('enableBt');
      return btisOn;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  ///disable bluetooth
  static Future<bool> get disableBluetooth async {
    try {
      bool btisOn = await _platformCall.invokeMethod('disableBt');
      return btisOn;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
