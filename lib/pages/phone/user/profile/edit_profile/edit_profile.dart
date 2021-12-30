import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<AssetEntity> assets = [];
  String downloadURI;
  double _progress;
  dynamic baseColor;
  File image;
  bool uploaded = false, selectedImage = false, waiting = false, error = false;
  Future<File> imageFile;
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
    _fetchAssets();
    controllerName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerName?.dispose();
    super.dispose();
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
                                child: selectedImage && imageFile != null
                                    ? FutureBuilder<File>(
                                        future: imageFile,
                                        builder: (_, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                          image = snapshot.data;
                                          if (image == null) return Container();
                                          return GestureDetector(
                                            onTap: () =>
                                                getPhotoModalBottomSheet(
                                                    context, true, true),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(85),
                                              child: Container(
                                                  height: 85,
                                                  width: 85,
                                                  child: Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          );
                                        },
                                      )
                                    : GestureDetector(
                                        onTap: () => getPhotoModalBottomSheet(
                                            context, true, true),
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
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholderFadeInDuration:
                                                        Duration(
                                                            milliseconds: 500),
                                                    placeholder:
                                                        (context, url) =>
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
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Center(
                                                    child: Text(
                                                        (userData.surname != ''
                                                                ? userData.name[
                                                                        0] +
                                                                    userData.surname[
                                                                        0]
                                                                : userData
                                                                    .name[0])
                                                            .toUpperCase(),
                                                        style:
                                                            TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
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
                              if (selectedImage &&
                                  controllerName.text.length >= 1) {
                                uploadedImageAndName();
                              }
                              if (controllerName.text.length >= 1 &&
                                  !selectedImage) {
                                var state = Provider.of<CloudFirestore>(context,
                                    listen: false);
                                state.updateName(
                                    context, controllerName.text.trim());
                              }
                              if (selectedImage &&
                                  controllerName.text.length == 0) {
                                uploadedImage();
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

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );
    setState(() => assets = recentAssets);
  }

  assetThumbnail({asset}) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null)
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.4)),
          );
        return InkWell(
          onTap: () {
            if (asset.type == AssetType.image) {
              setState(() {
                selectedImage = true;
                imageFile = asset.file;
              });
              Navigator.pop(context);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getPhotoModalBottomSheet(
    BuildContext context,
    bool isScrollControlled,
    bool isDismissible,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      builder: (context) {
        return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent >= 0.8) {
              } else if (notification.extent <= 0.77) {}
            },
            child: DraggableScrollableActuator(
                child: DraggableScrollableSheet(
              minChildSize: 0.3,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, controller) {
                return Column(
                  children: [
                    Container(
                      height: 5,
                      width: 75,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black54.withOpacity(0.4)),
                    ),
                    assets == null
                        ? Container()
                        : Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                controller: controller,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                itemCount: assets.length,
                                itemBuilder: (_, index) {
                                  return assetThumbnail(asset: assets[index]);
                                },
                              ),
                            ),
                          ),
                  ],
                );
              },
            )));
      },
    );
  }

  uploadedImage() async {
    String randomName;
    randomName = Uuid().v1();
    var state = Provider.of<CloudFirestore>(context, listen: false);
    firebase_storage.Reference slideshowImageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('avatars/${randomName}.png');
    File _newFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80, percentage: 80);
    firebase_storage.UploadTask slideshowRefTask =
        slideshowImageRef.putFile(_newFile);
    slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
      setState(() {
        uploaded = true;
        _progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });
      if (snapshot.state == firebase_storage.TaskState.success) {
        slideshowImageRef.getDownloadURL().then((snapshot) {
          downloadURI = snapshot.toString();
          state.uploadPhoto(
            context,
            snapshot.toString(),
          );
        });
      }
    });
  }

  uploadedImageAndName() async {
    String randomName;
    randomName = Uuid().v1();
    var state = Provider.of<CloudFirestore>(context, listen: false);
    firebase_storage.Reference slideshowImageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('avatars/${randomName}.png');
    File _newFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80, percentage: 80);
    firebase_storage.UploadTask slideshowRefTask =
        slideshowImageRef.putFile(_newFile);
    slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
      setState(() {
        uploaded = true;
        _progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });
      if (snapshot.state == firebase_storage.TaskState.success) {
        slideshowImageRef.getDownloadURL().then((snapshot) {
          downloadURI = snapshot.toString();
          state.uploadPhotoAndName(
              context, snapshot.toString(), controllerName.text.trim());
        });
      }
    });
  }
}
