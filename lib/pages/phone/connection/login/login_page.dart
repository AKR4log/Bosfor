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
  bool error = false, waiting = false;

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
      backgroundColor: Color.fromRGBO(247, 247, 249, 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(78, 41, 254, 1),
        child: waiting
            ? Container(
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () {
          setState(() {
            error = false;
            waiting = true;
          });
          verifyPhone(_controllerNumberPhone.text, context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 150),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Color.fromRGBO(78, 41, 254, 0.09),
                        ),
                        height: 175,
                        width: 175,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                child: textFieldPhones(
                                    context, _controllerNumberPhone, error)),
                            Container(
                              width: double.infinity,
                              child: Text(
                                AppLocalizations.of(context).translate(
                                    'enter_country_code_and_phone_number'),
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                            ),
                          ],
                        ),
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
        error = true;
        waiting = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        error = false;
        waiting = true;
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
