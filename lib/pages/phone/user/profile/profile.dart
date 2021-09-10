import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/profile/myPostList.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, GlobalKey<ScaffoldState> scaffoldKey, this.profileId})
      : super(key: key);
  final String profileId;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

    var hash = _authUid.hashCode;
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
        body: StreamBuilder<UserData>(
            stream: FeedState().authUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        userData.u_uri_avatars != null &&
                                                userData.u_uri_avatars != ''
                                            ? GestureDetector(
                                                onTap: () => showGeneralDialog(
                                                    barrierDismissible: true,
                                                    barrierLabel: '',
                                                    barrierColor:
                                                        Colors.black38,
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 700),
                                                    pageBuilder: (ctx, anim1,
                                                            anim2) =>
                                                        BackdropFilter(
                                                            filter: ImageFilter.blur(
                                                                sigmaX: 35 *
                                                                    anim1.value,
                                                                sigmaY: 35 *
                                                                    anim1
                                                                        .value),
                                                            child:
                                                                FadeTransition(
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                  height: 300,
                                                                  width: 300,
                                                                  child: Column(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              300,
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.center,
                                                                                child: Container(
                                                                                  width: double.infinity,
                                                                                  height: double.infinity,
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: userData.u_uri_avatars,
                                                                                    cacheManager: DefaultCacheManager(),
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    placeholderFadeInDuration: Duration(milliseconds: 500),
                                                                                    placeholder: (context, url) => Container(
                                                                                      color: Colors.grey[300].withOpacity(0.3),
                                                                                    ),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              opacity: anim1,
                                                            )),
                                                    transitionBuilder: (ctx,
                                                            anim1,
                                                            anim2,
                                                            child) =>
                                                        BackdropFilter(
                                                          filter: ImageFilter.blur(
                                                              sigmaX: 35 *
                                                                  anim1.value,
                                                              sigmaY: 35 *
                                                                  anim1.value),
                                                          child: FadeTransition(
                                                            child: child,
                                                            opacity: anim1,
                                                          ),
                                                        ),
                                                    context: context),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Container(
                                                    width: 75,
                                                    height: 75,
                                                    child: CachedNetworkImage(
                                                      imageUrl: userData
                                                          .u_uri_avatars,
                                                      cacheManager:
                                                          DefaultCacheManager(),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholderFadeInDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  500),
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        color: Colors.grey[300]
                                                            .withOpacity(0.3),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : ClipRRect(
                                                child: Container(
                                                  width: 75,
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                      color: baseColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Center(
                                                    child: Text(
                                                        (userData.u_surname !=
                                                                    ''
                                                                ? userData.u_name[
                                                                        0] +
                                                                    userData.u_surname[
                                                                        0]
                                                                : userData
                                                                    .u_name[0])
                                                            .toUpperCase(),
                                                        style:
                                                            TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                  ),
                                                ),
                                              ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pushReplacementNamed(
                                                  context, "/EditProfile"),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('h_edit_2'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('h_hello_profile'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              userData.u_surname != null
                                                  ? userData.u_surname +
                                                      ' ' +
                                                      userData.u_name
                                                  : userData.u_name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'h_all_auth_user_applications'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/ActiveApplications');
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_active'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/Archive');
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_arcive'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_settings_and_other'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_settings'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_help_support'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_useing'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_pol_config'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('suggestion_and_remark'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pushNamed('/ActiveApplications');
                                    ScaffoldMessenger.of(context).showSnackBar(prug(
                                        context,
                                        'Данный экран требует рассмотрения от заказчика'));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('h_about_app'),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 35),
                            child: Center(
                              child: TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/EditsLang'),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_edits_lang'),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                              ),
                            )),
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 35),
                            child: Center(
                              child: TextButton(
                                onPressed: () =>
                                    FirebaseAuth.instance.signOut(),
                                child: Text(AppLocalizations.of(context)
                                    .translate('h_sign_out')),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          child: Container(
                                            width: 75,
                                            height: 75,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                          ),
                                        ),
                                        Container(
                                          width: 125,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 75,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            height: 25,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                          ),
                                          Container(
                                            width: 125,
                                            height: 25,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.symmetric(vertical: 2.5),
                                decoration: BoxDecoration(
                                    color: Colors.orange[400].withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 2.5),
                                decoration: BoxDecoration(
                                    color: Colors.green[400].withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 75,
                                height: 25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 105,
                                height: 25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 75,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 105,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 95,
                                height: 25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 135,
                                height: 25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 155,
                                height: 25,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              Container(
                                width: 85,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
