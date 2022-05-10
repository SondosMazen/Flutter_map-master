import 'package:flutter/material.dart';

import '../utlies/app_colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String BtnText;
  final double circularBorderRadius;

  CustomAlertDialog({
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.BtnText,

  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title, style: TextStyle(color: AppColors.MAIN_COLOR),) : null,
      content: message != null ? Text(message) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
         FlatButton(
          child: Text(BtnText),
          textColor: AppColors.MAIN_COLOR,
          onPressed: () {
            Navigator.pop(context);
            }
        ),
      ],
    );
  }
}