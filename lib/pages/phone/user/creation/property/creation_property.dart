import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreationProperty extends StatefulWidget {
  CreationProperty({Key key}) : super(key: key);

  @override
  _CreationPropertyState createState() => _CreationPropertyState();
}

class _CreationPropertyState extends State<CreationProperty> {
  List<AssetEntity> assets = [];
  String average_category,
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
  TextEditingController controllerNumberRooms;
  TextEditingController controllerPrice;
  TextEditingController controllerYearBuilt;
  TextEditingController controllerTotalArea;
  TextEditingController controllerFloorStart;
  TextEditingController controllerFloorEnd;
  TextEditingController controllerLivingSpace;
  TextEditingController controllerCeilingHeight;
  TextEditingController controllerCrossing;
  TextEditingController controllerKitchenSquare;
  TextEditingController controllerHouseNumber;
  TextEditingController controllerCountryCity;
  TextEditingController controllerStreetMicrodistrict;
  File image;
  Future<File> imageFile;
  bool error_average_category = false,
      error_lower_category = false,
      errorControllerNumberRooms = false,
      errorControllerPrice = false,
      errorControllerYearBuilt = false,
      errorControllerTotalArea = false,
      errorControllerCeilingHeight = false,
      errorControllerCrossing = false,
      errorControllerHouseNumber = false,
      errorControllerStreetMicrodistrict = false,
      errorControllerCountryCity = false,
      error_building_type = false,
      isPledge = false,
      uploaded = false,
      selectedImage = false,
      waiting = false,
      isInDorm = false,
      hidePhone = false;

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

  @override
  void initState() {
    controllerCeilingHeight = TextEditingController();
    controllerCountryCity = TextEditingController();
    controllerCrossing = TextEditingController();
    controllerFloorEnd = TextEditingController();
    controllerFloorStart = TextEditingController();
    controllerHouseNumber = TextEditingController();
    controllerKitchenSquare = TextEditingController();
    controllerLivingSpace = TextEditingController();
    controllerNumberRooms = TextEditingController();
    controllerPrice = TextEditingController();
    controllerStreetMicrodistrict = TextEditingController();
    controllerTotalArea = TextEditingController();
    controllerYearBuilt = TextEditingController();
    _fetchAssets();
    super.initState();
  }

