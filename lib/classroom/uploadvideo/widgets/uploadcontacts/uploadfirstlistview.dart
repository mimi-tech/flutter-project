import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/golive/alumni/title.dart';
import 'package:sparks/classroom/golive/classmate/title.dart';
import 'package:sparks/classroom/golive/mentees/titles.dart';
import 'package:sparks/classroom/golive/tutees/titles.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/subtitles_listview.dart';
import 'package:sparks/classroom/uploadvideo/contactscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/contactcount.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadcontacts/contactlist.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';


class UploadFirstListViewtitles{
  static List<Widget> titles = [
    Container(
        child:SubTitle(title: kListviewContact,)
    ),
    Container(
        child: SubTitle(title: kListviewMentees)
    ),
    Container(
        child: SubTitle(title: kListviewTutees)
    ),
    Container(
        child: SubTitle(title: kListviewClassmate)
    ),
    Container(
        child: SubTitle(title: kListviewAlumin)
    ),
  ];

}
class  UploadListViewtitles{
  static List<Widget> subtitles = [
    Container(
        child: UploadContactCount()
    ),
    Container(
        child: ListTitlesMentees()
    ),
    Container(
        child: ListTitlesTutees()
    ),
    Container(
        child: ListTitlesClassMate()
    ),
    Container(
        child:  ListTitlesAlumni()
    ),
  ];

}

class UploadFirstListView{

  static final title = [kListviewContact, kListviewMentees, kListviewTutees, kListviewClassmate,
    kListviewAlumin];

  static final icons = [ GestureDetector(
    child: CircleAvatar(
        backgroundColor: kBlackcolor,
        child: SvgPicture.asset('images/classroom/contactnew.svg',
          color: kFloatbtn,
        )
    ),
  ),
    GestureDetector(
      child: CircleAvatar(
          backgroundColor: kBlackcolor,
          child: SvgPicture.asset('images/classroom/mentees.svg',
            color: kFloatbtn,
          )
      ),
    ),

    GestureDetector(
      child: CircleAvatar(
          backgroundColor: kBlackcolor,
          child: SvgPicture.asset('images/classroom/tutees.svg',
            color: kFloatbtn,
          )
      ),
    ),
    GestureDetector(
      child: CircleAvatar(
          backgroundColor: kBlackcolor,
          child: SvgPicture.asset('images/classroom/classmates.svg',
            color: kFloatbtn,
          )
      ),
    ),
    GestureDetector(
      child: CircleAvatar(
          backgroundColor: kBlackcolor,
          child: SvgPicture.asset('images/classroom/Alumni.svg',
            color: kFloatbtn,
          )
      ),
    ),

  ];
}

