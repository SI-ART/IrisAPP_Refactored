// ignore_for_file: unused_element, non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/newgateway/CodeReceiver.dart';
import 'package:iris/service/gateway/newgateway/messages.dart';
import 'package:iris/service/user/user.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mobx/mobx.dart';

part 'new_gateway_service.g.dart';

class NewGatewayService = _NewGatewayService with _$NewGatewayService;

abstract class _NewGatewayService with Store {
  Uuid _UART_UUID = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  Uuid _UART_RX = Uuid.parse("808ccec4-d862-11eb-b8bc-0242ac130003");
  Uuid _UART_TX = Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  BuildContext? context;

  final flutterReactiveBle = FlutterReactiveBle();

  String oldData = '';

  bool flag = true;

  @observable
  bool isUserNameValidate = false;

  GatewayModel? gatewayModel;

  Animation<double>? animation;

  AnimationController? controller;

  double waveRadius = 0.0;

  double waveGap = 40.0;

  @observable
  ObservableList<Message> messages = ObservableList<Message>();

  bool isRequest = false;

  int clientID = 0;

  int serverID = 1;

  Stream<ConnectionStateUpdate>? _currentConnectionStream;

  StreamSubscription<DiscoveredDevice>? _scanStream;

  StreamSubscription<ConnectionStateUpdate>? _connection;

  QualifiedCharacteristic? _txCharacteristic;

  QualifiedCharacteristic? _rxCharacteristic;

  Stream<List<int>>? _receivedDataStream;

  bool _scanning = false;

  bool _connected = false;

  String _logTexts = '';

  List<String> _receivedData = [];

  @observable
  String connectionText = 'Procurando pelo Gateway';

  String gid = '';

  @observable
  bool initScan = false;

  bool reconnect = true;

  bool hello = true;

  @observable
  bool goToChat = false;

  TextEditingController nameGateway = TextEditingController();

  TextEditingController descGateway = TextEditingController();

  bool isWaitingGid = false;

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Gateway');

  CodeReceiver codeReceiver = CodeReceiver();

  final ScrollController listScrollController = ScrollController();

  TextEditingController message = TextEditingController();

  static const serverRequest = 'KQ.?2qf01X|,JZRq8!},';

  static const clientRequest = 'tSdcxhoLVYj7oMT500&5';

  String dialogTitle = "Por favor, fornece-nos a permissao a localizacao!";

  bool displayDialogContent = true;

  String dialogContent =
      "Este aplicativo requer Bluetooth para se conectar ao dispositivo. ";

  String cancelBtnText = "Não";

  String acceptBtnText = "Sim";

  double dialogRadius = 10.0;

  bool barrierDismissible = true;

  Future<void> restartScan() async {
    if (reconnect) {
      await Future.delayed(const Duration(seconds: 5));
      if (reconnect) {
        print('busca reiniciada');
        _scanStream!.cancel();
        startScan();
      }
    }
  }

  Future<void> _sendData(String data) async {
    if (data != oldData) {
      await flutterReactiveBle.writeCharacteristicWithResponse(
          _rxCharacteristic!,
          value: data.codeUnits);
      print('escrito');
    }
  }

  Future<void> disconnect() async {
    await _connection!.cancel();
    _connected = false;
  }

  void stopScan() async {
    if (_scanStream != null) {
      _scanStream!.cancel();
    }
    _scanning = false;
  }

