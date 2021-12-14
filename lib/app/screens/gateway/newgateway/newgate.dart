import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iris/service/gateway/newgateway/newgateapi.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/widget/circlewavepainter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class NewGatewayAdd extends StatefulWidget {
  final NewGatewayService gatewayService;
  const NewGatewayAdd(this.gatewayService, {Key? key}) : super(key: key);
  @override
  _NewGatewayState createState() => _NewGatewayState();
}

class _NewGatewayState extends State<NewGatewayAdd>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController controller;
  double waveRadius = 0.0;
  double waveGap = 40.0;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;

    _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = _animation.value;
        });
      });

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              color: const Color.fromRGBO(249, 249, 249, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Novo Gateway',
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black,
                              fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Adicionar um novo Gateway',
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black.withOpacity(0.3),
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: height - 250,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FutureBuilder(
                                  future: UserData().userPic,
                                  initialData: "",
                                  builder: (BuildContext context,
                                          AsyncSnapshot<String> text) =>
                                      Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              text.data!,
                                            )),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                  future: UserData().userName,
                                  initialData: "",
                                  builder: (BuildContext context,
                                          AsyncSnapshot<String> text) =>
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 40, left: 20),
                                        child: Text(
                                          text.data!,
                                          style: const TextStyle(
                                              fontFamily: 'Schyler',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: width * 0.8,
                                child: TextFormField(
                                  controller: widget.gatewayService.nameGateway,
                                  decoration: InputDecoration(
                                      errorText: isUserNameValidate
                                          ? 'Insira uma nome'
                                          : null,
                                      border: InputBorder.none,
                                      labelText: 'Nome do Gateway',
                                      fillColor: const Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: width * 0.8,
                                child: TextFormField(
                                  controller: widget.gatewayService.descGateway,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Descrição (Opcional)',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: SizedBox(
                                  height: 50,
                                  width: width * 0.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // widget.gatewayService.test();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.greenAccent,
                                                Colors.blue
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        width: 300,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'CONFIRMAR',
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: widget.gatewayService.initScan ? buildSheet() : Container(),
        ),
      ],
    );
  }

  bool isUserNameValidate = false;

  Widget buildSheet() {
    return SlidingSheet(
      elevation: 8,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
          snap: true,
          snappings: [112, 400, double.infinity],
          positioning: SnapPositioning.pixelOffset),
      builder: (_, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: 300,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: CircleWavePainter(waveRadius),
          ),
        );
      },
      headerBuilder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: 56,
          width: double.infinity,
          child: Center(
            child: Text(
              widget.gatewayService.connectionText,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      },
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        isUserNameValidate = true;
      });
      return false;
    }
    setState(() {
      isUserNameValidate = false;
    });
    return true;
  }

  Future<void> start(BuildContext context) async {
    if (widget.gatewayService.nameGateway.text.isNotEmpty) {
      setState(() {
        widget.gatewayService.initScan = true;
      });
      widget.gatewayService.startScan(context);
    } else {
      validateTextField(widget.gatewayService.nameGateway.text);
    }
  }
}
