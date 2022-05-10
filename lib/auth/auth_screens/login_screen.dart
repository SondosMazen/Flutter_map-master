import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/live_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../custom_screen/app_stack_textfeild.dart';
import '../../custom_screen/custom_alertDialog.dart';
import '../../custom_screen/primary_button.dart';
import '../../pages/home.dart';
import '../../utlies/app_colors.dart';
import '../provider/Auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  bool _obscureText = true;
  final LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  @override
  void initState() {
    // TODO: implement initState
    _getCurrentPosition();
    super.initState();
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return  ;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
       /// ///
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );
        /// ///
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }
  void _updatePositionDefault() {
    LatLng(20.5937, 78.9629);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "تسجيل الدخول",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, x) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
            ),
            color: Colors.white,
            child: Form(
              key: loginFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 240,
                      child: Image.asset('assets/images/app_icon.png'),
                    ),
                    AppStackHome(
                      isHidden: false,
                      textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        controller: provider.userNameController,
                        hintText: "اسم المستخدم",
                        icon: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.account_circle),
                          color: Colors.white,
                        ),
                        color: AppColors.MAIN_COLOR,
                        validateFunction: () {
                          var result = provider.validateUserNameFunction();
                          if (result is String) {
                            return result;
                          }
                        },
                        saveFunction: () {}),
                    SizedBox(height: 20,),
                    AppStackHome(
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.visiblePassword,
                      isHidden: _obscureText,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      controller: provider.passwordController,
                      hintText: "كلمة المرور",
                      icon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        color: Colors.white,
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      color: AppColors.MAIN_COLOR,
                      validateFunction: () {
                        var result = provider.validatepasswordFunction();
                        if (result is String) {
                          // show error message
                          return result;
                        }
                      },
                      saveFunction: () {},
                    ),
                    SizedBox(height: 40,),

                    PrimaryButton(
                      textKey: "تسجيل دخول",
                      buttonPressFun: () async {
                        if (loginFormKey.currentState!.validate()) {
                          bool result = await provider.login();
                          if (result) {
                            Navigator.pushReplacementNamed(
                                context, LiveLocationPage.routeName);
                          } else {
                            // user data error
                            var dialog = CustomAlertDialog(
                                title: "تسجيل الدخول",
                                message: "هناك خطأ في اسم المستخدم أو كلمة المرور",
                                BtnText: 'إنهاء',
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => dialog);
                       //     print("error api");
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
