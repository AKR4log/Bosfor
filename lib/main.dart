import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/routes/routes.dart';
import 'package:kz/tools/state/app_state.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'akr4log',
  'holdpath',
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
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
      child: MaterialApp(
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
