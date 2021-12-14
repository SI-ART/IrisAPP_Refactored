import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/station/station/stationvalve/station_valve.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class StationValve extends StatefulWidget {
  final StationModel stationModel;
  const StationValve({Key? key, required this.stationModel}) : super(key: key);

  @override
  _StationValveState createState() => _StationValveState();
}

class _StationValveState extends State<StationValve> {
  late StreamSubscription _onUpdateStatus;
  StationValveService stationValveService = StationValveService();
  @override
  void initState() {
    stationValveService
        .getStatusStream(widget.stationModel.idS, widget.stationModel.id,
            stationValveService.onStatusUpdate)
        .then((StreamSubscription s) => _onUpdateStatus = s);
    super.initState();
  }

  @override
  void dispose() {
    _onUpdateStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    stationValveService.status
                        ? 'A estação está Ligada'
                        : 'A estação está Desligada',
                    style: const TextStyle(
                        fontFamily: 'Schyler',
                        color: Colors.black45,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    stationValveService.setOnDatabase(widget.stationModel);
                  },
                  elevation: 2.0,
                  fillColor: stationValveService.status
                      ? Colors.red
                      : Global.greenspri,
                  child: const Icon(
                    LineAwesomeIcons.power_off,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
