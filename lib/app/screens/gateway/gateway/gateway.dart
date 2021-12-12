// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/app/screens/gateway/gateway/gateway_report.dart';
import 'package:iris/app/screens/gateway/gateway/gateway_time.dart';
import 'package:iris/app/screens/gateway/gateway/station_list.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/gateway/gateway.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Gateway extends StatefulWidget {
  final GatewayModel gatewayModel;
  const Gateway({Key? key, required this.gatewayModel}) : super(key: key);

  @override
  _GatewayState createState() => _GatewayState();
}

class _GatewayState extends State<Gateway> {
  GatewayService gatewayService = GatewayService();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double width = queryData.size.width;
    double freeScreen = width - 80;
    double cardSize = freeScreen / 3;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              /*  pushNewScreen(
                context,
                screen: GatewayConfig(widget.gatewayModel),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );*/
            },
            child: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.west),
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Observer(
        builder: (context) => Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                color: const Color.fromRGBO(249, 249, 249, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            widget.gatewayModel.name,
                            style: const TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.black,
                                fontSize: 24),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Opacity(
                            opacity: 0.3,
                            child: Text(
                              'Plano Standard',
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: cardSize,
                              width: cardSize,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Container(
                                  decoration: gatewayService.currentScreen == 1
                                      ? gatewayService.colorsIsTrue
                                      : gatewayService.colorsIsFalse,
                                  child: InkWell(
                                    onTap: () {
                                      gatewayService.setScreen(1);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          LineAwesomeIcons.wired_network,
                                          color: gatewayService.currentScreen ==
                                                  1
                                              ? gatewayService.colorIconIsTrue
                                              : gatewayService.colorIconIsFalse,
                                          size: 30,
                                        ),
                                        Text(
                                          'Estações',
                                          style: TextStyle(
                                              fontFamily: 'Schyler',
                                              color: gatewayService
                                                          .currentScreen ==
                                                      1
                                                  ? gatewayService
                                                      .colorIconIsTrue
                                                  : gatewayService
                                                      .colorIconIsFalse,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: cardSize,
                              width: cardSize,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Container(
                                  decoration: gatewayService.currentScreen == 2
                                      ? gatewayService.colorsIsTrue
                                      : gatewayService.colorsIsFalse,
                                  child: InkWell(
                                    onTap: () {
                                      gatewayService.setScreen(2);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          LineAwesomeIcons.clock,
                                          color: gatewayService.currentScreen ==
                                                  2
                                              ? gatewayService.colorIconIsTrue
                                              : gatewayService.colorIconIsFalse,
                                          size: 30,
                                        ),
                                        Text(
                                          'Horário',
                                          style: TextStyle(
                                              fontFamily: 'Schyler',
                                              color: gatewayService
                                                          .currentScreen ==
                                                      2
                                                  ? gatewayService
                                                      .colorIconIsTrue
                                                  : gatewayService
                                                      .colorIconIsFalse,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: cardSize,
                            width: cardSize,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 5,
                              child: Container(
                                decoration: gatewayService.currentScreen == 3
                                    ? gatewayService.colorsIsTrue
                                    : gatewayService.colorsIsFalse,
                                child: InkWell(
                                  onTap: () {
                                    gatewayService.setScreen(3);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.paste,
                                        color: gatewayService.currentScreen == 3
                                            ? gatewayService.colorIconIsTrue
                                            : gatewayService.colorIconIsFalse,
                                        size: 30,
                                      ),
                                      Text(
                                        'Relatórios',
                                        style: TextStyle(
                                            fontFamily: 'Schyler',
                                            color: gatewayService
                                                        .currentScreen ==
                                                    3
                                                ? gatewayService.colorIconIsTrue
                                                : gatewayService
                                                    .colorIconIsFalse,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: gatewayService.currentScreen == 1
                          ? StationList(gatewayModel: widget.gatewayModel)
                          : gatewayService.currentScreen == 2
                              ? const TimeList()
                              : GatewayReport(
                                  cs: cardSize,
                                  gatewayModel: widget.gatewayModel),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        child: SizedBox(
                          height: 60,
                          width: 250,
                          child: gatewayService.currentScreen == 1
                              ? ElevatedButton(
                                  onPressed: () {
                                    /*pushNewScreen(
                                    context,
                                    screen: NewStation(widget.gatewayModel),
                                    withNavBar: true,
                                    // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );*/
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
                                              Global.greensec,
                                              Global.greenspri
                                            ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: 300,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'NOVA ESTAÇÃO',
                                        style: TextStyle(
                                            fontFamily: 'Schyler',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              : gatewayService.currentScreen == 2
                                  ? ElevatedButton(
                                      onPressed: () {
                                        /*   pushNewScreen(
                                        context,
                                        screen: NewTime(),
                                        withNavBar: true,
                                        // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );*/
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
                                                  Global.greensec,
                                                  Global.greenspri
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          width: 300,
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'NOVO HORÁRIO',
                                            style: TextStyle(
                                                fontFamily: 'Schyler',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
