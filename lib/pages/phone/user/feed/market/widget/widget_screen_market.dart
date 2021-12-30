import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/chat/screen_chat.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/pages/phone/user/feed/market/widget/list_similar_market.dart';
import 'package:kz/pages/phone/user/feed/review/reviews_list.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/database/utility_database.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/reviews.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetContainerMarket extends StatefulWidget {
  static var routeName = '/cnt';
  final String uidMarket;
  WidgetContainerMarket({Key key, this.uidMarket}) : super(key: key);

  @override
  _WidgetContainerMarketState createState() => _WidgetContainerMarketState();
}

class _WidgetContainerMarketState extends State<WidgetContainerMarket> {
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
        .collection('market')
        .doc(widget.uidMarket)
        .get()
        .then((value) {
      setState(() {
        uidUser = value.data()['m_uid_user_by_application'];
      });
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

    var hash = widget.uidMarket.hashCode;
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
        body: StreamBuilder<MarketApplication>(
            stream: FeedState(
                    uidApplicationMarket:
                        kIsWeb ? args.message : widget.uidMarket)
                .marketApplication,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MarketApplication marketApplication = snapshot.data;
                List<String> images = [
                  marketApplication.m_photo_1,
                  if (marketApplication.m_photo_2 != null)
                    marketApplication.m_photo_2,
                  if (marketApplication.m_photo_3 != null)
                    marketApplication.m_photo_3,
                  if (marketApplication.m_photo_4 != null)
                    marketApplication.m_photo_4,
                  if (marketApplication.m_photo_5 != null)
                    marketApplication.m_photo_5,
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
                                                marketApplication.m_heading,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                marketApplication
                                                            .m_negotiated_price !=
                                                        false
                                                    ? 'Договорная цена'
                                                    : marketApplication
                                                                .m_will_give_free !=
                                                            false
                                                        ? 'Отдам даром'
                                                        : '₸ ${marketApplication.m_price}',
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
                              padding: EdgeInsets.only(bottom: 85),
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
                                        pageSnapping: true,
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
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: marketApplication.m_address !=
                                                  null
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(
                                                    marketApplication.m_address,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: marketApplication.m_region !=
                                                      null &&
                                                  marketApplication.m_address ==
                                                      null
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(
                                                    marketApplication.m_region,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Text(
                                            getChatTime(
                                                context,
                                                marketApplication
                                                    .m_date_creation_application),
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .pushNamed('/UserScreen/' +
                                                    marketApplication
                                                        .m_uid_user_by_application),
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
                                                          userData.name,
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
                                                  userData.uriImage != null &&
                                                          userData.uriImage !=
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
                                                                  .uriImage,
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
                                                                  (userData.surname != ''
                                                                          ? userData.name[0] +
                                                                              userData.surname[
                                                                                  0]
                                                                          : userData.name[
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
                                  TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed('/ListFollowingMarket/' +
                                            marketApplication
                                                .m_uid_application),
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ваше обьявление понравилось',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Показать кому',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
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
                                                        marketApplication.m_lower_category !=
                                                                    null &&
                                                                marketApplication
                                                                        .m_lower_category !=
                                                                    ''
                                                            ? AppLocalizations.of(context).translate(marketApplication.m_average_category) +
                                                                ',' +
                                                                AppLocalizations.of(context)
                                                                    .translate(
                                                                        marketApplication
                                                                            .m_upper_category) +
                                                                ',' +
                                                                AppLocalizations.of(context)
                                                                    .translate(
                                                                        marketApplication
                                                                            .m_lower_category)
                                                            : AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        marketApplication
                                                                            .m_average_category) +
                                                                ',' +
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        marketApplication.m_upper_category),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            TextButton.icon(
                                                                onPressed: () {
                                                                  var state = Provider.of<
                                                                          CloudFirestore>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                                  !bDLiked &&
                                                                          !bLiked
                                                                      ? state
                                                                          .likedMarket(context,
                                                                              widget.uidMarket,
                                                                              dbname:
                                                                                  'market')
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
                                                                              .removeLiked(context, widget.uidMarket, uidLiked, dbname: 'market')
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
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            TextButton.icon(
                                                                onPressed: () {
                                                                  var state = Provider.of<
                                                                          CloudFirestore>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                                  !bLiked &&
                                                                          !bDLiked
                                                                      ? state
                                                                          .dLikedMarket(context,
                                                                              widget.uidMarket,
                                                                              dbname:
                                                                                  'market')
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
                                                                              .removeDLiked(context, widget.uidMarket, uidLiked, dbname: 'market')
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
                                          : SizedBox()),
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
                                                        'market',
                                                        marketApplication
                                                            .m_uid_application,
                                                        cntrllrReview.text
                                                            .trim())
                                                    .whenComplete(() =>
                                                        cntrllrReview.clear());
                                              }
                                            },
                                            child: Text('Оставить отзыв')),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'Все отзывы о товаре',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 300,
                                          child: StreamProvider<
                                              List<Review>>.value(
                                            value: FeedState(
                                                    uidApplications:
                                                        marketApplication
                                                            .m_uid_application)
                                                .allReviewsMarket,
                                            child: ReviewsList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // // Container(
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
                                  TextButton(
                                    child: Text(
                                      'Вопрос/Ответ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {},
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  !kIsWeb
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                          decoration: BoxDecoration(
                                            color: Colors.red[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                              onPressed: () => launch('tel://' +
                                                  marketApplication.m_phone),
                                              child: Text(
                                                'Позвонить',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )
                                      : SizedBox(),
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
                                                  marketApplication
                                                      .m_uid_user_by_application);
                                          Map<String, dynamic> chatRoomInfoMap =
                                              {
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
                                                  builder: (context) => ChatScreen(
                                                      marketApplication
                                                          .m_uid_user_by_application,
                                                      uidApp: marketApplication
                                                          .m_uid_application,
                                                      db: 'market')));
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
