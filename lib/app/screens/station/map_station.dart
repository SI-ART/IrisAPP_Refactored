import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/utilities/widget/station/blowing_circle.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:iris/service/station/station/stationmap/station_map.dart';

class StationMap extends StatefulWidget {
  final double cardsize;
  final StationModel stationModel;

  const StationMap(this.cardsize, this.stationModel, {Key? key})
      : super(key: key);

  @override
  _StationMapState createState() => _StationMapState();
}

class _StationMapState extends State<StationMap>
    with SingleTickerProviderStateMixin {
  StationMapS stationMapS = StationMapS();
  late StreamSubscription _onUpdateMap;
  @override
  void initState() {
    stationMapS.animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    stationMapS
        .onMapListen(widget.stationModel.idS, widget.stationModel.id,
            stationMapS.onMapUpdate)
        .then((StreamSubscription s) => _onUpdateMap = s);

    stationMapS.animation = CurvedAnimation(
      parent: stationMapS.animationController!,
      curve: Curves.linear,
    );
    stationMapS.animationController!.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    _onUpdateMap.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Observer(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              height: height - 50,
              child: SfMapsTheme(
                data: SfMapsThemeData(
                  shapeHoverColor: Colors.transparent,
                ),
                child: SfMaps(
                  layers: <MapLayer>[
                    MapTileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/rastertiles/light_nolabels/{z}/{x}/{y}.png',
                      initialMarkersCount: stationMapS.maps.length,
                      zoomPanBehavior: stationMapS.zoomPanBehavior,
                      controller: stationMapS.mapController,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: stationMapS.maps[index].latitude,
                          longitude: stationMapS.maps[index].longitude,
                          child: index == 0
                              ? BlowingCircle(color: stationMapS.layerColor!)
                              : Icon(Icons.circle,
                                  color: stationMapS.layerColor, size: 15),
                        );
                      },
                      markerTooltipBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Gateway'),
                        );
                      },
                      tooltipSettings: const MapTooltipSettings(
                        color: Color.fromRGBO(45, 45, 45, 1),
                      ), /*
                    sublayers: <MapSublayer>[
                      MapArcLayer(
                        arcs: List<MapArc>.generate(
                          items.length,
                          (int index) {
                            return MapArc(
                              from: MapLatLng(-23.343953, -51.183709),
                              to: MapLatLng(items[index].latlng.latitude,
                                  items[index].latlng.longitude),
                              dashArray: _dashArray,
                              heightFactor: index == 5 &&
                                      MapLatLng(items[index].latlng.latitude,
                                              items[index].latlng.longitude) ==
                                          const MapLatLng(13.0827, 80.2707)
                                  ? 0.5
                                  : 0.2,
                              color: _layerColor,
                              width: 5.0,
                            );
                          },
                        ).toSet(),
                        animation: _animation,
                        tooltipBuilder: _tooltipBuilder,
                      ),
                    ],*/
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
