// ignore_for_file: missing_return

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/functions/uploadedPhotoApp.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/widget_containers/car_containers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AutoMaster extends StatefulWidget {
  AutoMaster({Key key}) : super(key: key);

  @override
  _AutoMasterState createState() => _AutoMasterState();
}

class _AutoMasterState extends State<AutoMaster> {
  TextEditingController controllerYoutube = TextEditingController();
  TextEditingController controllerHead = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController cntrllrMileage = TextEditingController();
  TextEditingController cntrllrYearOfIssue = TextEditingController();
  TextEditingController cntrllrEngineVolume = TextEditingController();
  TextEditingController controllerCarTax = TextEditingController();
  TextEditingController controllerHosts = TextEditingController();
  TextEditingController controllerPriceForTerm = TextEditingController();
  List<AssetEntity> assets = [];
  Future<File> imageFile;
  File image_first_photo,
      image_second_photo,
      image_third_photo,
      image_fourth_photo,
      image_fifth_photo;
  bool error_head = false,
      errorMarketDropdown = false,
      errorLocates = false,
      wait_first_photo = false,
      errorCarTax = false,
      errorHosts = false,
      wait_second_photo = false,
      errorYear = false,
      errorMileage = false,
      wait_third_photo = false,
      errorPrice = false,
      only_foreign_cars = false,
      errorPriceForTerm = false,
      rent_auto = false,
      wait_fourth_photo = false,
      wait_fifth_photo = false,
      wait_coml_first_photo = false,
      wait_coml_second_photo = false,
      wait_coml_third_photo = false,
      wait_coml_fourth_photo = false,
      wait_coml_fifth_photo = false;
  String finished_first_photo,
      finished_second_photo,
      finished_third_photo,
      mValAuto,
      mNameCars,
      mNameModelCars,
      dValAuto,
      dValCommercial,
      dValRepairsAndService,
      dValSpareParts,
      rent_auto_term_val,
      rent_auto_payment_val,
      rent_auto_an_initial_fee_val,
      rent_auto_contract_val,
      rent_auto_casco_insurance_val,
      dValOther,
      mValCarBody,
      mValDriveAuto,
      valCondition,
      mValGearboxBox,
      dropdownValueLocates,
      finished_fourth_photo,
      finished_fifth_photo;

