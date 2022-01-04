import 'package:flutter/material.dart';
import 'package:iris/app/screens/settings/settings.dart';
import 'package:iris/utilities/globals.dart';

import 'gateway/gatewaylist/gatewaylist.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key}) : super(key: key);

  @override
  _BottomScreen createState() => _BottomScreen();
}

class _BottomScreen extends State<BottomScreen> {
  int _currentIndex = 0;
  final List<Widget> _telas = [
    const GatewayList(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedItemColor: Global.greenspri,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.network_check_outlined), label: "Network"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configurações"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
