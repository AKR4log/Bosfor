import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/pages/phone/user/feed/property/list_all_property_applications.dart';
import 'package:kz/pages/phone/user/feed/transport/list_all_transport_applications.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  FeedPage(
      {Key key,
      GlobalKey<ScaffoldState> scaffoldKey,
      GlobalKey<RefreshIndicatorState> refreshIndicatorKey})
      : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        actions: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search_rounded,
                                        color: Colors.black))
                              ],
                            ),
                          )
                        ],
                        backgroundColor: Colors.white,
                        bottom: TabBar(
                          indicatorColor: Colors.black26,
                          automaticIndicatorColorAdjustment: true,
                          isScrollable: true,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_market'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_auto'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_property'),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          'Bosfor',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return StreamProvider<List<MarketApplication>>.value(
                        value: FeedState().allMarketApplications,
                        child: ListMarketApplications(),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return StreamProvider<List<TransportApplication>>.value(
                        value: FeedState().allTransportApplications,
                        child: ListTransportApplications(),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return StreamProvider<List<PropertyApplication>>.value(
                        value: FeedState().allPropertyApplications,
                        child: ListPropertyApplications(),
                      );
                    },
                  ),
                ),
              ]))),
    );
  }
}
