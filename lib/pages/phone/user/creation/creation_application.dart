import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
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
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                          Navigator.of(context).pushNamed("/CreationMarket"),
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
                          Navigator.of(context).pushNamed("/CreationAuto"),
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
                              AppLocalizations.of(context).translate('auto'),
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
                          Navigator.of(context).pushNamed("/CreationProperty"),
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
                              AppLocalizations.of(context).translate('domain'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
