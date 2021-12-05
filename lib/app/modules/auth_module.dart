import 'package:flutter_modular/flutter_modular.dart';
import 'package:iris/app/screens/auth/login.dart';
import 'package:iris/app/screens/auth/register.dart';
import 'package:iris/app/screens/auth/wellcome.dart';
import 'package:iris/app/screens/routes.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, args) => const Wellcome()),
        ChildRoute(Routes.login, child: (_, args) => const Login()),
        ChildRoute(Routes.register, child: (_, args) => const Register()),
      ];
}
