import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/models/station/station_model.dart';

class StationData extends StatefulWidget {
  final double cardsize;
  final StationModel stationModel;
  final GatewayModel gatewayModel;

  const StationData(this.cardsize, this.stationModel, this.gatewayModel,
      {Key? key})
      : super(key: key);

  @override
  _StationDataState createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}