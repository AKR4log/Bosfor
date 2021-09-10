import 'dart:io';
import 'dart:typed_data';

import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _controllerName, _controllerSurname;
  List<AssetEntity> assets = [];
  String downloadURI;
  double _progress;
  File image;
  bool uploaded = false,
      selectedImage = false,
      waiting = false,
      error = false,
      errorS = false;
  Future<File> imageFile;

  @override
  void initState() {
    _controllerName = TextEditingController();
    _controllerSurname = TextEditingController();
    _fetchAssets();
    super.initState();
  }

  @override
  void dispose() {
    _controllerSurname?.dispose();
    _controllerName?.dispose();
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
          if (_controllerName.text.length > 2) {
            if (_controllerSurname.text.length > 2) {
              if (selectedImage && imageFile != null) {
                uploadedImage();
              } else {
                var state = Provider.of<CloudFirestore>(context, listen: false);
                state.createNewUser(
                  context,
                  _controllerName.text.trim(),
                  _controllerSurname.text.trim(),
                );
              }
            } else {
              setState(() {
                errorS = true;
              });
            }
          } else {
            setState(() {
              error = true;
            });
          }
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).translate('create_account'),
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color.fromRGBO(247, 247, 249, 1),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: selectedImage && imageFile != null
                    ? FutureBuilder<File>(
                        future: imageFile,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          image = snapshot.data;
                          if (image == null) return Container();
                          return GestureDetector(
                            onTap: () =>
                                getPhotoModalBottomSheet(context, true, true),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(85),
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
                        onTap: () =>
                            getPhotoModalBottomSheet(context, true, true),
                        child: Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(85),
                              color: Color.fromRGBO(241, 241, 243, 1)),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
              ),
              Flexible(
                flex: 8,
                child: twoLinesContainer(
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: textField(_controllerName, error,
                          hint: AppLocalizations.of(context)
                              .translate('enter_name'), onChanged: () {
                        setState(() {
                          error = false;
                        });
                      }),
                    ),
                    textField(_controllerSurname, errorS,
                        hint: AppLocalizations.of(context)
                            .translate('enter_surname'), onChanged: () {
                      setState(() {
                        error = false;
                      });
                    }),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
              ),
            ],
          ),
        ),
      ),
    );
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
          state.createNewUser(
            context,
            _controllerName.text.trim(),
            _controllerSurname.text.trim(),
            downloadURI: snapshot.toString(),
          );
        });
      }
    });
  }
}
