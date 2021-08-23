import 'package:flutter/material.dart';

class CustomPillButton extends StatelessWidget {
  const CustomPillButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.height,
    required this.width,
    this.color,
  }) : super(key: key);

  final Widget child;
  final Function onTap;
  final double height;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
