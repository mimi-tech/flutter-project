import 'package:flutter/material.dart';
import 'package:sparks/market/utilities/market_const.dart';

class CustomErrorTextWidget extends StatelessWidget {
  const CustomErrorTextWidget({
    Key? key,
    required this.visible,
    required this.text,
  }) : super(key: key);

  final bool visible;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Text(
        text,
        style: kMCustomErrorMessageTextStyle,
      ),
    );
  }
}
