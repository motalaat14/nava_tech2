import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'helpers/constants/MyColors.dart';
import 'helpers/providers/FcmTokenProvider.dart';
import 'layouts/Home/Home.dart';
import 'layouts/auth/splash/Splash.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [Locale('ar', 'EG'), Locale('en', 'US'), Locale('ur', 'UR')],
    path: 'assets/langs',
    fallbackLocale: Locale('ar', 'EG'),
    startLocale: Locale('ar', 'EG'),
  ));}

class MyApp extends StatelessWidget {
  final navigatorKey = new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FcmTokenProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Nava Tech',
        theme: ThemeData(
          primaryColor: MyColors.primary,
          fontFamily: GoogleFonts.almarai().fontFamily,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home:
        Splash(navigatorKey: navigatorKey,),
        // Home(),

        builder: EasyLoading.init(),
      ),
    );
  }
}
