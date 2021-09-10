import 'dart:typed_data';

import 'package:flutter/material.dart';

class TransportApplication {
  String a_uid_application;
  String a_mAuto;
  String a_mNameCars;
  String a_mNameModelCars;
  String a_dValAuto;
  String a_dValCommercial;
  String a_dValRepairsAndService;
  String a_dValSpareParts;
  String a_dValOther;
  String a_mValCarBody;
  String a_mValDriveAuto;
  String a_mValGearboxBox;
  String photo_1;
  String photo_2;
  String photo_3;
  String photo_4;
  String photo_5;
  String youtube;
  String a_address;
  List<Uint8List> listURL;
  String a_region;
  String a_yearOfIssue;
  String a_engineVolume;
  String a_head;
  String a_desc;
  String a_mileage;
  String a_price;
  String a_uid_user_by_application;
  String date_creation_application;

  TransportApplication({
    this.a_uid_application,
    this.a_mAuto,
    this.a_mNameCars,
    this.date_creation_application,
    this.listURL,
    this.a_mNameModelCars,
    this.a_dValAuto,
    this.a_dValCommercial,
    this.a_dValRepairsAndService,
    this.a_dValSpareParts,
    this.a_dValOther,
    this.a_mValCarBody,
    this.a_mValDriveAuto,
    this.a_mValGearboxBox,
    this.a_yearOfIssue,
    this.photo_1,
    this.photo_2,
    this.photo_3,
    this.photo_4,
    this.photo_5,
    this.youtube,
    this.a_engineVolume,
    this.a_mileage,
    this.a_price,
    this.a_uid_user_by_application,
    this.a_address,
    this.a_region,
    this.a_desc,
    this.a_head,
  });
}
