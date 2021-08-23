import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/language.dart';

import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LanguageList extends StatefulWidget {
  @override
  _LanguageListState createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  var selected = [];

  String? filter;
  var items = [];
  //var items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var newList = [
      CourseLanguage1.languages,
      CourseLanguage2.languages,
      CourseLanguage4.languages,
      CourseLanguage5.languages,
      CourseLanguage6.languages,
      CourseLanguage7.languages,
      CourseLanguage8.languages,
      CourseLanguage9.languages,
      CourseLanguage10.languages,
      CourseLanguage11.languages,
      CourseLanguage12.languages,
      CourseLanguage13.languages,
      CourseLanguage14.languages,
      CourseLanguage15.languages,
      CourseLanguage16.languages,
      CourseLanguage17.languages,
      CourseLanguage18.languages,
      CourseLanguage19.languages,
      CourseLanguage20.languages,
      CourseLanguage21.languages,
      CourseLanguage22.languages,
      CourseLanguage23.languages,
      CourseLanguage24.languages,
      CourseLanguage25.languages,
      CourseLanguage26.languages,
      CourseLanguage27.languages,
      CourseLanguage28.languages,
    ].expand((x) => x).toList();

    items.addAll(newList);
    Constants.searchController.addListener(() {
      setState(() {
        Constants.searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return filter == null || filter == ""
                  ? ListTile(
                      onTap: () {
                        showList(context, items[index], index);
                        print(items[index]);
                      },
                      leading: selected.contains(index)
                          ? Icon(
                              Icons.radio_button_checked,
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
                      ))
                  : '${items[index]}'
                          .toLowerCase()
                          .contains(filter!.toLowerCase())
                      ? ListTile(
                          onTap: () {
                            showList(context, items[index], index);
                          },
                          leading: selected.contains(index)
                              ? Icon(
                                  Icons.radio_button_checked,
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
                          ))
                      : Container();
            },
          ),
          RaisedButton(
            onPressed: () {
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
      ),
    );
  }

  void showList(BuildContext context, String language, int index) {
    if (selected.contains(index)) {
      setState(() {
        selected.remove(index);
        SelectedLanguage.data.remove(language);
      });
    } else {
      setState(() {
        selected.add(index);
        SelectedLanguage.data.add(language);
      });
    }
  }
}
