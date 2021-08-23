import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentsActivitiesTab.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/StudentprofileList.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/schoolPost/reportStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentsPostProfile2.dart';
import 'package:sparks/schoolClassroom/studentFolder/classmateList.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/teachersList.dart';
import 'package:sparks/schoolClassroom/utils/notAStudents.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/textConstants.dart';

class StudentsPostProfile extends StatefulWidget {
  StudentsPostProfile({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentsPostProfileState createState() => _StudentsPostProfileState();
}

class _StudentsPostProfileState extends State<StudentsPostProfile> {
  bool progress = false;
  var _studentDocuments = <DocumentSnapshot>[];

  List<dynamic> studentsDocuments = <dynamic>[];
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
    getStudentsDetails();
    getStudent();
    getTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return studentsDocuments.length == 0 && progress == false ?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):
    studentsDocuments.length == 0 && progress == true ?NotAStudent():SafeArea(child: Scaffold(
        appBar: StuAppBar(),
        body: CustomScrollView(slivers: <Widget>[
        SchClassConstant.isProprietor?ProprietorActivityAppBar(
          activitiesColor: kStabcolor1,
          classColor: kTextColor,
          newsColor: kTextColor,
          studiesColor: kTextColor,
        ): ActivityAppBer(
      activitiesColor: kStabcolor1,
      classColor: kTextColor,
      newsColor: kTextColor,
    ),
      SchClassConstant.isUniStudent? PostSliverStudentAppBar(
        campusBgColor: Colors.transparent,
        campusColor: klistnmber,
        deptBgColor: Colors.transparent,
        deptColor: klistnmber,
        recordsBgColor: Colors.transparent,
        recordsColor: klistnmber,
        profileBgColor: klistnmber,
        profileColor: kWhitecolor,
      ):PostSliverAppBar(
        campusBgColor: klistnmber,
        campusColor: kWhitecolor,
        deptBgColor: Colors.transparent,
        deptColor: klistnmber,
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
            Center(
              child: CachedNetworkImage(
                  imageUrl: studentsDocuments[0]['logo'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: 200.w,
                    height: 200.h,
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
            space(),
            space(),
            Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('${studentsDocuments[0]['fn']} ${studentsDocuments[0]['ln']}',
                      style: GoogleFonts.rajdhani(
                        fontSize:kFontsize.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlackcolor,
                      ),
                    ),

                    Text('${studentsDocuments[0]['oth']}',
                      style: GoogleFonts.rajdhani(
                        fontSize:kFontsize.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlackcolor,
                      ),
                    ),



                  ],
                ),

                Spacer(),
                IconButton(icon: Icon(Icons.more_vert), onPressed: (){_showReport();})
              ],
            ),

            space(),
            space(),
            TextConstants(text1: 'School',),
            Text('${studentsDocuments[0]['sN']}',
              style: GoogleFonts.rajdhani(
                fontSize: kFontSize14.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.w500,

              ),),

            TextConstants(text1: 'Faculty',),
            Text('${studentsDocuments[0]['fac']}',
              style: GoogleFonts.rajdhani(
                fontSize: kFontSize14.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.w500,

              ),),
            space(),

            TextConstants(text1: 'Department',),
            Text('${studentsDocuments[0]['dept']}',
              style: GoogleFonts.rajdhani(
                fontSize: kFontSize14.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.w500,

              ),),
            space(),

            TextConstants(text1: 'Level',),
            Text('${studentsDocuments[0]['lv']}',
              style: GoogleFonts.rajdhani(
                fontSize: kFontSize14.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.w500,

              ),),
            space(),

            SchClassConstant.schDoc['id'] == studentsDocuments[0]['id']?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConstants(text1: 'Username',),
                Text('${studentsDocuments[0]['un']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
                space(),

                TextConstants(text1: 'Your Pin',),
                Text('${studentsDocuments[0]['pin']}',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontSize14.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,

                  ),),
              ],
            ):Text(''),
            space(),

            TextConstants(text1: 'Sex',),
            Text('${studentsDocuments[0]['sex']}',
              style: GoogleFonts.rajdhani(
                fontSize: kFontSize14.sp,
                color: kBlackcolor,
                fontWeight: FontWeight.w500,

              ),),
            space(),
            space(),

            SchClassConstant.schDoc['id'] == studentsDocuments[0]['id']? BtnSecond(next: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentActivitiesTab(doc:_studentDocuments[0])));

            }, title: 'Your activities', bgColor: Colors.purpleAccent):Text(''),
            space(),
            space(),
            Text('${widget.doc['fn']} \'s classmates'.toUpperCase(),
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
              height: 60,

              child: ListView.builder(
                  itemCount: workingDocuments.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {

                    return  Container(
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
                                child: Icon(Icons.circle,color: workingDocuments[index]['onl'] == true?kAGreen:kRed,size: 15,)),

                            Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}'.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontSize14.sp,
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
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
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            space(),
            space(),

            Text('${widget.doc['fn']} \'s teachers'.toUpperCase(),
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
              height: 75,

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
                                  child: Icon(Icons.circle,color: teachersList[index]['onl'] == true?kAGreen:kRed,size: 15,)),

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
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            space(),
            space(),
            SchClassConstant.isUniStudent?Text('${widget.doc['fn']} \'s Post(s)'.toUpperCase(),
              style: GoogleFonts.rajdhani(
                decoration: TextDecoration.underline,
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: kIconColor,
              ),
            ):Text(''),

           SchClassConstant.isUniStudent? CampusPostScreenSecond():Text('')

          ],
      ),

    ),
        ]))])));
  }

  Future<void> getStudentsDetails() async {

     FirebaseFirestore.instance.collection('uniStudents').doc(widget.doc['schId'])
         .collection('campusStudents').doc(widget.doc['id']).get().then((value) {
       if (value.data()!.length != 0) {

       setState(() {
         _studentDocuments.add(value);
         studentsDocuments.add(value.data());
       });


     }else{
         setState(() {
           progress = true;
         });
       }

         });

  }

  Future<void> getStudent() async {

      FirebaseFirestore.instance.collection('uniStudents').doc(
          SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('dept', isEqualTo: widget.doc['dept'])
          .where('lv', isEqualTo: widget.doc['lv'])
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

      FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
          .where('dept',isEqualTo: widget.doc['dept'])
          .where('lv', isEqualTo: widget.doc['lv'])
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

  void _showReport() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            StudentProfileList(doc:studentsDocuments));
  }
}
