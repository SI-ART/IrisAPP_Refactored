// ignore_for_file: unused_field, prefer_final_fields, non_constant_identifier_names, unused_element, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/repository/repository.dart';
import 'package:iris/service/user/user.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mobx/mobx.dart';

part 'new_station.g.dart';

class NewStationService = _NewStationService with _$NewStationService;

abstract class _NewStationService with Store implements Disposable {
  Uuid _UART_UUID = Uuid.parse("32454db8-1322-11ec-82a8-0242ac130003");
  Uuid _UART_RX = Uuid.parse("808ccec4-d862-11eb-b8bc-0242ac130003");
  Uuid _UART_TX = Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  final flutterReactiveBle = FlutterReactiveBle();

  final ImagePicker _picker = ImagePicker();

  StreamSubscription<DiscoveredDevice>? _scanStream;

  Stream<ConnectionStateUpdate>? _currentConnectionStream;

  StreamSubscription<ConnectionStateUpdate>? _connection;

  QualifiedCharacteristic? _txCharacteristic;

  BuildContext? context;

  GatewayModel? gatewayModel;

  QualifiedCharacteristic? _rxCharacteristic;

  Stream<List<int>>? _receivedDataStream;

  bool _scanning = false;

  bool _connected = false;

  String _logTexts = "";

  List<String> _receivedData = [];

  bool isUserNameValidate = false;

  @observable
  String connectionText = 'Procurando pela Estação';

  String oldData = '';

  Animation<double>? animation;

  AnimationController? controller;

  bool flag = true;

  bool isRequest = false;

  bool isWaitingSid = false;

  double waveRadius = 0.0;

  double waveGap = 40.0;

  static const serverRequest = '&i((3,iH0,+-z[i]PpAh';

  static const clientRequest = 'hHo}8j<Sf(:4mTQW8W#l';

  bool flagInit = false;

  String sid = '';

  String dialogTitle = "Por favor, fornece-nos a permissão para a localizacao!";

  bool displayDialogContent = true;

  String dialogContent =
      "Este aplicativo requer Bluetooth para se conectar ao dispositivo. ";

  String cancelBtnText = "Não";

  String acceptBtnText = "Sim";

  String warnnig = '';

  double dialogRadius = 10.0;

  @observable
  bool initScan = false;

  bool reconnect = true;

  bool barrierDismissible = true;

  int trysCount = 0;

  String deviceIdd = '';

  final TextEditingController nameStation = TextEditingController();

  @observable
  File? image;

  @observable
  bool isPicked = false;

  String _urlImage = '';

  //references

  final refStorage = FirebaseStorage.instance
      .ref()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  @override
  void dispose() {
    disableBlue();
  }

  Future<void> configBluetooth() async {
    bool statusBlue = await IrisRepository.bluetoothStatus;
    if (statusBlue == false) {
      IrisRepository.enableBluetooth;
    }
  }

  Future<void> disableBlue() async {
    bool statusBlue = await IrisRepository.bluetoothStatus;
    if (statusBlue) {
      IrisRepository.disableBluetooth;
    }
  }

  @action
  imgFromCamera() async {
    var _image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    isPicked = true;
    image = File(_image!.path);
  }

  @action
  imgFromGallery() async {
    var _image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    isPicked = true;
    image = File(_image!.path);
  }

