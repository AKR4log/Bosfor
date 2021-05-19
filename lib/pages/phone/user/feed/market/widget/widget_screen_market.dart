import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/pages/phone/user/chat/screen_chat.dart';
import 'package:kz/pages/phone/user/feed/market/list_all_market_applications.dart';
import 'package:kz/pages/phone/user/feed/market/widget/list_similar_market.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/database/utility_database.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetContainerMarket extends StatefulWidget {
  final String uidMarket;
  WidgetContainerMarket({Key key, this.uidMarket}) : super(key: key);

  @override
  _WidgetContainerMarketState createState() => _WidgetContainerMarketState();
}

class _WidgetContainerMarketState extends State<WidgetContainerMarket> {
  int iLiked = 0, iDLiked = 0;
  bool bLiked = false, bDLiked = false, verId = false;
  String uidLiked;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  verID() {
    FirebaseFirestore.instance
        .collection('market')
        .doc(widget.uidMarket)
        .get()
        .then((value) {
      if (value.data()['m_uid_user_by_application'] ==
          FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          verId = true;
        });
      }
    });
  }

  init() {
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.uidMarket)
        .collection('liked')
        .where('uidUser', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.docs.length >= 1) {
        setState(() {
          bLiked = true;
          uidLiked = value.docs.first.id;
        });
      }
    });
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.uidMarket)
        .collection('liked')
        .get()
        .then((snapshot) {
      if (snapshot.docs != null) {
        setState(() {
          iLiked = snapshot.docs.length;
        });
      }
    });
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.uidMarket)
        .collection('dliked')
        .where('uidUser', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.docs.length >= 1) {
        setState(() {
          bDLiked = true;
          uidLiked = value.docs.first.id;
        });
      }
    });
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.uidMarket)
        .collection('dliked')
        .get()
        .then((snapshot) {
      if (snapshot.docs != null) {
        setState(() {
          iDLiked = snapshot.docs.length;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    verID();
  }

  @override
  Widget build(BuildContext context) {
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
                              actions: [
                                verId
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          right: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () =>
                                                    Navigator.pushNamed(
                                                        context,
                                                        "/EditMarket/" +
                                                            widget.uidMarket),
                                                icon: Icon(
                                                    Icons.mode_edit_rounded,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
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
                                                    ? 'Договорная цена'
                                                    : marketApplication
                                                            .m_will_give_free !=
                                                        false
                                                    ? 'Отдам даром'
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
                                                'Местоположение',
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
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed('/UserScreen/' +
                                                marketApplication
                                                    .m_uid_user_by_application),
                                        child: Text(
                                          'Показать все объявления',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                      Center(
                                        child: Text('Оцените это объявление.'),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  TextButton.icon(
                                                      onPressed: () {
                                                        var state = Provider.of<
                                                                CloudFirestore>(
                                                            context,
                                                            listen: false);
                                                        !bDLiked && !bLiked
                                                            ? state
                                                                .likedMarket(
                                                                    context,
                                                                    widget
                                                                        .uidMarket)
                                                                .whenComplete(
                                                                    () {
                                                                setState(() {
                                                                  bLiked = true;
                                                                  iLiked++;
                                                                });
                                                              })
                                                            : bLiked
                                                            ? state
                                                                .removeLiked(
                                                                    context,
                                                                    widget
                                                                        .uidMarket,
                                                                    uidLiked)
                                                                .whenComplete(
                                                                    () {
                                                                setState(() {
                                                                  bLiked =
                                                                      false;
                                                                  iLiked--;
                                                                });
                                                              })
                                                            : null;
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .thumb_up_alt_rounded,
                                                        color: bLiked
                                                            ? Colors.green
                                                            : Colors.blue[400],
                                                      ),
                                                      label: Text(
                                                        iLiked.toString(),
                                                        style: TextStyle(
                                                            color: bLiked
                                                                ? Colors.green
                                                                : Colors
                                                                    .blue[400],
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  TextButton.icon(
                                                      onPressed: () {
                                                        var state = Provider.of<
                                                                CloudFirestore>(
                                                            context,
                                                            listen: false);
                                                        !bLiked && !bDLiked
                                                            ? state
                                                                .dLikedMarket(
                                                                    context,
                                                                    widget
                                                                        .uidMarket)
                                                                .whenComplete(
                                                                    () {
                                                                setState(() {
                                                                  bDLiked =
                                                                      true;
                                                                  iDLiked++;
                                                                });
                                                              })
                                                            : bDLiked
                                                            ? state
                                                                .removeDLiked(
                                                                    context,
                                                                    widget
                                                                        .uidMarket,
                                                                    uidLiked)
                                                                .whenComplete(
                                                                    () {
                                                                setState(() {
                                                                  bDLiked =
                                                                      false;
                                                                  iDLiked--;
                                                                });
                                                              })
                                                            : null;
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .thumb_down_alt_rounded,
                                                        color: bDLiked
                                                            ? Colors.green
                                                            : Colors.blue[400],
                                                      ),
                                                      label: Text(
                                                        iDLiked.toString(),
                                                        style: TextStyle(
                                                            color: bDLiked
                                                                ? Colors.green
                                                                : Colors
                                                                    .blue[400],
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                                'Параметры',
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
                                                  Text('Категория'),
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
                                                'Описание',
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
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      bottom: 5, left: 15, right: 15, top: 5),
                                  margin: EdgeInsets.only(bottom: 10),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Похожее',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        child: StreamProvider<
                                            List<MarketApplication>>.value(
                                          value: FeedState(
                                                  upperCategory:
                                                      marketApplication
                                                          .m_upper_category,
                                                  uidExclude: widget.uidMarket)
                                              .allSimilarMarketApplications,
                                          child:
                                              ListSilimarMarketApplications(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                      onPressed: () => launch(
                                          'tel://' + marketApplication.m_phone),
                                      child: Text(
                                        'Позвонить',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        var chatRoomId =
                                            getChatRoomIdByUsernames(
                                                FirebaseAuth
                                                    .instance.currentUser.uid,
                                                marketApplication
                                                    .m_uid_user_by_application);
                                        Map<String, dynamic> chatRoomInfoMap = {
                                          "users": [
                                            FirebaseAuth
                                                .instance.currentUser.uid,
                                            marketApplication
                                                .m_uid_user_by_application
                                          ]
                                        };
                                        DatabaseMethods().createChatRoom(
                                            chatRoomId, chatRoomInfoMap);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(marketApplication
                                                        .m_uid_user_by_application)));
                                      },
                                      child: Text(
                                        'Написать',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
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
