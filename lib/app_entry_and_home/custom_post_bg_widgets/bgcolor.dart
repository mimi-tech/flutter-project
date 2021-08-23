import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

//TODO: Reusable custom background colour widget thumbnail.
class BgColor extends StatelessWidget {
  final double dim;
  final Color bgColour;
  final Function bgColourTap;
  final Function endAnimation;

  BgColor({
    required this.dim,
    required this.bgColour,
    required this.bgColourTap,
    required this.endAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: bgColourTap as void Function()?,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: dim,
        height: dim,
        color: bgColour,
        curve: Curves.fastOutSlowIn,
        onEnd: endAnimation as void Function()?,
      ),
    );
  }
}

//TODO: Reusable custom background image widget thumbnail.
class BgImage extends StatelessWidget {
  final double dim;
  final String bgImageUrl;
  final Function bgImageTap;
  final Function endAnimationImg;

  BgImage({
    required this.dim,
    required this.bgImageUrl,
    required this.bgImageTap,
    required this.endAnimationImg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: bgImageTap as void Function()?,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 0),
        width: dim,
        height: dim,
        decoration: BoxDecoration(
          border: Border.all(
            color: kGreyLightShade,
          ),
          image: DecorationImage(
            image: AssetImage(bgImageUrl),
            fit: BoxFit.cover,
          ),
        ),
        curve: Curves.fastOutSlowIn,
        onEnd: endAnimationImg as void Function()?,
      ),
    );
  }
}

//TODO: Reusable custom widget for sparks reactions.
class SparksReactions extends StatelessWidget {
  final double dim;
  final double aDim;
  final String reactionUrl;
  final Color? btnReactionColor;
  final Function bgImageTap;
  final Function endAnimationImg;

  SparksReactions({
    required this.dim,
    required this.aDim,
    required this.reactionUrl,
    this.btnReactionColor,
    required this.bgImageTap,
    required this.endAnimationImg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: bgImageTap as void Function()?,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: aDim,
        height: aDim,
        child: SvgPicture.asset(
          reactionUrl,
          width: dim,
          height: dim,
          color: btnReactionColor,
        ),
        curve: Curves.easeInOutCubic,
        onEnd: endAnimationImg as void Function()?,
      ),
    );
  }
}
