import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iris/models/auth/auth_model.dart';
import 'package:iris/service/user/auth.dart';
import 'package:iris/utilities/constants.dart';

import '../routes.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Auth auth = Auth();

  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      body: SingleChildScrollView(
        reverse: false,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.25,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(6, 64, 49, 1),
                      Color.fromRGBO(0, 119, 84, 1),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      "assets/image/circuit.png",
                      color: Colors.greenAccent,
                      height: height * 0.35,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Registro',
                        style: TextStyle(
                            fontFamily: 'Schyler',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameTEC,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      hintText: "Nome",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: emailTEC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock_outline),
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: passwordTEC,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock_outline),
                        hintText: "Senha",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: () => auth.signUp(AuthModel(emailTEC.text,
                          passwordTEC.text, nameTEC.text, context)),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 119, 84, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            'CRIAR CONTA',
                            style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Ou crie pelo',
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Colors.black.withOpacity(0.3),
                          fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            radius: kSpacingUnit.w * 3,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                const AssetImage("assets/icon/google.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            radius: kSpacingUnit.w * 3,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                const AssetImage("assets/icon/facebook.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'Já tem uma conta?',
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black.withOpacity(0.3),
                              fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextButton(
                          child: Text(
                            'Entrar.',
                            style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.green.withOpacity(0.7),
                                fontSize: 15),
                          ),
                          onPressed: () => Modular.to.pushNamed(Routes.login),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
