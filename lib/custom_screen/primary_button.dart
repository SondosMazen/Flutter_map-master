import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utlies/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Function buttonPressFun;
  final String textKey;
  final Color color;

  PrimaryButton(
      {
        required this.buttonPressFun,
      required this.textKey,
      this.color = AppColors.MAIN_COLOR
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 200,
      child: RaisedButton(
          color: this.color,
          child: Text(
            textKey,
            style: TextStyle(color: Colors.white),
            maxLines: 1,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () => buttonPressFun()),
    );
  }
}
