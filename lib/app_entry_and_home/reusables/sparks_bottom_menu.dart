import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SparksButtonAppBarMenu extends StatelessWidget {
  final String menuIcon;
  final List<Color> menuItemColor;
  final Function menuPressed;

  SparksButtonAppBarMenu({
    required this.menuIcon,
    required this.menuItemColor,
    required this.menuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bound) {
        return LinearGradient(
          tileMode: TileMode.mirror,
          colors: menuItemColor,
        ).createShader(bound);
      },
      child: IconButton(
        icon: SvgPicture.asset(
          menuIcon,
          width: MediaQuery.of(context).size.width * 0.025,
          height: MediaQuery.of(context).size.height * 0.030,
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
        onPressed: menuPressed as void Function()?,
      ),
    );
  }
}



