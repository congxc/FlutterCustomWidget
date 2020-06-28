import 'dart:ui';

import 'package:flutter/material.dart';
import '../res/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

///
/// Toast 简单封装
///
class YToast {
  static show({
    @required String msg,
    Toast toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
  }) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: YColors.colorPrimaryDark,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}