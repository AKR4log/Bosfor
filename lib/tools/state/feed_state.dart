import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/app_state.dart';

class FeedState extends AppState {
  final String uid;
  final String uidUser;
  final String uidComment;
  final String uidApplicationMarket;
  final String uidApplications;
  final String upperCategory;
  final String uidExclude;
  FeedState(
      {this.uid,
      this.uidUser,
      this.uidExclude,
      this.uidApplicationMarket,
      this.upperCategory,
      this.uidApplications,
      this.uidComment});
  final CollectionReference marketCollection =
      FirebaseFirestore.instance.collection('market');
  final CollectionReference transportCollection =
      FirebaseFirestore.instance.collection('auto');
  final CollectionReference propertyCollection =
      FirebaseFirestore.instance.collection('property');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final String uidAuthUser = FirebaseAuth.instance.currentUser.uid;

  // Get data AuthUser
  UserData _getAuthUser(DocumentSnapshot snapshot) {
    return UserData(
        u_name: snapshot.get('name'),
        u_phone_number: snapshot.get('phoneNumber'),
        u_surname: snapshot.get('surname'),
        u_uri_avatars: snapshot.get('uriImage'),
        u_uid: snapshot.get('uidUser'));
  }

  // Get data Market
  MarketApplication _getMarketApplication(DocumentSnapshot snapshot) {
    return MarketApplication(
      m_address: snapshot.get('m_address'),
      m_average_category: snapshot.get('m_average_category'),
      m_date_creation_application: snapshot.get('m_date_creation_application'),
      m_description: snapshot.get('m_description'),
      m_email: snapshot.get('m_email'),
      m_exchange: snapshot.get('m_exchange'),
      m_heading: snapshot.get('m_heading'),
      m_latitude: snapshot.get('m_latitude'),
      m_longitude: snapshot.get('m_longitude'),
      m_negotiated_price: snapshot.get('m_negotiated_price'),
      m_lower_category: snapshot.get('m_lower_category'),
      m_phone: snapshot.get('m_phone'),
      m_photo: snapshot.get('m_photo'),
      m_price: snapshot.get('m_price'),
      m_region: snapshot.get('m_region'),
      m_uid_application: snapshot.get('m_uid_application'),
      m_uid_user_by_application: snapshot.get('m_uid_user_by_application'),
      m_upper_category: snapshot.get('m_upper_category'),
      m_will_give_free: snapshot.get('m_will_give_free'),
    );
  }

