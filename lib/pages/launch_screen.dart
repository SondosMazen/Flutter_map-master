import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/live_location.dart';
import '../auth/auth_screens/login_screen.dart';
import '../auth/pref/user_preferences.dart';
import '../utlies/app_colors.dart';
import 'home_screen.dart';

class LaunchScreen extends StatefulWidget {
  static final routeName = "launchScreen";

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    isLoggedIn();

    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.MAIN_COLOR,
      body: Center(
        child: SizedBox(
            height: 200,
            width: 240,
            child: Image.asset('assets/images/app_icon.png')),
      ),
    );
  }
  void isLoggedIn() async {
    if (UserPreferences.instance.isLoggedIn()) {
      print("user pref data");

      print(UserPreferences.instance.getToken());
      UserPreferences.instance.setLogin();
      Future.delayed(Duration(seconds: 3), () {
        // Navigator.pushReplacementNamed(context, LoginWebViewScreen.routeName);
        Navigator.pushReplacementNamed(context, LiveLocationPage.routeName);
      });
    } else {
      Future.delayed(Duration(seconds: 3), () {
        // Navigator.pushReplacementNamed(context, LoginWebViewScreen.routeName);
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    }
  }
}
