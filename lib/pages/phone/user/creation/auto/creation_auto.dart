import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/widget_containers/car_containers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreationAuto extends StatefulWidget {
  CreationAuto({Key key}) : super(key: key);

  @override
  _CreationAutoState createState() => _CreationAutoState();
}

class _CreationAutoState extends State<CreationAuto> {
  String mValAuto,
      mNameCars,
      mNameModelCars,
      dValAuto,
      dValCommercial,
      dValRepairsAndService,
      dValSpareParts,
      dValOther,
      mValCarBody,
      mValDriveAuto,
      mValGearboxBox;
  List<AssetEntity> assets = [];
  File image;
  Future<File> imageFile;
  TextEditingController controllerYearOfIssue;
  TextEditingController controllerEngineVolume;
  TextEditingController controllerMileage;
  TextEditingController controllerPrice;
  TextEditingController controllerDescription;
  bool uploaded = false,
      selectedImage = false,
      waiting = false,
      errorPrice = false,
      errorYear = false;

  @override
  void initState() {
    _fetchAssets();
    controllerDescription = TextEditingController();
    controllerEngineVolume = TextEditingController();
    controllerMileage = TextEditingController();
    controllerPrice = TextEditingController();
    controllerYearOfIssue = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerDescription?.dispose();
    controllerEngineVolume?.dispose();
    controllerMileage?.dispose();
    controllerPrice?.dispose();
    controllerYearOfIssue?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('h_auto'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            child: Column(children: [
              mContainer(mValAuto, (val) {
                setState(() {
                  mValAuto = val;
                });
              }, context),
              ...[
                if (mValAuto == 'cars')
                  dContainerCars(dValAuto, (val) {
                    setState(() {
                      dValAuto = val;
                    });
                  }, context)
                else if (mValAuto == 'spare_parts')
                  dContainerSpareParts(dValAuto, (val) {
                    setState(() {
                      dValSpareParts = val;
                    });
                  }, context)
                else if (mValAuto == 'repairs_and_services')
                  dContainerRepairsAndServices(dValAuto, (val) {
                    setState(() {
                      dValRepairsAndService = val;
                    });
                  }, context)
                else if (mValAuto == 'commercial')
                  dContainerCommercial(dValAuto, (val) {
                    setState(() {
                      dValCommercial = val;
                    });
                  }, context)
                else if (mValAuto == 'other')
                  dContainerOther(dValAuto, (val) {
                    setState(() {
                      dValOther = val;
                    });
                  }, context)
                else if (mValAuto == '')
                  SizedBox()
              ],
              ...[
                if (dValAuto == 'passenger_cars')
                  mContainerCarBody(mValCarBody, (val) {
                    setState(() {
                      mValCarBody = val;
                    });
                  }, context),
              ],
              ...[
                if (dValAuto == 'passenger_cars')
                  containerCarModel(mNameCars, mNameModelCars, (val) {
                    setState(() {
                      mNameCars = val;
                    });
                  }, (val) {
                    setState(() {
                      mNameModelCars = val;
                    });
                  }, context)
              ],
              ...[
                if (mValCarBody != null && mValCarBody != '')
                  mContainerDriveAuto(mValDriveAuto, (val) {
                    setState(() {
                      mValDriveAuto = val;
                    });
                  }, context)
              ],
              ...[
                if (mValDriveAuto != null && mValDriveAuto != '')
                  mContainerGearboxAuto(mValGearboxBox, (val) {
                    setState(() {
                      mValGearboxBox = val;
                    });
                  }, context)
              ],
              ...[
                if (mValGearboxBox != null && mValGearboxBox != '')
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: textFieldtwo(
                                  controllerEngineVolume,
                                  false,
                                  AppLocalizations.of(context)
                                      .translate('h_m_engine_volume'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 3,
                                child: textFieldtwo(
                                  controllerPrice,
                                  errorPrice,
                                  AppLocalizations.of(context)
                                      .translate('h_m_price_in_tenge'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: textFieldtwo(
                                  controllerMileage,
                                  false,
                                  AppLocalizations.of(context)
                                      .translate('h_m_mileage'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 3,
                                child: textFieldtwo(
                                  controllerYearOfIssue,
                                  errorYear,
                                  AppLocalizations.of(context)
                                      .translate('h_m_year_of_issue'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('h_m_photos'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 5),
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
                                      onTap: () => getPhotoModalBottomSheet(
                                          context, true, true),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                            height: 155,
                                            width: 155,
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
                                  child: Container(
                                    height: 155,
                                    width: 155,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.055)),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(14, 190, 126, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('h_m_good_application'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (controllerPrice.text.length >= 1) {
                                if (controllerYearOfIssue.text.length >= 1) {
                                  uploadedImage();
                                } else {
                                  setState(() {
                                    errorYear = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  errorPrice = true;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ]),
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
        .child('auto/${randomName}.png');
    File _newFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80, percentage: 80);
    firebase_storage.UploadTask slideshowRefTask =
        slideshowImageRef.putFile(_newFile);
    slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
      setState(() {
        uploaded = true;
      });
      if (snapshot.state == firebase_storage.TaskState.success) {
        slideshowImageRef.getDownloadURL().then((snapshot) {
          state.createAutoApplication(
            context,
            mValDriveAuto: mValDriveAuto ?? null,
            mNameCars: mNameCars ?? null,
            mNameModelCars: mNameModelCars ?? null,
            mValAuto: mValAuto,
            mValCarBody: mValCarBody ?? null,
            mValGearboxBox: mValGearboxBox ?? null,
            dValAuto: dValAuto ?? null,
            dValCommercial: dValCommercial ?? null,
            dValOther: dValOther ?? null,
            dValRepairsAndService: dValRepairsAndService ?? null,
            dValSpareParts: dValSpareParts ?? null,
            description: controllerDescription.text.trim() ?? null,
            engineVolume: controllerEngineVolume.text.trim() ?? null,
            yearOfIssue: controllerYearOfIssue.text.trim() ?? null,
            price: controllerPrice.text.trim() ?? null,
            mileage: controllerMileage.text.trim() ?? null,
          );
        });
      }
    });
  }
}
