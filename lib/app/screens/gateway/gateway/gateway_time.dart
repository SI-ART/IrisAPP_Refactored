// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iris/service/user/user.dart';

class TimeList extends StatefulWidget {
  const TimeList({Key? key}) : super(key: key);

  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  CollectionReference fs = FirebaseFirestore.instance
      .collection('Users')
      .doc(User().uid)
      .collection('Gateway')
      .doc('-MfxDSLybTci5FnmUf1z')
      .collection('Times');

  String tag = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fs.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData == false) {
          return const Center(
            child: Text('Nào há horarios programados'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Expanded(
          child: SizedBox(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            print(data['tag']);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 9),
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/image/gatewaylist.png')),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20),
                                    child: Text(
                                      data['tag'],
                                      style: const TextStyle(
                                          fontFamily: 'Schyler',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20),
                                    child: Text(
                                      data['tag'],
                                      style: const TextStyle(
                                          fontFamily: 'Schyler',
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                          fontSize: 12),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10, left: 20),
                                    child: Text(
                                      'Remover',
                                      style: TextStyle(
                                          fontFamily: 'Schyler',
                                          color:
                                              Color.fromRGBO(246, 114, 128, 1),
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
