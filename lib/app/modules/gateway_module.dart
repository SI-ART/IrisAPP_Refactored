import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/bottom_navigation.dart';
import 'package:iris/app/screens/gateway/gateway/gateway.dart';
import 'package:iris/app/screens/gateway/gateway/gateway_config/gateway_config.dart';
import 'package:iris/app/screens/gateway/gatewaylist/gatewaylist.dart';
import 'package:iris/app/screens/gateway/newgateway/new_gateway.dart';
import 'package:iris/app/screens/routes.dart';
import 'package:iris/app/screens/station/new_station.dart';

class GatewayModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, args) => const GatewayList()),
        ChildRoute(Routes.newgate, child: (_, args) => NewGateway()),
        ChildRoute(Routes.gate,
            child: (_, args) => Gateway(
                  gatewayModel: args.data,
                )),
        ChildRoute(Routes.gateconfig,
            child: (_, args) => GatewayConfig(args.data)),
        ChildRoute(Routes.newstation,
            child: (_, args) => NewStation(args.data)),
      ];
}
