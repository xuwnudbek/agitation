import 'dart:async';
import 'dart:convert';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/connection/connection_page.dart';
import 'package:agitation/pages/connection/provider/connection_provider.dart';
import 'package:agitation/pages/home/home.dart';
import 'package:agitation/pages/lock_page/lock_page.dart';
import 'package:agitation/pages/main_page/main_page.dart';
import 'package:agitation/pages/moderation/provider/moderation_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'controller/language/language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

Future init() async {
  // await Hive.openBox("user");
  await Hive.openBox("language");
  await Hive.openBox("db");
  await Hive.openBox("fcmToken");
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        "/Home": (context) => Home(),
        "/Chat": (context) => ChatPage(),
      },
      // builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: <Locale>[
        const Locale('uz', 'UZ'),
        const Locale('ru'),
      ],
      locale: Locale("${Hive.box("db").get("language") ?? "uz"}"),
      translations: Language(),
      // supportedLocales: const [Locale('ru',"RU")],   0--
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Montserrat",
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 14.0, color: HexToColor.blackColor),
        ),
      ),
      
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectionProvider()),
          ChangeNotifierProvider(create: (_) => ModerationProvider()),
        ],
        builder: (context, child) {
          return Consumer<ConnectionProvider>(
            builder: (context, provider, _) {
              return !provider.isConnected
                  ? ConnectionPage()
                  : StreamBuilder<BoxEvent>(
                      stream: Hive.box("db").watch(key: "user"),
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
                    );
            },
          );
        },
      ),
    );
  }
}
