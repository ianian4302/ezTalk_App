import 'package:flutter/material.dart';

// this class is store the information of our design
// use this class to define all the details of our design
// for example, the color of the button, the color of the text, border radius, etc.
class Design {
  static const Color primaryColor = Color.fromRGBO(43, 233, 177, 1);
  static const Color secondaryColor = Color.fromRGBO(123, 127, 241,1);
  static const Color backgroundColor = Color.fromRGBO(243, 254, 250, 1);
  static const Color accentColor = Color.fromRGBO(165, 87, 237, 1);
  static const Color insideColor = Color(0xFFEFEFEF);

  static const Color primaryTextColor = Colors.black;
  static const Color secondaryTextColor = Color.fromARGB(137, 11, 11, 11);

  static const Color generalTagColor = Color.fromARGB(255, 191, 166, 175);
  static const Color systemTagColor = Color.fromARGB(255, 240, 235, 116);

  static const spacing = EdgeInsets.all(10.0);
  static const outsideBorderRadius = BorderRadius.all(Radius.circular(20.0));
  static const insideBorderRadius = BorderRadius.all(Radius.circular(10.0));

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}