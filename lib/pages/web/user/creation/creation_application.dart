import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/web/user/bookmarks/bookmarks.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/pages/web/user/messanger/chat/chats.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/tools/widgets/custom/container/button_shopping_service.dart';

class WebCreationApplication extends StatefulWidget {
  static var routeName = '/created';
  WebCreationApplication({Key key}) : super(key: key);

  @override
  _WebCreationApplicationState createState() => _WebCreationApplicationState();
}

class _WebCreationApplicationState extends State<WebCreationApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
          body: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(255, 221, 97, 1),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed("/CreationMarket"),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/svg/undraw_online_shopping.svg',
                            fit: BoxFit.fitWidth,
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('h_market'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(255, 221, 97, 1)),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed("/CreationAuto"),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/svg/undraw_city_driver.svg',
                            fit: BoxFit.fitWidth,
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              AppLocalizations.of(context).translate('h_auto'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(255, 221, 97, 1)),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed("/CreationProperty"),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/svg/undraw_building.svg',
                            fit: BoxFit.fitWidth,
                            height: 150,
                            width: 150,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('h_property'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.only(bottom: 15),
                  //         width: double.infinity,
                  //         child: Text(
                  //           'Сервисы',
                  //           style: TextStyle(
                  //               color: Colors.black.withOpacity(0.7),
                  //               fontSize: 20),
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           print('hello');
                  //         },
                  //         child: button_shop_service('Покрасить объявление',
                  //             Icons.monochrome_photos_rounded),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           print('hello');
                  //         },
                  //         child: button_shop_service('Поднять в списке',
                  //             Icons.auto_fix_high_rounded),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
