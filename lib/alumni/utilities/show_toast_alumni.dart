import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/utilities/colors.dart';

/// This class is used to display a toast message on the screen
///
/// The [toastLength], [textColor], [backgroundColor], and [gravity] can be
/// customized to custom values or allowed to use the default values
class ShowToastAlumni {
  static showToastMessage(
      {required String toastMessage,
      Color? textColor,
      Color? bgColor,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: textColor ?? kBlackColor,
      backgroundColor: bgColor ?? Colors.white70,
      gravity: gravity ?? ToastGravity.BOTTOM,
    );
  }
}
