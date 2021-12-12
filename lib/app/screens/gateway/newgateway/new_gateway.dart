// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_field, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:iris/app/screens/gateway/newgateway/chatpage.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/utilities/widget/circlewavepainter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class NewGateWay extends StatefulWidget {
  const NewGateWay({Key? key}) : super(key: key);

  @override
  _NewGateWay createState() => _NewGateWay();
}

class _NewGateWay extends State<NewGateWay>
    with SingleTickerProviderStateMixin {
  Uuid _UART_UUID = Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  Uuid _UART_RX = Uuid.parse("808ccec4-d862-11eb-b8bc-0242ac130003");
  Uuid _UART_TX = Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  //Reactive BLE
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late Stream<ConnectionStateUpdate> _currentConnectionStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late QualifiedCharacteristic _txCharacteristic;
  late QualifiedCharacteristic _rxCharacteristic;
  late Stream<List<int>> _receivedDataStream;
  bool _scanning = false;
  bool _connected = false;
  String _logTexts = "";
  List<String> _receivedData = [];
  String connectionText = 'Procurando pelo Gateway';

  TextEditingController nameGateway = TextEditingController();
  TextEditingController descGateway = TextEditingController();

  final ref = FirebaseDatabase.instance.reference();
  String gid = '';

  bool initScan = false;
  late bool reconnect;
  bool isWaitingGid = false;

  //Animation
  double waveRadius = 0.0;
  double waveGap = 40.0;
  late Animation<double> _animation;
  late AnimationController controller;

  int countWrite = 0;
  bool flagRequest = false;
  bool flagInit = false;
  int countMessage = 0;
  static const serverRequest = 'KQ.?2qf01X|,JZRq8!},';
  String clientRequest = 'tSdcxhoLVYj7oMT500&5';

  //Request Permission
  String dialogTitle = "Por favor, fornece-nos a permissao a localizacao!";
  bool displayDialogContent = true;
  String dialogContent =
      "Este aplicativo requer Bluetooth para se conectar ao dispositivo. ";

  //or
  // bool displayDialogContent = false;
  // String dialogContent = "";
  String cancelBtnText = "Não";
  String acceptBtnText = "Sim";
  double dialogRadius = 10.0;
  bool barrierDismissible = true; //

  String name = '';
  final re = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser!.uid);

  Future<void> _restartScan() async {
    if (reconnect) {
      await Future.delayed(const Duration(seconds: 5));
      if (reconnect) {
        print('busca reiniciada');
        _scanStream.cancel();
        _startScan();
      }
    }
  }

  String oldData = '';

  Future<void> _sendData(String data) async {
    if (data != oldData) {
      await flutterReactiveBle.writeCharacteristicWithResponse(
          _rxCharacteristic,
          value: data.codeUnits);
      print('escrito');
    }
  }

  @override
  void dispose() {
    _stopScan();
    controller.dispose();
    super.dispose();
  }

  Future<void> _disconnect() async {
    await _connection.cancel();
    _connected = false;
  }

  void _stopScan() async {
    if (_scanStream != null) {
      _scanStream.cancel();
    }
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
        await Future.delayed(const Duration(seconds: 2));
        _stopScan();
        await Future.delayed(const Duration(seconds: 2));
        onConnectDevice(device.id, device.name);
      }, onError: (Object error) {
        _logTexts = "${_logTexts}ERROR while scanning:$error \n";
      });
      Future<void>.delayed(const Duration(seconds: 2)).then<void>((_) {
        _scanStream.cancel();
      });
      _restartScan();
    } else {
      await showNoPermissionDialog();
    }
  }

  Future<void> showNoPermissionDialog() async => showDialog<void>(
        context: context,
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
  bool flag = true;
  bool isRequest = false;

  Future<void> _syncConnection() async {
    if (flag) {
      _sendData('@');
      print('@');
      setState(() {
        isRequest = true;
        flag = false;
      });
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
          _disconnect();
        }
      } else {
        switch (String.fromCharCodes(data)) {
          case '/':
            {
              _sendData(FirebaseAuth.instance.currentUser!.uid);
              isWaitingGid = true;
              break;
            }
          case '~':
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        flutterReactiveBle,
                        _rxCharacteristic,
                        _txCharacteristic,
                        _receivedData,
                        _connection,
                        GatewayModel(
                            gid, nameGateway.text, descGateway.text, true),
                        deviceIdi)),
              );

              break;
            }
        }
      }
    }
  }

  String deviceIdi = '';

  Future<void> connectToDevice(event, deviceName, deviceId) async {
    reconnect = false;
    var id = event.deviceId.toString();
    switch (event.connectionState) {
      case DeviceConnectionState.connecting:
        {
          _logTexts = "${_logTexts}Connecting to $id\n";
          setState(() {
            connectionText = 'Conectado ao Gateway';
          });
          break;
        }
      case DeviceConnectionState.connected:
        {
          setState(() {
            connectionText = 'Conectado com ' + deviceName;
          });
          _connected = true;
          _logTexts = "${_logTexts}Connected to $id\n";
          _receivedData = [];
          _txCharacteristic = QualifiedCharacteristic(
              serviceId: _UART_UUID,
              characteristicId: _UART_TX,
              deviceId: event.deviceId);

          _receivedDataStream =
              flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic);
          _receivedDataStream.listen((data) {
            onNewReceivedData(data);
          });
          _rxCharacteristic = QualifiedCharacteristic(
              serviceId: _UART_UUID,
              characteristicId: _UART_RX,
              deviceId: event.deviceId);
          flagInit = true;
          deviceIdi = deviceId;
          _syncConnection();
          break;
        }
      case DeviceConnectionState.disconnecting:
        {
          _connected = false;
          _logTexts = "${_logTexts}Disconnecting from $id\n";
          setState(() {
            connectionText = 'Desconectando de ' + deviceName;
          });

          break;
        }
      case DeviceConnectionState.disconnected:
        {
          _logTexts = "${_logTexts}Disconnected from $id\n";
          setState(() {
            connectionText = 'Desconectado do ' + deviceName;
          });
          break;
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
    _connection = _currentConnectionStream.listen((event) async {
      connectToDevice(event, deviceName, deviceId);
      if (event.connectionState == DeviceConnectionState.disconnected) {
        print('desconectado');
      } else if (event.connectionState == DeviceConnectionState.connected) {
        print('conectado');
      }
    });
  }

  Future<void> updateConnect(event, deviceName, deviceId) async {
    await _disconnect();
    connectToDevice(event, deviceName, deviceId);
  }

  final refe = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser!.uid);

  String image = '';

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    controller.forward();

    refe
        .child('Profile')
        .child('urlImageProfile')
        .once()
        .then((DataSnapshot data) {
      setState(() {
        image = data.value;
      });
    });

    setState(() {
      reconnect = true;
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    re.child('Nome').once().then((DataSnapshot data) {
      setState(() {
        name = data.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;

    _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = _animation.value;
        });
      });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.west),
          color: Colors.black,
          onPressed: () {},
        ),
        backgroundColor: const Color.fromRGBO(249, 249, 249, 1.0),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                color: const Color.fromRGBO(249, 249, 249, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Novo Gateway',
                            style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.black,
                                fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Opacity(
                            opacity: 0.3,
                            child: Text(
                              'Adicionar um novo Gateway',
                              style: TextStyle(
                                  fontFamily: 'Schyler',
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: height - 250,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              image,
                                            )),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 40, left: 20),
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                              fontFamily: 'Schyler',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Divider(
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: width * 0.8,
                                  child: TextFormField(
                                    controller: nameGateway,
                                    decoration: InputDecoration(
                                        errorText: isUserNameValidate
                                            ? 'Insira uma nome'
                                            : null,
                                        border: InputBorder.none,
                                        labelText: 'Nome do Gateway',
                                        fillColor: const Color(0xfff3f3f4),
                                        filled: true),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: width * 0.8,
                                  child: TextFormField(
                                    controller: descGateway,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Descrição (Opcional)',
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: SizedBox(
                                    height: 50,
                                    width: width * 0.6,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _start(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.greenAccent,
                                                  Colors.blue
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: 300,
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'CONFIRMAR',
                                            style: TextStyle(
                                                fontFamily: 'Schyler',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: initScan ? buildSheet() : Container(),
          ),
        ],
      ),
    );
  }

  bool isUserNameValidate = false;

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        isUserNameValidate = true;
      });
      return false;
    }
    setState(() {
      isUserNameValidate = false;
    });
    return true;
  }

  Widget buildSheet() {
    return SlidingSheet(
      elevation: 8,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
          snap: true,
          snappings: [112, 400, double.infinity],
          positioning: SnapPositioning.pixelOffset),
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: 300,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: CircleWavePainter(waveRadius),
          ),
        );
      },
      headerBuilder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: 56,
          width: double.infinity,
          child: Center(
            child: Text(
              connectionText,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      },
    );
  }

  Future<void> _start(BuildContext context) async {
    if (nameGateway.text.isNotEmpty) {
      setState(() {
        initScan = true;
      });
      _startScan();
    } else {
      validateTextField(nameGateway.text);
    }
  }
}
