import 'package:flutter/material.dart';
import 'package:portfolio/resources/enum.dart';

class CommonWidget {
  static double fontSize = 25;
  CommonWidget._();
  static Widget textWidget(Color textcolor, String text, PageSelection page, [Function()? func = null]) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
            fontSize: fontSize,
          ),
        ),
      ),
      onTap: func,
    );
  }

  static Widget linkTextWidget(String text, [Function()? func]) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
      onTap: func,
    );
  }

  static Widget get divider => Transform.scale(
        scale: 1.5,
        child: Text(
          "|",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      );
}
