import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToastMarket {
  static showToastMessage(
      {required String toastMessage,
      Color? textColor,
      Color? bgColor,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      textColor: textColor ?? Colors.black,
      backgroundColor: bgColor ?? Colors.white70,
      gravity: gravity ?? ToastGravity.BOTTOM,
    );
  }
}
