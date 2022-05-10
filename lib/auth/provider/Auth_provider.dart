import 'package:flutter/material.dart';

import '../data/auth_helper.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {}
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  validatepasswordFunction() {
    if (passwordController.text.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    } else if (passwordController.text.length < 6) {
      return 'كلمة المرور يجب أن تكون أكثر من 6 خانات';
    }
    return true;
  }

  validateUserNameFunction() {
    if (userNameController.text.isEmpty) {
      return "الرجاء إدخال اسم المستخدم";
    }
    return true;
  }

  Future<bool> login() async {
    bool result = await AuthHelper.authHelper
        .login(userNameController.text, passwordController.text);
    // print("api called");
    return result;
  }

  clearTextInput() {
    userNameController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
