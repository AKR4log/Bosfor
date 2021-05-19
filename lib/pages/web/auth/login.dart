import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/widgets/custom/button/flatButtonCustom.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

class LoginPageWeb extends StatefulWidget {
  final VoidCallback loginCallback;
  LoginPageWeb({Key key, this.loginCallback}) : super(key: key);

  @override
  _LoginPageWebState createState() => _LoginPageWebState();
}

class _LoginPageWebState extends State<LoginPageWeb> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List urldata;
  Map data;
  String urlBase = '';
  String verificationID;
  TextEditingController _phoneAuth;
  TextEditingController _codeAuth;
  bool enabled = true;
  bool error = false;
  bool waiting = false;
  bool sendCode = false;
  FocusNode phoneFocusNode;
  Duration timeoutVerifyPhone = const Duration(seconds: 5);

  String errorAuth;

  @override
  void initState() {
    _phoneAuth = TextEditingController();
    _codeAuth = TextEditingController();
    phoneFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _phoneAuth.dispose();
    _codeAuth.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: MediaQuery.of(context).size.height - 20,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(60, 145, 230, 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.035,
                          vertical: 15),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.035,
                          vertical: 10),
                      child: Text(
                        "You are logged into your developer account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.035),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(93, 163, 234, 1),
                    ),
                    child: Text(
                      "How can I log in?",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              children: [
                Container(
                  height: 55,
                  margin: EdgeInsets.only(bottom: 100),
                  child: Image.asset(
                    "assets/images/logos/light_rounded_icon_oh_non_full.png",
                    height: 55,
                    width: 55,
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      sendCode
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: textFieldPhone(
                                    _codeAuth,
                                    "Введите код подтверждения",
                                    true,
                                    true,
                                    enabled,
                                    error,
                                    waiting,
                                    phoneFocusNode, () {
                                  setState(() {
                                    waiting = false;
                                    error = false;
                                  });
                                }, () {}),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: textFieldPhone(
                                    _phoneAuth,
                                    "Введите номер телефона",
                                    true,
                                    true,
                                    enabled,
                                    error,
                                    waiting,
                                    phoneFocusNode, () {
                                  setState(() {
                                    waiting = false;
                                    error = false;
                                  });
                                }, () {}),
                              ),
                            ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 40,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: FlatButtonCustom().flatButtonPhone(() async {
                          if (!sendCode) {
                            setState(() {
                              if (kIsWeb) {
                                enabled = true;
                              } else {
                                enabled = false;
                              }
                              error = false;
                              waiting = false;
                            });
                            if (_phoneAuth.text == "") {
                              setState(() {
                                waiting = false;
                                error = true;
                                enabled = !enabled;
                              });
                            } else {
                              verifyPhone(_phoneAuth.text, context);
                            }
                          } else {
                            var state = Provider.of<CloudFirestore>(context,
                                listen: false);
                            if (kIsWeb) {
                              state.signInWithPhoneNumberWebConfirm(
                                  _codeAuth.text, context);
                            } else {
                              state.signInWithCredentialOTP(
                                  _codeAuth.text, verificationID, context);
                            }
                          }
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )
        //   slivers: [
        //     SliverToBoxAdapter(
        //       child: Container(
        //         margin: EdgeInsets.only(top: 45),
        //         width: double.infinity,
        //         child: Center(
        //           child: Container(
        //             margin: EdgeInsets.symmetric(horizontal: 30),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Image.asset(
        //                   "assets/images/rounted/rounded_icons_oh.png",
        //                   height: 35,
        //                   width: 35,
        //                 ),
        //                 Container(
        //                   margin: EdgeInsets.only(left: 5),
        //                   child: Text(
        //                     "connect",
        //                     style: TextStyle(
        //                       fontSize: 18,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     sendCode
        //         ? SliverToBoxAdapter(
        //             child: Container(
        //               margin: EdgeInsets.only(top: 175, left: 30, right: 30),
        //               width: double.infinity,
        //               child: Center(
        //                 child: TextFieldCustom().textFieldPhone(
        //                     _codeAuth,
        //                     "Введите код подтверждения",
        //                     true,
        //                     true,
        //                     enabled,
        //                     error,
        //                     waiting,
        //                     phoneFocusNode, () {
        //                   setState(() {
        //                     waiting = false;
        //                     error = false;
        //                   });
        //                 }, () {}),
        //               ),
        //             ),
        //           )
        //         : SliverToBoxAdapter(
        //             child: Container(
        //               margin: EdgeInsets.only(top: 175, left: 30, right: 30),
        //               width: double.infinity,
        //               child: Center(
        //                 child: TextFieldCustom().textFieldPhone(
        //                     _phoneAuth,
        //                     "Введите номер телефона",
        //                     true,
        //                     true,
        //                     enabled,
        //                     error,
        //                     waiting,
        //                     phoneFocusNode, () {
        //                   setState(() {
        //                     waiting = false;
        //                     error = false;
        //                   });
        //                 }, () {}),
        //               ),
        //             ),
        //           ),
        //     SliverToBoxAdapter(
        //       child: Container(
        //         width: double.infinity,
        //         height: 40,
        //         margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        //         child: FlatButtonCustom().flatButtonPhone(() async {
        //           if (!sendCode) {
        //             setState(() {
        //               if (kIsWeb) {
        //                 enabled = true;
        //               } else {
        //                 enabled = false;
        //               }
        //               error = false;
        //               waiting = false;
        //             });
        //             if (_phoneAuth.text == "") {
        //               setState(() {
        //                 waiting = false;
        //                 error = true;
        //                 enabled = !enabled;
        //               });
        //             } else {
        //               verifyPhone(_phoneAuth.text, context);
        //             }
        //           } else {
        //             var state =
        //                 Provider.of<CloudFirestore>(context, listen: false);
        //             if (kIsWeb) {
        //               state.signInWithPhoneNumberWebConfirm(
        //                   _codeAuth.text, context);
        //             } else {
        //               state.signInWithCredentialOTP(
        //                   _codeAuth.text, verificationID, context);
        //             }
        //           }
        //         }),
        //       ),
        //     ),
        //   ],

        );
  }

  /// Авторизация и регистрация пользователя, по его номеру телефона
  Future<void> verifyPhone(phoneNumber, context) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.signInWithCredential(authResult, context);
      widget.loginCallback();
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      if (authException.code == 'invalid-phone-number') {
        errorAuth = "Вы ввели неверный номер телефона";
      } else if (authException.code == "") {
        errorAuth = "";
      }
      // Ошибка авторизации
      setState(() {
        error = true;
        waiting = false;
        enabled = true;
      });
      print(authException.code);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        error = false;
        waiting = true;
        enabled = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationID = verId;

      // codeSendModalBottomSheet(context);
    };

    if (kIsWeb) {
      var state = Provider.of<CloudFirestore>(context, listen: false);
      state.signInWithPhoneNumberWeb(phoneNumber);
      setState(() {
        sendCode = true;
      });
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          timeout: const Duration(seconds: 5),
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout);
    }
  }
}

// Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 height: 35,
//                 width: 35,
//                 child: Image.asset('assets/images/logo/logo_oh.png'),
//               ),
//               Text(
//                 "Mirize",
//               )
//             ],
//           ),
//           Center(
//             child: FutureBuilder(
//               future: invitilLink(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return PrettyQr(
//                       size: 200,
//                       typeNumber: 25,
//                       // data: "${snapshot.data.body}",
//                       data: "Coming soon",
//                       roundEdges: true);
//                 } else if (snapshot.hasError) {
//                   return Text("${snapshot.error}");
//                 }

//                 // By default, show a loading spinner.
//                 return CircularProgressIndicator();
//               },
//             ),
//           ),
//         ],
//       ),
