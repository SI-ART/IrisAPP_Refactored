// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:iris/app/screens/gateway/gateway/gateway_config/alert_delete_gateway.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/utilities/widget/gateway/iris_options.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class GatewayConfig extends StatefulWidget {
  final GatewayModel gatewayModel;

  const GatewayConfig(this.gatewayModel);

  @override
  _GatewayConfigState createState() => _GatewayConfigState();
}

class _GatewayConfigState extends State<GatewayConfig> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Configurações do Gateway',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Schyler',
          ),
        ),
        leading: TextButton(
          child: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => print('Voltar'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: <Widget>[
            IrisOptionList(
              icon: const Icon(FeatherIcons.edit2, size: 40.0),
              title: 'Nome',
              subtitle: 'Altere o nome do Gateway.',
              press: () {},
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(FeatherIcons.edit2, size: 40.0),
              title: 'Descrição',
              subtitle: 'Altere a descrição do Gateway.',
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(FeatherIcons.bell, size: 40.0),
              title: 'Notificações',
              subtitle: 'Altere a configurações de notificação do Gateway',
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(CommunityMaterialIcons.security, size: 40.0),
              title: 'Segurança',
              subtitle: 'Configuração de segurança do Gateway.',
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(FeatherIcons.users, size: 40.0),
              title: 'Tranferir Gateway',
              subtitle: 'Transferir propriedade do Gateway para outro usuário.',
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(CommunityMaterialIcons.refresh, size: 40.0),
              title: 'Resetar Gateway',
              subtitle: 'Apague todas a informações do Gateway',
            ),
            IrisOptionList(
              press: () {},
              icon: const Icon(CommunityMaterialIcons.block_helper, size: 40.0),
              title: 'Desativar Gateway',
              subtitle: 'Desative o Gateway Temporariamente',
            ),
            IrisOptionList(
              icon: const Icon(CommunityMaterialIcons.delete, size: 40.0),
              title: 'Deletar Gateway',
              subtitle: 'Delete este Gateway de sua conta.',
              press: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDelete(widget.gatewayModel);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
