import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utlies/app_colors.dart';

class MyTextField extends StatelessWidget {
  final String hintTextKey;
   Function saveFunction;
   Function  validateFunction;
  final int nofLines;
  final TextInputType textInputType;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  bool isHidden;

  MyTextField(
      {required this.hintTextKey,
       required this.saveFunction,
       required this.validateFunction,
      this.nofLines = 1,
      this.textInputType = TextInputType.text,
        required this.floatingLabelBehavior,
        required this.textEditingController,
        required this.textInputAction,
        this.isHidden = false,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 50,
      margin: EdgeInsets.only(top: 2,bottom: 2),
      child: TextFormField(
        obscureText: isHidden,
        cursorColor: AppColors.MAIN_COLOR,
        textInputAction: textInputAction,
        controller: textEditingController,
        maxLines: nofLines,

        validator: (v) {
          return validateFunction();
        },
        keyboardType: textInputType,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: AppColors.MAIN_COLOR,
            fontWeight: FontWeight.w300,
            fontFamily: "ExpoArabic",
            fontSize: 11.0,),
          floatingLabelBehavior: floatingLabelBehavior,
          // helperText: '',
          //alignLabelWithHint: true,
          labelText: hintTextKey,
          labelStyle: TextStyle(
            fontSize: 15,
            color: AppColors.MAIN_COLOR,
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.MAIN_COLOR, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.MAIN_COLOR, width: 2.0),
            borderRadius: BorderRadius.all(new Radius.circular(50.0)),
          ),
        ),
        onSaved: (newValue) => saveFunction(),
        onChanged: (value) => validateFunction(),
        // onChanged: (value) {},
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
