import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/teachersActivitiesTab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/schoolTeachersAnalysis.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/StudentprofileList.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentsPostProfile2.dart';
import 'package:sparks/schoolClassroom/studentFolder/classmateList.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/teachersList.dart';
import 'package:sparks/schoolClassroom/utils/analysisText.dart';
import 'package:sparks/schoolClassroom/utils/notAStudents.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/schoolClassroom/utils/textConstants.dart';

class TeachersProfile extends StatefulWidget {

  @override
  _TeachersProfileState createState() => _TeachersProfileState();
}

class _TeachersProfileState extends State<TeachersProfile> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> teachersList = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudent();
    getTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return workingDocuments.length == 0 && progress == false ?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):
    workingDocuments.length == 0 && progress == true ?NotAStudent():SafeArea(child: Scaffold(
        appBar: StuAppBar(),
        body: CustomScrollView(slivers: <Widget>[
          ActivityAppBer(
            activitiesColor: kStabcolor1,
            classColor: kTextColor,
            newsColor: kTextColor,
          ),
          PostSliverAppBar(
            campusBgColor: Colors.transparent,
            campusColor: klistnmber,
            deptBgColor: klistnmber,
            deptColor: kWhitecolor,
            recordsBgColor: Colors.transparent,
            recordsColor: klistnmber,
          ),
          SliverList(
              delegate: SliverChildListDelegate([

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space(),
                      space(),

                      Row(
                        children: [
                          Center(
                            child: CachedNetworkImage(
                                imageUrl: SchClassConstant.teachersListItems[0]['logo'],
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 100.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(

                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>  SvgPicture.asset('images/classroom/user.svg')
                            ),
                          ),
                          SizedBox(width: 5,),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text('${SchClassConstant.teachersListItems[0]['tc']}',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 1,
                                  style: GoogleFonts.rajdhani(
                                    fontSize:kFontsize.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kBlackcolor,
                                  ),
                                ),

                                Text('${SchClassConstant.teachersListItems[0]['str']}, ${SchClassConstant.teachersListItems[0]['cty']}',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 1,
                                  style: GoogleFonts.rajdhani(
                                    fontSize: kFontSize14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kIconColor,
                                  ),
                                ),


                                Text(DateFormat('yyyy-MM-dd hh:mm:a').format(DateTime.parse(SchClassConstant.teachersListItems[0]['ts'])),
                                  style: GoogleFonts.rajdhani(
                                    fontSize: kFontSize14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kIconColor,
                                  ),
                                ),


                              ],
                            ),
                          ),

                        ],
                      ),

                      space(),
                      space(),
                      TextConstants(text1: 'School',),
                      Text('${SchClassConstant.teachersListItems[0]['name']}',
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontSize14.sp,
                          color: kBlackcolor,
                          fontWeight: FontWeight.w500,

                        ),),


                      TextConstants(text1: 'Pin',),
                      Text('${SchClassConstant.teachersListItems[0]['pin']}',
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontSize14.sp,
                          color: kBlackcolor,
                          fontWeight: FontWeight.w500,

                        ),),
                      space(),
                      TextConstants(text1: SchClassConstant.isLecturer?'Department':'Class',),
                      Text('${SchClassConstant.teachersListItems[0]['cl']}',
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontSize14.sp,
                          color: kBlackcolor,
                          fontWeight: FontWeight.w500,

                        ),),
                      space(),

                      TextConstants(text1: 'Level',),
                      Text('${SchClassConstant.teachersListItems[0]['lv']}',
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontSize14.sp,
                          color: kBlackcolor,
                          fontWeight: FontWeight.w500,

                        ),),



                      space(),
                      space(),
                      Divider(),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(SchClassConstant.schDoc['onl']==true?'Online':'Offline',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SchClassConstant.schDoc['onl']==true?kAGreen:kRed,
                                        fontSize: kFontSize14.sp,
                                      ),
                                    )),

                                Text(SchClassConstant.schDoc['onl']==true?'${timeago.format(DateTime.parse(SchClassConstant.schDoc['ol']), locale: 'en_short')} ago':'${timeago.format(DateTime.parse(SchClassConstant.schDoc['off']), locale: 'en_short')} ago',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kIconColor,
                                        fontSize: kFontSize14.sp,
                                      ),
                                    )),

                                Text('online count: ${SchClassConstant.schDoc['olc'].toString()}',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kIconColor,
                                        fontSize: kFontSize14.sp,
                                      ),
                                    )),


                              ],
                            ) ,

                            VerticalDivider(),
                            Column(
                              children: [
                                Text( SchClassConstant.teachersListItems[0]['live']==true?'Live':'Not live',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:  SchClassConstant.teachersListItems[0]['live']==true?kAGreen:kRed,
                                        fontSize: kFontSize14.sp,
                                      ),
                                    )),

                                BtnSecond(next: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersAnalysis(doc:SchClassConstant.schDoc)));

                                }, title: 'See Analysis', bgColor: Colors.orange),


                              ],
                            ) ,
                          ],
                        ),
                      ),
                      Divider(),



                      space(),

                      AnalysisTextSchool(title: kTeachersAnalysis,),
                      space(),

                      AnalysisTableSchool(
                        text1: kEclassCount,
                        text2: SchClassConstant.teachersListItems[0]['lday']==DateTime.now().day && SchClassConstant.teachersListItems[0]['lmth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['lyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['ld'].toString():'0',
                        text3: SchClassConstant.teachersListItems[0]['lwky']==Jiffy().week && SchClassConstant.teachersListItems[0]['lyr'] == DateTime.now().year?SchClassConstant.teachersListItems[0]['lw'].toString():'0',
                        text4: SchClassConstant.teachersListItems[0]['lmth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['lyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['lm'].toString():'0',
                        text5: SchClassConstant.teachersListItems[0]['lyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['ly'].toString():'0',

                        text6: kRecordedCount,
                        text7: SchClassConstant.teachersListItems[0]['uday']==DateTime.now().day && SchClassConstant.teachersListItems[0]['umth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['uyr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['ud'].toString():'0',
                        text8: SchClassConstant.teachersListItems[0]['uwky']==Jiffy().week && SchClassConstant.teachersListItems[0]['uyr'] == DateTime.now().year?SchClassConstant.teachersListItems[0]['uw'].toString():'0',
                        text9: SchClassConstant.teachersListItems[0]['umth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['uyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['um'].toString():'0',
                        text10: SchClassConstant.teachersListItems[0]['uyr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['uy'].toString():'0',

                        text11: kExtraCount,
                        text12: SchClassConstant.teachersListItems[0]['eday']==DateTime.now().day && SchClassConstant.teachersListItems[0]['emth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['eyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['ed'].toString():'0',
                        text13: SchClassConstant.teachersListItems[0]['ewky']==Jiffy().week && SchClassConstant.teachersListItems[0]['eyr'] == DateTime.now().year?SchClassConstant.teachersListItems[0]['ew'].toString():'0',
                        text14: SchClassConstant.teachersListItems[0]['emth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['eyr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['em'].toString():'0',
                        text15: SchClassConstant.teachersListItems[0]['eyr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['ey'].toString():'0',

                        text16: kResultCount,
                        text17: SchClassConstant.teachersListItems[0]['rday']==DateTime.now().day && SchClassConstant.teachersListItems[0]['rmth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['ryr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['rd'].toString():'0',
                        text18:  SchClassConstant.teachersListItems[0]['rwky']==Jiffy().week && SchClassConstant.teachersListItems[0]['ryr'] == DateTime.now().year?SchClassConstant.teachersListItems[0]['rw'].toString():'0',
                        text19: SchClassConstant.teachersListItems[0]['rmth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['ryr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['rm'].toString():'0',
                        text20: SchClassConstant.teachersListItems[0]['ryr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['ry'].toString():'0',

                        text21: kAssessmentCount,
                        text22: SchClassConstant.teachersListItems[0]['aday']==DateTime.now().day && SchClassConstant.teachersListItems[0]['amth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['ayr']==DateTime.now().year ?SchClassConstant.teachersListItems[0]['ad'].toString():'0',
                        text23: SchClassConstant.teachersListItems[0]['awky']==Jiffy().week && SchClassConstant.teachersListItems[0]['ayr'] == DateTime.now().year?SchClassConstant.teachersListItems[0]['aw'].toString():'0',
                        text24: SchClassConstant.teachersListItems[0]['amth']==DateTime.now().month && SchClassConstant.teachersListItems[0]['ayr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['am'].toString():'0',
                        text25: SchClassConstant.teachersListItems[0]['ayr']==DateTime.now().year?SchClassConstant.teachersListItems[0]['ay'].toString():'0',
                      ),
                      space(),



                      Text('${SchClassConstant.schDoc['tc']} \'s students'.toUpperCase(),
                        style: GoogleFonts.rajdhani(
                          decoration: TextDecoration.underline,
                          fontSize:kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          color: kIconColor,
                        ),
                      ),
                      space(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfClassmate()));

                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text('See all'.toUpperCase(),

                            style: GoogleFonts.rajdhani(
                              decoration: TextDecoration.underline,
                              fontSize:kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              color: kAGreen,
                            ),
                          ),
                        ),
                      ),
                      space(),
                      SizedBox(
                        height: 100,

                        child: ListView.builder(
                            itemCount: workingDocuments.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {

                              return GestureDetector(
                                  onTap: (){

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(

                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width * 0.5,

                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(10),
                                          color: kLightmaincolor

                                      ),
                                      child:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [

                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontSize14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: kMaincolor,
                                                    ),
                                                  ),

                                                  Align(
                                                      alignment: Alignment.topRight,
                                                      child: Icon(Icons.circle,color: workingDocuments[index]['onl'] == true?kAGreen:kRed,size: 15))

                                                ],
                                              ),


                                              Text('${workingDocuments[index]['cl']}',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontSize14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: kBlackcolor,
                                                ),
                                              ),

                                              Text('${workingDocuments[index]['lv']}',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontSize14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: kIconColor,
                                                ),
                                              ),

                                              Text('${workingDocuments[index]['ass'] == true?'Access':'Denied'}',
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontSize14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: workingDocuments[index]['ass'] == true?kLightGreen:kRed,
                                                ),
                                              ),

                                            ]),
                                      ),
                                    ),
                                  ));
                            }),
                      ),

                      space(),
                      space(),

                      Text('Teachers'.toUpperCase(),
                        style: GoogleFonts.rajdhani(
                          decoration: TextDecoration.underline,
                          fontSize:kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          color: kIconColor,
                        ),
                      ),
                      space(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfTeachers()));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text('See all'.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              decoration: TextDecoration.underline,
                              fontSize:kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              color: kAGreen,
                            ),
                          ),
                        ),
                      ),
                      space(),
                      SizedBox(
                        height: 100,

                        child: ListView.builder(
                            itemCount: teachersList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {

                              return  Container(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfTeachers()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(

                                          height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width * 0.5,

                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              color: kResendColor

                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,

                                                children: [

                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Text('${teachersList[index]['tc']}',
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: true,
                                                        maxLines: 1,
                                                        style: GoogleFonts.rajdhani(
                                                          fontSize: kFontSize14.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: kMaincolor,
                                                        ),
                                                      ),

                                                      Align(
                                                          alignment: Alignment.topRight,
                                                          child: Icon(Icons.circle,color: teachersList[index]['onl'] == true?kAGreen:kRed,size: 15))

                                                    ],
                                                  ),


                                                  Text('${teachersList[index]['cl']}',
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontSize14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: kBlackcolor,
                                                    ),
                                                  ),

                                                  Text('${teachersList[index]['lv']}',
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontSize14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: kIconColor,
                                                    ),
                                                  ),

                                                  Text('${teachersList[index]['ass'] == true?'Access':'Denied'}',
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontSize14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: teachersList[index]['ass'] == true?kLightGreen:kRed,
                                                    ),
                                                  ),

                                                ]),
                                          ),
                                        ),
                                      )));
                            }),
                      ),

                    ],
                  ),

                ),
              ]))])));
  }



  Future<void> getStudent() async {

    if(SchClassConstant.isLecturer){

      FirebaseFirestore.instance.collection('uniStudents').doc(
          SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
          .where('lv', isEqualTo:SchClassConstant.schDoc['lv'])
          .orderBy('ts', descending: true)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);
              workingDocuments.shuffle();

            });
          }
        } else {
          setState(() {
            progress = true;
          });
        }
      });
    }else{
      print('erteyret');
    FirebaseFirestore.instance.collection('classroomStudents').doc(
        SchClassConstant.schDoc['schId']).collection('students')
        .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv', isEqualTo:SchClassConstant.schDoc['lv'])
        .orderBy('ts', descending: true)
        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length != 0) {
        workingDocuments.clear();
        for (DocumentSnapshot document in documents) {
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);
            workingDocuments.shuffle();

          });
        }
      } else {
        setState(() {
          progress = true;
        });
      }
    });
  }}

  void getTeachers() {
    if(SchClassConstant.isLecturer){
    FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        //.where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
        .orderBy('ts',descending: true)
        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length != 0) {
        teachersList.clear();
        for (DocumentSnapshot document in documents) {
          setState(() {
            teachersList.add(document.data());
            teachersList.shuffle();
          });
        }
      }else{
        setState(() {
          progress = true;
        });
      }
    });


  }else{
      FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers')
          //.where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
          .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
          .orderBy('ts',descending: true)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          teachersList.clear();
          for (DocumentSnapshot document in documents) {
            setState(() {
              teachersList.add(document.data());
              teachersList.shuffle();
            });
          }
        }else{
          setState(() {
            progress = true;
          });
        }
      });
    }

  }


}
