import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  final String profileId;
  UserScreen({Key key, this.profileId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _authUid = FirebaseAuth.instance.currentUser.uid;
  dynamic baseColor;

  colors() async {
    List<Color> _colorList = [
      Colors.pink[400],
      Colors.pinkAccent,
      Colors.red[400],
      Colors.redAccent,
      Colors.deepOrange[400],
      Colors.deepOrangeAccent,
      Colors.orange[800],
      Colors.orangeAccent[700],
      Colors.amber[900],
      Colors.lime[800],
      Colors.lightGreen[700],
      Colors.green[600],
      Colors.teal[400],
      Colors.cyan[600],
      Colors.lightBlue[600],
      Colors.lightBlueAccent[700],
      Colors.blue[600],
      Colors.blueAccent,
      Colors.indigo[400],
      Colors.indigoAccent,
      Colors.purple[400],
      Colors.purpleAccent[400],
      Colors.deepPurple[400],
      Colors.deepPurpleAccent,
      Colors.blueGrey[400],
      Colors.brown[400],
      Colors.grey[600],
    ];

    var hash = widget.profileId.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColor = _colorList[index];
    });
    return _colorList[index];
  }

  @override
  void initState() {
    colors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(color: Colors.black),
          backgroundColor: baseColor,
          centerTitle: true,
          title: Text(
            widget.profileId,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: StreamBuilder<UserData>(
            stream: FeedState(uidUser: widget.profileId).qUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            Container(
                                child: Row(
                              children: [
                                Text(
                                  userData.u_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  userData.u_surname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                              ],
                            )),
                            Container(
                                child: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('h_def_number_phone'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(userData.u_phone_number),
                              ],
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamProvider<List<MarketApplication>>.value(
                          value: FeedState(uidUser: widget.profileId)
                              .allMarketApplicationsUID,
                          child: ListMarketApplications(),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
