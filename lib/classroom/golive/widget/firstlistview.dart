import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:sparks/classroom/golive/alumni/title.dart';
import 'package:sparks/classroom/golive/classmate/title.dart';

import 'package:sparks/classroom/golive/mentees/titles.dart';

import 'package:sparks/classroom/golive/mycontacts/title_widgets.dart';
import 'package:sparks/classroom/golive/tutees/titles.dart';

import 'package:sparks/classroom/golive/widget/subtitles_listview.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class FirstListViewtitles{
  static List<Widget> titles = [
    Container(
        child: SubTitle(title: kListviewContact)
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
class ListViewtitles{
  static List<Widget> subtitles = [
    Container(
        child: ListTitles()
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

class FirstListView{

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

