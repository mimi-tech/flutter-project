import 'package:flutter/material.dart';

class CustomImagePickerBox extends StatelessWidget {
  final Widget? widget;
  final Function? onTap;

  CustomImagePickerBox({this.widget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: widget,
      ),
    );
  }
}
