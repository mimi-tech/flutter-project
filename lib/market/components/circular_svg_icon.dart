import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSvgIcon extends StatefulWidget {
  final Function onTap;
  final double width;
  final double height;
  final String svg;
  final double? svgWidth;
  final double? svgHeight;
  final List<Color>? linearColor;
  final String label;
  final TextStyle textStyle;

  CircularSvgIcon(
      {required this.onTap,
      required this.width,
      required this.height,
      required this.svg,
      required this.label,
      required this.textStyle,
      this.svgWidth,
      this.svgHeight,
      this.linearColor});

  @override
  _CircularSvgIconState createState() => _CircularSvgIconState();
}

class _CircularSvgIconState extends State<CircularSvgIcon>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  late Animation animation;

  void _animate() {
    _controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    _scale = 1 - animation.value as double;
    return GestureDetector(
      onTap: () {
        _animate();
        widget.onTap();
      },
      child: Transform.scale(
        scale: _scale,
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:
                          widget.linearColor ?? [Colors.white, Colors.white])),
              child: SvgPicture.asset(
                widget.svg,
                width: widget.svgWidth,
                height: widget.svgHeight,
              ),
            ),
            Positioned(
              top: 60.0,
              child: Text(
                widget.label,
                style: widget.textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
