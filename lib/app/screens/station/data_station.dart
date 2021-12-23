import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/station/station/stationdata/station_data.dart';
import 'package:iris/utilities/widget/station/station_widget_data.dart';

class StationData extends StatefulWidget {
  final double cardsize;
  final StationModel stationModel;
  const StationData(this.cardsize, this.stationModel, {Key? key})
      : super(key: key);

  @override
  _StationDataState createState() => _StationDataState();
}

class _StationDataState extends State<StationData> {
  StationDataService stationDataService = StationDataService();
  late StreamSubscription _onUpdateData;
  @override
  void initState() {
    stationDataService
        .getStatusStream(widget.stationModel.idS, widget.stationModel.id,
            stationDataService.onDataUpdate)
        .then((StreamSubscription s) => _onUpdateData = s);
    super.initState();
  }

  @override
  void dispose() {
    _onUpdateData.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double cardh = height - 60 - 48 - 100 - widget.cardsize;
    double cardheight = cardh / 4;
    final cardwidth = width - 60;
    final card = cardwidth / 2;

    return Observer(
      builder: (context) => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: StationListInfos(
                  width: card,
                  dataType: 'Temperatura',
                  sizedataType: 15,
                  press: () {},
                  height: cardheight,
                  icon: FontAwesomeIcons.thermometerThreeQuarters,
                  sizeIcon: 40,
                  iconColor: Colors.amber,
                  data: '${stationDataService.temp}C',
                  sizeData: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 30),
                child: StationListInfos(
                  width: card,
                  dataType: 'Umidade',
                  sizedataType: 15,
                  height: cardheight,
                  icon: CommunityMaterialIcons.water_percent,
                  sizeIcon: 50,
                  iconColor: Colors.blue,
                  data: '${stationDataService.humi}%',
                  sizeData: 30,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: StationListInfos(
                  width: card,
                  dataType: 'Água',
                  sizedataType: 15,
                  height: cardheight,
                  icon: CommunityMaterialIcons.water,
                  sizeIcon: 40,
                  iconColor: Colors.blue,
                  data: '20L',
                  sizeData: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: StationListInfos(
                  width: card,
                  dataType: 'Pressão do ar',
                  sizedataType: 15,
                  height: cardheight,
                  icon: FontAwesomeIcons.airFreshener,
                  sizeIcon: 40,
                  iconColor: Colors.deepPurple,
                  data: '1 ATM',
                  sizeData: 30,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: StationListInfos(
                  width: card,
                  dataType: 'Vento',
                  sizedataType: 15,
                  height: cardheight,
                  icon: CommunityMaterialIcons.weather_windy,
                  sizeIcon: 40,
                  iconColor: Colors.blue,
                  data: '15KM/H',
                  sizeData: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: StationListInfos(
                  width: card,
                  dataType: 'Chuva',
                  sizedataType: 15,
                  height: cardheight,
                  icon: FeatherIcons.cloudRain,
                  sizeIcon: 40,
                  iconColor: Colors.blueAccent,
                  data: '4%',
                  sizeData: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
