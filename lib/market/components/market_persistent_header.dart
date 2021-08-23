import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketPersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final Color color;

  MarketPersistentHeader({required this.widget, required this.color});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
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
      child: Center(child: widget),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
