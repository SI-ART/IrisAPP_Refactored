import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/station/station_list/station_list.dart';
import 'package:iris/service/user/user.dart';

class StationList extends StatefulWidget {
  final GatewayModel gatewayModel;
  const StationList({Key? key, required this.gatewayModel}) : super(key: key);

  @override
  _StationListState createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  StationListService stationListService = StationListService();
  @override
  void initState() {
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(User().uid)
        .child("Gateway")
        .child(widget.gatewayModel.id)
        .child('Station')
        .onChildAdded
        .listen((event) {
      stationListService.onStationAdded(event, widget.gatewayModel);
    });

    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(User().uid)
        .child("Gateway")
        .child(widget.gatewayModel.id)
        .child('Station')
        .onChildRemoved
        .listen((event) {
      stationListService.onStationRemoved(event);
    });

    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(User().uid)
        .child("Gateway")
        .child(widget.gatewayModel.id)
        .child('Station')
        .onChildChanged
        .listen((event) {
      stationListService.onStationUpdated(event, widget.gatewayModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Expanded(
        child: SizedBox(
          child: stationListService.stations.isEmpty
              ? const Center(
                  child: Text(
                  'Você não tem nenhuma estação :(',
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25),
                ))
              : Column(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: stationListService.stations.length,
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                height: 110,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 5,
                                  child: Container(
                                    color: stationListService
                                            .stations[position].isSelectS
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Modular.to.pushNamed(Routes.station,
                                            arguments: stationListService
                                                .stations[position]);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 9),
                                            child: Container(
                                              width: 85,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: stationListService
                                                                .stations[
                                                                    position]
                                                                .urlImageS ==
                                                            ''
                                                        ? const AssetImage(
                                                            'assets/image/gatewaylist.png')
                                                        : CachedNetworkImageProvider(
                                                                stationListService
                                                                    .stations[
                                                                        position]
                                                                    .urlImageS)
                                                            as ImageProvider),
                                                borderRadius:
                                                    const BorderRadius.all(
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
                                                  stationListService
                                                      .stations[position].nameS,
                                                  style: const TextStyle(
                                                      fontFamily: 'Schyler',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 20),
                                                child: Text(
                                                  stationListService
                                                              .stations[
                                                                  position]
                                                              .isConnectedS &&
                                                          stationListService
                                                              .stations[
                                                                  position]
                                                              .isOnS
                                                      ? 'Conectada e Ativa'
                                                      : stationListService
                                                                  .stations[
                                                                      position]
                                                                  .isConnectedS &&
                                                              stationListService
                                                                      .stations[
                                                                          position]
                                                                      .isOnS ==
                                                                  false
                                                          ? 'Conectada e Inativa'
                                                          : stationListService
                                                                      .stations[
                                                                          position]
                                                                      .isConnectedS ==
                                                                  false
                                                              ? 'Desconectada'
                                                              : '',
                                                  style: const TextStyle(
                                                      fontFamily: 'Schyler',
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.3),
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: stationListService
                                                    .stations[position]
                                                    .networkIcon),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
        ),
      ),
    );
  }
}
