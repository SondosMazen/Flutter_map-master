import 'package:flutter/material.dart';

import '../utlies/app_colors.dart';

class TitleDrawerCustom extends StatelessWidget {
  String text;
  Icon imageicon;
  Function function;

  TitleDrawerCustom({
    required this.text,
    required this.imageicon,
    required this.function
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> function(),
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
        decoration: BoxDecoration (
          borderRadius: BorderRadius.circular(10),
          color: AppColors.App_Bar_COLOR,
        ),
        child: ListTile(
          // onTap: () {
          //   function();
          // },
          leading:SizedBox(
            height: 26,
            width: 25,
            child:  imageicon,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: AppColors.MAIN_COLOR,
            ),
          ),

        ),
      ),
    );
  }
}