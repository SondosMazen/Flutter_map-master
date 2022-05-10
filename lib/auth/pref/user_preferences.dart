import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';


class UserPreferences {

  static UserPreferences? _instance = UserPreferences._();
  static SharedPreferences? _pref;
  static User _user = new User(token: "adf",termsOfReference: [], screenPermissions: []);

  static UserPreferences get instance {
    // if (_instance != null) {
    //   print("INITIALIZED");
    //   return _instance!;
    // }
    // print("NOT INITIALIZED");
    // _instance = UserPreferences._();
    return _instance!;
  }

  UserPreferences._() {
    initialize();
  }

  void initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  // SharedPreferences getSharedPreferences() {
  //   return _pref!;
  // }

  void setLogin() {
    _pref!.setBool(isLoggedInKey, true);
  }

  User? getUser() {
    return _user;
  }

  Future save(User user) async {
    update(user);
    await _pref!.setString(tokenKey, user.token);
  }
  Future update(User user) async {
    _user = user;
    await _pref!.setBool(isLoggedInKey, true);
  }
  Future logout() async {
   // clear();
    return await _pref!.setBool(isLoggedInKey, false);
  }

  bool isLoggedIn() {
    return _pref!.getBool(isLoggedInKey) ?? false;
  }
  String getToken() {
    return _pref!.getString(tokenKey) ?? "ttttt";
  }
  Future<bool> clear() async {
    return await _pref!.clear();
  }

  static final String isLoggedInKey = "isLoggedIn";
  static final String tokenKey = "sondosToken";
}
