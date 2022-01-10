import 'package:flutter/material.dart';
import 'package:iris/models/station/station_model.dart';
import 'package:iris/service/station/config/alert_delete_service.dart';
import 'package:iris/utilities/constants.dart';

class AlertDeleteStation extends StatefulWidget {
  final StationModel stationModel;
  const AlertDeleteStation({Key? key, required this.stationModel})
      : super(key: key);

  @override
  _AlertDeleteStationState createState() => _AlertDeleteStationState();
}

class _AlertDeleteStationState extends State<AlertDeleteStation> {
  AlertDeleteService alertDeleteService = AlertDeleteService();

  @override
  void initState() {
    alertDeleteService.checkBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Atenção !!!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Schyler',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Você está preste a remover esta Estação, para confirmar digite ${widget.stationModel.nameS}.',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Schyler',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: alertDeleteService.nameController,
                decoration:
                    InputDecoration(hintText: widget.stationModel.nameS),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          if (alertDeleteService
                                  .nameController.text.isNotEmpty &&
                              alertDeleteService.nameController.text ==
                                  widget.stationModel.nameS) {
                            alertDeleteService.delete(widget.stationModel);
                          }
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 30,
            child: Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
