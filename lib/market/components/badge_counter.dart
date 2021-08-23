import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:sparks/market/utilities/market_const.dart';

class BadgeCounter extends StatelessWidget {
  final String? badgeText;
  final IconData? iconData;
  final Color? color;
  final BadgePosition? position;
  final Function? onTap;
  final bool showBadge;

  BadgeCounter(
      {this.badgeText,
      this.iconData,
      this.color,
      this.position,
      this.onTap,
      this.showBadge = true});

  // This class handles the badges displayed on the shopping cart and the notification
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Badge(
        badgeContent: Text(
          badgeText!,
          style: kBadgeTextStyle,
        ),
        badgeColor: color ?? kNotificationBadgeColour,
        position:
            position ?? BadgePosition.bottomStart(bottom: 12.0, start: -6.0),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
        showBadge: showBadge,
      ),
    );
  }
}
