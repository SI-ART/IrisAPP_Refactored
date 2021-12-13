import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/station/station/stationvalve/station_valve.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class StationValve extends StatefulWidget {
  final GatewayModel gatewayModel;
  final StationModel stationModel;
  const StationValve(
      {Key? key, required this.gatewayModel, required this.stationModel})
      : super(key: key);

  @override
  _StationValveState createState() => _StationValveState();
}

class _StationValveState extends State<StationValve> {
  late StationValveService stationValveService;
  @override
  void initState() {
    stationValveService =
        StationValveService(widget.gatewayModel, widget.stationModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stationValveService.statusStream,
      builder: (context, status) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    status.data as bool
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
                    stationValveService.setOnDatabase();
                  },
                  elevation: 2.0,
                  fillColor:
                      status.data as bool ? Colors.red : Global.greenspri,
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
