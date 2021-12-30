import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kz/tools/database/database.dart';
import 'package:local_auth/local_auth.dart';
import 'package:kz/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notification = true, fingerprint = false;
  final LocalAuthentication auth = LocalAuthentication();

  notificationVoid() {
    FirebaseMessaging.instance.deleteToken();
    setState(() {
      notification = !notification;
    });
  }

  Future<void> _checkBiometrics(BuildContext context) async {
    bool canCheckBiometrics;

    var state = Provider.of<CloudFirestore>(context, listen: false);
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      state.onLocalAuth();
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;
  }

  init(bool value) async {
    List<BiometricType> availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      if (!value) {
        LocalAuthentication()
            .stopAuthentication()
            .whenComplete(() => setState(() {
                  fingerprint = false;
                }));
      } else {
        LocalAuthentication()
            .authenticate(
                localizedReason: 'Please authenticate to show account',
                biometricOnly: true)
            .whenComplete(() => setState(() {
                  fingerprint = true;
                }));
      }
    } else {
      setState(() {
        fingerprint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: 100,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    pinned: true,
                    flexibleSpace: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15, left: 25),
                        child: Text(
                          AppLocalizations.of(context).translate('h_settings'),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Уведомление',
                  ),
                  leading: Switch(
                    value: notification,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (bool value) {
                      notificationVoid();
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Биометрия',
                  ),
                  leading: Switch(
                    value: fingerprint,
                    activeColor: Color(0xFF6200EE),
                    onChanged: (bool value) {
                      init(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
