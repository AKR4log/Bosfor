import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/starting/loging/codes/confirm_code.dart';
import 'package:kz/pages/phone/user/feed/market/widget/widget_screen_market.dart';
import 'package:kz/pages/phone/user/feed/property/widget/screen_property.dart';
import 'package:kz/pages/phone/user/feed/transport/widget/screen_auto.dart';
import 'package:kz/pages/web/auth/loging/codes/confirm_code.dart';
import 'package:kz/pages/web/auth/loging/login_page.dart';
import 'package:kz/pages/web/user/bookmarks/bookmarks.dart';
import 'package:kz/pages/web/user/creation/creation_application.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/pages/web/user/messanger/chat/chats.dart';
import 'package:kz/pages/web/user/messanger/chat/screen_chat.dart';
import 'package:kz/pages/web/user/profile/active_applications/active_list_applications.dart';
import 'package:kz/pages/web/user/profile/archive/archive_list.dart';
import 'package:kz/pages/web/user/profile/edit_profile/edit_profile.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/splash.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/routes/routes.dart';
import 'package:kz/tools/state/app_state.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'akr4log',
  'developer',
  'com.bosfor.kz',
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  runApp(MyHome());
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyHomeState state = context.findAncestorStateOfType<_MyHomeState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Locale _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<CloudFirestore>(create: (_) => CloudFirestore()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
      ],
      child: kIsWeb
          ? MaterialApp(
              theme: ThemeData(fontFamily: "Nunito"),
              supportedLocales: [
                Locale("ru", "RU"),
                Locale("en", "US"),
                Locale("kk", "KK")
              ],
              locale: _locale,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocates) {
                print(locale);
                for (var supportedLocale in supportedLocates) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocates.first;
              },
              debugShowCheckedModeBanner: false,
              initialRoute: SplashPage.routeName,
              routes: {
                SplashPage.routeName: (context) => SplashPage(),
                HomeWebPage.routeName: (context) => HomeWebPage(),
                WebLoginPage.routeName: (context) => WebLoginPage(),
                WebConfirmCode.routeName: (context) => WebConfirmCode(),
                WebEditProfile.routeName: (context) => WebEditProfile(),
                ActiveApplicationsAuthUser.routeName: (context) =>
                    ActiveApplicationsAuthUser(),
                ArchiveList.routeName: (context) => ArchiveList(),
                WidgetContainerMarket.routeName: (context) =>
                    WidgetContainerMarket(),
                WidgetContainerProperty.routeName: (context) =>
                    WidgetContainerProperty(),
                WidgetContainerAuto.routeName: (context) =>
                    WidgetContainerAuto(),
                WebBookmarksPage.routeName: (context) => WebBookmarksPage(),
                WebCreationApplication.routeName: (context) =>
                    WebCreationApplication(),
                WebProfilePage.routeName: (context) => WebProfilePage(),
                ChatTab.routeName: (context) => ChatTab(),
                ChatScreen.routeName: (context) => ChatScreen(),
              },
            )
          : MaterialApp(
              theme: ThemeData(fontFamily: "Nunito"),
              supportedLocales: [
                Locale("ru", "RU"),
                Locale("en", "US"),
                Locale("kk", "KK")
              ],
              locale: _locale,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocates) {
                print(locale);
                for (var supportedLocale in supportedLocates) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                print(supportedLocates.first);
                return supportedLocates.first;
              },
              debugShowCheckedModeBanner: false,
              routes: Routes.route(),
              onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
              initialRoute: "SplashPage",
            ),
    );
  }
}
