import 'package:flutter/material.dart';
import 'package:kz/pages/phone/starting/loging/codes/confirm_code.dart';
import 'package:kz/pages/phone/starting/loging/login_page.dart';
import 'package:kz/pages/phone/starting/loging/register_page.dart';
import 'package:kz/pages/phone/home.dart';
import 'package:kz/pages/phone/user/creation/auto/auto.dart';
import 'package:kz/pages/phone/user/creation/auto/crt_auto.dart';
import 'package:kz/pages/phone/user/creation/market/market.dart';
import 'package:kz/pages/phone/user/creation/property/crt_property.dart';
import 'package:kz/pages/phone/user/feed/market/widget/edit/edit_photo.dart';
import 'package:kz/pages/phone/user/feed/market/widget/edit/edit_screen.dart';
import 'package:kz/pages/phone/user/feed/market/widget/following/screen.dart';
import 'package:kz/pages/phone/user/feed/market/widget/widget_screen_market.dart';
import 'package:kz/pages/phone/user/feed/property/widget/screen_property.dart';
import 'package:kz/pages/phone/user/feed/transport/widget/screen_auto.dart';
import 'package:kz/pages/phone/user/profile/active_applications/active_list_applications.dart';
import 'package:kz/pages/phone/user/profile/archive/archive_list.dart';
import 'package:kz/pages/phone/user/profile/archive/widgets/screen.dart';
import 'package:kz/pages/phone/user/profile/cash/cash_profile.dart';
import 'package:kz/pages/phone/user/profile/edit_profile/edit_lang/edits_lang.dart';
import 'package:kz/pages/phone/user/profile/edit_profile/edit_profile.dart';
import 'package:kz/pages/phone/user/profile/profile.dart';
import 'package:kz/pages/phone/user/profile/settings/settings.dart';
import 'package:kz/pages/phone/user/profile/user_screen.dart';
import 'package:kz/splash.dart';
import 'package:kz/tools/routes/custom_routes.dart';
import 'package:kz/tools/widgets/custom/container/success/success_update_name.dart';
import 'package:kz/tools/widgets/custom/container/success/success_upload_photo.dart';
import 'package:kz/tools/widgets/custom/container/success/success_upload_photo_and_name.dart';
import 'package:kz/tools/widgets/supporting/plug_screen.dart';

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
        return CustomRoute<bool>(builder: (BuildContext context) => HomePage());
      case "SettingsPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => SettingsPage());
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
      case "WidgetProperty":
        String uidMarket = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => WidgetContainerProperty(
                  uidProperty: uidMarket,
                ));
      case "WidgetAuto":
        String uidMarket = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => WidgetContainerAuto(
                  uidAuto: uidMarket,
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
      case "ListFollowingMarket":
        String uidApp = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => ListFollowingMarket(
                  uidApp: uidApp,
                ));

      case "EditPhoto":
        String uidApp = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => EditPhoto(
                  uid: uidApp,
                ));

      case "CashProfile":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => CashProfile());
      case "CreationMarket":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => MarketMaster());
      case "CreationProperty":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => CRTProperty());
      case "CreationAuto":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => AutoMaster());
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
      case "PlugScreen":
        return CustomRoute<bool>(
            builder: (BuildContext context) => PlugScreen());

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