  void startScan() async {
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
        await Future.delayed(const Duration(seconds: 2));
        stopScan();
        await Future.delayed(const Duration(seconds: 2));
        onConnectDevice(device.id, device.name);
      }, onError: (Object error) {
        _logTexts = "${_logTexts}ERROR while scanning:$error \n";
      });
      Future<void>.delayed(const Duration(seconds: 2)).then<void>((_) {
        _scanStream!.cancel();
      });
      restartScan();
    } else {
      await showNoPermissionDialog();
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

  Future<void> _syncConnection() async {
    if (flag) {
      _sendData('@');
      isRequest = true;
      flag = false;
    }
  }

  Future<void> onNewReceivedData(List<int> data) async {
    print(String.fromCharCodes(data));
    print('data antiga $oldData');

    if (String.fromCharCodes(data) != oldData) {
      oldData = String.fromCharCodes(data);
      if (isWaitingGid) {
        gid = String.fromCharCodes(data);
        isWaitingGid = false;
      }

      if (isRequest) {
        if (String.fromCharCodes(data) == serverRequest) {
          _sendData(clientRequest);
          isRequest = false;
        } else {
          disconnect();
        }
      } else {
        switch (String.fromCharCodes(data)) {
          case '/':
            {
              _sendData(UserData.uid);
              isWaitingGid = true;
              break;
            }
          case '~':
            {
              hello = false;
              goToChat = true;
              break;
            }
          case '^':
            {
              newServerMsg(codeReceiver.Perfeito);
              await Future.delayed(const Duration(seconds: 1));
              newServerMsg(codeReceiver.coisinha);
              await Future.delayed(const Duration(seconds: 1));
              newServerMsg(codeReceiver.senha);
            }
            break;
          case '!':
            {
              newServerMsg(codeReceiver.Hmmm);
              await Future.delayed(const Duration(seconds: 1));
              newServerMsg(codeReceiver.erro);
              await Future.delayed(const Duration(seconds: 1));
              newServerMsg(codeReceiver.novamente);
              break;
            }
          case '&':
            {
              newServerMsg(codeReceiver.conectada);
              _newGatewayOnFirebase();
              disconnect();
              break;
            }
        }
      }
    }
  }

  void onConnectDevice(deviceId, String deviceName) {
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: deviceId,
      prescanDuration: const Duration(seconds: 5),
      withServices: [_UART_UUID, _UART_RX, _UART_TX],
      connectionTimeout: const Duration(seconds: 2),
    );
    _logTexts = "";
    _currentConnectionStream!.listen((event) async {
      connectToDevice(event, deviceName, deviceId);
    });
  }

  @action
  void connectToDevice(event, deviceName, deviceId) {
    reconnect = false;
    var id = event.deviceId.toString();
    switch (event.connectionState) {
      case DeviceConnectionState.connecting:
        {
          _logTexts = "${_logTexts}Connecting to $id\n";
          connectionText = 'Conectado ao Gateway';
          break;
        }

      case DeviceConnectionState.connected:
        {
          connectionText = 'Conectado com $deviceName';
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
          deviceId = deviceId;
          _syncConnection();
          break;
        }
      case DeviceConnectionState.disconnecting:
        {
          _connected = false;
          _logTexts = "${_logTexts}Disconnecting from $id\n";
          connectionText = 'Desconectando de $deviceName';

          break;
        }
      case DeviceConnectionState.disconnected:
        {
          _logTexts = "${_logTexts}Disconnected from $id\n";
          connectionText = 'Desconectado do $deviceName';
          break;
        }
    }
  }

  Future<bool> onBackPressed() async {
    return await showDialog(
          context: context!,
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
                  disconnect();
                  Modular.to.navigate(Routes.gateway);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @action
  void submitAction(String data) {
    data = data.trim();
    message.clear();
    _sendData(data);
    messages.add(Message(clientID, data));

    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOut);
    });
  }

  Future<void> hey() async {
    if (hello) {
      hello = false;
      newServerMsg(codeReceiver.hello);
      await Future.delayed(const Duration(seconds: 1));
      newServerMsg(codeReceiver.Vamos);
      await Future.delayed(const Duration(seconds: 1));
      newServerMsg(codeReceiver.iniciar);
    }
  }

  @action
  Future<void> start(BuildContext contextt) async {
    if (nameGateway.text.isNotEmpty) {
      initScan = true;
      context = contextt;
      startScan();
    } else {
      validateTextField(nameGateway.text);
    }
  }

  @action
  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      isUserNameValidate = true;
      return false;
    }
    isUserNameValidate = false;
    return true;
  }

  @action
  void newServerMsg(String text) {
    messages.add(Message(serverID, text));

    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOut);
    });
  }

  Future<void> _newGatewayOnFirebase() async {
    await ref.child(gatewayModel!.id).set({
      'Name': gatewayModel!.name,
      'Desc': gatewayModel!.desc,
      'isOn': gatewayModel!.isOn,
      'refresh': false,
    });
    Modular.to.navigate(Routes.gateway);
  }
}
