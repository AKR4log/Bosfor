import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/pages/phone/connection/login/codes/confirm_code.dart';
import 'package:kz/pages/phone/connection/login/login_page.dart';
import 'package:kz/pages/phone/connection/register/register_page.dart';
import 'package:kz/pages/phone/home.dart';
import 'package:kz/pages/phone/user/creation/auto/creation_auto.dart';
import 'package:kz/pages/phone/user/creation/market/creation_market.dart';
import 'package:kz/pages/phone/user/creation/property/creation_property.dart';
import 'package:kz/pages/phone/user/feed/market/widget/edit/edit_screen.dart';
import 'package:kz/pages/phone/user/feed/market/widget/widget_screen_market.dart';
import 'package:kz/pages/phone/user/profile/active_applications/active_list_applications.dart';
import 'package:kz/pages/phone/user/profile/archive/archive_list.dart';
import 'package:kz/pages/phone/user/profile/archive/widgets/screen.dart';
import 'package:kz/pages/phone/user/profile/edit_profile/edit_lang/edits_lang.dart';
import 'package:kz/pages/phone/user/profile/edit_profile/edit_profile.dart';
import 'package:kz/pages/phone/user/profile/profile.dart';
import 'package:kz/pages/phone/user/profile/user_screen.dart';
import 'package:kz/pages/web/auth/login.dart';
import 'package:kz/pages/web/user/feed/feed_page.dart';
import 'package:kz/splash.dart';
import 'package:kz/tools/routes/custom_routes.dart';
import 'package:kz/tools/widgets/custom/container/success/success_update_name.dart';
import 'package:kz/tools/widgets/custom/container/success/success_upload_photo.dart';
import 'package:kz/tools/widgets/custom/container/success/success_upload_photo_and_name.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }

  static void sendNavigationEventToFirebase(String path) {
    if (path != null && path.isNotEmpty) {
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    if (kIsWeb) {
      switch (pathElements[1]) {
        case "LoginPage":
          return CustomRoute<bool>(
              builder: (BuildContext context) => LoginPageWeb());
        case "ConfirmCode":
          return CustomRoute<bool>(
              builder: (BuildContext context) => RegisterPage());
        case "HomePage":
          return CustomRoute<bool>(
              builder: (BuildContext context) => FeedPageWeb());
      }
    } else {
      switch (pathElements[1]) {
        case "LoginPage":
          return CustomRoute<bool>(
              builder: (BuildContext context) => LoginPage());
        case "RegisterPage":
          return CustomRoute<bool>(
              builder: (BuildContext context) => RegisterPage());
        case "ConfirmCode":
          return CustomRoute<bool>(
              builder: (BuildContext context) => RegisterPage());
        case "HomePage":
          return CustomRoute<bool>(
              builder: (BuildContext context) => HomePage());
        case "ProfilePage":
          String profileId = pathElements[2];
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => ProfilePage(
                    profileId: profileId,
                  ));
        case "ConfirmCodes":
          String verificationID = pathElements[2];
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => ConfirmCode(
                    verificationID: verificationID,
                  ));
        case "WidgetMarket":
          String uidMarket = pathElements[2];
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => WidgetContainerMarket(
                    uidMarket: uidMarket,
                  ));
        case "ArchiveWidgetMarket":
          String uidMarket = pathElements[2];
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => ArchiveWidgetContainerMarket(
                    uidMarket: uidMarket,
                  ));
        case "UserScreen":
          String profileId = pathElements[2];
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => UserScreen(
                    profileId: profileId,
                  ));
        case "CreationMarket":
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => CreationMarket());
        case "CreationProperty":
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => CreationProperty());
        case "CreationAuto":
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => CreationAuto());
        case "ActiveApplications":
          return SlideLeftRoute<bool>(
              builder: (BuildContext context) => ActiveApplicationsAuthUser());
        case "EditProfile":
          return CustomRoute<bool>(
              builder: (BuildContext context) => EditProfile());
        case "Archive":
          return CustomRoute<bool>(
              builder: (BuildContext context) => ArchiveList());
        case "EditMarket":
          String uidMarket = pathElements[2];
          return CustomRoute<bool>(
              builder: (BuildContext context) => EditScreenMarket(
                    uidApp: uidMarket,
                  ));
        case "EditsLang":
          return CustomRoute<bool>(
              builder: (BuildContext context) => EditsLang());

        case "SuccessUploadPhoto":
          return CustomRoute<bool>(
              builder: (BuildContext context) => SuccessUploadPhoto());
        case "SuccessUploadPhotoAndName":
          return CustomRoute<bool>(
              builder: (BuildContext context) => SuccessUploadPhotoAndName());
        case "SuccessUpdateName":
          return CustomRoute<bool>(
              builder: (BuildContext context) => SuccessUpdateName());
      }
    }
  }
}
