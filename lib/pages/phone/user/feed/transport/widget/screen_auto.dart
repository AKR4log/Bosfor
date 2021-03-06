import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:imageview360/imageview360.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/chat/screen_chat.dart';
import 'package:kz/pages/phone/user/feed/review/reviews_list.dart';
import 'package:kz/tools/database/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/database/utility_database.dart';
import 'package:kz/tools/models/applications/reviews.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WidgetContainerAuto extends StatefulWidget {
  static var routeName = '/cnt_auto';
  final String uidAuto;
  WidgetContainerAuto({Key key, this.uidAuto}) : super(key: key);

  @override
  _WidgetContainerAutoState createState() => _WidgetContainerAutoState();
}

class _WidgetContainerAutoState extends State<WidgetContainerAuto> {
  int iLiked = 0, iDLiked = 0;
  bool bLiked = false, bDLiked = false, verId = false;
  String uidLiked, uidUser;
  PageController controllerPage;
  TextEditingController cntrllrReview = TextEditingController();
  bool allowSwipeToRotate = true;
  int swipeSensitivity = 2;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  verID() {
    FirebaseFirestore.instance
        .collection('auto')
        .doc(widget.uidAuto)
        .get()
        .then((value) {
      setState(() {
        uidUser = value.data()['a_uid_user_by_application'];
      });
      if (value.data()['a_uid_user_by_application'] ==
          FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          verId = true;
        });
      }
    });
  }

  init() {
    FirebaseFirestore.instance
        .collection("auto")
        .doc(widget.uidAuto)
        .collection('liked')
        .where('a_uid_user_by_application',
            isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
        .collection("auto")
        .doc(widget.uidAuto)
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
        .collection("auto")
        .doc(widget.uidAuto)
        .collection('dliked')
        .where('a_uid_user_by_application',
            isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
        .collection("auto")
        .doc(widget.uidAuto)
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

    var hash = widget.uidAuto.hashCode;
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
        body: StreamBuilder<TransportApplication>(
            stream: FeedState(
                    uidApplicationMarket:
                        kIsWeb ? args.message : widget.uidAuto)
                .autoApplication,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TransportApplication marketApplication = snapshot.data;
                List<String> images = [
                  marketApplication.photo_1,
                  if (marketApplication.photo_2 != null)
                    marketApplication.photo_2,
                  if (marketApplication.photo_3 != null)
                    marketApplication.photo_3,
                  if (marketApplication.photo_4 != null)
                    marketApplication.photo_4,
                  if (marketApplication.photo_5 != null)
                    marketApplication.photo_5,
                ];
                List<Uint8List> image360 =
                    //     marketApplication.listURL.map((item) {
                    //   item as String;
                    // })?.toList();
                    marketApplication.listURL;
                print(image360);
                YoutubePlayerController _controller = YoutubePlayerController(
                  initialVideoId: marketApplication.youtube,
                  params: YoutubePlayerParams(
                    autoPlay: true,
                    showVideoAnnotations: false,
                    origin: 'https://www.youtube.com/watch?v=' +
                        marketApplication.youtube,
                    captionLanguage: 'ru',
                    startAt: Duration(seconds: 30),
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                );

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
                                                marketApplication.a_head,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '???${marketApplication.a_price}',
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
                                                            widget.uidAuto),
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
                              padding: EdgeInsets.only(bottom: 85, top: 15),
                              child: Column(
                                children: [
                                  image360.length >= 1
                                      ? SizedBox(
                                          height: 300,
                                          // child: ImageView360(
                                          //   key: UniqueKey(),
                                          //   imageList: image360,
                                          //   autoRotate: false,
                                          //   rotationCount: 2,
                                          //   rotationDirection:
                                          //       RotationDirection.anticlockwise,
                                          //   frameChangeDuration:
                                          //       Duration(milliseconds: 170),
                                          //   swipeSensitivity: swipeSensitivity,
                                          //   allowSwipeToRotate:
                                          //       allowSwipeToRotate,
                                          // ),
                                          child: Center(
                                              child: Text('???????? ??????????????????')),
                                        )
                                      : SizedBox(
                                          height: 300,
                                          child: PageView.builder(
                                              physics: BouncingScrollPhysics(
                                                  parent:
                                                      AlwaysScrollableScrollPhysics()),
                                              allowImplicitScrolling: true,
                                              itemCount: images.length + 1,
                                              controller: controllerPage,
                                              itemBuilder: (context, position) {
                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 2.5),
                                                  child: position == 5
                                                      ? YoutubePlayerIFrame(
                                                          controller:
                                                              _controller,
                                                        )
                                                      : AspectRatio(
                                                          aspectRatio: 1,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: images[
                                                                position],
                                                            cacheManager:
                                                                DefaultCacheManager(),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: kIsWeb
                                                                      ? BoxFit
                                                                          .fitWidth
                                                                      : BoxFit
                                                                          .cover,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                );
                                              }),
                                        ),
                                  Row(
                                    children: [
                                      marketApplication.a_address != null
                                          ? Container(
                                              width: 200,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              child: Text(
                                                marketApplication.a_address,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            )
                                          : SizedBox(),
                                      Text(
                                        getChatTime(
                                            context,
                                            marketApplication
                                                .date_creation_application),
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
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
                                                            '???????????? ???????????????????? ?????????????? ???????????????????????? ???? ??????????????????'));
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
                                                          '?????????????????? ????????????????????',
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
                                                            '???????????? ???????????????????? ?????????????? ???????????????????????? ???? ??????????????????'));
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
                                                          '????????????????????',
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
                                      // ignore: missing_return
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          UserData userData = snapshot.data;
                                          return TextButton(
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .pushNamed('/UserScreen/' +
                                                    marketApplication
                                                        .a_uid_user_by_application),
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
                                                          '???????????????? ?????? ????????????????????',
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
                                                  '??????????????????',
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
                                                    Text('??????????, ????????????'),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Text(
                                                        marketApplication
                                                                        .a_mNameModelCars !=
                                                                    null &&
                                                                marketApplication
                                                                        .a_mNameModelCars !=
                                                                    ''
                                                            ? marketApplication
                                                                    .a_mNameCars
                                                                    .toUpperCase() +
                                                                ', ' +
                                                                marketApplication
                                                                    .a_mNameModelCars
                                                                    .toUpperCase()
                                                            : marketApplication
                                                                .a_mNameCars
                                                                .toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('??????????'),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                marketApplication
                                                                    .a_mValCarBody),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('????????????'),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                marketApplication
                                                                    .a_mValDriveAuto),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('?????????????? ??????????????'),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                marketApplication
                                                                    .a_mValGearboxBox),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              marketApplication
                                                              .a_engineVolume !=
                                                          null &&
                                                      marketApplication
                                                              .a_engineVolume !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '?????????? ??????????????????'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                              marketApplication
                                                                  .a_engineVolume,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.a_mileage !=
                                                          null &&
                                                      marketApplication
                                                              .a_mileage !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('????????????'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                              marketApplication
                                                                  .a_mileage,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              marketApplication.a_yearOfIssue !=
                                                          null &&
                                                      marketApplication
                                                              .a_yearOfIssue !=
                                                          ''
                                                  ? Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('?????? ??????????????'),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.55,
                                                            child: Text(
                                                                marketApplication
                                                                    .a_yearOfIssue),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                        marketApplication.a_desc != null &&
                                                marketApplication.a_desc != ''
                                            ? Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '????????????????',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                      marketApplication.a_desc,
                                                      maxLines: 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                  ],
                                                ),
                                              )
                                            : SizedBox()
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
                                                    '?????????????? ?????? ????????????????????.'),
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
                                                                                .uidAuto,
                                                                            dbname:
                                                                                'auto')
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
                                                                                widget.uidAuto,
                                                                                uidLiked,
                                                                                dbname: 'auto')
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
                                                                                .uidAuto,
                                                                            dbname:
                                                                                'auto')
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
                                                                                widget.uidAuto,
                                                                                uidLiked,
                                                                                dbname: 'auto')
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
                                              cntrllrReview, false, '?????? ??????????',
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
                                                        'auto',
                                                        marketApplication
                                                            .a_uid_application,
                                                        cntrllrReview.text
                                                            .trim())
                                                    .whenComplete(() =>
                                                        cntrllrReview.clear());
                                              }
                                            },
                                            child: Text('???????????????? ??????????')),
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
                                        SizedBox(
                                          height: 200,
                                          child: StreamProvider<
                                              List<Review>>.value(
                                            value: FeedState(
                                                    uidApplications:
                                                        marketApplication
                                                            .a_uid_application)
                                                .allReviewsAuto,
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
                                  //           '??????????????',
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               fontSize: 16),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height:
                                  //             MediaQuery.of(context).size.height *
                                  //                 0.65,
                                  //         child: StreamProvider<
                                  //             List<MarketApplication>>.value(
                                  //           value: FeedState(
                                  //                   upperCategory:
                                  //                       marketApplication
                                  //                           .m_upper_category,
                                  //                   uidExclude: widget.uidAuto)
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
                          verId
                              ? SizedBox()
                              : Align(
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
                                        //         '??????????????????',
                                        //         style: TextStyle(color: Colors.white),
                                        //       )),
                                        // ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextButton(
                                              onPressed: () {
                                                var chatRoomId =
                                                    getChatRoomIdByUsernames(
                                                        FirebaseAuth.instance
                                                            .currentUser.uid,
                                                        marketApplication
                                                            .a_uid_user_by_application);
                                                Map<String, dynamic>
                                                    chatRoomInfoMap = {
                                                  "users": [
                                                    FirebaseAuth.instance
                                                        .currentUser.uid,
                                                    marketApplication
                                                        .a_uid_user_by_application
                                                  ]
                                                };
                                                DatabaseMethods()
                                                    .createChatRoom(chatRoomId,
                                                        chatRoomInfoMap);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ChatScreen(
                                                            marketApplication
                                                                .a_uid_user_by_application,
                                                            uidApp: marketApplication
                                                                .a_uid_application,
                                                            db: 'auto')));
                                              },
                                              child: Text(
                                                '????????????????',
                                                style: TextStyle(
                                                    color: Colors.white),
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
