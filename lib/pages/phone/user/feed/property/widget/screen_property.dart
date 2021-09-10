import 'dart:math';
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
import 'package:kz/pages/phone/user/feed/review/reviews_list.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/database/utility_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/models/applications/reviews.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetContainerProperty extends StatefulWidget {
  static var routeName = '/cnt_property';
  final String uidProperty;
  WidgetContainerProperty({Key key, this.uidProperty}) : super(key: key);

  @override
  _WidgetContainerPropertyState createState() =>
      _WidgetContainerPropertyState();
}

class _WidgetContainerPropertyState extends State<WidgetContainerProperty> {
  int iLiked = 0, iDLiked = 0;
  bool bLiked = false, bDLiked = false, verId = false;
  String uidLiked, uidUser;
  PageController controllerPage;
  TextEditingController cntrllrReview = TextEditingController();

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  verID() {
    FirebaseFirestore.instance
        .collection('property')
        .doc(widget.uidProperty)
        .get()
        .then((value) {
      setState(() {
        uidUser = value.data()['uid_user'];
      });
      if (value.data()['uid_user'] == FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          verId = true;
        });
      }
    });
  }

  init() {
    FirebaseFirestore.instance
        .collection("property")
        .doc(widget.uidProperty)
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
        .collection("property")
        .doc(widget.uidProperty)
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
        .collection("property")
        .doc(widget.uidProperty)
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
        .collection("property")
        .doc(widget.uidProperty)
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
  void dispose() {
    cntrllrReview.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controllerPage = PageController(initialPage: 0, viewportFraction: 0.955);
    colors();
    init();
    verID();
    cntrllrReview = TextEditingController();
  }

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

    var hash = widget.uidProperty.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColor = _colorList[index];
    });
    return _colorList[index];
  }

  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 135.0;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 55.0;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }
    return _kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<PropertyApplication>(
            stream: FeedState(
                    uidApplicationMarket:
                        kIsWeb ? args.message : widget.uidProperty)
                .propertyApplication,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PropertyApplication marketApplication = snapshot.data;
                List<String> images = [
                  marketApplication.p_photo_1,
                  if (marketApplication.p_photo_2 != null)
                    marketApplication.p_photo_2,
                  if (marketApplication.p_photo_3 != null)
                    marketApplication.p_photo_3,
                  if (marketApplication.p_photo_4 != null)
                    marketApplication.p_photo_4,
                  if (marketApplication.p_photo_5 != null)
                    marketApplication.p_photo_5,
                ];
                return NestedScrollView(
                    controller: _scrollController,
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
                              expandedHeight: kExpandedHeight,
                              floating: false,
                              pinned: true,
                              stretch: true,
                              onStretchTrigger: () {
                                // Function callback for stretch
                                print('true stretch');
                                return;
                              },
                              flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.parallax,
                                  centerTitle: false,
                                  stretchModes: <StretchMode>[
                                    StretchMode.zoomBackground,
                                    StretchMode.blurBackground,
                                    StretchMode.fadeTitle,
                                  ],
                                  titlePadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 0),
                                  title: ValueListenableBuilder(
                                    valueListenable: _titlePaddingNotifier,
                                    builder: (context, value, child) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: value),
                                        child: Container(
                                          // color: Colors.yellow,
                                          height: 44,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                marketApplication.p_head,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '₸${marketApplication.p_price}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  background: Container(color: Colors.white)),
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
                                                            widget.uidProperty),
                                                icon: Icon(
                                                    Icons.mode_edit_rounded,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      margin: kIsWeb
                          ? EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.25)
                          : EdgeInsets.zero,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(bottom: 85, top: 15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: PageView.builder(
                                        physics: BouncingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics()),
                                        itemCount: images.length,
                                        allowImplicitScrolling: true,
                                        controller: controllerPage,
                                        itemBuilder: (context, position) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: CachedNetworkImage(
                                                imageUrl: images[position],
                                                cacheManager:
                                                    DefaultCacheManager(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: kIsWeb
                                                            ? BoxFit.fitWidth
                                                            : BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                placeholderFadeInDuration:
                                                    Duration(milliseconds: 500),
                                                placeholder: (context, url) =>
                                                    Container(
                                                  color: Colors.grey[300]
                                                      .withOpacity(0.3),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  marketApplication.p_country_city != null
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                marketApplication
                                                        .p_country_city +
                                                    ', ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                getChatTime(
                                                    context,
                                                    marketApplication
                                                        .date_creation_application),
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                  verId
                                      ? Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromRGBO(
                                                                255,
                                                                221,
                                                                97,
                                                                1)),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    )),
                                                  ),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(prug(
                                                            context,
                                                            'Данная технология требует рассмотрения от заказчика'));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          'Покрасить объявление',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.40),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons
                                                                .invert_colors_rounded,
                                                            size: 18,
                                                            color: Colors.black,
                                                          ))),
                                                    ],
                                                  )),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromRGBO(
                                                                255,
                                                                221,
                                                                97,
                                                                1)),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    )),
                                                  ),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(prug(
                                                            context,
                                                            'Данная технология требует рассмотрения от заказчика'));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        child: Text(
                                                          'Продвигать',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.40),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons
                                                                .trending_up_rounded,
                                                            size: 18,
                                                            color: Colors.black,
                                                          ))),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    width: double.infinity,
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  StreamBuilder<UserData>(
                                      stream: FeedState(uidUser: uidUser).qUser,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          UserData userData = snapshot.data;
                                          return TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed(
                                                    '/UserScreen/' +
                                                        marketApplication
                                                            .uid_user),
                                            child: Container(
                                              height: 55,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          userData.u_name,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          'Показать все объявления',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  userData.u_uri_avatars !=
                                                              null &&
                                                          userData.u_uri_avatars !=
                                                              ''
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(45),
                                                          child: Container(
                                                            width: 55,
                                                            height: 55,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: userData
                                                                  .u_uri_avatars,
                                                              cacheManager:
                                                                  DefaultCacheManager(),
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholderFadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                color: Colors
                                                                    .grey[300]
                                                                    .withOpacity(
                                                                        0.3),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          child: Container(
                                                            width: 55,
                                                            height: 55,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    baseColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40)),
                                                            child: Center(
                                                              child: Text(
                                                                  (userData.u_surname != ''
                                                                          ? userData.u_name[0] +
                                                                              userData.u_surname[
                                                                                  0]
                                                                          : userData.u_name[
                                                                              0])
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),

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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                                        .p_lower_category !=
                                                                    null &&
                                                                marketApplication
                                                                        .p_lower_category !=
                                                                    ''
                                                            ? AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        marketApplication
                                                                            .p_average_category) +
                                                                ',' +
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        marketApplication
                                                                            .p_lower_category)
                                                            : AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_average_category),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              marketApplication.p_condition !=
                                                          null &&
                                                      marketApplication
                                                              .p_condition !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Состояние'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_condition)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_telephone !=
                                                          null &&
                                                      marketApplication
                                                              .p_telephone !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Телефон'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_telephone)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_internet !=
                                                          null &&
                                                      marketApplication
                                                              .p_internet !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Интернет'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_internet)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_bathroom !=
                                                          null &&
                                                      marketApplication
                                                              .p_bathroom !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Санузел'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_bathroom)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_balcony !=
                                                          null &&
                                                      marketApplication
                                                              .p_balcony !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Балкон'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_balcony)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_glazed_balcony !=
                                                          null &&
                                                      marketApplication
                                                              .p_glazed_balcony !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Балкон остеклён'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_glazed_balcony)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_door !=
                                                          null &&
                                                      marketApplication
                                                              .p_door !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Дверь'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_door)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_parking !=
                                                          null &&
                                                      marketApplication
                                                              .p_parking !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Парковка'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_parking)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_furniture !=
                                                          null &&
                                                      marketApplication
                                                              .p_furniture !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Мебель'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_furniture)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_floor !=
                                                          null &&
                                                      marketApplication
                                                              .p_floor !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Пол'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_floor)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_ceiling_height !=
                                                          null &&
                                                      marketApplication
                                                              .p_ceiling_height !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Высота потолков'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_ceiling_height)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_numbers_room !=
                                                          null &&
                                                      marketApplication
                                                              .p_numbers_room !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Количество комнат'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_numbers_room)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_building_type !=
                                                          null &&
                                                      marketApplication
                                                              .p_building_type !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Тип строения'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    marketApplication
                                                                        .p_building_type)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_year_built !=
                                                          null &&
                                                      marketApplication
                                                              .p_year_built !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Год постройки'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                                marketApplication
                                                                    .p_year_built),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_year_built !=
                                                          null &&
                                                      marketApplication
                                                              .p_year_built !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Этаж'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Row(
                                                              children: [
                                                                Text(marketApplication
                                                                    .p_floor_start),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                  child: Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'h_m_of')),
                                                                ),
                                                                Text(marketApplication
                                                                    .p_floor_end),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.p_total_area !=
                                                          null &&
                                                      marketApplication
                                                              .p_total_area !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Площадь (общая)'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                                marketApplication
                                                                    .p_total_area),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_living_space !=
                                                          null &&
                                                      marketApplication
                                                              .p_living_space !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Площадь (жилая)'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                                marketApplication
                                                                    .p_living_space),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication
                                                              .p_kitchen_square !=
                                                          null &&
                                                      marketApplication
                                                              .p_kitchen_square !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Площадь (кухня)'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                                marketApplication
                                                                    .p_kitchen_square),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Container(
                                                  child: Text(
                                                marketApplication.p_desc,
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
                                    margin: EdgeInsets.only(
                                      bottom: 15,
                                    ),
                                    child: !kIsWeb
                                        ? Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                    'Оцените это объявление.'),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                var state =
                                                                    Provider.of<
                                                                            CloudFirestore>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                !bDLiked &&
                                                                        !bLiked
                                                                    ? state
                                                                        .likedMarket(
                                                                            context,
                                                                            widget
                                                                                .uidProperty,
                                                                            dbname:
                                                                                'property')
                                                                        .whenComplete(
                                                                            () {
                                                                        setState(
                                                                            () {
                                                                          bLiked =
                                                                              true;
                                                                          iLiked++;
                                                                        });
                                                                      })
                                                                    : bLiked
                                                                        ? state
                                                                            .removeLiked(
                                                                                context,
                                                                                widget.uidProperty,
                                                                                uidLiked,
                                                                                dbname: 'property')
                                                                            .whenComplete(() {
                                                                            setState(() {
                                                                              bLiked = false;
                                                                              iLiked--;
                                                                            });
                                                                          })
                                                                        : null;
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .thumb_up_alt_rounded,
                                                                color: bLiked
                                                                    ? Colors
                                                                        .green
                                                                    : Colors.blue[
                                                                        400],
                                                              ),
                                                              label: Text(
                                                                iLiked
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: bLiked
                                                                        ? Colors
                                                                            .green
                                                                        : Colors.blue[
                                                                            400],
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                var state =
                                                                    Provider.of<
                                                                            CloudFirestore>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                !bLiked &&
                                                                        !bDLiked
                                                                    ? state
                                                                        .dLikedMarket(
                                                                            context,
                                                                            widget
                                                                                .uidProperty,
                                                                            dbname:
                                                                                'property')
                                                                        .whenComplete(
                                                                            () {
                                                                        setState(
                                                                            () {
                                                                          bDLiked =
                                                                              true;
                                                                          iDLiked++;
                                                                        });
                                                                      })
                                                                    : bDLiked
                                                                        ? state
                                                                            .removeDLiked(
                                                                                context,
                                                                                widget.uidProperty,
                                                                                uidLiked,
                                                                                dbname: 'property')
                                                                            .whenComplete(() {
                                                                            setState(() {
                                                                              bDLiked = false;
                                                                              iDLiked--;
                                                                            });
                                                                          })
                                                                        : null;
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .thumb_down_alt_rounded,
                                                                color: bDLiked
                                                                    ? Colors
                                                                        .green
                                                                    : Colors.blue[
                                                                        400],
                                                              ),
                                                              label: Text(
                                                                iDLiked
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: bDLiked
                                                                        ? Colors
                                                                            .green
                                                                        : Colors.blue[
                                                                            400],
                                                                    fontSize:
                                                                        16,
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
                                          )
                                        : SizedBox(),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: textFieldtwo(
                                              cntrllrReview, false, 'Ваш отзыв',
                                              isText: true, lines: 3),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (cntrllrReview.text.length >=
                                                  1) {
                                                var state =
                                                    Provider.of<CloudFirestore>(
                                                        context,
                                                        listen: false);
                                                state
                                                    .crtReview(
                                                        context,
                                                        'property',
                                                        marketApplication
                                                            .uid_property,
                                                        cntrllrReview.text
                                                            .trim())
                                                    .whenComplete(() =>
                                                        cntrllrReview.clear());
                                              }
                                            },
                                            child: Text('Оставить отзыв')),
                                        SizedBox(
                                          height: 400,
                                          child: StreamProvider<
                                              List<Review>>.value(
                                            value: FeedState(
                                                    uidApplications:
                                                        marketApplication
                                                            .uid_property)
                                                .allReviewsProperty,
                                            child: ReviewsList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   width: double.infinity,
                                  //   padding: EdgeInsets.only(
                                  //       bottom: 5, left: 15, right: 15, top: 5),
                                  //   margin: EdgeInsets.only(bottom: 10),
                                  //   color: Colors.white,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Container(
                                  //         child: Text(
                                  //           'Похожее',
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               fontSize: 16),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: MediaQuery.of(context)
                                  //                 .size
                                  //                 .height *
                                  //             0.65,
                                  //         child: StreamProvider<
                                  //             List<MarketApplication>>.value(
                                  //           value: FeedState(
                                  //                   upperCategory:
                                  //                       marketApplication
                                  //                           .m_upper_category,
                                  //                   uidExclude:
                                  //                       widget.uidMarket)
                                  //               .allSimilarMarketApplications,
                                  //           child:
                                  //               ListSilimarMarketApplications(),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Container(
                                  //   padding: EdgeInsets.symmetric(horizontal: 25),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.red[300],
                                  //     borderRadius: BorderRadius.circular(10),
                                  //   ),
                                  //   child: TextButton(
                                  //       onPressed: () => launch(
                                  //           'tel://' + marketApplication.m_phone),
                                  //       child: Text(
                                  //         'Позвонить',
                                  //         style: TextStyle(color: Colors.white),
                                  //       )),
                                  // ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
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
                                                  marketApplication.uid_user);
                                          Map<String, dynamic> chatRoomInfoMap =
                                              {
                                            "users": [
                                              FirebaseAuth
                                                  .instance.currentUser.uid,
                                              marketApplication.uid_user
                                            ]
                                          };
                                          DatabaseMethods().createChatRoom(
                                              chatRoomId, chatRoomInfoMap);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          marketApplication
                                                              .uid_user,
                                                          uidApp:
                                                              marketApplication
                                                                  .uid_property,
                                                          db: 'property')));
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
                      ),
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
