import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ShowReadMoreText extends StatelessWidget {
  ShowReadMoreText({required this.title, required this.titleColor});
  final String title;
  final Color titleColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: ScreenUtil()
              .setHeight(constrainedReadMoreHeight),
        ),
        child: ReadMoreText(title,

          trimLines: 2,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ...',
          trimExpandedText: 'show less',
          style:GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: titleColor,
              fontSize:kFontsize.sp,
            ),
          ),
        ),
      ),
    );

  }
}
