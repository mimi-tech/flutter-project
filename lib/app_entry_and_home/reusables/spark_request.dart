import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class SparksRequestButton extends StatelessWidget {
  final String buttonName;
  final Function requestTypeSent;
  final double fontSize;

  SparksRequestButton({
    required this.buttonName,
    required this.requestTypeSent,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: requestTypeSent as void Function()?,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: kLight_orange,
          width: 1.0,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        child: Center(
          child: Text(
            buttonName,
            style: Theme.of(context).textTheme.headline6!.apply(
                  fontSizeFactor: 0.5,
                  fontSizeDelta: fontSize,
                  color: kLight_orange,
                ),
          ),
        ),
      ),
    );
  }
}
