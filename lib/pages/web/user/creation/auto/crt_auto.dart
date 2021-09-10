import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/functions/for_cusSmootPageIndicator.dart';
import 'package:kz/tools/functions/uploadedPhotoApp.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:kz/tools/widgets/supporting/customSmoothPageIndicator.dart';
import 'package:kz/tools/widgets/widget_containers/car_containers.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class CRTAuto extends StatefulWidget {
  CRTAuto({Key key}) : super(key: key);

  @override
  _CRTAutoState createState() => _CRTAutoState();
}

class _CRTAutoState extends State<CRTAuto> {
  PageController controller = PageController(initialPage: 0);
  Future<File> imageFile;
  double dataLongitude, dataLatitude;
  File image_first_photo,
      image_second_photo,
      image_third_photo,
      image_fourth_photo,
      image_fifth_photo;
  List<AssetEntity> assets = [];
  String finished_first_photo,
      finished_second_photo,
      finished_third_photo,
      finished_fourth_photo,
      finished_fifth_photo,
      mValAuto,
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
  bool serviceEnabled,
      wait_first_photo = false,
      wait_second_photo = false,
      wait_third_photo = false,
      wait_fourth_photo = false,
      wait_fifth_photo = false,
      wait_coml_first_photo = false,
      wait_coml_second_photo = false,
      wait_coml_third_photo = false,
      wait_coml_fourth_photo = false,
      wait_coml_fifth_photo = false,
      exchange = false,
      for_free = false,
      agreed = false,
      errorPrice = false,
      errorMarketDropdown = false,
      errorYear = false,
      getAddress = false;
  Address _address;
  LocationPermission permission;
  StreamSubscription<Position> _positionStream;
  TextEditingController cntrllrPriceApp;
  TextEditingController cntrllrHeadApp;
  TextEditingController cntrllrDescApp;
  TextEditingController cntrllrYoutubeVideoApp;
  TextEditingController cntrllrAdressApp;
  TextEditingController cntrllrEmailApp;
  TextEditingController cntrllrRegionApp;
  TextEditingController cntrllrMileage;
  TextEditingController cntrllrYearOfIssue;
  TextEditingController cntrllrEngineVolume;

  @override
  void initState() {
    _fetchAssets();
    cntrllrPriceApp = TextEditingController();
    cntrllrHeadApp = TextEditingController();
    cntrllrDescApp = TextEditingController();
    cntrllrYoutubeVideoApp = TextEditingController();
    cntrllrAdressApp = TextEditingController();
    cntrllrEmailApp = TextEditingController();
    cntrllrRegionApp = TextEditingController();
    cntrllrMileage = TextEditingController();
    cntrllrYearOfIssue = TextEditingController();
    cntrllrEngineVolume = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cntrllrPriceApp?.dispose();
    cntrllrHeadApp?.dispose();
    cntrllrDescApp?.dispose();
    cntrllrYoutubeVideoApp?.dispose();
    cntrllrAdressApp?.dispose();
    cntrllrEmailApp?.dispose();
    cntrllrRegionApp?.dispose();
    cntrllrMileage?.dispose();
    cntrllrYearOfIssue?.dispose();
    cntrllrEngineVolume?.dispose();
    super.dispose();
  }

