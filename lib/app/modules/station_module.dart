import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/station/station.dart';

class StationModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, args) => Station(
                  stationModel: args.data,
                )),
      ];
}
