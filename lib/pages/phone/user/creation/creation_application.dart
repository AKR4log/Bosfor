import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/widgets/custom/container/button_shopping_service.dart';

class CreationApplication extends StatefulWidget {
  CreationApplication({Key key}) : super(key: key);

  @override
  _CreationApplicationState createState() => _CreationApplicationState();
}

class _CreationApplicationState extends State<CreationApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('h_m_creation_application'),
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
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 65,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(255, 221, 97, 1)),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed("/CreationMarket"),
                              child: Icon(
                                Icons.local_grocery_store_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(255, 221, 97, 1)),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed("/CreationAuto"),
                                child: Icon(
                                  Icons.commute_rounded,
                                  color: Colors.black,
                                  size: 30,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(255, 221, 97, 1)),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed("/CreationProperty"),
                              child: Icon(
                                Icons.maps_home_work_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
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
            )));
  }
}
