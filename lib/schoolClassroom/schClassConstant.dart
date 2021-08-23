import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SchClassConstant {
  static late DocumentSnapshot schDoc;
  static late DocumentSnapshot studentsLessonDoc;
  static List<dynamic> teachersListItems = <dynamic>[];
  static List<dynamic> studentsActivityItems = <dynamic>[];
  static bool isLesson = true;
  static bool isStudent = false;
  static bool isUniStudent = false;
  static bool isCampusProprietor = false;
  static bool isHighSchProprietor = false;
  static bool isProprietor = false;
  static bool isAdmin = false;

  static bool isTeacher = false;
  static bool isLecturer = false;
  static bool isLiked = false;
  static bool isView = false;
  static bool isDownload = false;
  static bool isDownloadNote = false;
  static int streamCount = 10;
  static List<int> count = <int>[];
  static List<int> countUpload = <int>[];
  static String radioItem = kPublic2;


  static displayToastError({@required title}) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackcolor,
        textColor: kFbColor);
  }

  static displayToastCorrect({@required title}) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackcolor,
        textColor: kAGreen);
  }

  static displayBotToastCorrect({@required title}) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: kBlackcolor,
      titleStyle: GoogleFonts.rajdhani(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: kAGreen,
          fontSize:kFontsize.sp,
        ),
      ),
    );
  }

  static displayBotToastError({@required title}) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: kBlackcolor,
      titleStyle: GoogleFonts.rajdhani(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: kRed,
          fontSize:kFontsize.sp,
        ),
      ),
    );
  }
  searchByStudentName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('campusStudents')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByTutorName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('tutors')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByNonCampusStudentsName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('students')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByNonCampusTutorsName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('schoolTeachers')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchByStudiesName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('schoolLessons')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  searchBySocialName(String searchField) {
    return FirebaseFirestore.instance.collectionGroup('schoolSocials')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase()).orderBy('ts')
        .get();
  }

  static showLevelDialog({@required title, @required context,@required count,}){
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            title: Text(title,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kFbColor,
                  fontSize: kFontsize.sp,
                ),
              ),

            ),
            children: <Widget>[
              Column(
                  children: <Widget>[
                   count
                  ]
              )
            ]
        )
    );

  }

  /*static showRichText({@required title, @required titleText,@required color}){
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title: ',
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: kSlivevcr,
            fontSize: kFontsize.sp,
          ),
        ),
        children: <TextSpan>[
          TextSpan(
            text: titleText,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: kFontsize.sp,
              ),
            ),
          ),

        ],
      ),
    );
  }*/

}

class ShowRichText extends StatelessWidget {
  ShowRichText(
      {required this.title, required this.titleText, required this.color});

  final String title;

  final String titleText;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title: ',
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: kSlivevcr,
            fontSize: kFontSize14.sp,
          ),
        ),
        children: <TextSpan>[
          TextSpan(
            text: titleText,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize:kFontSize14.sp,

              ),
            ),
          ),
        ],
      ),
    );
  }
}



class ShowLevels extends StatelessWidget {
  ShowLevels({required this.click,required this.title, });
  final Function click;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: click as void Function(),
      leading: Icon(Icons.circle,color: kFbColor,),
      title: Text(title,
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize: kFontsize.sp,
          ),
        ),

      ),
    );
  }
}

