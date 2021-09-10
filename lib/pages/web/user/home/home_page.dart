import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/pages/phone/user/feed/property/list_all_property_applications.dart';
import 'package:kz/pages/phone/user/feed/transport/list_all_transport_applications.dart';
import 'package:kz/pages/web/user/bookmarks/bookmarks.dart';
import 'package:kz/pages/web/user/creation/creation_application.dart';
import 'package:kz/pages/web/user/messanger/chat/chats.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class HomeWebPage extends StatefulWidget {
  static var routeName = '/home';
  HomeWebPage({Key key}) : super(key: key);

  @override
  _HomeWebPageState createState() => _HomeWebPageState();
}

class _HomeWebPageState extends State<HomeWebPage> {
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
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(255, 221, 97, 1),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(HomeWebPage.routeName),
                          icon: Icon(
                            Icons.home_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebBookmarksPage.routeName),
                          icon: Icon(
                            Icons.favorite_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebCreationApplication.routeName),
                          icon: Icon(
                            Icons.add_circle_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(ChatTab.routeName),
                          icon: Icon(
                            Icons.near_me_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebProfilePage.routeName),
                          icon: Icon(
                            Icons.account_circle_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      )
                    ],
                    bottom: TabBar(
                      indicatorColor: Color.fromRGBO(143, 161, 180, 1),
                      automaticIndicatorColorAdjustment: true,
                      isScrollable: true,
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            AppLocalizations.of(context).translate('h_market'),
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(context).translate('h_auto'),
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('h_property'),
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                        // fontFamily: "Comfortaa",
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: TabBarView(
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
      ),
    );
  }
}
