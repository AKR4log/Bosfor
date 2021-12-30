import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:kz/pages/phone/home.dart';
import 'package:kz/pages/phone/starting/start.dart';
import 'package:kz/pages/web/auth/loging/login_page.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/enum/enum.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashPage extends StatefulWidget {
  static var routeName = '/loging_session';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState _supportState = SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 1)).then((_) async {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.getCurrentUser(context: context);
    });
  }

  Widget _body() {
    var height = 95.0;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(255, 238, 180, 0),
                    const Color.fromRGBO(255, 238, 180, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.75],
                  tileMode: TileMode.clamp),
            ),
            height: height,
            width: height,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bosfor',
                    style:
                        TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
                Text('kz',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    return kIsWeb
        ? Scaffold(
            backgroundColor: Colors.white,
            body: state.authStatus == AuthStatus.NOT_DETERMINED
                ? _body()
                : state.authStatus == AuthStatus.LOGGED_IN
                    ? HomeWebPage()
                    : state.authStatus == AuthStatus.NOT_LOGGED_IN ||
                            state.authStatus != AuthStatus.LOGGED_IN
                        ? WebLoginPage()
                        : HomeWebPage(),
          )
        : Scaffold(
            backgroundColor: Color.fromRGBO(255, 221, 97, 1),
            body: state.authStatus == AuthStatus.NOT_DETERMINED
                ? _body()
                : state.authStatus == AuthStatus.LOGGED_IN
                    ? HomePage()
                    : state.authStatus == AuthStatus.NOT_LOGGED_IN ||
                            state.authStatus != AuthStatus.LOGGED_IN
                        ? StartPage()
                        : HomePage(),
          );
  }
}
