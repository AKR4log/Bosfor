// ignore_for_file: unnecessary_statements

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';

class EditScreenMarket extends StatefulWidget {
  final String uidApp;
  EditScreenMarket({Key key, this.uidApp}) : super(key: key);

  @override
  _EditScreenMarketState createState() => _EditScreenMarketState();
}

class _EditScreenMarketState extends State<EditScreenMarket> {
  TextEditingController cntrlPrice = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    cntrlPrice = TextEditingController();
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('llogo');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  createPush(body, title, uid) async {
    var bodys = {
      'notification': {'body': '$body', 'title': '$title'},
      'priority': 'high',
      'data': {
        'clickaction': 'FLUTTERNOTIFICATIONCLICK',
        'id': '1',
        'status': 'done'
      },
      'to': '/topics/$uid'
    };
    print(jsonEncode(bodys));
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(bodys),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAQc6iwA8:APA91bFDBfxC7vLQS4KuepsgMvxVSZP3NTH4GA2B8hyDmiXbDK5PZGRTRqLbVrl2KQA7cbb-clFo99JCjIOWyKrgVZwvHFcRXmR0453CuIl1Arfvo57V0XmiUfXqjQHC49QHHXYfkQ9D',
        }).then((response) {
      if (response.statusCode == 201) {
        print(response.body);
      } else {
        throw Exception('Failed auth');
      }
    });
  }

  @override
  void dispose() {
    cntrlPrice?.dispose();
    super.dispose();
  }

  modalBottomSheet(String name, Widget widget) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return DraggableScrollableActuator(
            child: DraggableScrollableSheet(
          minChildSize: 0.3,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return Column(
              children: [
                Container(
                  height: 5,
                  width: 75,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54.withOpacity(0.4)),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                widget,
              ],
            );
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            AppLocalizations.of(context).translate('h_edit'),
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => state.addArchiveMarket(context, widget.uidApp),
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  AppLocalizations.of(context).translate('h_add_archive'),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(prug(context,
                      'Данная технология требует рассмотрения от заказчика'));
                },
                icon: Icon(
                  Icons.trending_up_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  'Продвигать',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/EditPhoto/' + widget.uidApp);
                },
                icon: Icon(
                  Icons.camera_front_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  'Изменить фото',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () => modalBottomSheet(
                  'Изменить цену',
                  Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: textField(cntrlPrice, false,
                            isNumber: true,
                            hint: 'Введите новую цену',
                            onChanged: () {}),
                      ),
                      TextButton(
                          onPressed: () {
                            CollectionReference ref =
                                FirebaseFirestore.instance.collection("market");
                            cntrlPrice.text.length >= 1
                                ? state
                                    .editPrice(context, widget.uidApp,
                                        cntrlPrice.text.trim(),
                                        dbname: 'market')
                                    .then((val) => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(prug(
                                                  context, 'Успешно изменено'))
                                        })
                                : null;
                            ref
                                .doc(widget.uidApp)
                                .collection('notification')
                                .get()
                                .then((value) => value.docs.forEach((element) {
                                      createPush(
                                          'Изменение цены на избранный товар',
                                          'Цена на товар изменилась до ' +
                                              cntrlPrice.text.trim(),
                                          element.data()['uid']);
                                    }));
                            Navigator.pop(context);
                          },
                          child: Text('Изменить'))
                    ],
                  ),
                ),
                icon: Icon(
                  Icons.tag_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  'Изменить цену',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