  @override
  void dispose() {
    controllerYoutube?.dispose();
    controllerHead?.dispose();
    controllerDesc?.dispose();
    controllerPrice?.dispose();
    cntrllrMileage?.dispose();
    cntrllrYearOfIssue?.dispose();
    cntrllrEngineVolume?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Widget cntUploadedPhotoFirst() {
    return imageFile != null
        ? finished_first_photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: finished_first_photo,
                  cacheManager: DefaultCacheManager(),
                  imageBuilder: (context, imageProvider) => Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 5, right: 5),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            )),
                      ),
                    ],
                  ),
                  placeholderFadeInDuration: Duration(milliseconds: 500),
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300].withOpacity(0.3),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
            : FutureBuilder<File>(
                future: imageFile,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  image_first_photo = snapshot.data;
                  if (image_first_photo == null) return Container();
                  return GestureDetector(
                    onTap: () => wait_coml_first_photo
                        ? null
                        : getPhotoModalBottomSheet(context, true, true),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.file(
                            image_first_photo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: wait_first_photo
                                ? Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, right: 15),
                                    height: 25,
                                    width: 25,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : IconButton(
                                    color: Colors.black,
                                    icon: Icon(Icons.upload_file_rounded),
                                    onPressed: () => uploadPhoto(
                                        context, 'auto', image_first_photo, () {
                                      setState(() {
                                        wait_first_photo = true;
                                      });
                                    }, () {
                                      setState(() {
                                        wait_first_photo = false;
                                        wait_coml_first_photo = true;
                                      });
                                    }, (val) {
                                      setState(() {
                                        finished_first_photo = val;
                                      });
                                    }),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
        : TextButton(
            onPressed: () => getPhotoModalBottomSheet(context, true, true),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(247, 247, 249, 1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_rounded),
                Text('Выберете фотографию')
              ],
            ),
          );
  }

  Widget cntUploadedPhotoSecond() {
    return finished_first_photo != null
        ? imageFile != null
            ? finished_second_photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: finished_second_photo,
                      cacheManager: DefaultCacheManager(),
                      imageBuilder: (context, imageProvider) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5, right: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )),
                          ),
                        ],
                      ),
                      placeholderFadeInDuration: Duration(milliseconds: 500),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300].withOpacity(0.3),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : FutureBuilder<File>(
                    future: imageFile,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      image_second_photo = snapshot.data;
                      if (image_second_photo == null) return Container();
                      return GestureDetector(
                        onTap: () => wait_coml_second_photo
                            ? null
                            : getPhotoModalBottomSheet(context, true, true),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Image.file(
                                image_second_photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: wait_second_photo
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, right: 15),
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.upload_file_rounded),
                                        onPressed: () => uploadPhoto(
                                            context, 'auto', image_second_photo,
                                            () {
                                          setState(() {
                                            wait_second_photo = true;
                                          });
                                        }, () {
                                          setState(() {
                                            wait_second_photo = false;
                                            wait_coml_second_photo = true;
                                          });
                                        }, (val) {
                                          setState(() {
                                            finished_second_photo = val;
                                          });
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
            : TextButton(
                onPressed: () => getPhotoModalBottomSheet(context, true, true),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(247, 247, 249, 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded),
                    Text('Выберете фотографию')
                  ],
                ),
              )
        : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.grey[300].withOpacity(0.25),
            ),
          );
  }

  Widget cntUploadedPhotoThird() {
    return finished_second_photo != null
        ? imageFile != null
            ? finished_third_photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: finished_third_photo,
                      cacheManager: DefaultCacheManager(),
                      imageBuilder: (context, imageProvider) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5, right: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )),
                          ),
                        ],
                      ),
                      placeholderFadeInDuration: Duration(milliseconds: 500),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300].withOpacity(0.3),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : FutureBuilder<File>(
                    future: imageFile,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      image_third_photo = snapshot.data;
                      if (image_third_photo == null) return Container();
                      return GestureDetector(
                        onTap: () => wait_coml_third_photo
                            ? null
                            : getPhotoModalBottomSheet(context, true, true),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Image.file(
                                image_third_photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: wait_third_photo
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, right: 15),
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.upload_file_rounded),
                                        onPressed: () => uploadPhoto(
                                            context, 'auto', image_third_photo,
                                            () {
                                          setState(() {
                                            wait_third_photo = true;
                                          });
                                        }, () {
                                          setState(() {
                                            wait_third_photo = false;
                                            wait_coml_third_photo = true;
                                          });
                                        }, (val) {
                                          setState(() {
                                            finished_third_photo = val;
                                          });
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
            : TextButton(
                onPressed: () => getPhotoModalBottomSheet(context, true, true),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(247, 247, 249, 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_rounded),
                    Text('Выберете фотографию')
                  ],
                ),
              )
        : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.grey[300].withOpacity(0.25),
            ),
          );
  }

  Widget cntUploadedPhotoFourth() {
    return finished_third_photo != null
        ? imageFile != null
            ? finished_fourth_photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: finished_fourth_photo,
                      cacheManager: DefaultCacheManager(),
                      imageBuilder: (context, imageProvider) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5, right: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )),
                          ),
                        ],
                      ),
                      placeholderFadeInDuration: Duration(milliseconds: 500),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300].withOpacity(0.3),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : FutureBuilder<File>(
                    future: imageFile,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      image_fourth_photo = snapshot.data;
                      if (image_fourth_photo == null) return Container();
                      return GestureDetector(
                        onTap: () => wait_coml_fourth_photo
                            ? null
                            : getPhotoModalBottomSheet(context, true, true),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Image.file(
                                image_fourth_photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: wait_fourth_photo
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, right: 15),
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.upload_file_rounded),
                                        onPressed: () => uploadPhoto(
                                            context, 'auto', image_fourth_photo,
                                            () {
                                          setState(() {
                                            wait_fourth_photo = true;
                                          });
                                        }, () {
                                          setState(() {
                                            wait_fourth_photo = false;
                                            wait_coml_fourth_photo = true;
                                          });
                                        }, (val) {
                                          setState(() {
                                            finished_fourth_photo = val;
                                          });
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
            : TextButton(
                onPressed: () => getPhotoModalBottomSheet(context, true, true),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(247, 247, 249, 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_rounded),
                    Text('Выберете фотографию')
                  ],
                ),
              )
        : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.grey[300].withOpacity(0.25),
            ),
          );
  }

  Widget cntUploadedPhotoFifth() {
    return finished_fourth_photo != null
        ? imageFile != null
            ? finished_fifth_photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: finished_fifth_photo,
                      cacheManager: DefaultCacheManager(),
                      imageBuilder: (context, imageProvider) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5, right: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )),
                          ),
                        ],
                      ),
                      placeholderFadeInDuration: Duration(milliseconds: 500),
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300].withOpacity(0.3),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : FutureBuilder<File>(
                    future: imageFile,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      image_fifth_photo = snapshot.data;
                      if (image_fifth_photo == null) return Container();
                      return GestureDetector(
                        onTap: () => wait_coml_fifth_photo
                            ? null
                            : getPhotoModalBottomSheet(context, true, true),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Image.file(
                                image_fifth_photo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: wait_fifth_photo
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, right: 15),
                                        height: 25,
                                        width: 25,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : IconButton(
                                        color: Colors.black,
                                        icon: Icon(Icons.upload_file_rounded),
                                        onPressed: () => uploadPhoto(
                                            context, 'auto', image_fifth_photo,
                                            () {
                                          setState(() {
                                            wait_fifth_photo = true;
                                          });
                                        }, () {
                                          setState(() {
                                            wait_fifth_photo = false;
                                            wait_coml_fifth_photo = true;
                                          });
                                        }, (val) {
                                          setState(() {
                                            finished_fifth_photo = val;
                                          });
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
            : TextButton(
                onPressed: () => getPhotoModalBottomSheet(context, true, true),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(247, 247, 249, 1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_rounded),
                    Text('Выберете фотографию')
                  ],
                ),
              )
        : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.grey[300].withOpacity(0.25),
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

  assetThumbnail({dynamic asset}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Авто',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              fontFamily: "Comfortaa"),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 225,
                      child: GridView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        children: [
                          cntUploadedPhotoFirst(),
                          cntUploadedPhotoSecond(),
                          cntUploadedPhotoThird(),
                          cntUploadedPhotoFourth(),
                          cntUploadedPhotoFifth(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '*добавьте ссылку на видео, где подробно рассказывается о вашем товаре. Например: "https://www.youtube.com/watch?v=pAC-XwB_6fI"',
                            style: TextStyle(color: Colors.black, fontSize: 11),
                          ),
                        ),
                        textFieldtwo(controllerYoutube, false,
                            'Введите ссылку на видео с YouTube',
                            isText: true),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Введите заголовок объявления',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          'А так же Вы можете ввести описание к объявлению',
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        textFieldtwo(
                            controllerHead, error_head, 'Введите заголовок',
                            isText: true),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: textFieldtwo(
                              controllerDesc, false, 'Введите описание',
                              isText: true, lines: 7),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('h_m_category'),
                          style: TextStyle(
                              fontSize: 20,
                              color: errorMarketDropdown
                                  ? Colors.red[500]
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: twoColumnsContainer(
                        AppCheckbox(
                          value: rent_auto,
                          onChanged: (val) {
                            setState(() {
                              rent_auto = val;
                              only_foreign_cars = false;
                            });
                            controllerCarTax.clear();
                            controllerHosts.clear();
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Аренда авто',
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                        )),
                  ),
                  rent_auto
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Выберите срок проживания',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      value: rent_auto_term_val,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text('Выберите срок'),
                                      items: rent_auto_term.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          rent_auto_term_val = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: textFieldtwo(
                                  controllerPriceForTerm,
                                  errorPriceForTerm,
                                  'Цена за указанный срок',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Оплата',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      value: rent_auto_payment_val,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text('Выберите вид оплаты'),
                                      items: rent_auto_payment.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          rent_auto_payment_val = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Первоначальный взнос',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      value: rent_auto_an_initial_fee_val,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text(
                                          'Выберите вид первоначального взноса'),
                                      items:
                                          rent_auto_an_initial_fee.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          rent_auto_an_initial_fee_val = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              rent_auto_an_initial_fee_val == 'from_to'
                                  ? Container()
                                  : SizedBox(),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Договор',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      value: rent_auto_contract_val,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text('Выберите вид договора'),
                                      items: rent_auto_contract.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          rent_auto_contract_val = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Страхование КАСКО',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownButtonFormField(
                                      isExpanded: true,
                                      value: rent_auto_casco_insurance_val,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text(
                                          'Выберите вид страхование КАСКО'),
                                      items:
                                          rent_auto_casco_insurance.map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          rent_auto_casco_insurance_val = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  !rent_auto
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
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
                                  containerCarModel(mNameCars, mNameModelCars,
                                      (val) {
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
                                if (mValDriveAuto != null &&
                                    mValDriveAuto != '')
                                  mContainerGearboxAuto(mValGearboxBox, (val) {
                                    setState(() {
                                      mValGearboxBox = val;
                                    });
                                  }, context)
                              ],
                              ...[
                                if (mValGearboxBox != null &&
                                    mValGearboxBox != '' &&
                                    mValAuto != null &&
                                    mValAuto != '')
                                  Column(
                                    children: [
                                      Container(
                                        child: textFieldtwo(
                                          cntrllrEngineVolume,
                                          false,
                                          AppLocalizations.of(context)
                                              .translate('h_m_engine_volume'),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              child: textFieldtwo(
                                                cntrllrMileage,
                                                errorMileage,
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
                                                cntrllrYearOfIssue,
                                                errorYear,
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        'h_m_year_of_issue'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: textFieldtwo(
                                          controllerCarTax,
                                          errorCarTax,
                                          'Налог на авто',
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: textFieldtwo(
                                          controllerHosts,
                                          errorHosts,
                                          'Было хозяев',
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Местоположения',
                          style: TextStyle(
                              fontSize: 20,
                              color: errorMarketDropdown
                                  ? Colors.red[500]
                                  : Colors.black),
                        ),
                        dropdownValueLocates != null
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    dropdownValueLocates = null;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('cancel'),
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: dropdownValueLocates,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text('Выберите местопложение'),
                      items: city_kz.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          errorLocates = false;
                          dropdownValueLocates = value;
                        });
                      },
                    ),
                  ),
                  !rent_auto
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Состояние',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: errorMarketDropdown
                                        ? Colors.red[500]
                                        : Colors.black),
                              ),
                              valCondition != null
                                  ? TextButton(
                                      onPressed: () {
                                        setState(() {
                                          valCondition = null;
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('cancel'),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )
                      : SizedBox(),
                  !rent_auto
                      ? Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: valCondition,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: TextStyle(color: Colors.yellow),
                            ),
                            hint: Text('Выберите состояние'),
                            items: condition_auto.map((map) {
                              return DropdownMenuItem(
                                child: Text(AppLocalizations.of(context)
                                    .translate(map['value'])),
                                value: map['value'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                errorLocates = false;
                                dropdownValueLocates = value;
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  finished_first_photo != null && dropdownValueLocates != null
                      ? Container(
                          margin: EdgeInsets.only(top: 25),
                          height: 55,
                          child: TextButton(
                              onPressed: () {
                                var state = Provider.of<CloudFirestore>(context,
                                    listen: false);
                                rent_auto
                                    ? state.createAutoApplication(
                                        context,
                                        rent_auto_term_val:
                                            rent_auto_term_val ?? null,
                                        rent_auto_payment_val:
                                            rent_auto_payment_val ?? null,
                                        rent_auto_an_initial_fee_val:
                                            rent_auto_an_initial_fee_val ??
                                                null,
                                        rent_auto_contract_val:
                                            rent_auto_contract_val ?? null,
                                        rent_auto_casco_insurance_val:
                                            rent_auto_casco_insurance_val ??
                                                null,
                                        controllerPriceForTerm:
                                            controllerPriceForTerm.text
                                                    .trim() ??
                                                null,
                                        listURL: null,
                                        mValDriveAuto: null,
                                        mNameCars: null,
                                        mNameModelCars: null,
                                        valCondition: null,
                                        mValAuto: null,
                                        mValCarBody: null,
                                        mValGearboxBox: null,
                                        photo_1: finished_first_photo ?? null,
                                        photo_2: finished_second_photo ?? null,
                                        photo_3: finished_third_photo ?? null,
                                        photo_4: finished_fourth_photo ?? null,
                                        photo_5: finished_fifth_photo ?? null,
                                        youtube:
                                            controllerYoutube.text.trim() ??
                                                null,
                                        dValAuto: null,
                                        dValCommercial: null,
                                        dValOther: null,
                                        adress: dropdownValueLocates,
                                        a_desc:
                                            controllerDesc.text.trim() ?? null,
                                        a_head:
                                            controllerHead.text.trim() ?? null,
                                        region: null,
                                        dValRepairsAndService: null,
                                        dValSpareParts: null,
                                        description:
                                            controllerDesc.text.trim() ?? null,
                                        engineVolume: null,
                                        yearOfIssue: null,
                                        price: null,
                                        mileage: null,
                                      )
                                    : state.createAutoApplication(
                                        context,
                                        listURL: null,
                                        mValDriveAuto: mValDriveAuto ?? null,
                                        mNameCars: mNameCars ?? null,
                                        mNameModelCars: mNameModelCars ?? null,
                                        mValAuto: mValAuto,
                                        mValCarBody: mValCarBody ?? null,
                                        rent_auto_term_val: null,
                                        valCondition: valCondition ?? null,
                                        rent_auto_payment_val: null,
                                        rent_auto_an_initial_fee_val: null,
                                        rent_auto_contract_val:
                                            rent_auto_contract_val,
                                        rent_auto_casco_insurance_val: null,
                                        controllerPriceForTerm: null,
                                        mValGearboxBox: mValGearboxBox ?? null,
                                        photo_1: finished_first_photo ?? null,
                                        photo_2: finished_second_photo ?? null,
                                        photo_3: finished_third_photo ?? null,
                                        photo_4: finished_fourth_photo ?? null,
                                        photo_5: finished_fifth_photo ?? null,
                                        youtube:
                                            controllerYoutube.text.trim() ??
                                                null,
                                        dValAuto: dValAuto ?? null,
                                        dValCommercial: dValCommercial ?? null,
                                        dValOther: dValOther ?? null,
                                        adress: dropdownValueLocates,
                                        a_desc:
                                            controllerDesc.text.trim() ?? null,
                                        a_head:
                                            controllerHead.text.trim() ?? null,
                                        region: null,
                                        dValRepairsAndService:
                                            dValRepairsAndService ?? null,
                                        dValSpareParts: dValSpareParts ?? null,
                                        description:
                                            controllerDesc.text.trim() ?? null,
                                        engineVolume:
                                            cntrllrEngineVolume.text.trim() ??
                                                null,
                                        yearOfIssue:
                                            cntrllrYearOfIssue.text.trim() ??
                                                null,
                                        price:
                                            controllerPrice.text.trim() ?? null,
                                        mileage:
                                            cntrllrMileage.text.trim() ?? null,
                                      );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(255, 221, 97, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Далее',
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
                                          child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: Colors.black,
                                      ))),
                                ],
                              )),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
