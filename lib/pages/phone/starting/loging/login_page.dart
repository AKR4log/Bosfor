import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  LoginPage({Key key, this.loginCallback}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerNumberPhone;
  String verificationID;
  Duration timeoutVerifyPhone = const Duration(seconds: 5);
  bool enableButtonAuth = false, wait = false, errorWait = false;

  @override
  void initState() {
    _controllerNumberPhone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerNumberPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(247, 247, 249, 1),
      appBar: AppBar(
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
                          AppLocalizations.of(context)
                              .translate('welcome_back'),
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('enter_country_code_and_phone_number'),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: textFieldPhones(
                              context, _controllerNumberPhone, errorWait,
                              onChanged: () {
                            setState(() {
                              enableButtonAuth = true;
                              errorWait = false;
                            });
                          })),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          child: TextButton(
                              onPressed: () => authPressed(),
                              style: ButtonStyle(
                                enableFeedback: enableButtonAuth,
                                backgroundColor: MaterialStateProperty.all(
                                    enableButtonAuth
                                        ? Color.fromRGBO(255, 221, 97, 1)
                                        : Color.fromRGBO(255, 221, 97, 0.25)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('auth'),
                                      style: TextStyle(
                                          color: errorWait
                                              ? Color.fromRGBO(255, 89, 100, 1)
                                              : Colors.black,
                                          fontSize: 15),
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
                                          child: wait
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    color: Colors.black,
                                                  ))
                                              : errorWait
                                                  ? Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      size: 18,
                                                      color: Color.fromRGBO(
                                                          255, 89, 100, 1),
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ))),
                                ],
                              )))
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

  void authPressed() {
    setState(() {
      wait = true;
      errorWait = false;
    });
    verifyPhone(_controllerNumberPhone.text.trim(), context);
  }

  Future<void> verifyPhone(phoneNumber, context) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.signInWithCredential(authResult, context);
      widget.loginCallback();
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        errorWait = true;
        wait = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        errorWait = false;
        wait = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationID = verId;
      Navigator.of(context).pushNamed('/ConfirmCodes/' + verId);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        timeout: const Duration(seconds: 5),
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }
}
