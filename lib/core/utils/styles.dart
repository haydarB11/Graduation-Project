import 'package:flutter/material.dart';
import 'package:shamseenfactory/constants.dart';

abstract class Styles {
  static const textStyle18 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Cairo');
  static const textStyle20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo');

  static const textStyle14 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Cairo');
  static const textStyle12 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Cairo');
  static const titleDialog = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
      color: Colors.black45);
  static const textStyle16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Cairo');
  static Color delteIconColor = Colors.red.withOpacity(0.7);
  static Color addIconColor = kActiveIconColor;
  static Color canselAddIconColor = kBlueLightColor;
  static Color editIconColor = Colors.blue.withOpacity(0.7);
  static const styleCanselButton =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Cairo');
  static TextStyle styledeleteButton = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Cairo',
      color: Colors.red.withOpacity(0.7));
}

const TextStyle textStyle = TextStyle();

