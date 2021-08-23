import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class SmallerFAB extends StatelessWidget {
  final String? heroTag;
  final String imageName;
  final Function smallFabOnPressed;

  SmallerFAB({
    required this.heroTag,
    required this.imageName,
    required this.smallFabOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      shape: CircleBorder(
          side: BorderSide(
            color: kWhiteColour,
          )),
      mini: true,
      backgroundColor: kProfile,
      onPressed: smallFabOnPressed as void Function()?,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.06,
        height: MediaQuery.of(context).size.height * 0.04,
        child: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            imageName,
            width: MediaQuery.of(context).size.width * 0.05,
            height:
            MediaQuery.of(context).size.height * 0.025,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
