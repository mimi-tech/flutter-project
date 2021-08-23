import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditAdminCourseAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  EditAdminCourseAppBar({required this.title, required this.pix});
  final String? title;
  final String? pix;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackcolor, size: 10.0),
      elevation: 4.0,
      backgroundColor: kWhitecolor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: title,
              style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kbtnsecond,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: " " + 'Course Content',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 32,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: pix!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}
