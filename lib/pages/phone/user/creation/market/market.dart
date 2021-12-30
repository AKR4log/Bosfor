// ignore_for_file: non_constant_identifier_names, unused_element, missing_return

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/functions/uploadedPhotoApp.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:http/http.dart' as http;
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class MarketMaster extends StatefulWidget {
  MarketMaster({Key key}) : super(key: key);

  @override
  _MarketMasterState createState() => _MarketMasterState();
}

class _MarketMasterState extends State<MarketMaster> {
  TextEditingController controllerYoutube = TextEditingController();
  TextEditingController controllerHead = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  Future<Map> getData() async {
    http.Response response = await http.get(
        Uri.parse("https://api.hgbrasil.com/finance?format=json&key=80f27c39"));
    return json.decode(response.body);
  }

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
      exchange = false,
      for_free = false,
      agreed = false,
      errorPrice = false,
      wait_first_photo = false,
      wait_second_photo = false,
      wait_third_photo = false,
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
      dropdownValue,
      dropdownValueLocates,
      dropdownValueTwo,
      dropdownValueThree,
      finished_fourth_photo,
      finished_fifth_photo;
  double dollar_buy;
  double euro_buy;
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  void _clearAll() {
    controllerPrice.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    controllerPrice.text = (dolar * this.dollar_buy).toStringAsFixed(2);
    euroController.text =
        (dolar * this.dollar_buy / euro_buy).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    controllerPrice.text = (euro * this.euro_buy).toStringAsFixed(2);
    dolarController.text =
        (euro * this.euro_buy / dollar_buy).toStringAsFixed(2);
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dollar_buy).toStringAsFixed(2);
    euroController.text = (real / euro_buy).toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _fetchAssets();
    controllerYoutube = TextEditingController();
    controllerHead = TextEditingController();
    controllerDesc = TextEditingController();
    controllerPrice = TextEditingController();
  }

  Widget buildTextField(
      String label, String prefix, TextEditingController c, Function f) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          // border: ,
          prefixText: prefix),
      style: TextStyle(color: Colors.grey[400], fontSize: 14.0),
      onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  void dispose() {
    controllerYoutube?.dispose();
    controllerHead?.dispose();
    controllerDesc?.dispose();
    controllerPrice?.dispose();
    super.dispose();
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
                                        context, 'domain', image_first_photo,
                                        () {
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
                                        onPressed: () => uploadPhoto(context,
                                            'domain', image_second_photo, () {
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
                                        onPressed: () => uploadPhoto(context,
                                            'domain', image_third_photo, () {
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
                                        onPressed: () => uploadPhoto(context,
                                            'domain', image_fourth_photo, () {
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
                                        onPressed: () => uploadPhoto(context,
                                            'domain', image_fifth_photo, () {
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
          'Маркет',
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
                          // GestureDetector(
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(15),
                          //     child: Container(
                          //       color: Colors.grey[300].withOpacity(0.3),
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Icon(Icons.panorama_horizontal_rounded),
                          //           Text('360'),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
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
                    child: Column(
                      children: [
                        agreed || for_free
                            ? SizedBox()
                            : textFieldtwo(
                                controllerPrice,
                                errorPrice,
                                AppLocalizations.of(context)
                                    .translate('h_m_price_in_tenge'),
                                onChanged: () {
                                _realChanged(controllerPrice.text.trim());
                                setState(() {
                                  agreed = false;
                                  for_free = false;
                                  errorPrice = false;
                                });
                              }),
                        agreed || for_free
                            ? SizedBox()
                            : FutureBuilder(
                                future: getData(),
                                //snapshot of the context/getData
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: Text(
                                        "Loading...",
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 25.0),
                                        textAlign: TextAlign.center,
                                      ));
                                    default:
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                          "Error :(",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 25.0),
                                          textAlign: TextAlign.center,
                                        ));
                                      } else {
                                        dollar_buy =
                                            //here we pull the us and eu rate
                                            snapshot.data["results"]
                                                ["currencies"]["USD"]["buy"];
                                        euro_buy = snapshot.data["results"]
                                            ["currencies"]["EUR"]["buy"];
                                        return SingleChildScrollView(
                                            child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: buildTextField(
                                                  "Dollars",
                                                  "US\$",
                                                  dolarController,
                                                  _dolarChanged),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: buildTextField(
                                                  "Euros",
                                                  "€",
                                                  euroController,
                                                  _euroChanged),
                                            ),
                                          ],
                                        ));
                                      }
                                  }
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
                                    controllerPrice.clear();
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_m_negotiated_price'),
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
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
                                    controllerPrice.clear();
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('h_m_will_give_free'),
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
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
                            color: Colors.black,
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
                                  color: Colors.black,
                                ),
                              ),
                            )),
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
                          child: Text(AppLocalizations.of(context)
                              .translate(map['value'])),
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
                                enabled:
                                    dropdownValueThree != null ? false : true,
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
                                    enabled: dropdownValueThree != null
                                        ? false
                                        : true,
                                    errorStyle: TextStyle(color: Colors.yellow),
                                  ),
                                  hint: Text(AppLocalizations.of(context)
                                      .translate('h_m_selected_category')),
                                  items: m_lower_category_for_electronics
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
                              : dropdownValue == 'home_and_garden'
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
                                      items:
                                          m_lower_category_for_home_and_garden
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
                                            errorStyle:
                                                TextStyle(color: Colors.yellow),
                                          ),
                                          hint: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      'h_m_selected_category')),
                                          items:
                                              m_lower_category_for_personal_belongings
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
                                      : dropdownValue == 'for_business'
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
                                                  m_lower_category_for_business
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
                                          : dropdownValue == 'animals'
                                              ? DropdownButtonFormField(
                                                  isExpanded: true,
                                                  value: dropdownValueTwo,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    enabled:
                                                        dropdownValueThree !=
                                                                null
                                                            ? false
                                                            : true,
                                                    fillColor: Colors.white,
                                                    errorStyle: TextStyle(
                                                        color: Colors.yellow),
                                                  ),
                                                  hint: Text(AppLocalizations
                                                          .of(context)
                                                      .translate(
                                                          'h_m_selected_category')),
                                                  items:
                                                      m_lower_category_for_animals
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
                                              : dropdownValue == 'for_children'
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
                                                          m_lower_category_for_children
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
                                                  : dropdownValue ==
                                                          'hobbies_and_sports'
                                                      ? DropdownButtonFormField(
                                                          isExpanded: true,
                                                          value:
                                                              dropdownValueTwo,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            enabled:
                                                                dropdownValueThree !=
                                                                        null
                                                                    ? false
                                                                    : true,
                                                            errorStyle: TextStyle(
                                                                color: Colors
                                                                    .yellow),
                                                          ),
                                                          hint: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate(
                                                                  'h_m_selected_category')),
                                                          items:
                                                              m_lower_category_for_hobbies_and_sports
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
                                                              dropdownValueTwo =
                                                                  value;
                                                            });
                                                          },
                                                        )
                                                      : dropdownValue == 'work'
                                                          ? DropdownButtonFormField(
                                                              isExpanded: true,
                                                              value:
                                                                  dropdownValueTwo,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                enabled:
                                                                    dropdownValueThree !=
                                                                            null
                                                                        ? false
                                                                        : true,
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
                              : dropdownValueTwo ==
                                      'kepair_and_maintenance_equipment'
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
                                          m_upper_category_for_services_kepair_and_maintenance_equipment
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
                                  : dropdownValueTwo == 'rental_goods'
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
                                              m_upper_category_for_services_rental_goods
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
                                      : dropdownValueTwo == 'beauty_and_health'
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
                                                  m_upper_category_for_services_beauty_and_health
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
                                                  'internet_and_computers'
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
                                                      m_upper_category_for_services_internet_and_computers
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
                                                      'transportation_or_car_service'
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
                                                          m_upper_category_for_services_transportation_or_car_service
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
                                                          'business_services'
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
                                                              m_upper_category_for_services_business_services
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
                                                              'cleaning'
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
                                                                  m_upper_category_for_services_cleaning
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
                                                                  'computers'
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
                                                                  items: m_upper_category_for_electronics_computers
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
                                                                      'photo_and_video_cameras'
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
                                                                      items: m_lower_category_for_work
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
                                                                                Colors.white,
                                                                            errorStyle:
                                                                                TextStyle(color: Colors.yellow),
                                                                          ),
                                                                          hint:
                                                                              Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                          items:
                                                                              m_upper_category_for_electronics_phones_or_gadgets.map((map) {
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
                                                                              'tv_and_video'
                                                                          ? DropdownButtonFormField(
                                                                              isExpanded: true,
                                                                              value: dropdownValueThree,
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                errorStyle: TextStyle(color: Colors.yellow),
                                                                              ),
                                                                              hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                              items: m_upper_category_for_electronics_tv_and_video.map((map) {
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
                                                                          : dropdownValueTwo == 'audio_engineering'
                                                                              ? DropdownButtonFormField(
                                                                                  isExpanded: true,
                                                                                  value: dropdownValueThree,
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: Colors.white,
                                                                                    errorStyle: TextStyle(color: Colors.yellow),
                                                                                  ),
                                                                                  hint: Text(AppLocalizations.of(context).translate('h_m_selected_category')),
                                                                                  items: m_upper_category_for_electronics_audio_engineering.map((map) {
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
                                                                              : dropdownValueTwo == 'gaming_consoles'
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
                  finished_first_photo != null &&
                          dropdownValue != null &&
                          dropdownValueTwo != null &&
                          dropdownValueLocates != null
                      ? Container(
                          margin: EdgeInsets.only(top: 25),
                          height: 55,
                          child: TextButton(
                              onPressed: () {
                                var state = Provider.of<CloudFirestore>(context,
                                    listen: false);
                                state.createMarketApplication(context,
                                    m_address: dropdownValueLocates ?? null,
                                    m_description:
                                        controllerDesc.text.trim() ?? null,
                                    m_email: null,
                                    m_exchange: exchange,
                                    m_heading:
                                        controllerHead.text.trim() ?? null,
                                    m_negotiated_price: agreed,
                                    m_photo_1: finished_first_photo,
                                    m_photo_2: finished_second_photo ?? null,
                                    m_photo_3: finished_third_photo ?? null,
                                    m_photo_4: finished_fourth_photo ?? null,
                                    m_photo_5: finished_fifth_photo ?? null,
                                    m_youtube:
                                        controllerYoutube.text.trim() ?? null,
                                    m_price:
                                        controllerPrice.text.trim() ?? null,
                                    m_region: null,
                                    m_latitude: null,
                                    m_longitude: null,
                                    m_will_give_free: for_free,
                                    m_average_category: dropdownValue,
                                    m_lower_category: dropdownValueTwo,
                                    m_upper_category:
                                        dropdownValueThree ?? null);
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
