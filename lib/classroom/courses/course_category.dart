import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseCategory extends StatefulWidget {
  @override
  _CourseCategoryState createState() => _CourseCategoryState();
}

class _CourseCategoryState extends State<CourseCategory> {
  List<String> items = [
    kSports,
    kEt,
    kSci,
    kFilm,
    kNews,
    kHs,
    kComedy,
    kMusic,
    kAe,
    kGaming,
    kTE,
    kEdu,
    kNa,
    kPb,
    kPA
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              showCate(context, items[index], index);
            },
            leading: SelectedCate.data.contains(items[index])
                ? Icon(
                    Icons.radio_button_checked,
                    color: kbtnsecond,
                  )
                : Icon(Icons.radio_button_unchecked),
            title: Text(items[index],
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: kFontsize.sp,
                  ),
                )),
          );
        });
  }

  void showCate(BuildContext context, String item, int index) {
    setState(() {
      if (SelectedCate.data.contains(item)) {
        setState(() {
          SelectedCate.data.remove(item);
        });
      } else {
        setState(() {
          SelectedCate.data.add(item);
        });
      }
    });
  }
}
