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

class CRTProperty extends StatefulWidget {
  CRTProperty({Key key}) : super(key: key);

  @override
  _CRTPropertyState createState() => _CRTPropertyState();
}

class _CRTPropertyState extends State<CRTProperty> {
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
      average_category,
      lower_category,
      building_type,
      bathroom,
      internet,
      condition,
      telephone,
      balcony,
      glazedBalcony,
      door,
      parking,
      furniture,
      floor,
      rentalPeriod;
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
      errorPrice = false,
      errorMarketDropdown = false,
      getAddress = false,
      error_average_category = false,
      error_lower_category = false,
      error_cntrllrCrossing = false,
      error_cntrllrHouseNumber = false,
      error_cntrllrStreetMicrodistrict = false,
      error_cntrllrCountryCity = false,
      error_building_type = false,
      errorControllerNumberRooms = false,
      errorControllerYearBuilt = false,
      errorControllerTotalArea = false,
      errorControllerCeilingHeight = false,
      isPledge = false,
      uploaded = false,
      selectedImage = false,
      waiting = false,
      isInDorm = false,
      hidePhone = false;
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
  TextEditingController cntrllrCrossing;
  TextEditingController cntrllrHouseNumber;
  TextEditingController cntrllrStreetMicrodistrict;
  TextEditingController cntrllrCountryCity;
  TextEditingController cntrllrNumberRooms;
  TextEditingController cntrllrYearBuilt;
  TextEditingController cntrllrTotalArea;
  TextEditingController cntrllrFloorStart;
  TextEditingController cntrllrFloorEnd;
  TextEditingController cntrllrLivingSpace;
  TextEditingController cntrllrCeilingHeight;
  TextEditingController cntrllrKitchenSquare;

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
    cntrllrCrossing = TextEditingController();
    cntrllrHouseNumber = TextEditingController();
    cntrllrStreetMicrodistrict = TextEditingController();
    cntrllrCountryCity = TextEditingController();
    cntrllrNumberRooms = TextEditingController();
    cntrllrYearBuilt = TextEditingController();
    cntrllrTotalArea = TextEditingController();
    cntrllrFloorStart = TextEditingController();
    cntrllrFloorEnd = TextEditingController();
    cntrllrLivingSpace = TextEditingController();
    cntrllrCeilingHeight = TextEditingController();
    cntrllrKitchenSquare = TextEditingController();
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
    cntrllrCrossing?.dispose();
    cntrllrHouseNumber?.dispose();
    cntrllrStreetMicrodistrict?.dispose();
    cntrllrCountryCity?.dispose();
    cntrllrNumberRooms?.dispose();
    cntrllrYearBuilt?.dispose();
    cntrllrTotalArea?.dispose();
    cntrllrFloorStart?.dispose();
    cntrllrFloorEnd?.dispose();
    cntrllrLivingSpace?.dispose();
    cntrllrCeilingHeight?.dispose();
    cntrllrKitchenSquare?.dispose();
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
                  textFieldtwo(
                      cntrllrMrktPriceApp,
                      errorPrice,
                      AppLocalizations.of(context)
                          .translate('h_m_price_in_tenge'), onChanged: () {
                    setState(() {
                      errorPrice = false;
                    });
                  }),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Text(
                AppLocalizations.of(context).translate('h_m_characteristics'),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                child: Column(children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_state')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: condition,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: condition != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_condition.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          condition = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_phone')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: telephone,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: telephone != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_phone.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          telephone = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        AppLocalizations.of(context).translate('h_m_internet')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: internet,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: internet != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_internet.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          internet = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        AppLocalizations.of(context).translate('h_m_bathroom')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: bathroom,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: bathroom != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_bathroom.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          bathroom = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_balcony')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: balcony,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: balcony != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_balcony.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          balcony = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)
                        .translate('h_m_glazed_balcony')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: glazedBalcony,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: glazedBalcony != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_glazed_balcony.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          glazedBalcony = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_door')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: door,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: door != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_door.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          door = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_parking')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: parking,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: parking != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_parking.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          parking = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)
                        .translate('h_m_furniture')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: furniture,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: furniture != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_furniture.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          furniture = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('h_m_gender')),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: floor,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: floor != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: sell_floor.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          floor = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: textFieldtwo(
                  cntrllrCeilingHeight,
                  errorControllerCeilingHeight,
                  AppLocalizations.of(context).translate('h_m_ceiling_height'),
                ),
              ),
              cntrllrHeadApp.text.length >= 1 &&
                      cntrllrMrktPriceApp.text.length >= 1
                  ? Container(
                      margin: EdgeInsets.only(top: 5, bottom: 20),
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
                  : SizedBox(),
            ]))
          ],
        ),
      ),
    );
  }

  Widget widgetCategory() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          children: [
            textFieldtwo(
              cntrllrNumberRooms,
              errorControllerNumberRooms,
              AppLocalizations.of(context).translate('h_m_number_room'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('h_m_pledge'),
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  Row(
                    children: [
                      AppCheckbox(
                        value: isPledge,
                        onChanged: (val) {
                          setState(() {
                            isPledge = val;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: average_category,
                decoration: InputDecoration(
                  filled: true,
                  enabled: average_category != null ? false : true,
                  fillColor: Colors.white,
                  errorStyle: TextStyle(color: Colors.yellow),
                ),
                hint: Text(AppLocalizations.of(context)
                    .translate('h_m_selected_category')),
                items: p_average_category.map((map) {
                  return DropdownMenuItem(
                    child: Text(
                        AppLocalizations.of(context).translate(map['value'])),
                    value: map['value'],
                  );
                }).toList(),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    error_average_category = false;
                    average_category = value;
                  });
                },
              ),
            ),
            average_category == 'sell'
                ? Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: lower_category,
                      decoration: InputDecoration(
                        filled: true,
                        enabled: lower_category != null ? false : true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      hint: Text(AppLocalizations.of(context)
                          .translate('h_m_selected_category')),
                      items: p_lower_category_sell.map((map) {
                        return DropdownMenuItem(
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          error_lower_category = false;
                          lower_category = value;
                        });
                      },
                    ),
                  )
                : average_category == 'to_rent'
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: lower_category,
                          decoration: InputDecoration(
                            filled: true,
                            enabled: lower_category != null ? false : true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.yellow),
                          ),
                          hint: Text(AppLocalizations.of(context)
                              .translate('h_m_selected_category')),
                          items: p_lower_category_sell.map((map) {
                            return DropdownMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate(map['value'])),
                              value: map['value'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              error_lower_category = false;
                              lower_category = value;
                            });
                          },
                        ),
                      )
                    : SizedBox(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('h_m_type_building'),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  DropdownButtonFormField(
                    isExpanded: true,
                    value: building_type,
                    decoration: InputDecoration(
                      filled: true,
                      enabled: building_type != null ? false : true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.yellow),
                    ),
                    hint: Text(AppLocalizations.of(context)
                        .translate('h_m_type_building')),
                    items: building_type_name.map((map) {
                      return DropdownMenuItem(
                        child: Text(AppLocalizations.of(context)
                            .translate(map['value'])),
                        value: map['value'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        error_building_type = false;
                        building_type = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: textFieldtwo(
                cntrllrYearBuilt,
                errorControllerYearBuilt,
                AppLocalizations.of(context).translate('h_m_year_built'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      AppLocalizations.of(context).translate('h_m_floor'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          cntrllrFloorStart,
                          false,
                          '',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          AppLocalizations.of(context).translate('h_m_of'),
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          cntrllrFloorEnd,
                          false,
                          '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      AppLocalizations.of(context).translate('h_m_area'),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          cntrllrTotalArea,
                          errorControllerTotalArea,
                          AppLocalizations.of(context)
                              .translate('h_m_area_general'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          cntrllrLivingSpace,
                          false,
                          AppLocalizations.of(context)
                              .translate('h_m_area_residential'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          cntrllrKitchenSquare,
                          false,
                          AppLocalizations.of(context)
                              .translate('h_m_area_kitchen'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('h_m_privat_hostel'),
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  Row(
                    children: [
                      AppCheckbox(
                        value: isInDorm,
                        onChanged: (val) {
                          setState(() {
                            isInDorm = val;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            lower_category != null
                ? Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
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
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_location'),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    cntrllrCountryCity,
                    error_cntrllrCountryCity,
                    AppLocalizations.of(context)
                        .translate('h_m_country_and_city'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    cntrllrStreetMicrodistrict,
                    error_cntrllrStreetMicrodistrict,
                    AppLocalizations.of(context)
                        .translate('h_m_street_or_microdistrict'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    cntrllrHouseNumber,
                    error_cntrllrHouseNumber,
                    AppLocalizations.of(context).translate('h_m_house_number'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    cntrllrCrossing,
                    error_cntrllrCrossing,
                    AppLocalizations.of(context)
                        .translate('h_m_intersect_with'),
                  ),
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
                  state.createProperty(
                    context,
                    p_average_category: average_category ?? null,
                    p_balcony: balcony ?? null,
                    p_bathroom: bathroom ?? null,
                    p_building_type: building_type ?? null,
                    p_ceiling_height: cntrllrCeilingHeight.text.trim() ?? null,
                    p_condition: condition ?? null,
                    p_country_city: cntrllrCountryCity.text.trim() ?? null,
                    p_crossing: cntrllrCrossing.text.trim() ?? null,
                    p_door: door ?? null,
                    p_desc: cntrllrDescApp.text.trim()??null,
                    p_head: cntrllrHeadApp.text.trim()??null,
                    p_floor: floor ?? null,
                    p_floor_end: cntrllrFloorEnd.text.trim() ?? null,
                    p_floor_start: cntrllrFloorStart.text.trim() ?? null,
                    p_furniture: furniture ?? null,
                    p_photo_1: finished_first_photo,
                    p_photo_2: finished_second_photo ?? null,
                    p_photo_3: finished_third_photo ?? null,
                    p_photo_4: finished_fourth_photo ?? null,
                    p_photo_5: finished_fifth_photo ?? null,
                    p_youtube: cntrllrYoutubeVideoApp.text.trim() ?? null,
                    p_glazed_balcony: glazedBalcony ?? null,
                    p_house_number: cntrllrHouseNumber.text.trim() ?? null,
                    p_internet: internet ?? null,
                    p_kitchen_square: cntrllrKitchenSquare.text.trim() ?? null,
                    p_living_space: cntrllrLivingSpace.text.trim() ?? null,
                    p_lower_category: lower_category ?? null,
                    p_numbers_room: cntrllrNumberRooms.text.trim() ?? null,
                    p_parking: parking ?? null,
                    p_price: cntrllrMrktPriceApp.text.trim() ?? null,
                    p_street_microdistrict:
                        cntrllrStreetMicrodistrict.text.trim() ?? null,
                    p_telephone: telephone ?? null,
                    p_total_area: cntrllrTotalArea.text.trim() ?? null,
                    p_year_built: cntrllrYearBuilt.text.trim() ?? null,
                    is_pledge: isPledge ?? false,
                    is_hide_phone: hidePhone ?? false,
                    is_in_dorm: isInDorm ?? false,
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
