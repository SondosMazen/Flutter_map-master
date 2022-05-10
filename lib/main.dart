import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/home_page.dart';
import 'package:flutter_map_example/pages/home_screen.dart';
import 'package:flutter_map_example/pages/launch_screen.dart';
import 'package:flutter_map_example/pages/live_location.dart';
import 'package:flutter_map_example/route_helper/route_helper.dart';
import 'package:flutter_map_example/utlies/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'auth/auth_screens/login_screen.dart';
import 'auth/pref/user_preferences.dart';
import 'auth/provider/Auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await UserPreferences.instance;
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: Locale('ar'),
      startLocale: Locale('ar'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
        providers: [
        ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
    ),
    ],
    child: MaterialApp(
    theme: ThemeData(
    backgroundColor: AppColors.MAIN_COLOR,
    textTheme: const TextTheme(
    button: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    //color: AppColors.MAIN_COLOR,
    fontFamily: "Segoe UI"),
    ),
    ),
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    navigatorKey: RouteHelper.routeHelper.navKey,
    debugShowCheckedModeBanner: false,
    builder: (context, widget) => ResponsiveWrapper.builder(
    BouncingScrollWrapper.builder(context, widget!),
    maxWidth: 1200,
    minWidth: 400,
    defaultScale: true,
    breakpoints: [
    ResponsiveBreakpoint.resize(400, name: MOBILE),
    ResponsiveBreakpoint.autoScale(800, name: TABLET),
    ResponsiveBreakpoint.resize(1000, name: DESKTOP),
    ],
    ),
      home: LaunchScreen(),
      routes: <String, WidgetBuilder>{
        LiveLocationPage.routeName: (context) => LiveLocationPage(),
        HomePage.routeName: (context) => HomePage(),
        LaunchScreen.routeName: (context) => LaunchScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen()
      },
    ),
    );
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = MaterialColor(
  _bluePrimary,
  <int, Color>{
    50: Color(0xFFE7EBFE),
    100: Color(0xFFC4CEFE),
    200: Color(0xFF9CADFD),
    300: Color(0xFF748CFC),
    400: Color(0xFF5773FB),
    500: Color(_bluePrimary),
    600: Color(0xFF3352F9),
    700: Color(0xFF2C48F9),
    800: Color(0xFF243FF8),
    900: Color(0xFF172EF6),
  },
);
