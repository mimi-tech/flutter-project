import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class LabelIconElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  const LabelIconElevatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6.0,
            ),
          ],
          // border: Border(
          //   bottom: BorderSide(style: BorderStyle.solid),
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: kTextStyleFont15Bold.copyWith(
                fontSize: 14.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            SvgPicture.asset(
              'images/alumni/sparks_tv.svg',
              width: 20.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8.0,
            ),
            Icon(
              Icons.east,
              color: kBlackColor,
            ),
          ],
        ),
      ),
    );
  }
}
