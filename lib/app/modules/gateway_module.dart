import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/gateway/gatewaylist/gatewaylist.dart';

class GatewayModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, args) => const GatewayList()),
      ];
}
