import 'package:awesome_select/awesome_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/report/report.dart';
import 'package:iris/utilities/globals.dart';
import 'package:iris/utilities/widget/date_report.dart';
import 'package:collection/collection.dart';

class GatewayReport extends StatefulWidget {
  final double cs;
  final GatewayModel gatewayModel;

  const GatewayReport({Key? key, required this.cs, required this.gatewayModel})
      : super(key: key);

  @override
  _GatewayReportState createState() => _GatewayReportState();
}

class _GatewayReportState extends State<GatewayReport> {
  List<DateTime>? date;
  List<String>? sid;
  List<String>? dateSelected;
  List<S2Choice<String>> sids = [];
  List<num>? list;
  List<Map<DateTime, num>>? temp;

  bool isProcessing = false;

  List<num>? avrg;
  List<num>? max;
  List<num>? min;

  String state = 'Configuração de relatório';

  Map<DateTime, List<num>>? templist;

  final fs = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Gateway");

  @override
  void initState() {
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("Gateway")
        .child(widget.gatewayModel.id)
        .child("Station")
        .onChildAdded
        .forEach((element) {
      sids.add(S2Choice<String>(
          value: element.snapshot.key!, title: element.snapshot.value["Name"]));
    });
    sid = [];
    temp = [];
    templist = {};
    list = [];
    date = [];
    dateSelected = [];
    date = [];

    avrg = [];
    min = [];
    max = [];
    super.initState();
  }

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
                        state,
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
                        child: isProcessing
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
                        setState(() => sid = selected!.value),
                    choiceItems: sids,
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
                          if (day != null) setState(() => date = day);
                        },
                        value: Text(
                          date!.isEmpty
                              ? 'Nenhum dia selecionado'
                              : daysl().toString(),
                          style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        isTwoLine: true,
                        leading: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: const Icon(CommunityMaterialIcons.calendar),
                        ),
                      );
                    },
                  ),
                  SmartSelect<String>.multiple(
                    title: 'Selecione as Estações',
                    onChange: (selected) =>
                        setState(() => sid = selected!.title),
                    choiceItems: sids,
                    choiceType: S2ChoiceType.chips,
                    modalType: S2ModalType.popupDialog,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        value: Text(
                          sid!.isEmpty
                              ? 'Nenhuma Estação selecionada'
                              : sid.toString(),
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
                      generateNewDoc();
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

  Future<void> generateNewDoc() async {
    setState(() {
      isProcessing = true;
      state = "Preparando os Dados";
    });
    await Future.delayed(const Duration(seconds: 1));
    await getData();
    setState(() {
      state = "Processandos os Dados";
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      state = "Calculando as Métricas";
    });
    calculate();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      state = "Prepando as planilhas";
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      state = "Abrindo o relatório";
    });
    await ReportDataService().generatExcel(
        dateSelected!,
        avrg!,
        min!,
        max!,
        widget.gatewayModel.name.toUpperCase(),
        sids.first.title!.toUpperCase());
    setState(() {
      isProcessing = false;
      state = "Configuração de relatório";
    });
  }

  Future<void> getData() async {
    List<num> a = [];
    for (int d = 0; d < date!.length; d++) {
      dateSelected!.add(date![d].day.toString() +
          '/' +
          date![d].month.toString() +
          '/' +
          date![d].year.toString());

      fs
          .doc(widget.gatewayModel.id)
          .collection("Station")
          .doc(sids.first.value)
          .collection(date![d].year.toString())
          .doc('${date![d].month - 1}')
          .collection(date![d].day.toString())
          .snapshots()
          .listen((snap) {
        a = [];
        for (int i = 0; i < snap.docs.length; i++) {
          var data = snap.docs[i];
          a.add(data["temperature"]);
          templist![date![d]] = a;
        }
      });
    }
  }

  void calculate() {
    for (int i = 0; i < templist!.length; i++) {
      var data = templist!.values.elementAt(i);
      avrg!.add(data.average);
      max!.add(data.max);
      min!.add(data.min);
    }
  }

  void newModel() {
    for (int i = 0; i < temp!.length; i++) {
      var data = temp![i];
      for (int d = 0; d < data.length; d++) {
        list!.add(data[i]!);
      }
    }
  }

  List<String> daysl() {
    List<String> day = [];
    for (var e in date!) {
      day.add(e.day.toString());
    }
    return day;
  }
}
