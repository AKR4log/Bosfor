// import 'dart:html' as html;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:path/path.dart' as Path;
import 'package:kz/tools/state/feed_state.dart';
// import 'package:mime_type/mime_type.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WebEditProfile extends StatefulWidget {
  static var routeName = '/edit_profile';
  WebEditProfile({Key key}) : super(key: key);

  @override
  _WebEditProfileState createState() => _WebEditProfileState();
}

class _WebEditProfileState extends State<WebEditProfile> {
  List<AssetEntity> assets = [];
  String downloadURI;
  double _progress;
  dynamic baseColor;
  bool uploaded = false,
      selectedImage = false,
      waiting = false,
      error = false,
      comlete = false;
  TextEditingController controllerName = TextEditingController();

  colors() async {
    List<Color> _colorList = [
      Colors.pink[400],
      Colors.pinkAccent,
      Colors.red[400],
      Colors.redAccent,
      Colors.deepOrange[400],
      Colors.deepOrangeAccent,
      Colors.orange[800],
      Colors.orangeAccent[700],
      Colors.amber[900],
      Colors.lime[800],
      Colors.lightGreen[700],
      Colors.green[600],
      Colors.teal[400],
      Colors.cyan[600],
      Colors.lightBlue[600],
      Colors.lightBlueAccent[700],
      Colors.blue[600],
      Colors.blueAccent,
      Colors.indigo[400],
      Colors.indigoAccent,
      Colors.purple[400],
      Colors.purpleAccent[400],
      Colors.deepPurple[400],
      Colors.deepPurpleAccent,
      Colors.blueGrey[400],
      Colors.brown[400],
      Colors.grey[600],
    ];

    var hash = FirebaseAuth.instance.currentUser.uid.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColor = _colorList[index];
    });
    return _colorList[index];
  }

  @override
  void initState() {
    colors();
    controllerName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerName?.dispose();
    super.dispose();
  }

  Future<void> getMultipleImageInfos() async {
    // var mediaData = await ImagePickerWeb.getImageInfo;
    // String mimeType = mime(Path.basename(mediaData.fileName));
    // html.File mediaFile =
    //     new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    // if (mediaFile != null) {
    //   String randomName;
    //   randomName = Uuid().v1();
    //   firebase_storage.Reference firebaseStorageRef = firebase_storage
    //       .FirebaseStorage.instance
    //       .ref()
    //       .child('application/$randomName.png');
    //   firebase_storage.UploadTask slideshowRefTask =
    //       firebaseStorageRef.putData(mediaData.data);
    //   slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
    //     setState(() {
    //       uploaded = true;
    //     });
    //     if (snapshot.state == firebase_storage.TaskState.success) {
    //       firebaseStorageRef.getDownloadURL().then((snapshot) {
    //         setState(() {
    //           uploaded = false;
    //           downloadURI = snapshot.toString();
    //           comlete = true;
    //         });
    //       });
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: StreamBuilder<UserData>(
            stream: FeedState().authUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.25),
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('h_edit_profile'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                uploaded
                                    ? Container(
                                        height: 35,
                                        width: 35,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => getMultipleImageInfos(),
                                  child: userData.uriImage != null &&
                                          userData.uriImage != ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            width: 75,
                                            height: 75,
                                            child: CachedNetworkImage(
                                              imageUrl: userData.uriImage,
                                              cacheManager:
                                                  DefaultCacheManager(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholderFadeInDuration:
                                                  Duration(milliseconds: 500),
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Colors.grey[300]
                                                    .withOpacity(0.3),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          child: Container(
                                            width: 75,
                                            height: 75,
                                            decoration: BoxDecoration(
                                                color: baseColor,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Center(
                                              child: Text(
                                                  (userData.surname != ''
                                                          ? userData.name[0] +
                                                              userData
                                                                  .surname[0]
                                                          : userData.name[0])
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 25),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(AppLocalizations.of(context)
                                        .translate('h_enter_name')),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.5),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: textField(controllerName, false,
                                        hint: userData.name +
                                                ' ' +
                                                userData.surname ??
                                            '',
                                        isSide: true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(12, 206, 107, 1),
                          ),
                          margin: EdgeInsets.only(bottom: 25),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextButton(
                            onPressed: () {
                              var state = Provider.of<CloudFirestore>(context,
                                  listen: false);
                              if (selectedImage &&
                                  controllerName.text.length >= 1) {
                                state.uploadPhotoAndName(context, downloadURI,
                                    controllerName.text.trim());
                              }
                              if (controllerName.text.length >= 1 &&
                                  !selectedImage) {
                                state.updateName(
                                    context, controllerName.text.trim());
                              }
                              if (comlete && controllerName.text.length == 0) {
                                state.uploadPhoto(context, downloadURI);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('h_save'),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
