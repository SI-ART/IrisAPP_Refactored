import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/station/station/station.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'data_station.dart';
import 'map_station.dart';
import 'station_valve.dart';

class Station extends StatefulWidget {
  final StationModel stationModel;
  const Station({Key? key, required this.stationModel}) : super(key: key);

  @override
  _StationState createState() => _StationState();
}

class _StationState extends State<Station> {
  StationService stationService = StationService();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    double freeScreen = width - 80;
    double cardSize = freeScreen / 3;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {},
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
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: height * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            widget.stationModel.urlImageS),
                      )),
                ),
              ],
            ),
          ),
          Observer(
            builder: (context) => SlidingSheet(
                elevation: 2,
                cornerRadius: 20,
                snapSpec: SnapSpec(
                    snap: false,
                    initialSnap: 1.0,
                    snappings: stationService.currentScreen == 3
                        ? [double.infinity, 1.0]
                        : [0.75, 1.0],
                    positioning: SnapPositioning.relativeToAvailableSpace),
                builder: (context, state) {
                  return Container(
                    color: Colors.white,
                    height: height,
                    child: Stack(
                      children: <Widget>[
                        stationService.currentScreen == 3
                            ? StationMap(cardSize, widget.stationModel)
                            : Container(),
                        Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 20),
                                  child: Text(
                                    widget.stationModel.nameS,
                                    style: const TextStyle(
                                        fontFamily: 'Schyler',
                                        color: Colors.black,
                                        fontSize: 24),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Descrição',
                                    style: TextStyle(
                                        fontFamily: 'Schyler',
                                        color: Global.black_opacity,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, bottom: 10),
                                    child: SizedBox(
                                      height: cardSize,
                                      width: cardSize,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        elevation: 5,
                                        child: Container(
                                          decoration:
                                              stationService.currentScreen == 1
                                                  ? stationService.colorsIsTrue
                                                  : stationService
                                                      .colorsIsFalse,
                                          child: InkWell(
                                            onTap: () {
                                              stationService.setScreen(1);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  LineAwesomeIcons
                                                      .broadcast_tower,
                                                  color: stationService
                                                              .currentScreen ==
                                                          1
                                                      ? stationService
                                                          .colorIconIsTrue
                                                      : stationService
                                                          .colorIconIsFalse,
                                                  size: 30,
                                                ),
                                                Text(
                                                  'Estação',
                                                  style: TextStyle(
                                                      fontFamily: 'Schyler',
                                                      color: stationService
                                                                  .currentScreen ==
                                                              1
                                                          ? stationService
                                                              .colorIconIsTrue
                                                          : stationService
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        elevation: 5,
                                        child: Container(
                                          decoration:
                                              stationService.currentScreen == 2
                                                  ? stationService.colorsIsTrue
                                                  : stationService
                                                      .colorsIsFalse,
                                          child: InkWell(
                                            onTap: () {
                                              stationService.setScreen(2);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  LineAwesomeIcons
                                                      .low_temperature,
                                                  color: stationService
                                                              .currentScreen ==
                                                          2
                                                      ? stationService
                                                          .colorIconIsTrue
                                                      : stationService
                                                          .colorIconIsFalse,
                                                  size: 30,
                                                ),
                                                Text(
                                                  'Dados',
                                                  style: TextStyle(
                                                      fontFamily: 'Schyler',
                                                      color: stationService
                                                                  .currentScreen ==
                                                              2
                                                          ? stationService
                                                              .colorIconIsTrue
                                                          : stationService
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 5,
                                      child: Container(
                                        decoration:
                                            stationService.currentScreen == 3
                                                ? stationService.colorsIsTrue
                                                : stationService.colorsIsFalse,
                                        child: InkWell(
                                          onTap: () {
                                            stationService.setScreen(3);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                LineAwesomeIcons.map_marked,
                                                color: stationService
                                                            .currentScreen ==
                                                        3
                                                    ? stationService
                                                        .colorIconIsTrue
                                                    : stationService
                                                        .colorIconIsFalse,
                                                size: 30,
                                              ),
                                              Text(
                                                'Localização',
                                                style: TextStyle(
                                                    fontFamily: 'Schyler',
                                                    color: stationService
                                                                .currentScreen ==
                                                            3
                                                        ? stationService
                                                            .colorIconIsTrue
                                                        : stationService
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
                              child: stationService.currentScreen == 1
                                  ? StationValve(
                                      stationModel: widget.stationModel)
                                  : stationService.currentScreen == 2
                                      ? StationData(
                                          cardSize, widget.stationModel)
                                      : Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
