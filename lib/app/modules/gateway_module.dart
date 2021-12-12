import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/gateway/gateway/gateway.dart';
import 'package:iris/app/screens/gateway/gatewaylist/gatewaylist.dart';
import 'package:iris/app/screens/gateway/newgateway/new_gateway.dart';
import 'package:iris/app/screens/routes.dart';

class GatewayModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, args) => const GatewayList()),
        ChildRoute(Routes.newgate, child: (_, args) => const NewGateWay()),
        ChildRoute(Routes.gate,
            child: (_, args) => Gateway(
                  gatewayModel: args.data,
                )),
      ];
}
