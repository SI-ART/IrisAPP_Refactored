// ignore_for_file: avoid_print, use_key_in_widget_constructors, unused_field

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/newgateway/codereceiver.dart';
import 'package:iris/service/gateway/newgateway/messages.dart';
import 'package:iris/service/user/user.dart';

import '../../routes.dart';

class ChatPage extends StatefulWidget {
  final FlutterReactiveBle flutterReactiveBle;
  final String deviceId;
  final QualifiedCharacteristic _rxCharacteristic;
  final QualifiedCharacteristic _txCharacteristic;
  final List<String> _receivedData;
  final StreamSubscription<ConnectionStateUpdate> _connection;
  final GatewayModel gatewayModel;

  const ChatPage(
      this.flutterReactiveBle,
      this._rxCharacteristic,
      this._txCharacteristic,
      this._receivedData,
      this._connection,
      this.gatewayModel,
      this.deviceId);

  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _message = TextEditingController();

  static const clientID = 0;
  static const serverID = 1;
  List<Message> messages = [];

  final ref = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(User().uid)
      .child('Gateway');

  late Stream<List<int>> _receivedDataStream;
  bool flagRequest = true;
  bool _connected = false;
  String uid = User().uid;

  CodeReceiver codeReceiver = CodeReceiver();

  String statusConnect = 'Digite sua mensagem aqui';

  int _numberOfMessagesReceived = 0;
  int countMessage = 0;
  bool flag = false;
  bool hello = true;
  int uidsend = 0;
  String oldData = '';
  String name = '';

  String serverRequest = 'KQ.?2qf01X|,JZRq8!},';
  String clientRequest = 'tSdcxhoLVYj7oMT500&5';

  bool clear = true;
  @override
  void initState() {
    super.initState();

    hey();

    _receivedDataStream = widget.flutterReactiveBle
        .subscribeToCharacteristic(widget._txCharacteristic);
    _receivedDataStream.listen((data) {
      onNewReceivedData(data);
    });

    ref.child('Nome').once().then((DataSnapshot data) {
      setState(() {
        name = data.value!;
      });
    });
  }

  Future<void> _sendID(String data) async {
    await widget.flutterReactiveBle.writeCharacteristicWithResponse(
        widget._rxCharacteristic,
        value: data.codeUnits);
  }

  Future<void> _sendData(String data) async {
    await widget.flutterReactiveBle.writeCharacteristicWithResponse(
        widget._rxCharacteristic,
        value: data.codeUnits);
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

  Future<void> _disconnect() async {
    // await widget.flutterReactiveBle.clearGattCache(widget.deviceId);
    await widget._connection.cancel();
    _connected = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshScreen() {
    setState(() {});
  }

  Future<void> onNewReceivedData(List<int> data) async {
    _numberOfMessagesReceived += 1;
    widget._receivedData
        .add("$_numberOfMessagesReceived: ${String.fromCharCodes(data)}");
    print(String.fromCharCodes(data));
    print(oldData);
    if (String.fromCharCodes(data) != oldData) {
      oldData = String.fromCharCodes(data);
      switch (String.fromCharCodes(data)) {
        case '/':
          {
            _sendID(uid);
            break;
          }
        case '*':
          {
            _sendID(widget.gatewayModel.id);
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
            _disconnect();
            break;
          }
      }
    }
  }

  void newServerMsg(String text) {
    setState(() {
      messages.add(Message(serverID, text));
    });

    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOut);
    });
  }

  void submitAction(String data) {
    data = data.trim();
    _message.clear();
    _sendData(data);
    setState(() {
      messages.add(Message(clientID, data));
    });

    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: const TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color: _message.whom == clientID ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              onBackPressed();
            },
            icon: const Icon(Icons.west),
            color: Colors.black,
          ),
          backgroundColor: const Color.fromRGBO(249, 249, 249, 1.0),
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView(
                          padding: const EdgeInsets.all(12.0),
                          controller: listScrollController,
                          children: list),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 16.0, bottom: 0),
                            child: TextField(
                              style: const TextStyle(fontSize: 15.0),
                              controller: _message,
                              decoration: InputDecoration.collapsed(
                                hintText: statusConnect,
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 8.0, bottom: 0),
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () => {
                              _message.text.isEmpty
                                  ? null
                                  : submitAction(_message.text),
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
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
                  Modular.to.navigate(Routes.gateway);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _newGatewayOnFirebase() async {
    await ref.child(widget.gatewayModel.id).set({
      'Name': widget.gatewayModel.name,
      'Desc': widget.gatewayModel.desc,
      'isOn': widget.gatewayModel.isOn,
      'refresh': false,
    });
    Modular.to.navigate(Routes.gateway);
  }
}
