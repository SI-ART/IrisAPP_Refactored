// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iris/app/screens/settings/profile_list_item.dart';
import 'package:iris/service/user/auth.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/constants.dart';
import 'package:iris/utilities/globals.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User settings = User();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return SizedBox(
      width: width * 0.8,
      child: Drawer(
        child: Material(
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Global.greensec, Global.greenspri],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Global.greenspri.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Observer(
                        builder: (_) => Padding(
                          padding: EdgeInsets.only(
                              right: 30,
                              left: 30,
                              bottom: 30,
                              top: height * 0.15),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: kSpacingUnit.w * 3,
                                backgroundImage: settings.userPic == ''
                                    ? const AssetImage(
                                        'assets/image/unknown-user.jpg',
                                      )
                                    : CachedNetworkImageProvider(
                                        settings.userPic) as ImageProvider,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      settings.userName,
                                      style: const TextStyle(
                                          fontFamily: 'Schyler',
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      settings.userEmail,
                                      style: const TextStyle(
                                          fontFamily: 'Schyler',
                                          color: Colors.white,
                                          fontSize: 15),
                                    ),
                                  ],
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
              const SizedBox(height: 20),
              ProfileListItem(
                text: "Minha Conta",
                icon: LineAwesomeIcons.user,
                press: () {},
              ),
              ProfileListItem(
                text: "Onde Comprar",
                icon: LineAwesomeIcons.shopping_bag,
                press: () {},
              ),
              ProfileListItem(
                text: "Configurações",
                icon: LineAwesomeIcons.cog,
                press: () {},
              ),
              ProfileListItem(
                text: "Ajuda e Suporte",
                icon: LineAwesomeIcons.question_circle,
                press: () {},
              ),
              ProfileListItem(
                text: "Sair",
                icon: LineAwesomeIcons.alternate_sign_out,
                press: () => Auth().signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
