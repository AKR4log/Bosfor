import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreationMarket extends StatefulWidget {
  CreationMarket({Key key}) : super(key: key);

  @override
  _CreationMarketState createState() => _CreationMarketState();
}

class _CreationMarketState extends State<CreationMarket> {
  List<AssetEntity> assets = [];
  String downloadURI, dropdownValue, dropdownValueTwo, dropdownValueThree;
  double _progress, dataLongitude, dataLatitude;
  Address _address;
  File image;
  Future<File> imageFile;
  TextEditingController controllerMarketPriceApplication =
      TextEditingController();
  TextEditingController controllerMarketNameApplication =
      TextEditingController();
  TextEditingController controllerMarketDescriptionApplication =
      TextEditingController();
  TextEditingController controllerMarketRegionApplication =
      TextEditingController();
  TextEditingController controllerMarketAdressApplication =
      TextEditingController();
  TextEditingController controllerMarketEmailApplication =
      TextEditingController();
  LocationPermission permission;
  StreamSubscription<Position> _positionStream;
  bool serviceEnabled,
      getAddress = false,
      errorMarketName = false,
      errorMarketDescription = false,
      errorMarketPrice = false,
      valCheckBoxNegotiatedPrice = false,
      valCheckBoxWillGiveFree = false,
      valCheckBoxExchange = false,
      valCheckBoxAuthUserPhone = false,
      uploaded = false,
      selectedImage = false,
      waiting = false,
      error = false,
      errorMarketDropdown = false;

