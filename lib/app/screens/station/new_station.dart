import 'package:flutter/material.dart';
import 'package:iris/models/gateway/gateway_model.dart';
import 'package:iris/service/station/new_station/new_station.dart';
import 'package:iris/utilities/globals.dart';
import 'package:iris/utilities/widget/circlewavepainter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class NewStation extends StatefulWidget {
  final GatewayModel gatewayModel;
  const NewStation(this.gatewayModel, {Key? key}) : super(key: key);

  @override
  _NewStationState createState() => _NewStationState();
}

class _NewStationState extends State<NewStation>
    with SingleTickerProviderStateMixin {
  NewStationService newStationService = NewStationService();

  @override
  void initState() {
    super.initState();
    newStationService.controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    newStationService.controller!.forward();

    newStationService.controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        newStationService.controller!.reset();
      } else if (status == AnimationStatus.dismissed) {
        newStationService.controller!.forward();
      }
    });
  }

  @override
  void dispose() {
    newStationService.stopScan();
    newStationService.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;

    void _showPicker() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Galeria'),
                        onTap: () {
                          newStationService.imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        newStationService.imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    newStationService.animation =
        Tween(begin: 0.0, end: newStationService.waveGap)
            .animate(newStationService.controller!)
          ..addListener(() {
            setState(() {
              newStationService.waveRadius = newStationService.animation!.value;
            });
          });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.west),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(249, 249, 249, 1.0),
        elevation: 0,
      ),
      body: Stack(
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
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 64,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, bottom: 20, right: 20),
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
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showPicker();
                                      },
                                      child: newStationService.isPicked
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                newStationService.image,
                                                width: 85,
                                                height: 85,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              width: 85,
                                              height: 85,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                      'assets/image/newimage.png',
                                                    )),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 40, left: 20),
                                        child: Text(
                                          'Nova Estação',
                                          style: TextStyle(
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
                                    controller: newStationService.nameStation,
                                    decoration: InputDecoration(
                                        errorText:
                                            newStationService.isUserNameValidate
                                                ? 'Insira uma nome'
                                                : null,
                                        border: InputBorder.none,
                                        labelText: 'Nome da Estação',
                                        fillColor: const Color(0xfff3f3f4),
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
                                        newStationService.start(
                                            context, widget.gatewayModel);
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
                                            'NOVA ESTACAO',
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
            child: newStationService.initScan ? buildSheet() : Container(),
          ),
        ],
      ),
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
            painter: CircleWavePainter(newStationService.waveRadius),
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
              newStationService.connectionText,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      },
    );
  }
}
