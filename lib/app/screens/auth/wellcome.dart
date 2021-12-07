import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../routes.dart';

class Wellcome extends StatefulWidget {
  const Wellcome({Key? key}) : super(key: key);

  @override
  _WellcomeState createState() => _WellcomeState();
}

class _WellcomeState extends State<Wellcome> with TickerProviderStateMixin {
  final PageController controller = PageController(initialPage: 0);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final AnimationController _controllerb = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late Animation<double> _animation;
  late Animation<double> _animationb;

  @override
  void initState() {
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _animationb = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controllerb);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage('assets/image/wellcome.jpg'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.green.withOpacity(0.3),
          ),
          FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Image.asset(
                      "assets/icon/icon.png",
                      scale: 5,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Olá, está é a Iris',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Schyler',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'A Iris Irá ajudar você a gerencia sua plantação, fornecendo dados vitais para você monitora sua plantação, e sem contar que você pode irrigar suas platações em qualquer lugar do mundo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Schyler',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      _controller.reset();
                      _controllerb.forward();
                    },
                    child: const Icon(
                      Icons.east_sharp,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          FadeTransition(
            opacity: _animationb,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Image.asset(
                      "assets/icon/icon.png",
                      scale: 5,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Já Tem uma Conta? Então faça login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Schyler',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () => Modular.to.pushNamed(Routes.login),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.greenAccent, Colors.blue]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          'ENTRAR',
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
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Não tem uma Conta? Então crie uma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Schyler',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () => Modular.to.pushNamed(Routes.register),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.greenAccent, Colors.blue]),
                          borderRadius: BorderRadius.circular(40)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
