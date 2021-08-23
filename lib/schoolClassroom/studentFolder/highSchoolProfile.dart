import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/StudentprofileList.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentsPostProfile2.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/utils/notAStudents.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/textConstants.dart';

class HighSchoolStudentProfile extends StatefulWidget {

  @override
  _HighSchoolStudentProfileState createState() => _HighSchoolStudentProfileState();
}

class _HighSchoolStudentProfileState extends State<HighSchoolStudentProfile> {
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
                          imageUrl: SchClassConstant.schDoc['logo'],
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
                          Text('${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                           overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: GoogleFonts.rajdhani(
                              fontSize:kFontsize.sp,
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                            ),
                          ),

                          Text('${SchClassConstant.schDoc['str']}, ${SchClassConstant.schDoc['cty']}',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontSize14.sp,
                              fontWeight: FontWeight.bold,
                              color: kIconColor,
                            ),
                          ),


                          Text(DateFormat('yyyy-MM-dd hh:mm:a').format(DateTime.parse(SchClassConstant.schDoc['ts'])),
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
                Text('${SchClassConstant.schDoc['sN']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),

                TextConstants(text1: 'Username',),
                Text('${SchClassConstant.schDoc['un']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),

                TextConstants(text1: 'Pin',),
                Text('${SchClassConstant.schDoc['pin']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),
                TextConstants(text1: 'Class',),
                Text('${SchClassConstant.schDoc['cl']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),

                TextConstants(text1: 'Level',),
                Text('${SchClassConstant.schDoc['lv']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),



                space(),
                space(),

                Text('${SchClassConstant.schDoc['fn']} \'s classmates'.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    decoration: TextDecoration.underline,
                    fontSize:kFontsize.sp,
                    fontWeight: FontWeight.bold,
                    color: kIconColor,
                  ),
                ),
                space(),
                SizedBox(
                  height: 60,

                  child: ListView.builder(
                      itemCount: workingDocuments.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) {

                        return  GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration:BoxDecoration(
                              color:KLightermaincolor,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment:Alignment.topRight,
                                      child: Icon(Icons.circle,color: workingDocuments[index]['ass'] == true?kAGreen:kRed,size: 15,)),

                                  Text('${workingDocuments[index]['fn']}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                    ),
                                  ),

                                  Text('${workingDocuments[index]['ln']}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kIconColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),

                space(),
                space(),

                Text('${SchClassConstant.schDoc['fn']} \'s teachers'.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    decoration: TextDecoration.underline,
                    fontSize:kFontsize.sp,
                    fontWeight: FontWeight.bold,
                    color: kIconColor,
                  ),
                ),
                space(),
                SizedBox(
                  height: 60,

                  child: ListView.builder(
                      itemCount: teachersList.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) {

                        return  GestureDetector(

                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration:BoxDecoration(
                              color:kStabcolor,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment:Alignment.topRight,
                                      child: Icon(Icons.circle,color: teachersList[index]['ass'] == true?kAGreen:kRed,size: 15,)),

                                  Text('${teachersList[index]['tc']}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                    ),
                                  ),

                                  Text('${teachersList[index]['curs']}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontSize14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: kMaincolor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),

              ],
            ),

          ),
        ]))])));
  }



  Future<void> getStudent() async {

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
  }

  void getTeachers() {

    FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers')
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
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
