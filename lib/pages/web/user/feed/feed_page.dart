import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class FeedPageWeb extends StatefulWidget {
  FeedPageWeb({Key key}) : super(key: key);

  @override
  _FeedPageWebState createState() => _FeedPageWebState();
}

class _FeedPageWebState extends State<FeedPageWeb>
    with TickerProviderStateMixin {
  Animation<int> _characterCount;
  bool isCharacterCountOne = false, load = false, loadWidget = false;
  TextEditingController _textNameMusic = TextEditingController();
  int _stringIndex;
  static const List<String> _kStrings = const <String>[
    'Создание аккаунта музыканта',
    'Trace program running.',
    '[312]555-0690',
  ];
  String get _currentString => _kStrings[_stringIndex % _kStrings.length];
  String downloadURIMusic;

  @override
  void dispose() {
    _textNameMusic.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textNameMusic = TextEditingController();
  }

  void _openFileExplorer() async {
    try {
      // FilePickerResult result = await FilePicker.platform.pickFiles(
      //     type: FileType.custom,
      //     allowedExtensions: ['mp3'],
      //     allowMultiple: false);

      // if (result.files.first != null) {
      //   var fileBytes = result.files.first.bytes;

      //   String randomName;
      //   randomName = Uuid().v1();
      //   firebase_storage.Reference firebaseStorageRef = firebase_storage
      //       .FirebaseStorage.instance
      //       .ref()
      //       .child('music/$randomName.mp3');
      //   firebase_storage.UploadTask uploadTask =
      //       firebaseStorageRef.putData(fileBytes);
      //   uploadTask.snapshotEvents.listen((event) async {
      //     setState(() {
      //       load = true;
      //       loadWidget = false;
      //     });
      //     downloadURIMusic = await firebaseStorageRef.getDownloadURL();
      //     setState(() {
      //       load = false;
      //       loadWidget = true;
      //     });
      //     print(fileBytes);
      //     print(downloadURIMusic);
      //   });
      // }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(color: Colors.white60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: double.infinity,
                    //   margin:
                    //       EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    //   child: StreamBuilder<UserData>(
                    //       stream: FeedState(
                    //               uidUser:
                    //                   FirebaseAuth.instance.currentUser.uid)
                    //           .user,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasData) {
                    //           UserData userData = snapshot.data;
                    //           return Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               ClipRRect(
                    //                 borderRadius: BorderRadius.circular(35),
                    //                 child: Container(
                    //                   width: 35,
                    //                   height: 35,
                    //                   child: CachedNetworkImage(
                    //                     imageUrl: userData.uriImage,
                    //                     useOldImageOnUrlChange: true,
                    //                     imageBuilder:
                    //                         (context, imageProvider) =>
                    //                             Container(
                    //                       decoration: BoxDecoration(
                    //                         image: DecorationImage(
                    //                           image: imageProvider,
                    //                           fit: BoxFit.cover,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     placeholderFadeInDuration:
                    //                         Duration(milliseconds: 500),
                    //                     placeholder: (context, url) =>
                    //                         Container(
                    //                       width: 35,
                    //                       height: 35,
                    //                       decoration: BoxDecoration(
                    //                           color: Colors.grey[300]
                    //                               .withOpacity(0.3),
                    //                           borderRadius:
                    //                               BorderRadius.circular(35)),
                    //                     ),
                    //                     errorWidget: (context, url, error) =>
                    //                         Icon(Icons.error),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Container(
                    //                   height: 35,
                    //                   width: 75,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(30),
                    //                     color: Colors.grey[200],
                    //                   ),
                    //                   child: FlatButton(
                    //                     child: Text("Sign out"),
                    //                     onPressed: () {
                    //                       FirebaseAuth.instance.signOut();
                    //                       Navigator.pushReplacementNamed(
                    //                           context, "/LoginPage");
                    //                     },
                    //                   ))
                    //             ],
                    //           );
                    //         } else {
                    //           return Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Container(
                    //                 width: 35,
                    //                 height: 35,
                    //                 decoration: BoxDecoration(
                    //                     color:
                    //                         Colors.grey[300].withOpacity(0.3),
                    //                     borderRadius:
                    //                         BorderRadius.circular(35)),
                    //               ),
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                     color:
                    //                         Colors.grey[300].withOpacity(0.5),
                    //                     borderRadius:
                    //                         BorderRadius.circular(50)),
                    //                 width: 75,
                    //                 height: 35,
                    //               ),
                    //             ],
                    //           );
                    //         }
                    //       }),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 15),
                    //   child: Column(
                    //     children: [
                    //       StreamBuilder<UserData>(
                    //           stream: FeedState(
                    //                   uidUser:
                    //                       FirebaseAuth.instance.currentUser.uid)
                    //               .user,
                    //           builder: (context, snapshot) {
                    //             if (snapshot.hasData) {
                    //               UserData userData = snapshot.data;
                    //               return userData.musician
                    //                   ? FlatButton(
                    //                       onPressed: () {
                    //                         Navigator.pushReplacementNamed(
                    //                             context, "/MusicianPage");
                    //                       },
                    //                       child: Container(
                    //                         padding: EdgeInsets.symmetric(
                    //                             vertical: 10),
                    //                         width: double.infinity,
                    //                         margin: EdgeInsets.symmetric(
                    //                             horizontal:
                    //                                 MediaQuery.of(context)
                    //                                         .size
                    //                                         .width *
                    //                                     0.025,
                    //                             vertical: 5),
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.start,
                    //                           children: [
                    //                             Container(
                    //                               margin: EdgeInsets.only(
                    //                                   right: 10),
                    //                               height: 30,
                    //                               width: 30,
                    //                               decoration: BoxDecoration(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           20),
                    //                                   color: Color.fromRGBO(
                    //                                       212, 20, 90, 0.2)),
                    //                               child: Center(
                    //                                 child: Icon(
                    //                                   FontAwesome5.music,
                    //                                   size: 13,
                    //                                   color: Color.fromRGBO(
                    //                                       212, 20, 90, 1),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             Text(
                    //                               "Music",
                    //                               style: TextStyle(
                    //                                   color: Colors.black87,
                    //                                   fontSize: 17),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     )
                    //                   : FlatButton(
                    //                       onPressed: () {
                    //                         Navigator.pushReplacementNamed(
                    //                             context, "/MusicPage");
                    //                       },
                    //                       child: Container(
                    //                         padding: EdgeInsets.symmetric(
                    //                             vertical: 10),
                    //                         width: double.infinity,
                    //                         margin: EdgeInsets.symmetric(
                    //                             horizontal:
                    //                                 MediaQuery.of(context)
                    //                                         .size
                    //                                         .width *
                    //                                     0.025,
                    //                             vertical: 5),
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.start,
                    //                           children: [
                    //                             Container(
                    //                               margin: EdgeInsets.only(
                    //                                   right: 10),
                    //                               height: 30,
                    //                               width: 30,
                    //                               decoration: BoxDecoration(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           20),
                    //                                   color: Color.fromRGBO(
                    //                                       212, 20, 90, 0.2)),
                    //                               child: Center(
                    //                                 child: Icon(
                    //                                   FontAwesome5.music,
                    //                                   size: 13,
                    //                                   color: Color.fromRGBO(
                    //                                       212, 20, 90, 1),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             Text(
                    //                               "Music",
                    //                               style: TextStyle(
                    //                                   color: Colors.black87,
                    //                                   fontSize: 17),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     );
                    //             } else {
                    //               return Container(
                    //                 decoration: BoxDecoration(
                    //                     color:
                    //                         Colors.grey[300].withOpacity(0.5),
                    //                     borderRadius:
                    //                         BorderRadius.circular(50)),
                    //                 width: 40,
                    //                 height: 40,
                    //               );
                    //             }
                    //           }),
                    //       GestureDetector(
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 15, vertical: 10),
                    //           width: double.infinity,
                    //           margin: EdgeInsets.symmetric(
                    //               horizontal:
                    //                   MediaQuery.of(context).size.width * 0.025,
                    //               vertical: 5),
                    //           child: Text(
                    //             "How can I log in?",
                    //             style: TextStyle(
                    //                 color: Colors.black87, fontSize: 15),
                    //           ),
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 15, vertical: 10),
                    //           width: double.infinity,
                    //           margin: EdgeInsets.symmetric(
                    //               horizontal:
                    //                   MediaQuery.of(context).size.width * 0.025,
                    //               vertical: 5),
                    //           child: Text(
                    //             "How can I log in?",
                    //             style: TextStyle(
                    //                 color: Colors.black87, fontSize: 15),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 55),
                child: Column(
                  children: [
                    Text("Upload Music"),
                    TextField(
                      controller: _textNameMusic,
                    ),
                    loadWidget
                        ? Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white.withOpacity(0.3)),
                            child: IconButton(
                              icon:
                                  Icon(Typicons.direction, color: Colors.black),
                              onPressed: () {
                                var state = Provider.of<CloudFirestore>(context,
                                    listen: false);
                                // state
                                //     .createNewMusic(
                                //         context,
                                //         downloadURIMusic,
                                //         _textNameMusic.text.trim(),
                                //         DateTime.now().toUtc().toString())
                                //     .whenComplete(() {
                                //   setState(() {
                                //     downloadURIMusic = null;
                                //   });
                                // });
                              },
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white.withOpacity(0.3)),
                            child: load
                                ? Center(
                                    child: Container(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(),
                                  ))
                                : IconButton(
                                    icon: Icon(Typicons.upload_cloud,
                                        color: Colors.white),
                                    onPressed: () {
                                      _openFileExplorer();
                                    },
                                  ),
                          ),
                    FlatButton(
                      child: Text("OPEN"),
                      onPressed: () {
                        _openFileExplorer();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
