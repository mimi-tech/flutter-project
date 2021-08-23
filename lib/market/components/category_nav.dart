import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/market/utilities/market_const.dart';

//This class is responsible for animating the category top nav of the market activity
class CategoryNav extends StatefulWidget {
  final String? iconText;
  final String imageURL;
  final Color shadowColor;
  final double elevation;
  final double? width;
  final Function? onTap;
  final TextStyle? textStyle;

  CategoryNav({
    required this.iconText,
    required this.imageURL,
    this.shadowColor = Colors.black,

    /// This simulates the shadow on the SVG image
    this.elevation = 5.5,
    this.onTap,
    this.width,
    this.textStyle,
  });

  @override
  _CategoryNavState createState() => _CategoryNavState();
}

class _CategoryNavState extends State<CategoryNav>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 105),
      lowerBound: 0.0,
      upperBound: 0.5,
    );
    animation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    _controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - animation.value as double;

    final mediaQuery = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _animate();
        widget.onTap!();
      },
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Material(
                type: MaterialType.circle,
                color: Colors.transparent,
                elevation: widget.elevation,
                shadowColor: widget.shadowColor.withAlpha(87),
                child: SvgPicture.asset(
                  widget.imageURL,
                  width: widget.width,
                ),
              ),
              Positioned(
                top: 60.0,
                child: Text(
                  widget.iconText!,
                  style: widget.textStyle,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
