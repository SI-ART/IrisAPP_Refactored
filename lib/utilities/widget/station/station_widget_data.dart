// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

import '../../globals.dart';

class StationListInfos extends StatelessWidget {
  IconData? icon;
  double? width;
  double? height;
  String? data;
  double? sizeData;
  double? sizeIcon;
  double? sizedataType;
  String? dataType;
  Color? iconColor;
  Color? cardColor;
  VoidCallback? press;

  StationListInfos(
      {this.icon,
      this.width,
      this.height,
      this.data,
      this.sizeData,
      this.sizeIcon,
      this.dataType,
      this.sizedataType,
      this.iconColor,
      this.press,
      this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: cardColor,
        child: InkWell(
            onTap: press,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          icon,
                          color: iconColor,
                          size: sizeIcon,
                        ),
                        Text(
                          data!,
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black,
                              fontSize: sizeData),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      dataType!,
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Global.black_opacity,
                          fontSize: sizedataType),
                    ),
                  )),
                ],
              ),
            )));
  }
}