  Future<void> _sendData(String data) async {
    await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic!,
        value: data.codeUnits);
  }

  Future<void> _disconnect() async {
    await _connection!.cancel();
    _connected = false;
  }

  void stopScan() async {
    await _scanStream!.cancel();
    _scanning = false;
  }

  void _startScan() async {
    bool goForIt = false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) goForIt = true;
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      _scanning = true;

      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: [_UART_UUID]).listen((device) async {
        await Future.delayed(const Duration(seconds: 5));
        stopScan();
        await Future.delayed(const Duration(seconds: 2));
        onConnectDevice(device.id, device.name);
      }, onError: (Object error) {
        _logTexts = "${_logTexts}ERROR while scanning:$error \n";
      });
      Future<void>.delayed(const Duration(seconds: 2)).then<void>((_) {
        _scanStream!.cancel();
      });

      _restartScan();
    } else {
      await showNoPermissionDialog();
    }
  }

  Future<void> _restartScan() async {
    trysCount = trysCount + 1;
    if (trysCount == 5) {
      _scanStream!.cancel();
      reconnect = false;
      warnnig = 'Não foi possivel localizar a estação';
    } else if (reconnect) {
      await Future.delayed(const Duration(seconds: 10));
      if (reconnect) {
        _scanStream!.cancel();
        _startScan();
      }
    }
  }

  Future<void> showNoPermissionDialog() async => showDialog<void>(
        context: context!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Sem acesso a localização '),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('A permissão para o acesso a localização foi negada!'),
                Text(
                    'Permissão para o acesso a localização é exigida pelo aplicativo, caso o contrario, não é possivel continuar.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Acknowledge'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  void onConnectDevice(deviceId, String deviceName) {
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: deviceId,
      prescanDuration: const Duration(seconds: 5),
      withServices: [_UART_UUID, _UART_RX, _UART_TX],
      connectionTimeout: const Duration(seconds: 2),
    );
    _logTexts = "";
    _connection = _currentConnectionStream!.listen((event) async {
      connectToDevice(event, deviceName, deviceId);
    });
  }

  @action
  Future<void> connectToDevice(event, deviceName, deviceId) async {
    reconnect = false;
    var id = event.deviceId.toString();
    deviceIdd = event.deviceId;
    switch (event.connectionState) {
      case DeviceConnectionState.connecting:
        {
          _logTexts = "${_logTexts}Connecting to $id\n";
          connectionText = 'Conectado ao Gateway';
          break;
        }
      case DeviceConnectionState.connected:
        {
          connectionText = 'Conectado com ' + deviceName;
          _connected = true;
          _logTexts = "${_logTexts}Connected to $id\n";
          _receivedData = [];
          _txCharacteristic = QualifiedCharacteristic(
              serviceId: _UART_UUID,
              characteristicId: _UART_TX,
              deviceId: event.deviceId);

          _receivedDataStream =
              flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic!);
          _receivedDataStream!.listen((data) {
            onNewReceivedData(data);
          });
          _rxCharacteristic = QualifiedCharacteristic(
              serviceId: _UART_UUID,
              characteristicId: _UART_RX,
              deviceId: event.deviceId);
          flagInit = true;
          deviceId = deviceId;
          _syncConnection();
          break;
        }
      case DeviceConnectionState.disconnecting:
        {
          _connected = false;
          _logTexts = "${_logTexts}Disconnecting from $id\n";
          connectionText = 'Desconectando de ' + deviceName;

          break;
        }
      case DeviceConnectionState.disconnected:
        {
          _logTexts = "${_logTexts}Disconnected from $id\n";
          connectionText = 'Desconectado do ' + deviceName;
          break;
        }
    }
  }

  Future<void> onNewReceivedData(List<int> data) async {
    print(String.fromCharCodes(data));
    if (String.fromCharCodes(data) != oldData) {
      oldData = String.fromCharCodes(data);

      if (isWaitingSid) {
        sid = String.fromCharCodes(data);

        isWaitingSid = false;
      }

      if (isRequest) {
        if (String.fromCharCodes(data) == serverRequest) {
          _sendData(clientRequest);
          isRequest = false;
        } else {
          _disconnect();
        }
      } else {
        switch (String.fromCharCodes(data)) {
          case '|':
            {
              _sendData(gatewayModel!.id);
              isWaitingSid = true;
              break;
            }

          case '&':
            {
              _disconnect();
              await _newStationOnFirebase();
              break;
            }
        }
      }
    }
  }

  Future<bool> onBackPressed(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Você tem certeza?'),
            content:
                const Text('Você tem certeza que deseja cancelar a conexão?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _syncConnection() async {
    if (flag) {
      _sendData('@');
      isRequest = true;
      flag = false;
    }
  }

  Future<void> _uploadImage() async {
    if (image != null) {
      try {
        await refStorage
            .child(gatewayModel!.id)
            .child('Station')
            .child(nameStation.text)
            .putFile(image!);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _getImageUrl() async {
    if (image != null) {
      _urlImage = await refStorage
          .child(gatewayModel!.id)
          .child('Station')
          .child(nameStation.text)
          .getDownloadURL();
    }
  }

  Future<void> _setOnFirebase() async {
    await ref.child(gatewayModel!.id).child('Station').child(sid).set({
      'Name': nameStation.text,
      'chipID': sid,
      'urlImage': _urlImage,
      'isOn': false,
      'isConnected': true,
      'rssi': 0
    });
    await ref.child(gatewayModel!.id).update({
      'refresh': true,
    });
  }

  Future<void> _newStationOnFirebase() async {
    await _uploadImage();
    await _getImageUrl();
    await _setOnFirebase();
    Modular.to.navigate('/gateway');
  }

  @action
  Future<void> start(BuildContext contextt, GatewayModel gate) async {
    await configBluetooth();
    context = contextt;
    gatewayModel = gate;
    initScan = true;
    _startScan();
  }
}
