import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bloodlines/Components/autoSizeText.dart';

import 'Color.dart';

poppinsRegular(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w100,
      fontFamily: 'Poppins-Medium',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

poppinsBold(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    fontStyle,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      fontStyle: fontStyle ?? FontStyle.normal,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontFamily: 'Poppins-Bold',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

poppinsSemiBold(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    fontStyle,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      fontStyle: fontStyle ?? FontStyle.normal,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontFamily: 'Poppins-SemiBold',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

poppinsLight(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    bool shadow = false,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontFamily: 'Poppins-Light',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

montserratRegular(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w100,
      fontFamily: 'Montserrat-Medium',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

montserratBold(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    fontStyle,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      fontStyle: fontStyle ?? FontStyle.normal,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontFamily: 'Montserrat-Bold',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

montserratExtraBold(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    fontStyle,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      fontStyle: fontStyle ?? FontStyle.normal,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontFamily: 'Montserrat-ExtraBold',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

montserratSemiBold(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    fontStyle,
    textDecoration,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      decoration: textDecoration,
      fontStyle: fontStyle ?? FontStyle.normal,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontFamily: 'Montserrat-SemiBold',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

montserratLight(
    {double? fontSize,
    color,
    fontWeight,
    double? latterSpacing,
    bool shadow = false,
    TextOverflow? textOverflow}) {
  return TextStyle(
      fontSize: fontSize ?? 18,
      color: color ?? DynamicColors.textColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontFamily: 'Montserrat-Light',
      letterSpacing: latterSpacing ?? 0,
      overflow: textOverflow);
}

autoSizeTextWidget(
    {String? text, double? fontSize, double? maxFontSize, otherStyling}) {
  return AutoSizeText(
    text!,
    minFontSize: fontSize ?? 25,
    maxFontSize: maxFontSize ?? 15,
    style: otherStyling ?? poppinsRegular(),
  );
}

String testImage =
    'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg';
String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}

String getNames(data) {
  return "${data.firstName} ${data.lastName}".capitalizeFirst!;
}
