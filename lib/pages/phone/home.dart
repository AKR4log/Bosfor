import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kz/pages/phone/user/bookmarks/bookmarks.dart';
import 'package:kz/pages/phone/user/chat/chats.dart';
import 'package:kz/pages/phone/user/creation/creation_application.dart';
import 'package:kz/pages/phone/user/feed/feed_page.dart';
import 'package:http/http.dart' as http;
import 'package:kz/pages/phone/user/profile/profile.dart';
import 'package:kz/tools/state/app_state.dart';
import 'package:kz/tools/widgets/custom/nav/bottom_bar_navigation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int pageIndex = 0;

  Widget _body() {
    return SafeArea(
      child: _getPage(Provider.of<AppState>(context).pageIndex),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('Remote ' + message.toString());
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.instance
        .subscribeToTopic('${FirebaseAuth.instance.currentUser.uid}');

    FirebaseMessaging.instance.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'pushToken': token});
    }).catchError((err) {
      print(err.message.toString());
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'bosfor',
              'com.bosfor.kz',
              'com.bosfor.kzss',
              icon: 'push_notification',
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;
      case 1:
        return BookmarksPage(scaffoldKey: _scaffoldKey);
        break;
      case 2:
        return CreationApplication();
        break;
      case 3:
        return ChatTab();
        break;
      case 4:
        return ProfilePage(
            scaffoldKey: _scaffoldKey,
            profileId: FirebaseAuth.instance.currentUser.uid);
        break;
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomMenubar(),
        body: _body(),
      ),
    );
  }
}