  @override
  void dispose() {
    controllerCeilingHeight?.dispose();
    controllerCountryCity?.dispose();
    controllerCrossing?.dispose();
    controllerFloorEnd?.dispose();
    controllerFloorStart?.dispose();
    controllerHouseNumber?.dispose();
    controllerKitchenSquare?.dispose();
    controllerLivingSpace?.dispose();
    controllerNumberRooms?.dispose();
    controllerPrice?.dispose();
    controllerStreetMicrodistrict?.dispose();
    controllerTotalArea?.dispose();
    controllerYearBuilt?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Row(
              children: [
                uploaded
                    ? Container(
                        width: 25,
                        height: 25,
                        margin: EdgeInsets.only(left: 15),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('h_m_property'),
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                AppLocalizations.of(context).translate('h_m_good_application'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
            lower_category == 'apartment' && average_category == 'sell'
                ? limit()
                : lower_category == 'house' && average_category == 'sell'
                ? limit()
                : lower_category == 'room' && average_category == 'sell'
                ? limit()
                : lower_category == 'dacha' && average_category == 'sell'
                ? limit(isDacha: true)
                : lower_category == 'commercial_real_estate' &&
                    average_category == 'sell'
                ? limit()
                : lower_category == 'other_real_estate' &&
                    average_category == 'sell'
                ? limit()
                : lower_category == 'apartment' && average_category == 'to_rent'
                ? rent()
                : lower_category == 'house' && average_category == 'to_rent'
                ? rent()
                : lower_category == 'room' && average_category == 'to_rent'
                ? rent()
                : lower_category == 'dacha' && average_category == 'to_rent'
                ? rent()
                : lower_category == 'commercial_real_estate' &&
                    average_category == 'to_rent'
                ? rent()
                : lower_category == 'other_real_estate' &&
                    average_category == 'to_rent'
                ? rent()
                : SizedBox(),
          ],
        ),
      )),
    );
  }

  Widget limit({bool isDacha = false, bool isOtherRealEstate = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                !isDacha
                    ? Flexible(
                        flex: 4,
                        child: textFieldtwo(
                          controllerNumberRooms,
                          errorControllerNumberRooms,
                          AppLocalizations.of(context)
                              .translate('h_m_number_room'),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 3,
                  child: textFieldtwo(
                    controllerPrice,
                    errorControllerPrice,
                    AppLocalizations.of(context)
                        .translate('h_m_price_in_tenge'),
                  ),
                ),
              ],
            ),
          ),
          !isDacha
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('h_m_pledge'),
                        style: TextStyle(fontSize: 17),
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
                )
              : SizedBox(),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)
                    .translate('h_m_type_building')),
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
                      child: Text(
                          AppLocalizations.of(context).translate(map['value'])),
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
          !isDacha
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: textFieldtwo(
                    controllerYearBuilt,
                    errorControllerYearBuilt,
                    AppLocalizations.of(context).translate('h_m_year_built'),
                  ),
                )
              : SizedBox(),
          !isDacha
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(AppLocalizations.of(context)
                            .translate('h_m_floor')),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              controllerFloorStart,
                              false,
                              '',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(AppLocalizations.of(context)
                                .translate('h_m_of')),
                          ),
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              controllerFloorEnd,
                              false,
                              '',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child:
                      Text(AppLocalizations.of(context).translate('h_m_area')),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: textFieldtwo(
                        controllerTotalArea,
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
                        controllerLivingSpace,
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
                        controllerKitchenSquare,
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
                  style: TextStyle(fontSize: 17),
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
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              AppLocalizations.of(context).translate('h_m_location'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: textFieldtwo(
              controllerCountryCity,
              errorControllerCountryCity,
              AppLocalizations.of(context).translate('h_m_country_and_city'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: textFieldtwo(
              controllerStreetMicrodistrict,
              errorControllerStreetMicrodistrict,
              AppLocalizations.of(context)
                  .translate('h_m_street_or_microdistrict'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: textFieldtwo(
              controllerHouseNumber,
              errorControllerHouseNumber,
              AppLocalizations.of(context).translate('h_m_house_number'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: textFieldtwo(
              controllerCrossing,
              errorControllerCrossing,
              AppLocalizations.of(context).translate('h_m_intersect_with'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('h_m_hide_house_number'),
                  style: TextStyle(fontSize: 17),
                ),
                Row(
                  children: [
                    AppCheckbox(
                      value: hidePhone,
                      onChanged: (val) {
                        setState(() {
                          hidePhone = val;
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
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text(
              AppLocalizations.of(context).translate('h_m_photos'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                    onTap: () => getPhotoModalBottomSheet(context, true, true),
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
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text(
              AppLocalizations.of(context).translate('h_m_characteristics'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Column(
              children: [
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
                      Text(AppLocalizations.of(context)
                          .translate('h_m_internet')),
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
                      Text(AppLocalizations.of(context)
                          .translate('h_m_bathroom')),
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
                      Text(AppLocalizations.of(context)
                          .translate('h_m_balcony')),
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
                      Text(AppLocalizations.of(context)
                          .translate('h_m_parking')),
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
                      Text(
                          AppLocalizations.of(context).translate('h_m_gender')),
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
                textFieldtwo(
                  controllerCeilingHeight,
                  errorControllerCeilingHeight,
                  AppLocalizations.of(context).translate('h_m_ceiling_height'),
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      if (average_category != '' && average_category != null) {
                        if (lower_category != '' && lower_category != null) {
                          if (controllerNumberRooms.text.length >= 1) {
                            if (controllerYearBuilt.text.length >= 1) {
                              if (controllerTotalArea.text.length >= 1) {
                                if (controllerCeilingHeight.text.length >= 1) {
                                  if (controllerCrossing.text.length >= 1) {
                                    if (controllerHouseNumber.text.length >=
                                        1) {
                                      if (controllerStreetMicrodistrict
                                              .text.length >=
                                          1) {
                                        if (controllerCountryCity.text.length >=
                                            1) {
                                          if (building_type != null &&
                                              building_type != '') {
                                            uploadedImage();
                                          } else {
                                            setState(() {
                                              error_building_type = true;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            errorControllerCountryCity = true;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          errorControllerStreetMicrodistrict =
                                              true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        errorControllerHouseNumber = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      errorControllerCrossing = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errorControllerCeilingHeight = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  errorControllerYearBuilt = true;
                                });
                              }
                            } else {
                              setState(() {
                                errorControllerYearBuilt = true;
                              });
                            }
                          } else {
                            setState(() {
                              errorControllerNumberRooms = true;
                            });
                          }
                        } else {
                          setState(() {
                            error_lower_category = true;
                          });
                        }
                      } else {
                        setState(() {
                          error_average_category = true;
                        });
                      }
                    } else {
                      setState(() {
                        errorControllerPrice = true;
                      });
                    }
                  })),
        ],
      ),
    );
  }

  Widget rent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: textFieldtwo(
                    controllerNumberRooms,
                    errorControllerNumberRooms,
                    AppLocalizations.of(context).translate('h_m_number_room'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 3,
                  child: textFieldtwo(
                    controllerPrice,
                    errorControllerPrice,
                    AppLocalizations.of(context)
                        .translate('h_m_price_in_tenge'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate('rental_period')),
                DropdownButtonFormField(
                  isExpanded: true,
                  value: rentalPeriod,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.yellow),
                  ),
                  hint: Text(AppLocalizations.of(context)
                      .translate('h_m_selected_category')),
                  items: rental_period.map((map) {
                    return DropdownMenuItem(
                      child: Text(
                          AppLocalizations.of(context).translate(map['value'])),
                      value: map['value'],
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      rentalPeriod = value;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(AppLocalizations.of(context)
                    .translate('h_m_type_building')),
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
                      child: Text(
                          AppLocalizations.of(context).translate(map['value'])),
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: textFieldtwo(
                    controllerYearBuilt,
                    errorControllerYearBuilt,
                    AppLocalizations.of(context).translate('h_m_year_built'),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(AppLocalizations.of(context)
                            .translate('h_m_floor')),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              controllerFloorStart,
                              false,
                              '',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(AppLocalizations.of(context)
                                .translate('h_m_of')),
                          ),
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              controllerFloorEnd,
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
                            AppLocalizations.of(context).translate('h_m_area')),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: textFieldtwo(
                              controllerTotalArea,
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
                              controllerLivingSpace,
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
                              controllerKitchenSquare,
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
                        AppLocalizations.of(context)
                            .translate('h_m_privat_hostel'),
                        style: TextStyle(fontSize: 17),
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
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_location'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    controllerCountryCity,
                    errorControllerCountryCity,
                    AppLocalizations.of(context)
                        .translate('h_m_country_and_city'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    controllerStreetMicrodistrict,
                    errorControllerStreetMicrodistrict,
                    AppLocalizations.of(context)
                        .translate('h_m_street_or_microdistrict'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    controllerHouseNumber,
                    errorControllerHouseNumber,
                    AppLocalizations.of(context).translate('h_m_house_number'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: textFieldtwo(
                    controllerCrossing,
                    errorControllerCrossing,
                    AppLocalizations.of(context)
                        .translate('h_m_intersect_with'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('h_m_hide_house_number'),
                        style: TextStyle(fontSize: 17),
                      ),
                      Row(
                        children: [
                          AppCheckbox(
                            value: hidePhone,
                            onChanged: (val) {
                              setState(() {
                                hidePhone = val;
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
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_photos'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                          onTap: () =>
                              getPhotoModalBottomSheet(context, true, true),
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
              ],
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      if (average_category != '' && average_category != null) {
                        if (lower_category != '' && lower_category != null) {
                          uploadedImage();
                        } else {
                          setState(() {
                            error_lower_category = true;
                          });
                        }
                      } else {
                        setState(() {
                          error_average_category = true;
                        });
                      }
                    } else {
                      setState(() {
                        errorControllerPrice = true;
                      });
                    }
                  })),
        ],
      ),
    );
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
        .child('property/${randomName}.png');
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
          state.createProperty(
            context,
            p_average_category: average_category ?? null,
            p_balcony: balcony ?? null,
            p_bathroom: bathroom ?? null,
            p_building_type: building_type ?? null,
            p_ceiling_height: controllerCeilingHeight.text.trim() ?? null,
            p_condition: condition ?? null,
            p_country_city: controllerCountryCity.text.trim() ?? null,
            p_crossing: controllerCrossing.text.trim() ?? null,
            p_door: door ?? null,
            p_floor: floor ?? null,
            p_floor_end: controllerFloorEnd.text.trim() ?? null,
            p_floor_start: controllerFloorStart.text.trim() ?? null,
            p_furniture: furniture ?? null,
            p_glazed_balcony: glazedBalcony ?? null,
            p_house_number: controllerHouseNumber.text.trim() ?? null,
            p_internet: internet ?? null,
            p_kitchen_square: controllerKitchenSquare.text.trim() ?? null,
            p_living_space: controllerLivingSpace.text.trim() ?? null,
            p_lower_category: lower_category ?? null,
            p_numbers_room: controllerNumberRooms.text.trim() ?? null,
            p_parking: parking ?? null,
            p_price: controllerPrice.text.trim() ?? null,
            p_street_microdistrict:
                controllerStreetMicrodistrict.text.trim() ?? null,
            p_telephone: telephone ?? null,
            p_total_area: controllerTotalArea.text.trim() ?? null,
            p_year_built: controllerYearBuilt.text.trim() ?? null,
            is_pledge: isPledge ?? false,
            is_hide_phone: hidePhone ?? false,
            is_in_dorm: isInDorm ?? false,
          );
        });
      }
    });
  }
}
