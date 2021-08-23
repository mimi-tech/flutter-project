import 'package:flutter/material.dart';
import 'package:sparks/market/utilities/market_const.dart';

class NewUsedButton extends StatelessWidget {
  final String? buttonText;
  final Color? textColor;
  final Function? onPressed;
  final double? elevation;
  final ShapeBorder? shape;

  NewUsedButton(
      {this.buttonText,
      this.textColor,
      this.onPressed,
      this.elevation,
      this.shape});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(
          minWidth: kNewUsedButtonMinWidth, minHeight: kNewUsedButtonMinHeight),
      fillColor: Color(0xffA60F00),
      elevation: elevation!,
      shape: shape!,
      onPressed: onPressed as void Function()?,
      child: Text(
        buttonText!,
        style: kNewUsedButtonTextStyle.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
