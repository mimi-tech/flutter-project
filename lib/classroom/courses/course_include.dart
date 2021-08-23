import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseInclude extends StatefulWidget {
  @override
  _CourseIncludeState createState() => _CourseIncludeState();
}

class _CourseIncludeState extends State<CourseInclude> {
  List<String> items = <String>[
    kSCourseIncludeItem1,
    kSCourseIncludeItem2,
    kSCourseIncludeItem3,
    kSCourseIncludeItem4,
    kSCourseNone
  ];
  var selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    showList(context, items[index], index);
                    print(items[index]);
                  },
                  leading: Included.items.contains(items[index])
                      ? Icon(
                          Icons.check_circle_outline,
                          color: kbtnsecond,
                        )
                      : Icon(Icons.radio_button_unchecked),
                  title: Text(
                    items[index],
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kBlackcolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),
                  ));
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            Navigator.pop(context);
          },
          color: kPreviewcolor,
          child: Text(kDone,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kWhitecolor,
                  fontSize: kFontsize.sp,
                ),
              )),
        )
      ],
    );
  }

  showList(BuildContext context, String item, int index) {
    if (selected.contains(index)) {
      setState(() {
        selected.remove(index);
        Included.items.remove(item);
      });
    } else {
      setState(() {
        selected.add(index);
        Included.items.add(item);
      });
    }
  }
}
