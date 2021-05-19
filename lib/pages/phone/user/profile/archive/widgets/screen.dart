import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/chat/screen_chat.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/pages/phone/user/feed/market/widget/list_similar_market.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/database/utility_database.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchiveWidgetContainerMarket extends StatefulWidget {
  final String uidMarket;
  ArchiveWidgetContainerMarket({Key key, this.uidMarket}) : super(key: key);

  @override
  _ArchiveWidgetContainerMarketState createState() =>
      _ArchiveWidgetContainerMarketState();
}

class _ArchiveWidgetContainerMarketState
    extends State<ArchiveWidgetContainerMarket> {
  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: StreamBuilder<MarketApplication>(
            stream: FeedState(uidApplicationMarket: widget.uidMarket)
                .marketApplication,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MarketApplication marketApplication = snapshot.data;
                return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverSafeArea(
                            top: false,
                            sliver: SliverAppBar(
                              leading: BackButton(
                                color: Colors.black,
                              ),
                              elevation: 0,
                              snap: true,
                              pinned: true,
                              floating: true,
                              backgroundColor: Colors.white,
                              title: Text(
                                marketApplication.m_heading,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Comfortaa"),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 85),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: marketApplication.m_photo,
                                    cacheManager: DefaultCacheManager(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholderFadeInDuration:
                                        Duration(milliseconds: 500),
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300].withOpacity(0.3),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 15, top: 10, left: 15, right: 15),
                                  margin: EdgeInsets.only(bottom: 10),
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                marketApplication
                                                            .m_negotiated_price !=
                                                        false
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'h_m_negotiated_price')
                                                    : marketApplication
                                                            .m_will_give_free !=
                                                        false
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'h_m_will_give_free')
                                                    : '₸${marketApplication.m_price}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                marketApplication.m_heading,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      marketApplication.m_phone != null
                                          ? GestureDetector(
                                              onTap: () => launch('tel://' +
                                                  marketApplication.m_phone),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text(
                                                  marketApplication.m_phone,
                                                  style: TextStyle(
                                                      color: Colors.blue[300],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      marketApplication.m_region != null ||
                                              marketApplication.m_address !=
                                                  null
                                          ? Container(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'h_def_location'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            )
                                          : SizedBox(),
                                      marketApplication.m_address != null
                                          ? GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                child: Text(
                                                  marketApplication.m_address,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      marketApplication.m_region != null &&
                                              marketApplication.m_address ==
                                                  null
                                          ? Container(
                                              child: Text(
                                                marketApplication.m_region,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 15, right: 15, top: 5),
                                  margin: EdgeInsets.only(bottom: 15),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'h_def_parameters'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(AppLocalizations.of(
                                                          context)
                                                      .translate(
                                                          'h_def_category')),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Text(
                                                      marketApplication
                                                                      .m_lower_category !=
                                                                  null &&
                                                              marketApplication
                                                                      .m_lower_category !=
                                                                  ''
                                                          ? marketApplication
                                                                  .m_average_category +
                                                              ',' +
                                                              marketApplication
                                                                  .m_upper_category +
                                                              ',' +
                                                              marketApplication
                                                                  .m_lower_category
                                                          : marketApplication
                                                                  .m_average_category +
                                                              ',' +
                                                              marketApplication
                                                                  .m_upper_category,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'h_def_description'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                                child: Text(
                                              marketApplication.m_description,
                                              maxLines: 10,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              color: Colors.blue.withOpacity(0.25),
                              height: 115,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('h_def_archive'),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          state.removeArchiveMarket(
                                              context, widget.uidMarket),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('h_def_restore'),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
              } else {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                              leading: BackButton(
                                color: Colors.black,
                              ),
                              elevation: 0,
                              snap: true,
                              pinned: true,
                              floating: true,
                              backgroundColor: Colors.white,
                              title: Container(
                                height: 25,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 125,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            Container(
                              width: double.infinity,
                              height: 25,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
