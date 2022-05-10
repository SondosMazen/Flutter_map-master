import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../pref/user_preferences.dart';

class AuthHelper {
  AuthHelper._();

  static AuthHelper authHelper = AuthHelper._();

  Future<bool> login(String username, String password) async {
    // call dio
    // String url = 'https://salma.sirius-it.dev/api/sanctum/token';
    // Response response = await dio.post(url, data: {
    //   'username': username,
    //   'password': password,
    // });

    // fake response
    var response;
    switch (username) {
      case "sondos":
        response = {
          "code": 200,
          "message": "login success",
          "data": {
            "token": "asdfghjkl;'",
            "id": 1,
            "name": "sondos",
            "termsOfReference": [
              "اختر",
                "إدارة الحسابات",
                "الإشراف"
            ],
            "screen": [
              "الرئيسية",
                "إدارة الحسابات",
                "إدارة الفواتير",
                "الإشراف"
            ]
          }
        };
        break;
      case "nour":
        response = {
          "code": 200,
          "message": "login success",
          "data": {
            "token": "asdfghjkl;'",
            "id": 2,
            "name": "nour",
            "termsOfReference": [
              "اختر",
                "فاتورة المية"
            ],
            "screen": [
              "الرئيسية",
              "فاتورة المياه",
              "فاتورة الكهرباء"
            ]
          }
        };
        break;
      default:
        response = {"code": 300, "message": "login faild", "data": null};
    }

    Map<String, dynamic> json = response;
    // Map<String, dynamic> json = response2;
    // Map<String, dynamic> json = response3;
    if (json['code'] != 200) {
      return false;
    }

    User user = User.fromJson(json['data']);
    UserPreferences.instance.save(user);
    UserPreferences.instance.setLogin();
    return true;
  }
}
