import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';

class WebConfirmCode extends StatefulWidget {
  static var routeName = '/confirm_code';
  WebConfirmCode({Key key, this.verificationID}) : super(key: key);
  final String verificationID;

  @override
  _WebConfirmCodeState createState() => _WebConfirmCodeState();
}

class _WebConfirmCodeState extends State<WebConfirmCode> {
  TextEditingController _controllerCodes;
  bool enableButtonAuth = false, wait = false;
  String pinCode;

  @override
  void initState() {
    _controllerCodes = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(247, 247, 249, 1),
      appBar: AppBar(
        leading: BackButton(color: Color.fromRGBO(143, 161, 180, 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'connect',
          style: TextStyle(
            color: Color.fromRGBO(143, 161, 180, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.25),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.3),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          AppLocalizations.of(context).translate('phone_check'),
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('verify_phone_waiting'),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(143, 161, 180, 1)
                                  .withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        child: PinView(
                            count: 6,
                            autoFocusFirstField: true,
                            margin: EdgeInsets.all(2),
                            obscureText: false,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w600),
                            submit: (String pin) {
                              setState(() {
                                wait = true;
                                enableButtonAuth = true;
                                pinCode = pin;
                              });
                              var state = Provider.of<CloudFirestore>(context,
                                  listen: false);
                              state.signInWithPhoneNumberWebConfirm(
                                  pin, context);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmPressed(String pin) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    state.signInWithPhoneNumberWebConfirm(pin, context);
  }
}
