import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/widgets/supporting/customSmoothPageIndicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                allowImplicitScrolling: true,
                children: [
                  view('assets/images/img_logo.png', 'Приветствуем',
                      AppLocalizations.of(context).translate('onbourd_1')),
                  view('assets/images/onbourd_2.png', 'Приветствуем',
                      AppLocalizations.of(context).translate('onbourd_2')),
                  view('assets/images/onbourd_3.png', 'Приветствуем',
                      AppLocalizations.of(context).translate('onbourd_3'),
                      end: true)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: cusSmootPageIndicator(controller),
            )
          ],
        ),
      ),
    );
  }

  Widget view(String url, String header, String description,
      {bool end = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(255, 180, 180, 1),
              const Color.fromRGBO(255, 180, 180, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.75],
            tileMode: TileMode.clamp),
      ),
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            height: MediaQuery.of(context).size.height * 0.70,
            child: Image.asset(
              url,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 15),
                ),
                end
                    ? Container(
                        margin: EdgeInsets.only(top: 25),
                        height: 55,
                        child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/LoginPage'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(255, 221, 97, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Войти в аккаунт',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.40),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                      color: Colors.black,
                                    ))),
                              ],
                            )))
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
