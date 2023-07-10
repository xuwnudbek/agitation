import 'dart:async';
import 'dart:convert';
import 'package:agitation/controller/firebase/firebase_notification.dart';
import 'package:agitation/firebase_options.dart';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/home/home.dart';
import 'package:agitation/pages/lock_page/lock_page.dart';
import 'package:agitation/pages/main_page/main_page.dart';
import 'package:agitation/pages/moderation/moderation_page.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'controller/language/language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotification().onInit();

  runZonedGuarded(() {
    runApp(
      // MultiProvider(
      // providers: [
      //   // ChangeNotifierProvider(create: (_) => CenterProvider())
      // ],
      // child:
      const MyApp(),
      // )
    );
  }, (error, stacktrace) {
    print("__________________________Error: $error");
  });
}

Future init() async {
  // await Hive.openBox("user");
  await Hive.openBox("language");
  await Hive.openBox("db");
  await Hive.openBox("fcmToken");

  // Box box = await Hive.openBox("db");
  // box.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<CenterProvider>().onInit();
    return GetMaterialApp(
      // builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: <Locale>[
        const Locale('uz', 'UZ'),
        const Locale('ru'),
      ],
      locale: const Locale('uz'),
      translations: Language(),
      // supportedLocales: const [Locale('ru',"RU")],   0--
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Montserrat",
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 14.0, color: HexToColor.blackColor),
        ),
      ),
      home: StreamBuilder<BoxEvent>(
        stream: Hive.box("db").watch(),
        builder: (context, snapshot) {
          //if user data is null
          var userHive = Hive.box("db").get("user");
          var userChange = userHive != null ? jsonDecode(snapshot.data?.value ?? userHive) : {};
          var pin = jsonDecode(Hive.box("db").get("phone") ?? "{}")["pin"] ?? false;

          if (pin ?? false) {
            return LockPage(indicator: LockIndicator.ON);
          }

          return userChange["token"] == null ? MainPage() : Home();
        },
      ),
      // home: Home(),
    );
  }
}