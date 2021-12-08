import 'package:flutter/material.dart';
import 'package:iris/service/auth/auth.dart';

import 'comp/list_comp_gateway.dart';

class GatewayList extends StatefulWidget {
  const GatewayList({Key? key}) : super(key: key);

  @override
  _GatewayListState createState() => _GatewayListState();
}

class _GatewayListState extends State<GatewayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: Auth().userPic,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Olá ${Auth().userName}',
                            style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 20),
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
                      fontFamily: 'Schyler', color: Colors.black, fontSize: 24),
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
            ],
          ),
        ],
      ),
    );
  }
}
