import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/app/screens/gateway/newgateway/chat_page.dart';
import 'package:iris/app/screens/gateway/newgateway/new_gateway_config.dart';
import 'package:iris/service/gateway/newgateway/new_gateway_service.dart';

// ignore: must_be_immutable
class NewGateway extends StatelessWidget {
  NewGateway({Key? key}) : super(key: key);

  NewGatewayService newGatewayService = NewGatewayService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await newGatewayService.onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              bool result = await newGatewayService.onBackPressed(context);
              if (result) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.west),
            color: Colors.black,
          ),
          backgroundColor: const Color.fromRGBO(249, 249, 249, 1.0),
          elevation: 0,
        ),
        body: Observer(
          builder: (context) => newGatewayService.goToChat
              ? ChatPage(newGatewayService: newGatewayService)
              : NewGatewayConfig(newGatewayService: newGatewayService),
        ),
      ),
    );
  }
}
