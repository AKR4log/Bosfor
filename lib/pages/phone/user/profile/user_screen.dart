import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/pages/phone/user/feed/property/list_all_property_applications.dart';
import 'package:kz/pages/phone/user/feed/transport/list_all_transport_applications.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/models/applications/transport.dart';
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
    return DefaultTabController(
      length: 3,
      child: StreamBuilder<UserData>(
        stream: FeedState(uidUser: widget.profileId).qUser,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white,
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverSafeArea(
                        top: false,
                        sliver: SliverAppBar(
                          pinned: true,
                          automaticallyImplyLeading: true,
                          elevation: 0,
                          // centerTitle: true,
                          leading: BackButton(
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.transparent,
                          expandedHeight: 100,
                          title: Text(
                            userData.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          bottom: TabBar(
                            indicatorColor: Colors.black,
                            indicatorWeight: 2,
                            labelColor: Colors.black,
                            labelStyle: TextStyle(fontSize: 25),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 15,
                            ),
                            unselectedLabelColor: Colors.black,
                            automaticIndicatorColorAdjustment: true,
                            isScrollable: true,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 25),
                            tabs: <Widget>[
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_market'),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_auto'),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_property'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          Expanded(
                            child:
                                StreamProvider<List<MarketApplication>>.value(
                              value: FeedState(uidUser: widget.profileId)
                                  .allMarketApplicationsUID,
                              child: ListMarketApplications(),
                            ),
                          ),
                          Expanded(
                            child: StreamProvider<
                                List<TransportApplication>>.value(
                              value: FeedState(uidUser: widget.profileId)
                                  .allAutoApplicationsUID,
                              child: ListTransportApplications(),
                            ),
                          ),
                          Expanded(
                            child:
                                StreamProvider<List<PropertyApplication>>.value(
                              value: FeedState(uidUser: widget.profileId)
                                  .allPropertyApplicationsUID,
                              child: ListPropertyApplications(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
