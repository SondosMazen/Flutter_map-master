import 'package:flutter/material.dart';
import 'package:flutter_map_example/custom_screen/tile_drawer_custom.dart';
import 'package:provider/provider.dart';
import '../auth/auth_screens/login_screen.dart';
import '../auth/model/user_model.dart';
import '../auth/pref/user_preferences.dart';
import '../auth/provider/Auth_provider.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late User myuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myuser = UserPreferences.instance.getUser()!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(builder: (context, provider, x) {
        return Column(children: [
          const DrawerHeader(
            child: Center(
              child: Image(
                image: AssetImage(
                  'assets/images/app_icon.png',
                ),
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
            ),
            decoration: BoxDecoration(
                // color: AppColors.MAIN_COLOR,
                ),
          ),
          const SizedBox(
            height: 15,
          ),
          TitleDrawerCustom(
            function: () {
              UserPreferences.instance.logout();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              provider.clearTextInput();

            },
            text: "تسجيل الخروج",
            imageicon: const Icon(
              Icons.logout,
            ),
          ),
           SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            //MediaQuery.of(context).size.height * 0.55,
            child: SingleChildScrollView(
              child: Column(
                children: myuser.screenPermissions!.map((String item) {
                  return TitleDrawerCustom(
                    function: () {},
                    text: item,
                    imageicon: const Icon(
                      Icons.circle,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
