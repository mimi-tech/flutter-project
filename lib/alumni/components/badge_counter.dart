import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sparks/alumni/color/colors.dart';

class BadgeCounter extends StatelessWidget {
  BadgeCounter({required this.iconData, required this.batchText});

  final IconData iconData;
  final String batchText;

  @override
  Widget build(BuildContext context) {
    return Badge(
      child: Icon(
        iconData,
        color: kAWhite,
      ),
      badgeContent: Text(
        batchText,
        style: TextStyle(color: kAWhite, fontSize: 10.0),
      ),
      badgeColor: kADeepOrange,
      animationType: BadgeAnimationType.scale,
      animationDuration: Duration(seconds: 1),
      position: BadgePosition.bottomStart(bottom: -5.0, start: -6.0),
    );
  }
}
