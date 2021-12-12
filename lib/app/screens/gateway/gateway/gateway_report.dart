import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';

class GatewayReport extends StatefulWidget {
  final double cs;
  final GatewayModel gatewayModel;

  const GatewayReport({Key? key, required this.cs, required this.gatewayModel})
      : super(key: key);

  @override
  _GatewayReportState createState() => _GatewayReportState();
}

class _GatewayReportState extends State<GatewayReport> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
