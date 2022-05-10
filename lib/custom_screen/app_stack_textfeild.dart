import 'package:flutter/material.dart';
import 'package:flutter_map_example/custom_screen/text_form_feild_auth.dart';

class AppStackHome extends StatelessWidget {
  final IconButton icon;
  final Color color;
  final String hintText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  bool isHidden;
  final TextInputType textInputType;
  Function saveFunction;
  Function  validateFunction;

  AppStackHome({
    required this.saveFunction,
    required this.validateFunction,
    required this.icon,
    required this.color,
    required this.hintText,
    required this.floatingLabelBehavior,
    required this.controller,
    required this.textInputAction,
    required this.isHidden ,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyTextField(
          isHidden: isHidden,
          textInputAction: textInputAction,
          textInputType: textInputType,
          floatingLabelBehavior: floatingLabelBehavior,
          textEditingController: controller,
          saveFunction: saveFunction,
          validateFunction: validateFunction,
          hintTextKey: hintText,
        ),
        PositionedDirectional(
         end: 0,
          top: 2,
          height:61,
          child: Container(
               // height: 100,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(50),
                  topEnd: Radius.circular(50),
                ),
                color: color,
              ),
              child: icon),
        ),
      ],
    );
  }
}
