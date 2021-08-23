import 'package:flutter/material.dart';

class FormLabelHeader extends StatelessWidget {

  FormLabelHeader({
    required this.labelHeader,
    required this.alignHeader,
    required this.labelHeaderColor,
    required this.onPress,
  });

  final String labelHeader;
  final TextAlign alignHeader;
  final Color labelHeaderColor;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress as void Function()?,
      child: Text(
        labelHeader,
        textAlign: alignHeader,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: labelHeaderColor,
        ),
      ),
    );
  }
}
