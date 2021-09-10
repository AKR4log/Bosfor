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
      // body: SingleChildScrollView(
      //   child: Container(
      //     height: MediaQuery.of(context).size.height,
      //     width: MediaQuery.of(context).size.width,
      //     child: Center(
      //       child: Column(
      //         children: [
      //           Container(
      //             margin: EdgeInsets.symmetric(horizontal: 15, vertical: 80),
      //             child: Column(
      //               children: [
      //                 Container(
      //                   padding: EdgeInsets.all(20),
      //                   margin: EdgeInsets.symmetric(vertical: 35),
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(45),
      //                     color: Color.fromRGBO(78, 41, 254, 0.09),
      //                   ),
      //                   child: Icon(
      //                     Icons.sms_outlined,
      //                     size: 52,
      //                     color: Color.fromRGBO(78, 41, 254, 1),
      //                   ),
      //                 ),
      //                 Container(
      //                   margin: EdgeInsets.symmetric(horizontal: 25),
      //                   child: Text(
      //                     AppLocalizations.of(context)
      //                         .translate('verify_phone_waiting'),
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                         fontSize: 17,
      //                         fontWeight: FontWeight.w600,
      //                         color: Colors.black.withOpacity(0.8)),
      //                   ),
      //                 ),
      //                 Container(
      //                   margin:
      //                       EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      //                   child: PinView(
      //                       count: 6,
      //                       autoFocusFirstField: true,
      //                       margin: EdgeInsets.all(2.5),
      //                       obscureText: false,
      //                       style: TextStyle(
      //                           fontSize: 22.0, fontWeight: FontWeight.w600),
      //                       submit: (String pin) {
      //                         var state = Provider.of<CloudFirestore>(context,
      //                             listen: false);
      //                         state.signInWithCredentialOTP(
      //                             pin, widget.verificationID, context);
      //                       }),
      //                 ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
                              state.signInWithCredentialOTP(
                                  pin, widget.verificationID, context);
                            }),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          child: TextButton(
                              onPressed: () => confirmPressed(),
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
                                          .translate('confirm_code'),
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
                                          child: wait
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    color: Colors.black,
                                                  ))
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

  void confirmPressed() {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    state.signInWithCredentialOTP(pinCode, widget.verificationID, context);
  }
}
