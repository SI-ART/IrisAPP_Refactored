import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/service/gateway/newgateway/new_gateway_service.dart';

class ChatPage extends StatefulWidget {
  final NewGatewayService newGatewayService;
  const ChatPage({Key? key, required this.newGatewayService}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    widget.newGatewayService.hey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget listChat() {
      return Observer(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(12.0),
          controller: widget.newGatewayService.listScrollController,
          children: widget.newGatewayService.messages.map((_message) {
            return Row(
              children: <Widget>[
                Container(
                  child: Text(
                      (text) {
                        return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                      }(_message.text.trim()),
                      style: const TextStyle(color: Colors.white)),
                  padding: const EdgeInsets.all(12.0),
                  margin:
                      const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                  width: 222.0,
                  decoration: BoxDecoration(
                      color: _message.whom == widget.newGatewayService.clientID
                          ? Colors.green
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(7.0)),
                ),
              ],
              mainAxisAlignment:
                  _message.whom == widget.newGatewayService.clientID
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
            );
          }).toList(),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: listChat(),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, bottom: 0),
                        child: TextField(
                          style: const TextStyle(fontSize: 15.0),
                          controller: widget.newGatewayService.message,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Digite sua mensagem aqui',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8.0, bottom: 0),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => {
                          widget.newGatewayService.message.text.isEmpty
                              ? null
                              : widget.newGatewayService.submitAction(
                                  widget.newGatewayService.message.text),
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
    );
  }
}
