// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/utilities/widget/gateway/iris_options.dart';

import 'alert_delete_station.dart';

class Stationconfig extends StatefulWidget {
  final StationModel stationModel;

  Stationconfig(this.stationModel, {Key? key}) : super(key: key);

  @override
  _Stationconfig createState() => _Stationconfig();
}

class _Stationconfig extends State<Stationconfig> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Configurações do Estação',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Schyler',
          ),
        ),
        leading: TextButton(
          child: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: <Widget>[
            IrisOptionList(
              icon: const Icon(FeatherIcons.edit2, size: 40.0),
              title: 'Nome',
              subtitle: 'Altere o nome da Estação.',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(FeatherIcons.edit2, size: 40.0),
              title: 'Descrição',
              subtitle: 'Altere a descrição da Estação.',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(FeatherIcons.bell, size: 40.0),
              title: 'Notificações',
              subtitle: 'Altere a configurações de notificação da Estação',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(CommunityMaterialIcons.security, size: 40.0),
              title: 'Segurança',
              subtitle: 'Configuração de segurança da Estação.',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(FeatherIcons.users, size: 40.0),
              title: 'Tranferir Estação',
              subtitle: 'Transferir propriedade da Estação para outro usuário.',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(CommunityMaterialIcons.refresh, size: 40.0),
              title: 'Resetar Estação',
              subtitle: 'Apague todas a informações da Estação',
              press: () {},
            ),
            IrisOptionList(
              icon: const Icon(CommunityMaterialIcons.delete, size: 40.0),
              title: 'Deletar Estação',
              subtitle: 'Delete este Estação de sua conta.',
              press: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDeleteStation(
                      stationModel: widget.stationModel,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
