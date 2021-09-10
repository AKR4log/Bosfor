import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/tools/enum/enum.dart';
import 'package:kz/tools/state/app_state.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CloudFirestore extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ConfirmationResult confirmationResult;
  User user;

  /// Вход по номеру телефона v.1
  signInWithCredential(authResult, context) async {
    UserCredential firebaseResult =
        await FirebaseAuth.instance.signInWithCredential(authResult);
    user = firebaseResult.user;
    if (firebaseResult.additionalUserInfo.isNewUser) {
      authStatus = AuthStatus.REGISTER_NOW_USER;
      Navigator.pushReplacementNamed(context, "/RegisterPage");
    } else {
      authStatus = AuthStatus.LOGGED_IN;
      Navigator.pushReplacementNamed(context, "/HomePage");
    }
  }

  signInWithPhoneNumberWeb(phoneNumber) async {
    confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(
      phoneNumber,
    );
  }

  signInWithPhoneNumberWebConfirm(code, context) async {
    UserCredential userCredential = await confirmationResult.confirm(code);
    user = userCredential.user;
    authStatus = AuthStatus.LOGGED_IN;
    Navigator.of(context).pushReplacementNamed(HomeWebPage.routeName);
  }

  /// Вход по номеру телефона v.2
  signInWithCredentialOTP(smsCODE, verID, context) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verID, smsCode: smsCODE);
    signInWithCredential(authCredential, context);
  }

  Future<User> getCurrentUser({context}) async {
    try {
      await Firebase.initializeApp();
      loading = true;
      user = _firebaseAuth.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get()
            .then((value) {
          if (value.data() != null) {
            authStatus = AuthStatus.LOGGED_IN;
            print(authStatus);
            if (kIsWeb) {
              Navigator.of(context).pushReplacementNamed(HomeWebPage.routeName);
            } else {
              Navigator.pushReplacementNamed(context, "/HomePage");
            }
          } else {
            authStatus = AuthStatus.REGISTER_NOW_USER;
            print(authStatus);
            Navigator.pushReplacementNamed(context, "/RegisterPage");
          }
        });
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch (error) {
      loading = false;
      debugPrint(user.toString());
      debugPrint("ERROR");
      debugPrint(error.toString());
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> createNewUser(
    BuildContext context,
    String name,
    String surname, {
    String downloadURI,
  }) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    var phone = FirebaseAuth.instance.currentUser.phoneNumber;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).set({
      "name": name,
      "surname": surname,
      "uriImage": downloadURI,
      "phoneNumber": phone,
      "uidUser": uid,
    }).whenComplete(() => Navigator.pushReplacementNamed(context, "/HomePage"));
    return;
  }

  Future<void> uploadPhoto(
    BuildContext context,
    String downloadURI,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).update({
      "uriImage": downloadURI,
    }).whenComplete(() {
      if (kIsWeb) {
        Navigator.of(context).pushReplacementNamed(WebProfilePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, "/SuccessUploadPhoto");
      }
    });
    return;
  }

  Future<void> updateName(
    BuildContext context,
    String name,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).update({
      "name": name,
    }).whenComplete(() {
      if (kIsWeb) {
        Navigator.of(context).pushReplacementNamed(WebProfilePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, "/SuccessUpdateName");
      }
    });
    return;
  }

  Future<void> uploadPhotoAndName(
      BuildContext context, String downloadURI, String name) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).update({
      "name": name,
      "uriImage": downloadURI,
    }).whenComplete(() {
      if (kIsWeb) {
        Navigator.of(context).pushReplacementNamed(WebProfilePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, "/SuccessUploadPhotoAndName");
      }
    });
    return;
  }

  Future<void> createMarketApplication(
    BuildContext context, {
    String m_address,
    String m_description,
    String m_email,
    bool m_exchange,
    String m_heading,
    bool m_negotiated_price,
    bool m_phone,
    String m_photo_1,
    String m_photo_2,
    String m_photo_3,
    String m_photo_4,
    String m_photo_5,
    String m_youtube,
    String m_price,
    String m_region,
    bool m_will_give_free,
    String m_average_category,
    String m_lower_category,
    double m_latitude,
    double m_longitude,
    String m_upper_category,
  }) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    var phone = FirebaseAuth.instance.currentUser.phoneNumber;
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("market");
    ref.doc(randomName).set({
      "m_address": m_address ?? null,
      "m_date_creation_application": DateTime.now().toUtc().toString(),
      "m_description": m_description,
      "m_email": m_email,
      "m_exchange": m_exchange,
      "m_heading": m_heading,
      "m_longitude": m_address != null ? m_longitude : null,
      "m_latitude": m_address != null ? m_latitude : null,
      "m_negotiated_price": m_negotiated_price ?? false,
      "m_phone": phone,
      "m_photo_1": m_photo_1 ?? null,
      "m_photo_2": m_photo_2 ?? null,
      "m_photo_3": m_photo_3 ?? null,
      "m_photo_4": m_photo_4 ?? null,
      "m_photo_5": m_photo_5 ?? null,
      "m_youtube": m_youtube ?? null,
      "m_status_archive": false,
      "m_price": m_price,
      "m_region": m_region,
      "m_uid_application": randomName,
      "m_uid_user_by_application": uid,
      "m_average_category": m_average_category,
      "m_lower_category": m_lower_category,
      "m_upper_category": m_upper_category,
      "m_will_give_free": m_will_give_free ?? false
    });
    CollectionReference refUser =
        FirebaseFirestore.instance.collection("users");
    refUser.doc(uid).collection("applications").doc(randomName).set({
      "m_uid_application": randomName,
      "m_date_creation_application": DateTime.now().toUtc().toString(),
    }).whenComplete(() => Navigator.pushReplacementNamed(context, "/HomePage"));
    return;
  }

  Future<void> createAutoApplication(
      BuildContext context, List<Uint8List> listURL,
      {String mValAuto,
      mNameCars,
      mNameModelCars,
      dValAuto,
      dValCommercial,
      dValRepairsAndService,
      dValSpareParts,
      dValOther,
      photo_1,
      photo_2,
      photo_3,
      photo_4,
      photo_5,
      youtube,
      mValCarBody,
      mValDriveAuto,
      mValGearboxBox,
      yearOfIssue,
      engineVolume,
      mileage,
      price,
      a_head,
      a_desc,
      description,
      adress,
      region}) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("auto");
    ref.doc(randomName).set({
      "a_uid_application": randomName,
      "a_mAuto": mValAuto ?? null,
      "a_mNameCars": mNameCars ?? null,
      "a_mNameModelCars": mNameModelCars ?? null,
      "a_dValAuto": dValAuto ?? null,
      "a_dValCommercial": dValCommercial ?? null,
      "a_dValRepairsAndService": dValRepairsAndService ?? null,
      "a_dValSpareParts": dValSpareParts ?? null,
      "a_dValOther": dValOther ?? null,
      "photo_1": photo_1 ?? null,
      "photo_2": photo_2 ?? null,
      "photo_3": photo_3 ?? null,
      "photo_4": photo_4 ?? null,
      "photo_5": photo_5 ?? null,
      "a_desc": a_desc ?? null,
      "a_head": a_head ?? null,
      "youtube": youtube ?? null,
      "listURL": listURL ?? null,
      "a_mValCarBody": 'h_m_' + mValCarBody ?? null,
      "a_mValDriveAuto": 'h_m_' + mValDriveAuto ?? null,
      "a_mValGearboxBox": 'h_m_' + mValGearboxBox ?? null,
      "a_yearOfIssue": yearOfIssue ?? null,
      "a_engineVolume": engineVolume ?? null,
      "a_mileage": mileage ?? null,
      "a_price": price ?? null,
      "a_uid_user_by_application": uid,
      "a_address": adress ?? null,
      "a_region": region ?? null,
      "date_creation_application": DateTime.now().toUtc().toString(),
    });
    CollectionReference refUser =
        FirebaseFirestore.instance.collection("users");
    refUser.doc(uid).collection("applications").doc(randomName).set({
      "m_uid_application": randomName,
      "m_date_creation_application": DateTime.now().toUtc().toString(),
    }).whenComplete(() => Navigator.pushReplacementNamed(context, "/HomePage"));
    return;
  }

  Future<void> createProperty(
    BuildContext context, {
    String p_price,
    String p_numbers_room,
    String p_average_category,
    String p_lower_category,
    String p_building_type,
    String p_bathroom,
    String p_internet,
    String p_condition,
    String p_photo_1,
    String p_photo_2,
    String p_photo_3,
    String p_photo_4,
    String p_photo_5,
    String p_youtube,
    String p_telephone,
    String p_balcony,
    String p_glazed_balcony,
    String p_head,
    String p_desc,
    String p_door,
    String p_parking,
    String p_furniture,
    String p_floor,
    String p_year_built,
    String p_total_area,
    String p_floor_start,
    String p_floor_end,
    String p_living_space,
    String p_ceiling_height,
    String p_crossing,
    String p_kitchen_square,
    String p_house_number,
    String p_country_city,
    String p_street_microdistrict,
    bool is_pledge,
    bool is_in_dorm,
    bool is_hide_phone,
  }) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    String randomName;
    randomName = Uuid().v4();
    CollectionReference ref = FirebaseFirestore.instance.collection("property");
    ref.doc(randomName).set({
      "p_price": p_price ?? null,
      "p_numbers_room": p_numbers_room ?? null,
      "p_desc": p_desc ?? null,
      "p_head": p_head ?? null,
      "p_average_category": p_average_category ?? null,
      "p_lower_category": p_lower_category ?? null,
      "p_building_type": p_building_type ?? null,
      "p_bathroom": p_bathroom ?? null,
      "p_internet": p_internet ?? null,
      "p_condition": p_condition ?? null,
      "p_telephone": p_telephone ?? null,
      "p_balcony": p_balcony ?? null,
      "p_photo_1": p_photo_1 ?? null,
      "p_photo_2": p_photo_2 ?? null,
      "p_photo_3": p_photo_3 ?? null,
      "p_photo_4": p_photo_4 ?? null,
      "p_photo_5": p_photo_5 ?? null,
      "p_youtube": p_youtube ?? null,
      "p_glazed_balcony": p_glazed_balcony ?? null,
      "p_door": p_door ?? null,
      "p_parking": p_parking ?? null,
      "p_furniture": p_furniture ?? null,
      "p_floor": p_floor ?? null,
      "p_year_built": p_year_built ?? null,
      "p_total_area": p_total_area ?? null,
      "p_floor_start": p_floor_start ?? null,
      "p_floor_end": p_floor_end ?? null,
      "p_living_space": p_living_space ?? null,
      "p_ceiling_height": p_ceiling_height ?? null,
      "p_crossing": p_crossing ?? null,
      "p_kitchen_square": p_kitchen_square ?? null,
      "p_house_number": p_house_number ?? null,
      "p_country_city": p_country_city ?? null,
      "p_street_microdistrict": p_street_microdistrict ?? null,
      "uid_property": randomName,
      "uid_user": uid,
      "is_pledge": is_pledge ?? false,
      "is_in_dorm": is_in_dorm ?? false,
      "is_hide_phone": is_hide_phone ?? false,
      "date_creation_application": DateTime.now().toUtc().toString(),
    }).whenComplete(() => Navigator.pushReplacementNamed(context, "/HomePage"));
    return;
  }

  Future<void> addBookmarks(
    BuildContext context,
    String uidApplications,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).collection('bookmarks').doc(uidApplications).set({
      "uidApplications": uidApplications,
      "dateCreations": DateTime.now().toUtc().toString(),
    });
    return;
  }

  Future<void> crtReview(
    BuildContext context,
    String db,
    String uidApplication,
    String review,
  ) async {
    await Firebase.initializeApp();
    String uid = Uuid().v4();
    String uidUser = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection(db);
    ref.doc(uidApplication).collection('reviews').doc(uid).set({
      "uidReviews": uid,
      "dateCreations": DateTime.now().toUtc().toString(),
      "txt": review,
      "uidUser": uidUser,
    });
    return;
  }

  Future<void> addArchiveMarket(
    BuildContext context,
    String uidApplication,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).collection('archive').doc(uidApplication).set({
      "m_uid_application": uidApplication,
      "m_date_creation_application": DateTime.now().toUtc().toString(),
      "m_status_archive": true,
    });

    CollectionReference refT = FirebaseFirestore.instance.collection("market");
    refT.doc(uidApplication).update({
      "m_status_archive": true,
    });
    return;
  }

  Future<void> removeArchiveMarket(
    BuildContext context,
    String uidApplication,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    CollectionReference refT = FirebaseFirestore.instance.collection("market");
    refT.doc(uidApplication).update({
      "m_status_archive": false,
    });
    ref.doc(uid).collection('archive').doc(uidApplication).delete();
    return;
  }

  Future<void> deteleBookmarks(
    BuildContext context,
    String uidApplications,
  ) async {
    await Firebase.initializeApp();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    ref.doc(uid).collection('bookmarks').doc(uidApplications).delete();
    return;
  }

  Future<void> likedMarket(BuildContext context, String uidApplication,
      {String dbname}) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection(dbname);
    ref.doc(uidApplication).collection('liked').doc(randomName).set({
      "uidApplication": uidApplication,
      "uidUser": uid,
      "uidLikedApplication": randomName,
      "dateCreations": DateTime.now().toUtc().toString(),
    });
    return;
  }

  Future<void> dLikedMarket(BuildContext context, String uidApplication,
      {String dbname}) async {
    await Firebase.initializeApp();
    String randomName;
    randomName = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection(dbname);
    ref.doc(uidApplication).collection('dliked').doc(randomName).set({
      "uidApplication": uidApplication,
      "uidUser": uid,
      "uidLikedApplication": randomName,
      "dateCreations": DateTime.now().toUtc().toString(),
    });
    return;
  }

  Future<void> removeLiked(
      BuildContext context, String uidApplication, String uidLiked,
      {String dbname}) async {
    await Firebase.initializeApp();
    CollectionReference ref = FirebaseFirestore.instance.collection(dbname);
    ref.doc(uidApplication).collection('liked').doc(uidLiked).delete();
    return;
  }

  Future<void> removeDLiked(
      BuildContext context, String uidApplication, String uidLiked,
      {String dbname}) async {
    await Firebase.initializeApp();
    CollectionReference ref = FirebaseFirestore.instance.collection(dbname);
    ref.doc(uidApplication).collection('dliked').doc(uidLiked).delete();
    return;
  }

  Future<void> getUserFromUid(uid) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("users")
        .where(uid, isEqualTo: uid)
        .get()
        .then((snapshot) {
      if (snapshot != null) {
        snapshot.docs.forEach((element) {
          print(element.data);
          return element.data;
        });
      } else {
        print("No data found");
      }
    });
    return;
  }

  // Future<void> readFollowers(collection, name, [isEqualTos]) async {
  //   await Firebase.initializeApp();

  //   FirebaseFirestore.instance
  //       .collection(collection)
  //       .where(name, isEqualTo: isEqualTos)
  //       .get()
  //       .then((snapshot) {
  //     if (snapshot != null) {
  //       snapshot.docs.forEach((element) {
  //         print(element.id);
  //         print(element.data().toString());
  //       });
  //     } else {
  //       print("No data found");
  //     }
  //   });
  //   return;
  // }

  // Future<void> update() async {
  //   await Firebase.initializeApp();
  //   CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  //   ref
  //       .doc('1234')
  //       .update({"name": "test1"})
  //       .then((value) => print("Success"))
  //       .catchError((error) => print(error.toString()));
  //   return;
  // }

  // Future<void> delete() async {
  //   await Firebase.initializeApp();
  //   CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  //   ref
  //       .doc('9123')
  //       .delete()
  //       .then((value) => print("Success"))
  //       .catchError((error) => print(error.toString()));
  //   return;
  // }

  // Future<void> follow(
  //   BuildContext context,
  //   String uidFriend,
  // ) async {
  //   await Firebase.initializeApp();
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   CollectionReference ref = FirebaseFirestore.instance.collection("users");
  //   ref.doc(uidFriend).collection('following').doc(uid).set({
  //     "uidFollower": uid,
  //     "timeRequest": DateTime.now().toUtc().toString(),
  //   });
  //   ref.doc(uid).collection('follower').doc(uidFriend).set({
  //     "uidFollowing": uidFriend,
  //     "timeRequest": DateTime.now().toUtc().toString(),
  //   });
  //   return;
  // }

  // Future<void> following(
  //   BuildContext context,
  //   String uidFriend,
  // ) async {
  //   await Firebase.initializeApp();
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   CollectionReference ref = FirebaseFirestore.instance.collection("users");
  //   ref.doc(uidFriend).collection('following').doc(uid).delete();
  //   ref.doc(uid).collection('follower').doc(uidFriend).delete();
  //   return;
  // }

}
