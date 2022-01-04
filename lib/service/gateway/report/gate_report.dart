// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:awesome_select/awesome_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/gateway/report/report.dart';
import 'package:iris/service/user/user.dart';
import 'package:mobx/mobx.dart';
import 'package:collection/collection.dart';

part 'gate_report.g.dart';

class GateReport = _GateReport with _$GateReport;

abstract class _GateReport with Store {
  List<DateTime> date = [];

  List<String> sid = [];

  List<String> dateSelected = [];

  //List<DataModel> dateModel = [];

  List<S2Choice<String>> sids = [];

  List<num> list = [];

  List<Map<DateTime, num>> temp = [];

  @observable
  bool isProcessing = false;

  List<num> avrg = [];

  List<num> max = [];

  List<num> min = [];

  Map<DateTime, List<num>> templist = {};

  final fs = FirebaseFirestore.instance
      .collection("Users")
      .doc(UserData.uid)
      .collection("Gateway");

  @observable
  String state = 'Configuração de relatório';

  void initReport(GatewayModel gatewayModel) {
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(UserData.uid)
        .child("Gateway")
        .child(gatewayModel.id)
        .child("Station")
        .onChildAdded
        .forEach((element) {
      sids.add(S2Choice<String>(
          value: element.snapshot.key!, title: element.snapshot.value["Name"]));
    });
  }

  @action
  Future<void> generateNewDoc(GatewayModel gatewayModel) async {
    isProcessing = true;
    state = "Preparando os Dados";
    await Future.delayed(const Duration(seconds: 1));
    await getData(gatewayModel);
    state = "Processandos os Dados";
    await Future.delayed(const Duration(seconds: 1));
    state = "Calculando as Métricas";
    calculate();
    await Future.delayed(const Duration(seconds: 1));
    state = "Prepando as planilhas";
    await Future.delayed(const Duration(seconds: 1));
    state = "Abrindo o relatório";
    await ReportDataService().generatExcel(dateSelected, avrg, min, max,
        gatewayModel.name.toUpperCase(), sids.first.title!.toUpperCase());
    isProcessing = false;
    state = "'Configuração de relatório'";
  }

  Future<void> getData(GatewayModel gatewayModel) async {
    List<num> a = [];
    for (int d = 0; d < date.length; d++) {
      dateSelected.add(date[d].day.toString() +
          '/' +
          date[d].month.toString() +
          '/' +
          date[d].year.toString());
      fs
          .doc(gatewayModel.id)
          .collection("Station")
          .doc(sids.first.value)
          .collection(date[d].year.toString())
          .doc(date[d].month.toString())
          .collection(date[d].day.toString())
          .snapshots()
          .listen((snap) {
        a = [];
        for (int i = 0; i < snap.docs.length; i++) {
          var data = snap.docs[i];
          a.add(data["temperature"]);
          templist[date[d]] = a;
        }
      });
    }
  }

  void calculate() {
    for (int i = 0; i < templist.length; i++) {
      var data = templist.values.elementAt(i);
      avrg.add(data.average);
      max.add(data.max);
      min.add(data.min);
    }
  }

  void newModel() {
    for (int i = 0; i < temp.length; i++) {
      var data = temp[i];
      for (int d = 0; d < data.length; d++) {
        list.add(data[i]!);
      }
    }
  }

  List<String> daysl() {
    List<String> day = [];
    for (var e in date) {
      day.add(e.day.toString());
    }
    return day;
  }
}
