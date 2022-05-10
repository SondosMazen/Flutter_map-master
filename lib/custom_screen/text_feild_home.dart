import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utlies/app_colors.dart';

class HomeTextField extends StatelessWidget {
  final String hintTextKey;
   Function saveFunction;
   Function  validateFunction;
  final int nofLines;
  final TextInputType textInputType;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController textEditingController;


  HomeTextField(
      {required this.hintTextKey,
       required this.saveFunction,
       required this.validateFunction,
      this.nofLines = 1,
      this.textInputType = TextInputType.text,
        required this.floatingLabelBehavior,
        required this.textEditingController
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 2,bottom: 2),
      child: TextFormField(
        cursorColor: AppColors.MAIN_COLOR,
        controller: textEditingController,
        maxLines: nofLines,
        // onFieldSubmitted: (value) {
        //   FocusScope.of(context).nextFocus();
        // },
        validator: (v) {
          return validateFunction();
        },
        textInputAction: TextInputAction.next,
        keyboardType: textInputType,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: "ExpoArabic",
            fontSize: 11.0,),
          floatingLabelBehavior: floatingLabelBehavior,
          // helperText: '',
          //alignLabelWithHint: true,
          labelText: hintTextKey,
          labelStyle: TextStyle(
            fontSize: 15,
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