  @override
  void initState() {
    _fetchAssets();
    controllerMarketPriceApplication = TextEditingController();
    controllerMarketNameApplication = TextEditingController();
    controllerMarketDescriptionApplication = TextEditingController();
    controllerMarketRegionApplication = TextEditingController();
    controllerMarketAdressApplication = TextEditingController();
    controllerMarketEmailApplication = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerMarketPriceApplication?.dispose();
    controllerMarketNameApplication?.dispose();
    controllerMarketDescriptionApplication?.dispose();
    controllerMarketAdressApplication?.dispose();
    controllerMarketRegionApplication?.dispose();
    controllerMarketEmailApplication?.dispose();
    _positionStream?.cancel();
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
            AppLocalizations.of(context).translate('h_market'),
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25, top: 10),
                  width: double.infinity,
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_header'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: textField(
                        controllerMarketNameApplication, errorMarketName,
                        hint: AppLocalizations.of(context)
                            .translate('h_m_hint_header'), onChanged: () {
                      setState(() {
                        errorMarketName = false;
                      });
                    }),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('h_m_category'),
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
                              child: Text(AppLocalizations.of(context)
                                  .translate('cancel')),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                              enabled:
                                  dropdownValueThree != null ? false : true,
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
                            items:
                                m_lower_category_for_home_and_garden.map((map) {
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
                              enabled:
                                  dropdownValueThree != null ? false : true,
                              errorStyle: TextStyle(color: Colors.yellow),
                            ),
                            hint: Text(AppLocalizations.of(context)
                                .translate('h_m_selected_category')),
                            items: m_lower_category_for_personal_belongings
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
                              enabled:
                                  dropdownValueThree != null ? false : true,
                              errorStyle: TextStyle(color: Colors.yellow),
                            ),
                            hint: Text(AppLocalizations.of(context)
                                .translate('h_m_selected_category')),
                            items: m_lower_category_for_business.map((map) {
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
                        : dropdownValue == 'animals'
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
                            items: m_lower_category_for_animals.map((map) {
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
                        : dropdownValue == 'for_children'
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
                            items: m_lower_category_for_children.map((map) {
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
                        : dropdownValue == 'hobbies_and_sports'
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
                            items: m_lower_category_for_hobbies_and_sports
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
                        : dropdownValue == 'work'
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
                            items: m_lower_category_for_work.map((map) {
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
                        : SizedBox()),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                            items: m_upper_category_for_services_rental_goods
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
                              errorStyle: TextStyle(color: Colors.yellow),
                            ),
                            hint: Text(AppLocalizations.of(context)
                                .translate('h_m_selected_category')),
                            items:
                                m_upper_category_for_services_beauty_and_health
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
                        : dropdownValueTwo == 'internet_and_computers'
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
                                m_upper_category_for_services_internet_and_computers
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
                        : dropdownValueTwo == 'transportation_or_car_service'
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
                                m_upper_category_for_services_transportation_or_car_service
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
                        : dropdownValueTwo == 'business_services'
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
                                m_upper_category_for_services_business_services
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
                        : dropdownValueTwo == 'cleaning'
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
                            items: m_upper_category_for_services_cleaning
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
                        : dropdownValueTwo == 'computers'
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
                            items: m_upper_category_for_electronics_computers
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
                        : dropdownValueTwo == 'photo_and_video_cameras'
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
                            items: m_lower_category_for_work.map((map) {
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
                        : dropdownValueTwo == 'phones_or_gadgets'
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
                                m_upper_category_for_electronics_phones_or_gadgets
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
                        : dropdownValueTwo == 'tv_and_video'
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
                            items: m_upper_category_for_electronics_tv_and_video
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
                        : dropdownValueTwo == 'audio_engineering'
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
                                m_upper_category_for_electronics_audio_engineering
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
                        : dropdownValueTwo == 'gaming_consoles'
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
                                m_upper_category_for_electronics_gaming_consoles
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
                        : dropdownValueTwo == 'individual_care'
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
                                m_upper_category_for_electronics_individual_care
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
                        : dropdownValueTwo == 'air_conditioning_equipment'
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
                                m_upper_category_for_electronics_air_conditioning_equipment
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
                        : dropdownValueTwo == 'kitchen_appliances'
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
                                m_upper_category_for_electronics_kitchen_appliances
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
                        : dropdownValueTwo == 'home_appliances'
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
                                m_upper_category_for_electronics_home_appliances
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
                        : dropdownValueTwo == 'furniture_and_interior'
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
                                m_upper_category_for_home_and_garden_furniture_and_interior
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
                        : dropdownValueTwo == 'renovation_and_construction'
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
                                m_upper_category_for_home_and_garden_renovation_and_construction
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
                        : dropdownValueTwo == 'tools_and_inventory'
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
                                m_upper_category_for_home_and_garden_tools_and_inventory
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
                        : dropdownValueTwo == 'plants'
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
                            items: m_upper_category_for_home_and_garden_plants
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
                        : dropdownValueTwo == 'home_textiles'
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
                                m_upper_category_for_home_and_garden_home_textiles
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
                        : dropdownValueTwo == 'household_chemicals'
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
                                m_upper_category_for_home_and_garden_household_chemicals
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
                        : dropdownValueTwo == 'clothing'
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
                                m_upper_category_for_personal_belongings_clothing
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
                        : dropdownValueTwo == 'footwear'
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
                                m_upper_category_for_personal_belongings_footwear
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
                        : dropdownValueTwo == 'for_the_wedding'
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
                                m_upper_category_for_personal_belongings_for_the_wedding
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
                        : dropdownValueTwo == 'accessories'
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
                                m_upper_category_for_personal_belongings_accessories
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
                        : dropdownValueTwo == 'presents'
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
                                m_upper_category_for_personal_belongings_presents
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
                        : dropdownValueTwo == 'products_for_beauty_and_health'
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
                                m_upper_category_for_personal_belongings_products_for_beauty_and_health
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
                        : dropdownValueTwo == 'clock'
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
                                m_upper_category_for_personal_belongings_clock
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
                        : dropdownValueTwo == 'raw_materials_and_supplies'
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
                                m_upper_category_for_business_raw_materials_and_supplies
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
                        : dropdownValueTwo == 'equipment_and_technology'
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
                                m_upper_category_for_business_equipment_and_technology
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
                        : dropdownValueTwo == 'food'
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
                                m_upper_category_for_business_food.map((map) {
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
                        : dropdownValueTwo == 'industrial_goods'
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
                                m_upper_category_for_business_industrial_goods
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
                        : dropdownValueTwo == 'sale_or_purchase_business'
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
                                m_upper_category_for_business_sale_or_purchase_business
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
                        : dropdownValueTwo == 'services_for_animals'
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
                                m_upper_category_for_animals_services_for_animals
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
                        : dropdownValueTwo == 'lost_and_found'
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
                            items: m_upper_category_for_animals_lost_and_found
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
                        : dropdownValueTwo == 'baby_clothes'
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
                            items: m_upper_category_for_children_baby_clothes
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
                        : dropdownValueTwo == 'children_shoes'
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
                            items: m_upper_category_for_children_children_shoes
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
                        : dropdownValueTwo == 'children_furniture'
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
                                m_upper_category_for_children_children_furniture
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
                        : dropdownValueTwo == 'collecting'
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
                                m_upper_category_for_hobbies_and_sports_collecting
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
                        : dropdownValueTwo == 'musical_instruments'
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
                                m_upper_category_for_hobbies_and_sports_musical_instruments
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
                        : dropdownValueTwo == 'sports_and_recreation'
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
                                m_upper_category_for_hobbies_and_sports_sports_and_recreation
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
                        : dropdownValueTwo == 'books_or_magazines'
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
                                m_upper_category_for_hobbies_and_sports_books_or_magazines
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
                        : dropdownValueTwo == 'bicycles'
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
                                m_upper_category_for_hobbies_and_sports_bicycles
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
                        : dropdownValueTwo == 'tickets'
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
                                m_upper_category_for_hobbies_and_sports_tickets
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
                        : dropdownValueTwo == 'travels'
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
                                m_upper_category_for_hobbies_and_sports_travels
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
                        : dropdownValueTwo == 'cd_or_dvd_or_records'
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
                                m_upper_category_for_hobbies_and_sports_cd_or_dvd_or_records
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
                        : dropdownValueTwo == 'trade_or_sales'
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
                            items: m_upper_category_for_work_trade_or_sales
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
                        : dropdownValueTwo == 'finance_or_banks_or_investments'
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
                                m_upper_category_for_work_finance_or_banks_or_investments
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
                        : dropdownValueTwo == 'transport_or_logistics'
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
                                m_upper_category_for_work_transport_or_logistics
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
                        : dropdownValueTwo == 'construction_or_real_estate'
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
                                m_upper_category_for_work_construction_or_real_estate
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
                        : dropdownValueTwo == 'jurisprudence_and_accounting'
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
                                m_upper_category_for_work_jurisprudence_and_accounting
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
                        : dropdownValueTwo == 'safety_and_security'
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
                            items: m_upper_category_for_work_safety_and_security
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
                        : dropdownValueTwo == 'domestic_staff'
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
                            items: m_upper_category_for_work_domestic_staff
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
                        : dropdownValueTwo == 'beauty_or_fitness_or_sports'
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
                                m_upper_category_for_work_beauty_or_fitness_or_sports
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
                        : dropdownValueTwo == 'tourism_or_hotels_or_restaurants'
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
                                m_upper_category_for_work_tourism_or_hotels_or_restaurants
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
                        : dropdownValueTwo == 'education_or_science'
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
                                m_upper_category_for_work_education_or_science
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
                        : dropdownValueTwo == 'culture_or_art_or_entertainment'
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
                                m_upper_category_for_work_culture_or_art_or_entertainment
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
                        : dropdownValueTwo == 'medicine_or_pharmaceuticals'
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
                                m_upper_category_for_work_medicine_or_pharmaceuticals
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
                            'it_or_computers_or_communications'
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
                                m_upper_category_for_work_it_or_computers_or_communications
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
                        : dropdownValueTwo == 'marketing_and_advertising'
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
                                m_upper_category_for_work_marketing_and_advertising
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
                        : dropdownValueTwo == 'manufacturing_or_energy'
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
                                m_upper_category_for_work_manufacturing_or_energy
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
                        : dropdownValueTwo == 'administrative_staff'
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
                                m_upper_category_for_work_administrative_staff
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
                        : dropdownValueTwo == 'career_start_or_students'
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
                                m_upper_category_for_work_career_start_or_students
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
                        : dropdownValueTwo == 'working_staff'
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
                            items: m_upper_category_for_work_working_staff
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
                        : dropdownValueTwo == 'car_business'
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
                            items: m_upper_category_for_work_car_business
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
                        : dropdownValueTwo == 'extraction_of_raw_materials'
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
                                m_upper_category_for_work_extraction_of_raw_materials
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
                        : dropdownValueTwo == 'insurance'
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
                                m_upper_category_for_work_insurance.map((map) {
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
                        : dropdownValueTwo == 'other_areas_activity'
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
                                m_upper_category_for_work_other_areas_activity
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
                        : dropdownValueTwo == 'network_marketing'
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
                            items: m_upper_category_for_work_network_marketing
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
                        : SizedBox()),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_price'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    children: [
                      valCheckBoxNegotiatedPrice || valCheckBoxWillGiveFree
                          ? SizedBox()
                          : textField(controllerMarketPriceApplication,
                              errorMarketPrice,
                              isNumber: true,
                              hint: AppLocalizations.of(context)
                                  .translate('h_m_price_in_tenge'),
                              onChanged: () {
                              setState(() {
                                valCheckBoxNegotiatedPrice = false;
                                valCheckBoxWillGiveFree = false;
                                errorMarketPrice = false;
                              });
                            }),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: twoColumnsContainer(
                            AppCheckbox(
                              value: valCheckBoxNegotiatedPrice,
                              onChanged: (val) {
                                setState(() {
                                  valCheckBoxNegotiatedPrice = val;
                                  valCheckBoxWillGiveFree = false;
                                  controllerMarketPriceApplication.clear();
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_m_negotiated_price'),
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: twoColumnsContainer(
                            AppCheckbox(
                              value: valCheckBoxWillGiveFree,
                              onChanged: (val) {
                                setState(() {
                                  valCheckBoxWillGiveFree = val;
                                  valCheckBoxNegotiatedPrice = false;
                                  controllerMarketPriceApplication.clear();
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_m_will_give_free'),
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_description'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: textField(
                        controllerMarketDescriptionApplication, false,
                        linesMax: 5,
                        hint: AppLocalizations.of(context)
                            .translate('h_m_desc_hint'), onChanged: () {
                      setState(() {
                        errorMarketName = false;
                      });
                    }),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_exchange'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  child: twoColumnsContainer(
                      AppCheckbox(
                        value: valCheckBoxExchange,
                        onChanged: (val) {
                          setState(() {
                            valCheckBoxExchange = val;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('h_m_exchange_true'),
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_photos'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).translate('h_m_contact_info'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                                  Text(AppLocalizations.of(context)
                                      .translate('h_m_region')),
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
                                      child: Text(AppLocalizations.of(context)
                                          .translate('h_m_get_location')),
                                    )
                            ],
                          ),
                          textField(controllerMarketRegionApplication, false,
                              enable: getAddress,
                              hint: !getAddress && _address != null
                                  ? _address.addressLine.toString()
                                  : AppLocalizations.of(context)
                                      .translate('h_m_enter_region'),
                              onChanged: () {
                            setState(() {
                              errorMarketName = false;
                            });
                          }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: twoColumnsContainer(
                            AppCheckbox(
                              value: valCheckBoxAuthUserPhone,
                              onChanged: (val) {
                                setState(() {
                                  valCheckBoxAuthUserPhone = val;
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('h_m_visible_phone'),
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                      ),
                      !getAddress && _address != null
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: twoLinesContainer(
                                Text(AppLocalizations.of(context)
                                    .translate('h_m_adress')),
                                textField(
                                    controllerMarketAdressApplication, false,
                                    hint: AppLocalizations.of(context)
                                        .translate('h_m_enter_adress'),
                                    onChanged: () {
                                  setState(() {
                                    errorMarketName = false;
                                  });
                                }),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: twoLinesContainer(
                          Text(AppLocalizations.of(context)
                              .translate('h_m_email')),
                          textField(controllerMarketEmailApplication, false,
                              hint: AppLocalizations.of(context)
                                  .translate('h_m_enter_email'), onChanged: () {
                            setState(() {
                              errorMarketName = false;
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                      if (controllerMarketNameApplication.text.length > 4) {
                        if (valCheckBoxNegotiatedPrice) {
                          if (controllerMarketDescriptionApplication
                                  .text.length >
                              10) {
                            if (dropdownValueTwo != null) {
                              uploadedImage();
                            } else {
                              setState(() {
                                errorMarketDropdown = true;
                              });
                            }
                          } else {
                            setState(() {
                              errorMarketDescription = true;
                            });
                          }
                        } else {
                          setState(() {
                            errorMarketPrice = true;
                          });
                        }
                        if (valCheckBoxWillGiveFree &&
                            !valCheckBoxNegotiatedPrice) {
                          if (controllerMarketDescriptionApplication
                                  .text.length >
                              10) {
                            if (dropdownValueTwo != null) {
                              uploadedImage();
                            } else {
                              setState(() {
                                errorMarketDropdown = true;
                              });
                            }
                          } else {
                            setState(() {
                              errorMarketDescription = true;
                            });
                          }
                        } else {
                          setState(() {
                            errorMarketPrice = true;
                          });
                        }
                        if (controllerMarketPriceApplication.text.length > 1) {
                          if (controllerMarketDescriptionApplication
                                  .text.length >
                              10) {
                            if (dropdownValueTwo != null) {
                              uploadedImage();
                            } else {
                              setState(() {
                                errorMarketDropdown = true;
                              });
                            }
                          } else {
                            setState(() {
                              errorMarketDescription = true;
                            });
                          }
                        } else {
                          setState(() {
                            errorMarketPrice = true;
                          });
                        }
                      } else {
                        setState(() {
                          errorMarketName = true;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
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
        .child('market/${randomName}.png');
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
          state.createMarketApplication(context,
              m_address: _address != null
                  ? _address.addressLine
                  : controllerMarketAdressApplication.text.trim() ?? null,
              m_description:
                  controllerMarketDescriptionApplication.text.trim() ?? null,
              m_email: controllerMarketEmailApplication.text.trim() ?? null,
              m_exchange: valCheckBoxExchange,
              m_heading: controllerMarketNameApplication.text.trim() ?? null,
              m_negotiated_price: valCheckBoxNegotiatedPrice,
              m_phone: valCheckBoxAuthUserPhone,
              m_photo: snapshot.toString(),
              m_price: controllerMarketPriceApplication.text.trim() ?? null,
              m_region: _address != null
                  ? null
                  : controllerMarketRegionApplication.text.trim() ?? null,
              m_latitude: _address != null ? dataLatitude : null,
              m_longitude: _address != null ? dataLongitude : null,
              m_will_give_free: valCheckBoxWillGiveFree,
              m_average_category: dropdownValue,
              m_lower_category: dropdownValueTwo,
              m_upper_category: dropdownValueThree ?? null);
        });
      }
    });
  }
}
