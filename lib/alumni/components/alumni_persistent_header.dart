import 'package:flutter/material.dart';
import 'package:sparks/utilities/colors.dart';

class AlumniPersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double maxHeight;
  final bool isCard;
  final Color? cardColor;
  final Color? containerColor;
  final double cardBottomLeftRadius;
  final double cardBottomRightRadius;

  AlumniPersistentHeader(
      {required this.widget,
      this.maxHeight = 56.0,
      this.isCard = false,
      this.cardColor,
      this.containerColor,
      this.cardBottomLeftRadius = 5.0,
      this.cardBottomRightRadius = 5.0});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (isCard) {
      return Container(
        height: kToolbarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor ?? kWhiteColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(cardBottomLeftRadius),
            bottomRight: Radius.circular(cardBottomRightRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: widget,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: containerColor ?? kWhiteColor,
        ),
        width: double.infinity,
        child: widget,
      );
    }
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