  Future<Address> getAddressbaseOnLocation({Coordinates coordinates}) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    setState(() {
      getAddress = true;
    });
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
        .listen((Position position) {
      setState(() {
        dataLongitude = position.longitude;
        dataLatitude = position.latitude;
      });
      final coordinates = Coordinates(position.latitude, position.longitude);
      getAddressbaseOnLocation(coordinates: coordinates).then((value) {
        _address = value;
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Ваше местоположение найдено"),
          backgroundColor: Colors.greenAccent[700],
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          getAddress = false;
          _positionStream.cancel();
        });
      });
    });
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
                // selectedImage = true;
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
      backgroundColor: Color.fromRGBO(143, 161, 180, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 161, 180, 1),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 15),
            child: cusSmootPageIndicator(controller, counts: 4),
          ),
        ],
      ),
      body: Container(
        height: double.maxFinite,
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            uploadPhotoApplication(),
            widgetStart(),
            widgetCategory(),
            widgetContacts()
          ],
        ),
      ),
    );
  }

  Widget uploadPhotoApplication() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Добавьте фото вашего объявления',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  Text(
                    'Вы можете добавить до 5 фото к объявлению\nА так же вы можете добавить видео с YouTube',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ),
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
                  textFieldtwo(cntrllrYoutubeVideoApp, false,
                      'Введите ссылку на видео с YouTube',
                      isText: true),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '*добавьте ссылку на видео, где подробно рассказывается о вашем товаре',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
            finished_first_photo != null
                ? Container(
                    margin: EdgeInsets.only(top: 25),
                    height: 55,
                    child: TextButton(
                        onPressed: () => nextSmootPageIndicator(controller),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(255, 221, 97, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    borderRadius: BorderRadius.circular(20)),
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
    );
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
                                        context, '', image_first_photo, () {
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
                                            context, '', image_second_photo,
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
                                            context, '', image_third_photo, () {
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
                                            context, '', image_fourth_photo,
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
                                            context, '', image_fifth_photo, () {
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

  Widget widgetStart() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Введите заголовок объявления',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  Text(
                    'А так же Вы можете ввести описание к объявлению',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  textFieldtwo(cntrllrHeadApp, false, 'Введите заголовок',
                      isText: true),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: textFieldtwo(
                        cntrllrDescApp, false, 'Введите описание',
                        isText: true, lines: 7),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  agreed || for_free
                      ? SizedBox()
                      : textFieldtwo(
                          cntrllrPriceApp,
                          errorPrice,
                          AppLocalizations.of(context)
                              .translate('h_m_price_in_tenge'), onChanged: () {
                          setState(() {
                            agreed = false;
                            for_free = false;
                            errorPrice = false;
                          });
                        }),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: twoColumnsContainer(
                        AppCheckbox(
                          value: agreed,
                          onChanged: (val) {
                            setState(() {
                              agreed = val;
                              for_free = false;
                              cntrllrPriceApp.clear();
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('h_m_negotiated_price'),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: twoColumnsContainer(
                        AppCheckbox(
                          value: for_free,
                          onChanged: (val) {
                            setState(() {
                              for_free = val;
                              agreed = false;
                              cntrllrPriceApp.clear();
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('h_m_will_give_free'),
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 5,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Обмен',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  twoColumnsContainer(
                      AppCheckbox(
                        value: exchange,
                        onChanged: (val) {
                          setState(() {
                            exchange = val;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('h_m_exchange_true'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            cntrllrHeadApp.text.length >= 1 &&
                        cntrllrPriceApp.text.length >= 1 ||
                    for_free ||
                    agreed
                ? Container(
                    margin: EdgeInsets.only(top: 25),
                    height: 55,
                    child: TextButton(
                        onPressed: () => nextSmootPageIndicator(controller),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(255, 221, 97, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    borderRadius: BorderRadius.circular(20)),
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
    );
  }

  Widget widgetCategory() {
    return SingleChildScrollView(
      child: Container(
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
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              cntrllrMileage,
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
                              cntrllrYearOfIssue,
                              errorYear,
                              AppLocalizations.of(context)
                                  .translate('h_m_year_of_issue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 20),
                      height: 55,
                      child: TextButton(
                          onPressed: () => nextSmootPageIndicator(controller),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(255, 221, 97, 1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.black,
                                  ))),
                            ],
                          )),
                    )
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget widgetContacts() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context).translate('h_m_contact_info'),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: twoLinesContainer(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .translate('h_m_region'),
                                style: TextStyle(color: Colors.white)),
                            getAddress
                                ? Container(
                                    height: 20,
                                    margin: EdgeInsets.only(left: 10),
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : _address != null
                                    ? Container(
                                        height: 20,
                                        margin: EdgeInsets.only(left: 10),
                                        width: 20,
                                        alignment: Alignment.center,
                                        child: Center(
                                            child: Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 20,
                                          color: Color.fromRGBO(49, 203, 0, 1)
                                              .withOpacity(0.5),
                                        )),
                                      )
                                    : SizedBox(),
                          ],
                        ),
                        _address != null
                            ? SizedBox()
                            : TextButton(
                                onPressed: () {
                                  getCurrentLocation();
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_m_get_location'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                      ],
                    ),
                    textField(cntrllrRegionApp, false,
                        enable: !getAddress,
                        colorsHintText: Colors.white,
                        colorsText: Colors.white,
                        hint: !getAddress && _address != null
                            ? _address.addressLine.toString()
                            : AppLocalizations.of(context)
                                .translate('h_m_enter_region')),
                  ),
                ),
                !getAddress && _address != null
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: twoLinesContainer(
                          Text(
                              AppLocalizations.of(context)
                                  .translate('h_m_adress'),
                              style: TextStyle(color: Colors.white)),
                          textField(cntrllrAdressApp, false,
                              colorsHintText: Colors.white,
                              colorsText: Colors.white,
                              hint: AppLocalizations.of(context)
                                  .translate('h_m_enter_adress')),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: twoLinesContainer(
                      Text(AppLocalizations.of(context).translate('h_m_email'),
                          style: TextStyle(color: Colors.white)),
                      textField(cntrllrEmailApp, false,
                          colorsHintText: Colors.white,
                          colorsText: Colors.white,
                          hint: AppLocalizations.of(context)
                              .translate('h_m_enter_email'))),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            height: 55,
            child: TextButton(
                onPressed: () {
                  var state =
                      Provider.of<CloudFirestore>(context, listen: false);
                  state.createAutoApplication(
                    context,
                    [],
                    mValDriveAuto: mValDriveAuto ?? null,
                    mNameCars: mNameCars ?? null,
                    mNameModelCars: mNameModelCars ?? null,
                    mValAuto: mValAuto,
                    mValCarBody: mValCarBody ?? null,
                    mValGearboxBox: mValGearboxBox ?? null,
                    photo_1: finished_first_photo ?? null,
                    photo_2: finished_second_photo ?? null,
                    photo_3: finished_third_photo ?? null,
                    photo_4: finished_fourth_photo ?? null,
                    photo_5: finished_fifth_photo ?? null,
                    youtube: cntrllrYoutubeVideoApp.text.trim() ?? null,
                    dValAuto: dValAuto ?? null,
                    dValCommercial: dValCommercial ?? null,
                    dValOther: dValOther ?? null,
                    adress: _address != null
                        ? _address.addressLine
                        : cntrllrAdressApp.text.trim() ?? null,
                    a_desc: cntrllrDescApp.text.trim() ?? null,
                    a_head: cntrllrHeadApp.text.trim() ?? null,
                    region: _address != null
                        ? null
                        : cntrllrRegionApp.text.trim() ?? null,
                    dValRepairsAndService: dValRepairsAndService ?? null,
                    dValSpareParts: dValSpareParts ?? null,
                    description: cntrllrDescApp.text.trim() ?? null,
                    engineVolume: cntrllrEngineVolume.text.trim() ?? null,
                    yearOfIssue: cntrllrYearOfIssue.text.trim() ?? null,
                    price: cntrllrPriceApp.text.trim() ?? null,
                    mileage: cntrllrMileage.text.trim() ?? null,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(255, 221, 97, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('h_m_good_application'),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.40),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Colors.black,
                        ))),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