  // Loading all market applications
  List<MarketApplication> _loadAllMarketApplications(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MarketApplication(
          m_address: doc.get("m_address") ?? null,
          m_date_creation_application:
              doc.get("m_date_creation_application") ?? null,
          m_description: doc.get("m_description") ?? null,
          m_email: doc.get("m_email") ?? null,
          m_exchange: doc.get("m_exchange") ?? '',
          m_heading: doc.get("m_heading") ?? null,
          m_negotiated_price: doc.get("m_negotiated_price") ?? '',
          m_phone: doc.get("m_phone") ?? null,
          m_photo: doc.get("m_photo") ?? null,
          m_price: doc.get("m_price") ?? null,
          m_region: doc.get("m_region") ?? null,
          m_uid_application: doc.get("m_uid_application") ?? null,
          m_latitude: doc.get('m_latitude') ?? null,
          m_longitude: doc.get('m_longitude') ?? null,
          m_uid_user_by_application:
              doc.get("m_uid_user_by_application") ?? null,
          m_will_give_free: doc.get("m_will_give_free") ?? '',
          m_average_category: doc.get('m_average_category') ?? '',
          m_lower_category: doc.get('m_lower_category') ?? '',
          m_upper_category: doc.get('m_upper_category') ?? '');
    }).toList();
  }

  // Loading all transport applictions
  List<TransportApplication> _loadAllTransportApplications(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TransportApplication(
        a_uid_application: doc.get('a_uid_application') ?? null,
        a_mAuto: doc.get('a_mAuto') ?? null,
        a_mNameCars: doc.get('a_mNameCars') ?? null,
        a_mNameModelCars: doc.get("a_mNameModelCars") ?? null,
        a_dValAuto: doc.get("a_dValAuto") ?? null,
        a_dValCommercial: doc.get("a_dValCommercial") ?? null,
        a_dValRepairsAndService: doc.get("a_dValRepairsAndService") ?? null,
        a_dValSpareParts: doc.get("a_dValSpareParts") ?? null,
        a_dValOther: doc.get("a_dValOther") ?? null,
        a_mValCarBody: doc.get("a_mValCarBody") ?? null,
        a_mValDriveAuto: doc.get("a_mValDriveAuto") ?? null,
        a_mValGearboxBox: doc.get("a_mValGearboxBox") ?? null,
        a_yearOfIssue: doc.get("a_yearOfIssue") ?? null,
        a_engineVolume: doc.get("a_engineVolume") ?? null,
        a_mileage: doc.get("a_mileage") ?? null,
        a_price: doc.get("a_price") ?? null,
        a_description: doc.get("a_description") ?? null,
        a_uid_user_by_application: doc.get("a_uid_user_by_application") ?? null,
      );
    }).toList();
  }

  // Loading all the property applications
  List<PropertyApplication> _loadAllPropertyApplications(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PropertyApplication(
        p_average_category: doc.get("p_average_category") ?? null,
        p_balcony: doc.get("p_balcony") ?? null,
        p_bathroom: doc.get("p_bathroom") ?? null,
        p_building_type: doc.get("p_building_type") ?? null,
        p_ceiling_height: doc.get("p_ceiling_height") ?? null,
        p_condition: doc.get("p_condition") ?? null,
        p_country_city: doc.get("p_country_city") ?? null,
        p_crossing: doc.get("p_crossing") ?? null,
        p_door: doc.get("p_door") ?? null,
        p_floor: doc.get('p_floor') ?? null,
        p_floor_end: doc.get('p_floor_end') ?? null,
        p_floor_start: doc.get('p_floor_start') ?? null,
        p_furniture: doc.get('p_furniture') ?? null,
        p_glazed_balcony: doc.get('p_glazed_balcony') ?? null,
        p_house_number: doc.get('p_house_number') ?? null,
        p_internet: doc.get('p_internet') ?? null,
        p_kitchen_square: doc.get('p_kitchen_square') ?? null,
        p_living_space: doc.get('p_living_space') ?? null,
        p_lower_category: doc.get('p_lower_category') ?? null,
        p_numbers_room: doc.get('p_numbers_room') ?? null,
        p_parking: doc.get('p_parking') ?? null,
        p_price: doc.get('p_price') ?? null,
        p_street_microdistrict: doc.get('p_street_microdistrict') ?? null,
        p_telephone: doc.get('p_telephone') ?? null,
        p_total_area: doc.get('p_total_area') ?? null,
        p_year_built: doc.get('p_year_built') ?? null,
        is_pledge: doc.get('is_pledge') ?? null,
        uid_property: doc.get('uid_property') ?? null,
        is_hide_phone: doc.get('is_hide_phone') ?? null,
        is_in_dorm: doc.get('is_in_dorm') ?? null,
        uid_user: doc.get('uid_user') ?? null,
      );
    }).toList();
  }

  // Loading all applications AuthUser
  List<Application> _loadAllApplicationsAuthUser(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Application(
          m_uid_application: doc.get("m_uid_application") ?? null,
          m_status_archive: doc.get("m_status_archive") ?? false,
          m_date_creation_application:
              doc.get('m_date_creation_application') ?? null);
    }).toList();
  }

  // Loading all bookmarks AuthUser
  List<BookmarksApplications> _loadAllBookmarksApplicationsAuthUser(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BookmarksApplications(
          uidApplications: doc.get('uidApplications') ?? '',
          dateCreations: doc.get('dateCreations') ?? '');
    }).toList();
  }

  Stream<List<MarketApplication>> get allMarketApplications {
    return marketCollection
        .where('m_status_archive', isEqualTo: false)
        .orderBy('m_date_creation_application', descending: true)
        .snapshots()
        .map(_loadAllMarketApplications);
  }

  Stream<List<MarketApplication>> get allMarketApplicationsUID {
    return marketCollection
        .where('m_status_archive', isEqualTo: false)
        .where('m_uid_user_by_application', isEqualTo: uidUser)
        .orderBy('m_date_creation_application', descending: true)
        .snapshots()
        .map(_loadAllMarketApplications);
  }

  Stream<List<MarketApplication>> get allSimilarMarketApplications {
    return marketCollection
        .where('m_uid_application', isLessThan: uidExclude)
        .where('m_upper_category', isEqualTo: upperCategory)
        // .orderBy('m_date_creation_application', descending: true)
        .snapshots()
        .map(_loadAllMarketApplications);
  }

  Stream<List<TransportApplication>> get allTransportApplications {
    return transportCollection
        // .orderBy('dateCreationApplication', descending: true)
        .snapshots()
        .map(_loadAllTransportApplications);
  }

  Stream<List<PropertyApplication>> get allPropertyApplications {
    return propertyCollection
        // .orderBy('dateCreationApplication', descending: true)
        .snapshots()
        .map(_loadAllPropertyApplications);
  }

  Stream<List<Application>> get allApplicationsAuthUser {
    return usersCollection
        .doc(uidAuthUser)
        .collection('applications')
        .snapshots()
        .map(_loadAllApplicationsAuthUser);
  }

  Stream<List<Application>> get allArchiveApplicationsAuthUser {
    return usersCollection
        .doc(uidAuthUser)
        .collection('archive')
        .snapshots()
        .map(_loadAllApplicationsAuthUser);
  }

  Stream<UserData> get authUser {
    return usersCollection.doc(uidAuthUser).snapshots().map(_getAuthUser);
  }

  Stream<UserData> get qUser {
    return usersCollection.doc(uidUser).snapshots().map(_getAuthUser);
  }

  Stream<MarketApplication> get marketApplication {
    return marketCollection
        .doc(uidApplicationMarket)
        .snapshots()
        .map(_getMarketApplication);
  }

  Stream<List<BookmarksApplications>> get allBookmarksApplications {
    return usersCollection
        .doc(uidAuthUser)
        .collection('bookmarks')
        .orderBy('dateCreations', descending: true)
        .snapshots()
        .map(_loadAllBookmarksApplicationsAuthUser);
  }

  // Applications from AuthUser
  // Stream<List<Post>> get posts {
  //   return postsCollection
  //       .orderBy('dateCreation', descending: true)
  //       .where("senderUid", isEqualTo: uidUser)
  //       .snapshots()
  //       .map(_postsDatabase);
  // }

  // Stream<List<UserData>> get users {
  //   return usersCollection.snapshots().map(_usersDatabase);
  // }

  // Stream<List<Liked>> get likes {
  //   return postsCollection
  //       .doc(uidPost)
  //       .collection('likes')
  //       // .where('fromUserUID', isEqualTo: uidAuthUser)
  //       .snapshots()
  //       .map(_getLikesPostDatabase);
  // }

  // // Stream<Music> get music {
  // //   return musicCollection.doc(uidMusic).snapshots().map(_getMusicDatabase);
  // // }

  // Stream<List<Comment>> get comments {
  //   return postsCollection
  //       .doc(uid)
  //       .collection("comment")
  //       .orderBy('timeCreated', descending: true)
  //       .snapshots()
  //       .map(_commentsDatabase);
  // }

  // Stream<Comment> get comment {
  //   return postsCollection
  //       .doc(uid)
  //       .collection('comment')
  //       .doc(uidComment)
  //       .snapshots()
  //       .map(_getCommentDatabase);
  // }
}
