import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:provider/provider.dart';

class ConfirmCode extends StatefulWidget {
  ConfirmCode({Key key, this.verificationID}) : super(key: key);
  final String verificationID;

  @override
  _ConfirmCodeState createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  TextEditingController _controllerCodes;

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
      backgroundColor: Color.fromRGBO(247, 247, 249, 1),
      appBar: AppBar(
        leading: BackButton(color: Colors.black87),
        title: Text(
          AppLocalizations.of(context).translate('phone_check'),
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color.fromRGBO(247, 247, 249, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 80),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(vertical: 35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Color.fromRGBO(78, 41, 254, 0.09),
                        ),
                        child: Icon(
                          Icons.sms_outlined,
                          size: 52,
                          color: Color.fromRGBO(78, 41, 254, 1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('verify_phone_waiting'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: PinView(
                            count: 6,
                            autoFocusFirstField: true,
                            margin: EdgeInsets.all(2.5),
                            obscureText: false,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w600),
                            submit: (String pin) {
                              var state = Provider.of<CloudFirestore>(context,
                                  listen: false);
                              state.signInWithCredentialOTP(
                                  pin, widget.verificationID, context);
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
