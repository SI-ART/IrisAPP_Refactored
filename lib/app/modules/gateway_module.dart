import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/gateway/gatewaylist.dart';
import 'package:iris/app/screens/routes.dart';

class GatewayModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Routes.gateway, child: (_, args) => const GatewayList()),
      ];
}
