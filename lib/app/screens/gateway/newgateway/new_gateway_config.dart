import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/globals.dart';
import 'package:iris/utilities/widget/circlewavepainter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:iris/service/gateway/newgateway/new_gateway_service.dart';

class NewGatewayConfig extends StatefulWidget {
  final NewGatewayService newGatewayService;
  const NewGatewayConfig({Key? key, required this.newGatewayService})
      : super(key: key);

  @override
  _NewGatewayConfigState createState() => _NewGatewayConfigState();
}

class _NewGatewayConfigState extends State<NewGatewayConfig>
    with SingleTickerProviderStateMixin {
  User user = User();
  @override
  void initState() {
    super.initState();
    widget.newGatewayService.controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    widget.newGatewayService.controller!.forward();

    widget.newGatewayService.controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.newGatewayService.controller!.reset();
      } else if (status == AnimationStatus.dismissed) {
        widget.newGatewayService.controller!.forward();
      }
    });
  }

  @override
  void dispose() {
    widget.newGatewayService.stopScan();
    widget.newGatewayService.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;

    widget.newGatewayService.animation =
        Tween(begin: 0.0, end: widget.newGatewayService.waveGap)
            .animate(widget.newGatewayService.controller!)
          ..addListener(() {
            setState(() {
              widget.newGatewayService.waveRadius =
                  widget.newGatewayService.animation!.value;
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
                    children: const <Widget>[
                      Padding(
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
                        padding: EdgeInsets.only(left: 20),
                        child: Opacity(
                          opacity: 0.3,
                          child: Text(
                            'Adicionar um novo Gateway',
                            style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.black,
                                fontSize: 14),
                          ),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 20),
                                  child: Container(
                                    width: 85,
                                    height: 85,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            user.userPic,
                                          )),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40, left: 20),
                                      child: Text(
                                        user.userName,
                                        style: const TextStyle(
                                            fontFamily: 'Schyler',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
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
                                  controller:
                                      widget.newGatewayService.nameGateway,
                                  decoration: InputDecoration(
                                      errorText: widget.newGatewayService
                                              .isUserNameValidate
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
                                  controller:
                                      widget.newGatewayService.descGateway,
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
                                      widget.newGatewayService.start(context);
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
                                                Global.greensec,
                                                Global.greenspri
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
          child: widget.newGatewayService.initScan ? buildSheet() : Container(),
        ),
      ],
    );
  }

  Widget buildSheet() {
    return SlidingSheet(
      elevation: 8,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
          snap: true,
          snappings: [112, 400, double.infinity],
          positioning: SnapPositioning.pixelOffset),
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Global.greensec, Global.greenspri],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: 300,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: CircleWavePainter(widget.newGatewayService.waveRadius),
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
              widget.newGatewayService.connectionText,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      },
    );
  }
}
