import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kz/pages/phone/connection/login/login_page.dart';
import 'package:kz/pages/phone/home.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/enum/enum.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashPage extends StatefulWidget {
  static var routeName = '/login_session';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 1)).then((_) {
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
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Text(
            'Bosfor',
            style: TextStyle(
                color: Colors.black, fontSize: 44, fontWeight: FontWeight.bold),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context);
    print(state.authStatus);
    return Scaffold(
      backgroundColor: Colors.white,
      body: state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : state.authStatus == AuthStatus.LOGGED_IN
          ? HomePage()
          : state.authStatus == AuthStatus.NOT_LOGGED_IN ||
              state.authStatus != AuthStatus.LOGGED_IN
          ? LoginPage(loginCallback: state.getCurrentUser)
          : HomePage(),
    );
  }
}
