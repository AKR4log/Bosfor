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
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class CRTMarket extends StatefulWidget {
  CRTMarket({Key key}) : super(key: key);

  @override
  _CRTMarketState createState() => _CRTMarketState();
}

class _CRTMarketState extends State<CRTMarket> {
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
      dropdownValue,
      dropdownValueTwo,
      dropdownValueThree;
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
      getAddress = false;
  Address _address;
  LocationPermission permission;
  StreamSubscription<Position> _positionStream;
  TextEditingController cntrllrMrktPriceApp;
  TextEditingController cntrllrHeadApp;
  TextEditingController cntrllrDescApp;
  TextEditingController cntrllrYoutubeVideoApp;
  TextEditingController cntrllrMrktAdressApp;
  TextEditingController cntrllrMrktEmailApp;
  TextEditingController cntrllrMrktRegionApp;

  @override
  void initState() {
    _fetchAssets();
    cntrllrMrktPriceApp = TextEditingController();
    cntrllrHeadApp = TextEditingController();
    cntrllrDescApp = TextEditingController();
    cntrllrYoutubeVideoApp = TextEditingController();
    cntrllrMrktAdressApp = TextEditingController();
    cntrllrMrktEmailApp = TextEditingController();
    cntrllrMrktRegionApp = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cntrllrMrktPriceApp?.dispose();
    cntrllrHeadApp?.dispose();
    cntrllrDescApp?.dispose();
    cntrllrYoutubeVideoApp?.dispose();
    cntrllrMrktAdressApp?.dispose();
    cntrllrMrktEmailApp?.dispose();
    cntrllrMrktRegionApp?.dispose();
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
                                        context, 'mrkt', image_first_photo, () {
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
                                            context, 'mrkt', image_second_photo,
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
                                            context, 'mrkt', image_third_photo,
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
                                            context, 'mrkt', image_fourth_photo,
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
                                            context, 'mrkt', image_fifth_photo,
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
                          cntrllrMrktPriceApp,
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
                              cntrllrMrktPriceApp.clear();
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
                              cntrllrMrktPriceApp.clear();
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
                        cntrllrMrktPriceApp.text.length >= 1 ||
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('h_m_category'),
                  style: TextStyle(
                      fontSize: 20,
                      color:
                          errorMarketDropdown ? Colors.red[500] : Colors.white),
                ),
                dropdownValue != null
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            dropdownValue = null;
                            dropdownValueTwo = null;
                            dropdownValueThree = null;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('cancel'),
                          style: TextStyle(color: Colors.white),
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
              value: dropdownValue,
              decoration: InputDecoration(
                filled: true,
                enabled: dropdownValueTwo != null ? false : true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.yellow),
              ),
              hint: Text(AppLocalizations.of(context)
                  .translate('h_m_selected_category')),
              items: m_average_category.map((map) {
                return DropdownMenuItem(
                  child: Text(
                      AppLocalizations.of(context).translate(map['value'])),
                  value: map['value'],
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  errorMarketDropdown = false;
                  dropdownValue = value;
                });
              },
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: dropdownValue == 'services'
                  ? DropdownButtonFormField(
                      isExpanded: true,
                      value: dropdownValueTwo,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: dropdownValueThree != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: m_lower_category_for_services.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueTwo = value;
                        });
                      },
                    )
                  : dropdownValue == 'electronics'
                      ? DropdownButtonFormField(
                          isExpanded: true,
                          value: dropdownValueTwo,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabled: dropdownValueThree != null ? false : true,
                            errorStyle: TextStyle(color: Colors.yellow),
                          ),
                          hint: Text(AppLocalizations.of(context)
                              .translate('h_m_selected_category')),
                          items: m_lower_category_for_electronics.map((map) {
                            return DropdownMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate(map['value'])),
                              value: map['value'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValueTwo = value;
                            });
                          },
                        )
                      : dropdownValue == 'home_and_garden'
                          ? DropdownButtonFormField(
                              isExpanded: true,
                              value: dropdownValueTwo,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabled:
                                    dropdownValueThree != null ? false : true,
                                errorStyle: TextStyle(color: Colors.yellow),
                              ),
                              hint: Text(AppLocalizations.of(context)
                                  .translate('h_m_selected_category')),
                              items: m_lower_category_for_home_and_garden
                                  .map((map) {
                                return DropdownMenuItem(
                                  child: Text(AppLocalizations.of(context)
                                      .translate(map['value'])),
                                  value: map['value'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValueTwo = value;
                                });
                              },
                            )
                          : dropdownValue == 'personal_belongings'
                              ? DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownValueTwo,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabled: dropdownValueThree != null
                                        ? false
                                        : true,
                                    errorStyle: TextStyle(color: Colors.yellow),
                                  ),
                                  hint: Text(AppLocalizations.of(context)
                                      .translate('h_m_selected_category')),
                                  items:
                                      m_lower_category_for_personal_belongings
                                          .map((map) {
                                    return DropdownMenuItem(
                                      child: Text(AppLocalizations.of(context)
                                          .translate(map['value'])),
                                      value: map['value'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValueTwo = value;
                                    });
                                  },
                                )
                              : dropdownValue == 'for_business'
                                  ? DropdownButtonFormField(
                                      isExpanded: true,
                                      value: dropdownValueTwo,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabled: dropdownValueThree != null
                                            ? false
                                            : true,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text(AppLocalizations.of(context)
                                          .translate('h_m_selected_category')),
                                      items: m_lower_category_for_business
                                          .map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownValueTwo = value;
                                        });
                                      },
                                    )
                                  : dropdownValue == 'animals'
                                      ? DropdownButtonFormField(
                                          isExpanded: true,
                                          value: dropdownValueTwo,
                                          decoration: InputDecoration(
                                            filled: true,
                                            enabled: dropdownValueThree != null
                                                ? false
                                                : true,
                                            fillColor: Colors.white,
                                            errorStyle:
                                                TextStyle(color: Colors.yellow),
                                          ),
                                          hint: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'h_m_selected_category')),
                                          items: m_lower_category_for_animals
                                              .map((map) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(map['value'])),
                                              value: map['value'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              dropdownValueTwo = value;
                                            });
                                          },
                                        )
                                      : dropdownValue == 'for_children'
                                          ? DropdownButtonFormField(
                                              isExpanded: true,
                                              value: dropdownValueTwo,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabled:
                                                    dropdownValueThree != null
                                                        ? false
                                                        : true,
                                                errorStyle: TextStyle(
                                                    color: Colors.yellow),
                                              ),
                                              hint: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'h_m_selected_category')),
                                              items:
                                                  m_lower_category_for_children
                                                      .map((map) {
                                                return DropdownMenuItem(
                                                  child: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(map['value'])),
                                                  value: map['value'],
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  dropdownValueTwo = value;
                                                });
                                              },
                                            )
                                          : dropdownValue ==
                                                  'hobbies_and_sports'
                                              ? DropdownButtonFormField(
                                                  isExpanded: true,
                                                  value: dropdownValueTwo,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabled:
                                                        dropdownValueThree !=
                                                                null
                                                            ? false
                                                            : true,
                                                    errorStyle: TextStyle(
                                                        color: Colors.yellow),
                                                  ),
                                                  hint: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(
                                                          'h_m_selected_category')),
                                                  items:
                                                      m_lower_category_for_hobbies_and_sports
                                                          .map((map) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(map[
                                                                  'value'])),
                                                      value: map['value'],
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dropdownValueTwo = value;
                                                    });
                                                  },
                                                )
                                              : dropdownValue == 'work'
                                                  ? DropdownButtonFormField(
                                                      isExpanded: true,
                                                      value: dropdownValueTwo,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        enabled:
                                                            dropdownValueThree !=
                                                                    null
                                                                ? false
                                                                : true,
                                                        errorStyle: TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      ),
                                                      hint: Text(AppLocalizations
                                                              .of(context)
                                                          .translate(
                                                              'h_m_selected_category')),
                                                      items:
                                                          m_lower_category_for_work
                                                              .map((map) {
                                                        return DropdownMenuItem(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(map[
                                                                      'value'])),
                                                          value: map['value'],
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dropdownValueTwo =
                                                              value;
                                                        });
                                                      },
                                                    )
                                                  : SizedBox()),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 5),
              child: dropdownValueTwo == 'construction_and_repair'
                  ? DropdownButtonFormField(
                      isExpanded: true,
                      value: dropdownValueThree,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items:
                          m_upper_category_for_services_construction_and_repair
                              .map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValueThree = value;
                        });
                      },
                    )
                  : dropdownValueTwo == 'education_or_courses'
                      ? DropdownButtonFormField(
                          isExpanded: true,
                          value: dropdownValueThree,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.yellow),
                          ),
                          hint: Text(AppLocalizations.of(context)
                              .translate('h_m_selected_category')),
                          items:
                              m_upper_category_for_services_education_or_courses
                                  .map((map) {
                            return DropdownMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate(map['value'])),
                              value: map['value'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownValueThree = value;
                            });
                          },
                        )
                      : dropdownValueTwo == 'kepair_and_maintenance_equipment'
                          ? DropdownButtonFormField(
                              isExpanded: true,
                              value: dropdownValueThree,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: TextStyle(color: Colors.yellow),
                              ),
                              hint: Text(AppLocalizations.of(context)
                                  .translate('h_m_selected_category')),
                              items:
                                  m_upper_category_for_services_kepair_and_maintenance_equipment
                                      .map((map) {
                                return DropdownMenuItem(
                                  child: Text(AppLocalizations.of(context)
                                      .translate(map['value'])),
                                  value: map['value'],
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValueThree = value;
                                });
                              },
                            )
                          : dropdownValueTwo == 'rental_goods'
                              ? DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownValueThree,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorStyle: TextStyle(color: Colors.yellow),
                                  ),
                                  hint: Text(AppLocalizations.of(context)
                                      .translate('h_m_selected_category')),
                                  items:
                                      m_upper_category_for_services_rental_goods
                                          .map((map) {
                                    return DropdownMenuItem(
                                      child: Text(AppLocalizations.of(context)
                                          .translate(map['value'])),
                                      value: map['value'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValueThree = value;
                                    });
                                  },
                                )
                              : dropdownValueTwo == 'beauty_and_health'
                                  ? DropdownButtonFormField(
                                      isExpanded: true,
                                      value: dropdownValueThree,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        errorStyle:
                                            TextStyle(color: Colors.yellow),
                                      ),
                                      hint: Text(AppLocalizations.of(context)
                                          .translate('h_m_selected_category')),
                                      items:
                                          m_upper_category_for_services_beauty_and_health
                                              .map((map) {
                                        return DropdownMenuItem(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(map['value'])),
                                          value: map['value'],
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownValueThree = value;
                                        });
                                      },
                                    )
                                  : dropdownValueTwo == 'internet_and_computers'
                                      ? DropdownButtonFormField(
                                          isExpanded: true,
                                          value: dropdownValueThree,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            errorStyle:
                                                TextStyle(color: Colors.yellow),
                                          ),
                                          hint: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'h_m_selected_category')),
                                          items:
                                              m_upper_category_for_services_internet_and_computers
                                                  .map((map) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(map['value'])),
                                              value: map['value'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              dropdownValueThree = value;
                                            });
                                          },
                                        )
                                      : dropdownValueTwo ==
                                              'transportation_or_car_service'
                                          ? DropdownButtonFormField(
                                              isExpanded: true,
                                              value: dropdownValueThree,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                errorStyle: TextStyle(
                                                    color: Colors.yellow),
                                              ),
                                              hint: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'h_m_selected_category')),
                                              items:
                                                  m_upper_category_for_services_transportation_or_car_service
                                                      .map((map) {
                                                return DropdownMenuItem(
                                                  child: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(map['value'])),
                                                  value: map['value'],
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  dropdownValueThree = value;
                                                });
                                              },
                                            )
                                          : dropdownValueTwo ==
                                                  'business_services'
                                              ? DropdownButtonFormField(
                                                  isExpanded: true,
                                                  value: dropdownValueThree,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorStyle: TextStyle(
                                                        color: Colors.yellow),
                                                  ),
                                                  hint: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(
                                                          'h_m_selected_category')),
                                                  items:
                                                      m_upper_category_for_services_business_services
                                                          .map((map) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(map[
                                                                  'value'])),
                                                      value: map['value'],
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dropdownValueThree =
                                                          value;
                                                    });
                                                  },
                                                )
                                              : dropdownValueTwo == 'cleaning'
                                                  ? DropdownButtonFormField(
                                                      isExpanded: true,
                                                      value: dropdownValueThree,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        errorStyle: TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      ),
                                                      hint: Text(AppLocalizations
                                                              .of(context)
                                                          .translate(
                                                              'h_m_selected_category')),
                                                      items:
                                                          m_upper_category_for_services_cleaning
                                                              .map((map) {
                                                        return DropdownMenuItem(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(map[
                                                                      'value'])),
                                                          value: map['value'],
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dropdownValueThree =
                                                              value;
                                                        });
                                                      },
                                                    )
                                                  : dropdownValueTwo ==
                                                          'computers'
                                                      ? DropdownButtonFormField(
                                                          isExpanded: true,
                                                          value:
                                                              dropdownValueThree,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            errorStyle: TextStyle(
                                                                color: Colors
                                                                    .yellow),
                                                          ),
                                                          hint: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'h_m_selected_category')),
                                                          items:
                                                              m_upper_category_for_electronics_computers
                                                                  .map((map) {
                                                            return DropdownMenuItem(
                                                              child: Text(AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(map[
                                                                      'value'])),
                                                              value:
                                                                  map['value'],
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              dropdownValueThree =
                                                                  value;
                                                            });
                                                          },
                                                        )
                                                      : dropdownValueTwo ==
                                                              'photo_and_video_cameras'
                                                          ? DropdownButtonFormField(
                                                              isExpanded: true,
                                                              value:
                                                                  dropdownValueThree,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                errorStyle: TextStyle(
                                                                    color: Colors
                                                                        .yellow),
                                                              ),
                                                              hint: Text(AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'h_m_selected_category')),
                                                              items:
                                                                  m_lower_category_for_work
                                                                      .map(
                                                                          (map) {
                                                                return DropdownMenuItem(
                                                                  child: Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          map['value'])),
                                                                  value: map[
                                                                      'value'],
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  dropdownValueThree =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          : dropdownValueTwo ==
                                                                  'phones_or_gadgets'
                                                              ? DropdownButtonFormField(
                                                                  isExpanded:
                                                                      true,
                                                                  value:
                                                                      dropdownValueThree,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    errorStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Colors.yellow),
                                                                  ),
                                                                  hint: Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'h_m_selected_category')),
                                                                  items: m_upper_category_for_electronics_phones_or_gadgets
                                                                      .map(
                                                                          (map) {
                                                                    return DropdownMenuItem(
                                                                      child: Text(AppLocalizations.of(
                                                                              context)
                                                                          .translate(
                                                                              map['value'])),
                                                                      value: map[
                                                                          'value'],
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      dropdownValueThree =
                                                                          value;
                                                                    });
                                                                  },
                                                                )
                                                              : dropdownValueTwo ==
                                                                      'tv_and_video'
                                                                  ? DropdownButtonFormField(
                                                                      isExpanded:
                                                                          true,
                                                                      value:
                                                                          dropdownValueThree,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        errorStyle:
                                                                            TextStyle(color: Colors.yellow),
                                                                      ),
                                                                      hint: Text(AppLocalizations.of(
                                                                              context)
                                                                          .translate(
                                                                              'h_m_selected_category')),
                                                                      items: m_upper_category_for_electronics_tv_and_video
                                                                          .map(
                                                                              (map) {
                                                                        return DropdownMenuItem(
                                                                          child:
                                                                              Text(AppLocalizations.of(context).translate(map['value'])),
                                                                          value:
                                                                              map['value'],
                                                                        );
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          dropdownValueThree =
                                                                              value;
                                                                        });
                                                                      },
                                                                    )
                                                                  : dropdownValueTwo ==
                                                                          'audio_engineering'
                                                                      ? DropdownButtonFormField(
                                                                          isExpanded:
                                                                              true,
                                                                          value:
                                                                              dropdownValueThree,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            errorStyle:
                                                                                TextStyle(color: Colors.yellow),
                                                                          ),
                                                                          hint:
                                                                              Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                          items:
                                                                              m_upper_category_for_electronics_audio_engineering.map((map) {
                                                                            return DropdownMenuItem(
                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                              value: map['value'],
                                                                            );
                                                                          }).toList(),
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              dropdownValueThree = value;
                                                                            });
                                                                          },
                                                                        )
                                                                      : dropdownValueTwo ==
                                                                              'gaming_consoles'
                                                                          ? DropdownButtonFormField(
                                                                              isExpanded: true,
                                                                              value: dropdownValueThree,
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                              ),
                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                              items: m_upper_category_for_electronics_gaming_consoles.map((map) {
                                                                                return DropdownMenuItem(
                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                  value: map['value'],
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  dropdownValueThree = value;
                                                                                });
                                                                              },
                                                                            )
                                                                          : dropdownValueTwo == 'individual_care'
                                                                              ? DropdownButtonFormField(
                                                                                  isExpanded: true,
                                                                                  value: dropdownValueThree,
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: Colors.white,
                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                  ),
                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                  items: m_upper_category_for_electronics_individual_care.map((map) {
                                                                                    return DropdownMenuItem(
                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                      value: map['value'],
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      dropdownValueThree = value;
                                                                                    });
                                                                                  },
                                                                                )
                                                                              : dropdownValueTwo == 'air_conditioning_equipment'
                                                                                  ? DropdownButtonFormField(
                                                                                      isExpanded: true,
                                                                                      value: dropdownValueThree,
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                      ),
                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                      items: m_upper_category_for_electronics_air_conditioning_equipment.map((map) {
                                                                                        return DropdownMenuItem(
                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                          value: map['value'],
                                                                                        );
                                                                                      }).toList(),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          dropdownValueThree = value;
                                                                                        });
                                                                                      },
                                                                                    )
                                                                                  : dropdownValueTwo == 'kitchen_appliances'
                                                                                      ? DropdownButtonFormField(
                                                                                          isExpanded: true,
                                                                                          value: dropdownValueThree,
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.white,
                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                          ),
                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                          items: m_upper_category_for_electronics_kitchen_appliances.map((map) {
                                                                                            return DropdownMenuItem(
                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                              value: map['value'],
                                                                                            );
                                                                                          }).toList(),
                                                                                          onChanged: (value) {
                                                                                            setState(() {
                                                                                              dropdownValueThree = value;
                                                                                            });
                                                                                          },
                                                                                        )
                                                                                      : dropdownValueTwo == 'home_appliances'
                                                                                          ? DropdownButtonFormField(
                                                                                              isExpanded: true,
                                                                                              value: dropdownValueThree,
                                                                                              decoration: InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                              ),
                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                              items: m_upper_category_for_electronics_home_appliances.map((map) {
                                                                                                return DropdownMenuItem(
                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                  value: map['value'],
                                                                                                );
                                                                                              }).toList(),
                                                                                              onChanged: (value) {
                                                                                                setState(() {
                                                                                                  dropdownValueThree = value;
                                                                                                });
                                                                                              },
                                                                                            )
                                                                                          : dropdownValueTwo == 'furniture_and_interior'
                                                                                              ? DropdownButtonFormField(
                                                                                                  isExpanded: true,
                                                                                                  value: dropdownValueThree,
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                  ),
                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                  items: m_upper_category_for_home_and_garden_furniture_and_interior.map((map) {
                                                                                                    return DropdownMenuItem(
                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                      value: map['value'],
                                                                                                    );
                                                                                                  }).toList(),
                                                                                                  onChanged: (value) {
                                                                                                    setState(() {
                                                                                                      dropdownValueThree = value;
                                                                                                    });
                                                                                                  },
                                                                                                )
                                                                                              : dropdownValueTwo == 'renovation_and_construction'
                                                                                                  ? DropdownButtonFormField(
                                                                                                      isExpanded: true,
                                                                                                      value: dropdownValueThree,
                                                                                                      decoration: InputDecoration(
                                                                                                        filled: true,
                                                                                                        fillColor: Colors.white,
                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                      ),
                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                      items: m_upper_category_for_home_and_garden_renovation_and_construction.map((map) {
                                                                                                        return DropdownMenuItem(
                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                          value: map['value'],
                                                                                                        );
                                                                                                      }).toList(),
                                                                                                      onChanged: (value) {
                                                                                                        setState(() {
                                                                                                          dropdownValueThree = value;
                                                                                                        });
                                                                                                      },
                                                                                                    )
                                                                                                  : dropdownValueTwo == 'tools_and_inventory'
                                                                                                      ? DropdownButtonFormField(
                                                                                                          isExpanded: true,
                                                                                                          value: dropdownValueThree,
                                                                                                          decoration: InputDecoration(
                                                                                                            filled: true,
                                                                                                            fillColor: Colors.white,
                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                          ),
                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                          items: m_upper_category_for_home_and_garden_tools_and_inventory.map((map) {
                                                                                                            return DropdownMenuItem(
                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                              value: map['value'],
                                                                                                            );
                                                                                                          }).toList(),
                                                                                                          onChanged: (value) {
                                                                                                            setState(() {
                                                                                                              dropdownValueThree = value;
                                                                                                            });
                                                                                                          },
                                                                                                        )
                                                                                                      : dropdownValueTwo == 'plants'
                                                                                                          ? DropdownButtonFormField(
                                                                                                              isExpanded: true,
                                                                                                              value: dropdownValueThree,
                                                                                                              decoration: InputDecoration(
                                                                                                                filled: true,
                                                                                                                fillColor: Colors.white,
                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                              ),
                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                              items: m_upper_category_for_home_and_garden_plants.map((map) {
                                                                                                                return DropdownMenuItem(
                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                  value: map['value'],
                                                                                                                );
                                                                                                              }).toList(),
                                                                                                              onChanged: (value) {
                                                                                                                setState(() {
                                                                                                                  dropdownValueThree = value;
                                                                                                                });
                                                                                                              },
                                                                                                            )
                                                                                                          : dropdownValueTwo == 'home_textiles'
                                                                                                              ? DropdownButtonFormField(
                                                                                                                  isExpanded: true,
                                                                                                                  value: dropdownValueThree,
                                                                                                                  decoration: InputDecoration(
                                                                                                                    filled: true,
                                                                                                                    fillColor: Colors.white,
                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                  ),
                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                  items: m_upper_category_for_home_and_garden_home_textiles.map((map) {
                                                                                                                    return DropdownMenuItem(
                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                      value: map['value'],
                                                                                                                    );
                                                                                                                  }).toList(),
                                                                                                                  onChanged: (value) {
                                                                                                                    setState(() {
                                                                                                                      dropdownValueThree = value;
                                                                                                                    });
                                                                                                                  },
                                                                                                                )
                                                                                                              : dropdownValueTwo == 'household_chemicals'
                                                                                                                  ? DropdownButtonFormField(
                                                                                                                      isExpanded: true,
                                                                                                                      value: dropdownValueThree,
                                                                                                                      decoration: InputDecoration(
                                                                                                                        filled: true,
                                                                                                                        fillColor: Colors.white,
                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                      ),
                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                      items: m_upper_category_for_home_and_garden_household_chemicals.map((map) {
                                                                                                                        return DropdownMenuItem(
                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                          value: map['value'],
                                                                                                                        );
                                                                                                                      }).toList(),
                                                                                                                      onChanged: (value) {
                                                                                                                        setState(() {
                                                                                                                          dropdownValueThree = value;
                                                                                                                        });
                                                                                                                      },
                                                                                                                    )
                                                                                                                  : dropdownValueTwo == 'clothing'
                                                                                                                      ? DropdownButtonFormField(
                                                                                                                          isExpanded: true,
                                                                                                                          value: dropdownValueThree,
                                                                                                                          decoration: InputDecoration(
                                                                                                                            filled: true,
                                                                                                                            fillColor: Colors.white,
                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                          ),
                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                          items: m_upper_category_for_personal_belongings_clothing.map((map) {
                                                                                                                            return DropdownMenuItem(
                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                              value: map['value'],
                                                                                                                            );
                                                                                                                          }).toList(),
                                                                                                                          onChanged: (value) {
                                                                                                                            setState(() {
                                                                                                                              dropdownValueThree = value;
                                                                                                                            });
                                                                                                                          },
                                                                                                                        )
                                                                                                                      : dropdownValueTwo == 'footwear'
                                                                                                                          ? DropdownButtonFormField(
                                                                                                                              isExpanded: true,
                                                                                                                              value: dropdownValueThree,
                                                                                                                              decoration: InputDecoration(
                                                                                                                                filled: true,
                                                                                                                                fillColor: Colors.white,
                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                              ),
                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                              items: m_upper_category_for_personal_belongings_footwear.map((map) {
                                                                                                                                return DropdownMenuItem(
                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                  value: map['value'],
                                                                                                                                );
                                                                                                                              }).toList(),
                                                                                                                              onChanged: (value) {
                                                                                                                                setState(() {
                                                                                                                                  dropdownValueThree = value;
                                                                                                                                });
                                                                                                                              },
                                                                                                                            )
                                                                                                                          : dropdownValueTwo == 'for_the_wedding'
                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                  isExpanded: true,
                                                                                                                                  value: dropdownValueThree,
                                                                                                                                  decoration: InputDecoration(
                                                                                                                                    filled: true,
                                                                                                                                    fillColor: Colors.white,
                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                  ),
                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                  items: m_upper_category_for_personal_belongings_for_the_wedding.map((map) {
                                                                                                                                    return DropdownMenuItem(
                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                      value: map['value'],
                                                                                                                                    );
                                                                                                                                  }).toList(),
                                                                                                                                  onChanged: (value) {
                                                                                                                                    setState(() {
                                                                                                                                      dropdownValueThree = value;
                                                                                                                                    });
                                                                                                                                  },
                                                                                                                                )
                                                                                                                              : dropdownValueTwo == 'accessories'
                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                      isExpanded: true,
                                                                                                                                      value: dropdownValueThree,
                                                                                                                                      decoration: InputDecoration(
                                                                                                                                        filled: true,
                                                                                                                                        fillColor: Colors.white,
                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                      ),
                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                      items: m_upper_category_for_personal_belongings_accessories.map((map) {
                                                                                                                                        return DropdownMenuItem(
                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                          value: map['value'],
                                                                                                                                        );
                                                                                                                                      }).toList(),
                                                                                                                                      onChanged: (value) {
                                                                                                                                        setState(() {
                                                                                                                                          dropdownValueThree = value;
                                                                                                                                        });
                                                                                                                                      },
                                                                                                                                    )
                                                                                                                                  : dropdownValueTwo == 'presents'
                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                          isExpanded: true,
                                                                                                                                          value: dropdownValueThree,
                                                                                                                                          decoration: InputDecoration(
                                                                                                                                            filled: true,
                                                                                                                                            fillColor: Colors.white,
                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                          ),
                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                          items: m_upper_category_for_personal_belongings_presents.map((map) {
                                                                                                                                            return DropdownMenuItem(
                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                              value: map['value'],
                                                                                                                                            );
                                                                                                                                          }).toList(),
                                                                                                                                          onChanged: (value) {
                                                                                                                                            setState(() {
                                                                                                                                              dropdownValueThree = value;
                                                                                                                                            });
                                                                                                                                          },
                                                                                                                                        )
                                                                                                                                      : dropdownValueTwo == 'products_for_beauty_and_health'
                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                              isExpanded: true,
                                                                                                                                              value: dropdownValueThree,
                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                filled: true,
                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                              ),
                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                              items: m_upper_category_for_personal_belongings_products_for_beauty_and_health.map((map) {
                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                  value: map['value'],
                                                                                                                                                );
                                                                                                                                              }).toList(),
                                                                                                                                              onChanged: (value) {
                                                                                                                                                setState(() {
                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                });
                                                                                                                                              },
                                                                                                                                            )
                                                                                                                                          : dropdownValueTwo == 'clock'
                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                  isExpanded: true,
                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                    filled: true,
                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                  ),
                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                  items: m_upper_category_for_personal_belongings_clock.map((map) {
                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                      value: map['value'],
                                                                                                                                                    );
                                                                                                                                                  }).toList(),
                                                                                                                                                  onChanged: (value) {
                                                                                                                                                    setState(() {
                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                    });
                                                                                                                                                  },
                                                                                                                                                )
                                                                                                                                              : dropdownValueTwo == 'raw_materials_and_supplies'
                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                      isExpanded: true,
                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                        filled: true,
                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                      ),
                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                      items: m_upper_category_for_business_raw_materials_and_supplies.map((map) {
                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                          value: map['value'],
                                                                                                                                                        );
                                                                                                                                                      }).toList(),
                                                                                                                                                      onChanged: (value) {
                                                                                                                                                        setState(() {
                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                        });
                                                                                                                                                      },
                                                                                                                                                    )
                                                                                                                                                  : dropdownValueTwo == 'equipment_and_technology'
                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                          isExpanded: true,
                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                            filled: true,
                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                          ),
                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                          items: m_upper_category_for_business_equipment_and_technology.map((map) {
                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                              value: map['value'],
                                                                                                                                                            );
                                                                                                                                                          }).toList(),
                                                                                                                                                          onChanged: (value) {
                                                                                                                                                            setState(() {
                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                            });
                                                                                                                                                          },
                                                                                                                                                        )
                                                                                                                                                      : dropdownValueTwo == 'food'
                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                              isExpanded: true,
                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                filled: true,
                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                              ),
                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                              items: m_upper_category_for_business_food.map((map) {
                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                  value: map['value'],
                                                                                                                                                                );
                                                                                                                                                              }).toList(),
                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                setState(() {
                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                });
                                                                                                                                                              },
                                                                                                                                                            )
                                                                                                                                                          : dropdownValueTwo == 'industrial_goods'
                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                    filled: true,
                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                  ),
                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                  items: m_upper_category_for_business_industrial_goods.map((map) {
                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                      value: map['value'],
                                                                                                                                                                    );
                                                                                                                                                                  }).toList(),
                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                    setState(() {
                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                    });
                                                                                                                                                                  },
                                                                                                                                                                )
                                                                                                                                                              : dropdownValueTwo == 'sale_or_purchase_business'
                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                        filled: true,
                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                      ),
                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                      items: m_upper_category_for_business_sale_or_purchase_business.map((map) {
                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                          value: map['value'],
                                                                                                                                                                        );
                                                                                                                                                                      }).toList(),
                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                        setState(() {
                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                        });
                                                                                                                                                                      },
                                                                                                                                                                    )
                                                                                                                                                                  : dropdownValueTwo == 'services_for_animals'
                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                            filled: true,
                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                          ),
                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                          items: m_upper_category_for_animals_services_for_animals.map((map) {
                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                              value: map['value'],
                                                                                                                                                                            );
                                                                                                                                                                          }).toList(),
                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                            setState(() {
                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                            });
                                                                                                                                                                          },
                                                                                                                                                                        )
                                                                                                                                                                      : dropdownValueTwo == 'lost_and_found'
                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                filled: true,
                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                              ),
                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                              items: m_upper_category_for_animals_lost_and_found.map((map) {
                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                );
                                                                                                                                                                              }).toList(),
                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                setState(() {
                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                });
                                                                                                                                                                              },
                                                                                                                                                                            )
                                                                                                                                                                          : dropdownValueTwo == 'baby_clothes'
                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                    filled: true,
                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                  ),
                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                  items: m_upper_category_for_children_baby_clothes.map((map) {
                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                    );
                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                    setState(() {
                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                    });
                                                                                                                                                                                  },
                                                                                                                                                                                )
                                                                                                                                                                              : dropdownValueTwo == 'children_shoes'
                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                        filled: true,
                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                      ),
                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                      items: m_upper_category_for_children_children_shoes.map((map) {
                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                        );
                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                        setState(() {
                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                        });
                                                                                                                                                                                      },
                                                                                                                                                                                    )
                                                                                                                                                                                  : dropdownValueTwo == 'children_furniture'
                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                            filled: true,
                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                          ),
                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                          items: m_upper_category_for_children_children_furniture.map((map) {
                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                            );
                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                            setState(() {
                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                            });
                                                                                                                                                                                          },
                                                                                                                                                                                        )
                                                                                                                                                                                      : dropdownValueTwo == 'collecting'
                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                              ),
                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                              items: m_upper_category_for_hobbies_and_sports_collecting.map((map) {
                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                );
                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                });
                                                                                                                                                                                              },
                                                                                                                                                                                            )
                                                                                                                                                                                          : dropdownValueTwo == 'musical_instruments'
                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                  ),
                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                  items: m_upper_category_for_hobbies_and_sports_musical_instruments.map((map) {
                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                    );
                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                    });
                                                                                                                                                                                                  },
                                                                                                                                                                                                )
                                                                                                                                                                                              : dropdownValueTwo == 'sports_and_recreation'
                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                      ),
                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                      items: m_upper_category_for_hobbies_and_sports_sports_and_recreation.map((map) {
                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                        );
                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                        });
                                                                                                                                                                                                      },
                                                                                                                                                                                                    )
                                                                                                                                                                                                  : dropdownValueTwo == 'books_or_magazines'
                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                          ),
                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                          items: m_upper_category_for_hobbies_and_sports_books_or_magazines.map((map) {
                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                            );
                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                            });
                                                                                                                                                                                                          },
                                                                                                                                                                                                        )
                                                                                                                                                                                                      : dropdownValueTwo == 'bicycles'
                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                              ),
                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                              items: m_upper_category_for_hobbies_and_sports_bicycles.map((map) {
                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                );
                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                });
                                                                                                                                                                                                              },
                                                                                                                                                                                                            )
                                                                                                                                                                                                          : dropdownValueTwo == 'tickets'
                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                  items: m_upper_category_for_hobbies_and_sports_tickets.map((map) {
                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                    );
                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                    });
                                                                                                                                                                                                                  },
                                                                                                                                                                                                                )
                                                                                                                                                                                                              : dropdownValueTwo == 'travels'
                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                      items: m_upper_category_for_hobbies_and_sports_travels.map((map) {
                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                        );
                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                        });
                                                                                                                                                                                                                      },
                                                                                                                                                                                                                    )
                                                                                                                                                                                                                  : dropdownValueTwo == 'cd_or_dvd_or_records'
                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                          items: m_upper_category_for_hobbies_and_sports_cd_or_dvd_or_records.map((map) {
                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                            );
                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                            });
                                                                                                                                                                                                                          },
                                                                                                                                                                                                                        )
                                                                                                                                                                                                                      : dropdownValueTwo == 'trade_or_sales'
                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                              items: m_upper_category_for_work_trade_or_sales.map((map) {
                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                );
                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                });
                                                                                                                                                                                                                              },
                                                                                                                                                                                                                            )
                                                                                                                                                                                                                          : dropdownValueTwo == 'finance_or_banks_or_investments'
                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                  items: m_upper_category_for_work_finance_or_banks_or_investments.map((map) {
                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                )
                                                                                                                                                                                                                              : dropdownValueTwo == 'transport_or_logistics'
                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                      items: m_upper_category_for_work_transport_or_logistics.map((map) {
                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                  : dropdownValueTwo == 'construction_or_real_estate'
                                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                          items: m_upper_category_for_work_construction_or_real_estate.map((map) {
                                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                                            });
                                                                                                                                                                                                                                          },
                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                      : dropdownValueTwo == 'jurisprudence_and_accounting'
                                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                              items: m_upper_category_for_work_jurisprudence_and_accounting.map((map) {
                                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                                });
                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                          : dropdownValueTwo == 'safety_and_security'
                                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                  items: m_upper_category_for_work_safety_and_security.map((map) {
                                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                              : dropdownValueTwo == 'domestic_staff'
                                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                      items: m_upper_category_for_work_domestic_staff.map((map) {
                                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                  : dropdownValueTwo == 'beauty_or_fitness_or_sports'
                                                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                          items: m_upper_category_for_work_beauty_or_fitness_or_sports.map((map) {
                                                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                                                            });
                                                                                                                                                                                                                                                          },
                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                      : dropdownValueTwo == 'tourism_or_hotels_or_restaurants'
                                                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                              items: m_upper_category_for_work_tourism_or_hotels_or_restaurants.map((map) {
                                                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                                                });
                                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                          : dropdownValueTwo == 'education_or_science'
                                                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                  items: m_upper_category_for_work_education_or_science.map((map) {
                                                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                              : dropdownValueTwo == 'culture_or_art_or_entertainment'
                                                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                      items: m_upper_category_for_work_culture_or_art_or_entertainment.map((map) {
                                                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                  : dropdownValueTwo == 'medicine_or_pharmaceuticals'
                                                                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                          items: m_upper_category_for_work_medicine_or_pharmaceuticals.map((map) {
                                                                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                                                                            });
                                                                                                                                                                                                                                                                          },
                                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                                      : dropdownValueTwo == 'it_or_computers_or_communications'
                                                                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                              items: m_upper_category_for_work_it_or_computers_or_communications.map((map) {
                                                                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                                                                });
                                                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                          : dropdownValueTwo == 'marketing_and_advertising'
                                                                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                  items: m_upper_category_for_work_marketing_and_advertising.map((map) {
                                                                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                                              : dropdownValueTwo == 'manufacturing_or_energy'
                                                                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                      items: m_upper_category_for_work_manufacturing_or_energy.map((map) {
                                                                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                  : dropdownValueTwo == 'administrative_staff'
                                                                                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                          items: m_upper_category_for_work_administrative_staff.map((map) {
                                                                                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                                                                                            });
                                                                                                                                                                                                                                                                                          },
                                                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                                                      : dropdownValueTwo == 'career_start_or_students'
                                                                                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                              items: m_upper_category_for_work_career_start_or_students.map((map) {
                                                                                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                });
                                                                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                                          : dropdownValueTwo == 'working_staff'
                                                                                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                  items: m_upper_category_for_work_working_staff.map((map) {
                                                                                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                                                              : dropdownValueTwo == 'car_business'
                                                                                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                      items: m_upper_category_for_work_car_business.map((map) {
                                                                                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                                  : dropdownValueTwo == 'extraction_of_raw_materials'
                                                                                                                                                                                                                                                                                                      ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                          isExpanded: true,
                                                                                                                                                                                                                                                                                                          value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                          decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                            filled: true,
                                                                                                                                                                                                                                                                                                            fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                            errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                                                                          hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                          items: m_upper_category_for_work_extraction_of_raw_materials.map((map) {
                                                                                                                                                                                                                                                                                                            return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                              child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                              value: map['value'],
                                                                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                                                                          }).toList(),
                                                                                                                                                                                                                                                                                                          onChanged: (value) {
                                                                                                                                                                                                                                                                                                            setState(() {
                                                                                                                                                                                                                                                                                                              dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                            });
                                                                                                                                                                                                                                                                                                          },
                                                                                                                                                                                                                                                                                                        )
                                                                                                                                                                                                                                                                                                      : dropdownValueTwo == 'insurance'
                                                                                                                                                                                                                                                                                                          ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                              isExpanded: true,
                                                                                                                                                                                                                                                                                                              value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                              decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                                filled: true,
                                                                                                                                                                                                                                                                                                                fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                              items: m_upper_category_for_work_insurance.map((map) {
                                                                                                                                                                                                                                                                                                                return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                                  child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                                  value: map['value'],
                                                                                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                                                                                              }).toList(),
                                                                                                                                                                                                                                                                                                              onChanged: (value) {
                                                                                                                                                                                                                                                                                                                setState(() {
                                                                                                                                                                                                                                                                                                                  dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                                });
                                                                                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                                                          : dropdownValueTwo == 'other_areas_activity'
                                                                                                                                                                                                                                                                                                              ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                                  isExpanded: true,
                                                                                                                                                                                                                                                                                                                  value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                                  decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                                    filled: true,
                                                                                                                                                                                                                                                                                                                    fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                                  items: m_upper_category_for_work_other_areas_activity.map((map) {
                                                                                                                                                                                                                                                                                                                    return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                                      child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                                      value: map['value'],
                                                                                                                                                                                                                                                                                                                    );
                                                                                                                                                                                                                                                                                                                  }).toList(),
                                                                                                                                                                                                                                                                                                                  onChanged: (value) {
                                                                                                                                                                                                                                                                                                                    setState(() {
                                                                                                                                                                                                                                                                                                                      dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                                    });
                                                                                                                                                                                                                                                                                                                  },
                                                                                                                                                                                                                                                                                                                )
                                                                                                                                                                                                                                                                                                              : dropdownValueTwo == 'network_marketing'
                                                                                                                                                                                                                                                                                                                  ? DropdownButtonFormField(
                                                                                                                                                                                                                                                                                                                      isExpanded: true,
                                                                                                                                                                                                                                                                                                                      value: dropdownValueThree,
                                                                                                                                                                                                                                                                                                                      decoration: InputDecoration(
                                                                                                                                                                                                                                                                                                                        filled: true,
                                                                                                                                                                                                                                                                                                                        fillColor: Colors.white,
                                                                                                                                                                                                                                                                                                                        errorStyle: TextStyle(color: Colors.yellow),
                                                                                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                                                                                      hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                                                                                                                                                                                                                                                      items: m_upper_category_for_work_network_marketing.map((map) {
                                                                                                                                                                                                                                                                                                                        return DropdownMenuItem(
                                                                                                                                                                                                                                                                                                                          child: Text(AppLocalizations.of(context).translate(map['value'])),
                                                                                                                                                                                                                                                                                                                          value: map['value'],
                                                                                                                                                                                                                                                                                                                        );
                                                                                                                                                                                                                                                                                                                      }).toList(),
                                                                                                                                                                                                                                                                                                                      onChanged: (value) {
                                                                                                                                                                                                                                                                                                                        setState(() {
                                                                                                                                                                                                                                                                                                                          dropdownValueThree = value;
                                                                                                                                                                                                                                                                                                                        });
                                                                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                                                  : SizedBox()),
          dropdownValueThree != null
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
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
                    textField(cntrllrMrktRegionApp, false,
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
                          textField(cntrllrMrktAdressApp, false,
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
                      textField(cntrllrMrktEmailApp, false,
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
                  state.createMarketApplication(context,
                      m_address: _address != null
                          ? _address.addressLine
                          : cntrllrMrktAdressApp.text.trim() ?? null,
                      m_description: cntrllrDescApp.text.trim() ?? null,
                      m_email: cntrllrMrktEmailApp.text.trim() ?? null,
                      m_exchange: exchange,
                      m_heading: cntrllrHeadApp.text.trim() ?? null,
                      m_negotiated_price: agreed,
                      m_photo_1: finished_first_photo,
                      m_photo_2: finished_second_photo ?? null,
                      m_photo_3: finished_third_photo ?? null,
                      m_photo_4: finished_fourth_photo ?? null,
                      m_photo_5: finished_fifth_photo ?? null,
                      m_youtube: cntrllrYoutubeVideoApp.text.trim() ?? null,
                      m_price: cntrllrMrktPriceApp.text.trim() ?? null,
                      m_region: _address != null
                          ? null
                          : cntrllrMrktRegionApp.text.trim() ?? null,
                      m_latitude: _address != null ? dataLatitude : null,
                      m_longitude: _address != null ? dataLongitude : null,
                      m_will_give_free: for_free,
                      m_average_category: dropdownValue,
                      m_lower_category: dropdownValueTwo,
                      m_upper_category: dropdownValueThree ?? null);
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
