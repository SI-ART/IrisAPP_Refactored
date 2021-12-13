import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/modules/gateway_module.dart';
import 'package:iris/app/screens/routes.dart';

import 'modules/auth_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: AuthModule()),
        ModuleRoute(Routes.gateway, module: GatewayModule()),
        ModuleRoute(Routes.station, module: GatewayModule()),
      ];
}
