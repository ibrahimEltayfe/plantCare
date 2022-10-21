import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, Color color,String fontFamily,FontWeight fontWeight){
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color
  );
}

TextStyle getRegularTextStyle({
         double fontSize = 15,
         Color color = Colors.black,
         String fontFamily = 'dubai',
         FontWeight fontWeight = FontWeight.bold
}) {
  return _getTextStyle(fontSize,color,fontFamily,fontWeight);
}


