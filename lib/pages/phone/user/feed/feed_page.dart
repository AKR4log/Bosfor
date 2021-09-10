import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: true,
                    elevation: 0,
                    // centerTitle: true,
                    // title: Text(
                    //   'Bosfor',
                    //   style: TextStyle(color: Colors.black, fontSize: 17),
                    // ),
                    backgroundColor: Colors.transparent,
                    expandedHeight: 100,
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
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            AppLocalizations.of(context).translate('h_market'),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(context).translate('h_auto'),
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
          body: TabBarView(
            children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
