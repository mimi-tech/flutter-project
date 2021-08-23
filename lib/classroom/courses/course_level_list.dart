import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseLevel extends StatefulWidget {
  CourseLevel({
    required this.context,
  });
  final BuildContext context;
  @override
  _CourseLevelState createState() => _CourseLevelState();
}

class _CourseLevelState extends State<CourseLevel> {
  List<String> items = <String>[
    kSCourseLevel1,
    kSCourseLevel2,
    kSCourseLevel3,
    kSCourseLevel4,
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
              showList(context, items[index], index);
            },
            leading: SelectedLevel.data.contains(items[index])
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

  void showList(BuildContext context, String items, int index) {
    if (SelectedLevel.data.contains(items)) {
      setState(() {
        SelectedLevel.data.remove(items);
      });
    } else {
      setState(() {
        SelectedLevel.data.add(items);
      });
    }
    /*setState(() {
      SelectedLevel.data.clear();
      SelectedLevel.data.add(items);
    });*/
  }
}
