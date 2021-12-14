import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iris/service/gateway/gateway_list.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ListCompGate extends StatefulWidget {
  const ListCompGate({Key? key}) : super(key: key);

  @override
  _ListCompGateState createState() => _ListCompGateState();
}

class _ListCompGateState extends State<ListCompGate> {
  FirebaseGatewayRepository fgr = FirebaseGatewayRepository();

  final ref = FirebaseDatabase.instance
      .reference()
      .child("Users")
      .child(UserData.uid)
      .child("Gateway");

  @override
  void initState() {
    ref.onChildAdded.listen(fgr.onGatewayAdded);
    ref.onChildChanged.listen(fgr.onGatewayUpdated);
    ref.onChildRemoved.listen(fgr.onGatewayDeleted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: fgr.gates.length,
                    padding: const EdgeInsets.all(20.0),
                    itemBuilder: (_, position) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 110,
                            child: Card(
                              color: Global.card_colors,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 1,
                              child: InkWell(
                                onTap: () =>
                                    fgr.navigateToGateway(fgr.gates[position]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 9),
                                      child: Container(
                                        width: 85,
                                        height: 85,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'assets/image/gatewaylist.png',
                                              )),
                                          borderRadius: BorderRadius.all(
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
                                              top: 10, left: 20),
                                          child: Text(
                                            fgr.gates[position].name,
                                            style: const TextStyle(
                                                fontFamily: 'Schyler',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 20),
                                          child: Text(
                                            fgr.gates[position].desc == ''
                                                ? 'Não há nenhuma descrição'
                                                : fgr.gates[position].desc,
                                            style: const TextStyle(
                                                fontFamily: 'Schyler',
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.3),
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    fgr.gates[position].isOn == false
                                        ? const Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  LineAwesomeIcons
                                                      .exclamation_circle,
                                                  color: Colors.red,
                                                  size: 30),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
