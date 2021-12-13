import 'package:awesome_select/awesome_select.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/report/gate_report.dart';
import 'package:iris/utilities/globals.dart';
import 'package:iris/utilities/widget/date_report.dart';

class GatewayReport extends StatefulWidget {
  final double cs;
  final GatewayModel gatewayModel;

  const GatewayReport({Key? key, required this.cs, required this.gatewayModel})
      : super(key: key);

  @override
  _GatewayReportState createState() => _GatewayReportState();
}

class _GatewayReportState extends State<GatewayReport> {
  GateReport gateReport = GateReport();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;
    double dividerw = (width - 40) * 0.8;
    double card = height - 50 - widget.cs - 270;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: card,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        gateReport.state,
                        style: TextStyle(
                            fontFamily: 'Schyler',
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 17),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: SizedBox(
                        width: dividerw,
                        child: gateReport.isProcessing
                            ? const LinearProgressIndicator(
                                backgroundColor: Global.white,
                              )
                            : const Divider(),
                      ),
                    ),
                  ),
                  SmartSelect<String>.multiple(
                    title: 'Selecione os dias',
                    choiceType: S2ChoiceType.chips,
                    onChange: (selected) =>
                        setState(() => gateReport.sid = selected!.value!),
                    choiceItems: gateReport.sids,
                    modalType: S2ModalType.popupDialog,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        onTap: () async {
                          List<DateTime>? day =
                              await showDialog<List<DateTime>>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const DatePikerReport();
                                  });
                          if (day != null) gateReport.date = day;
                        },
                        value: Text(
                          gateReport.date.isEmpty
                              ? 'Nenhum dia selecionado'
                              : gateReport.daysl().toString(),
                          style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        isTwoLine: true,
                        leading: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: const Icon(
                              CommunityMaterialIcons.access_point_network),
                        ),
                      );
                    },
                  ),
                  SmartSelect<String>.multiple(
                    title: 'Selecione as Estações',
                    onChange: (selected) => gateReport.sid = selected!.title!,
                    choiceItems: gateReport.sids,
                    choiceType: S2ChoiceType.chips,
                    modalType: S2ModalType.popupDialog,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        value: Text(
                          gateReport.sid.isEmpty
                              ? 'Nenhuma Estação selecionada'
                              : gateReport.sid.toString(),
                          style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        isTwoLine: true,
                        leading: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: const Icon(
                              CommunityMaterialIcons.access_point_network),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      //generateNewDoc();
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
