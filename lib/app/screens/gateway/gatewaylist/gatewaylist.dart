import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/settings/settings.dart';
import 'package:iris/service/initialize.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'comp/list_comp_gateway.dart';

class GatewayList extends StatefulWidget {
  const GatewayList({Key? key}) : super(key: key);

  @override
  _GatewayListState createState() => _GatewayListState();
}

class _GatewayListState extends State<GatewayList> {
  User user = User();
  @override
  void initState() {
    IrisInitialize().initIrisApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const Settings(),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 50),
                  child: Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Image(
                            image: const AssetImage(
                              'assets/icon/list.png',
                            ),
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Observer(
                              builder: (_) => Text(
                                'Olá ${user.userName}',
                                style: TextStyle(
                                    fontFamily: 'Schyler',
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Meus Gateways',
                    style: TextStyle(
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
                      'Seus Gateways',
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  ),
                ),
                const ListCompGate(),
                Visibility(
                  visible: true,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: SizedBox(
                        height: 50,
                        width: width * 0.6,
                        child: ElevatedButton(
                          onPressed: () =>
                              Modular.to.pushNamed('/gateway/newgate'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Global.greensec,
                                      Global.greenspri
                                    ]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: width * 0.6,
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'NOVO GATEWAY',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
