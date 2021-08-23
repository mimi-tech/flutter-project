import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/schoolProfilePost.dart';
import 'package:sparks/schoolClassroom/studentFolder/classmateList.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/schoolClassroom/studentFolder/teachersList.dart';
import 'package:sparks/schoolClassroom/utils/schoolCountConst.dart';
import 'package:sparks/utilities/colors.dart';

class SchoolProfile extends StatefulWidget {
  @override
  _SchoolProfileState createState() => _SchoolProfileState();
}

class _SchoolProfileState extends State<SchoolProfile> {
  bool progress = false;

  List<dynamic> schoolDocuments = <dynamic>[];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> teachersList = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  int count = 1;
  bool isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSchoolDetails();
    getTeachers();
    getStudent();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: StuAppBar(),
        body: schoolDocuments.length == 0?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Center(
                    child: CachedNetworkImage(
                        imageUrl: schoolDocuments[0]['logo'],
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
                        Text('${schoolDocuments[0]['fn']} ${schoolDocuments[0]['ln']}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: GoogleFonts.rajdhani(
                            fontSize:kFontsize.sp,
                            fontWeight: FontWeight.bold,
                            color: kBlackcolor,
                          ),
                        ),

                        Text('${schoolDocuments[0]['oth']}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: GoogleFonts.rajdhani(
                            fontSize:kFontsize.sp,
                            fontWeight: FontWeight.bold,
                            color: kBlackcolor,
                          ),
                        ),

                        Text('${schoolDocuments[0]['city']}, ${schoolDocuments[0]['cty']}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: GoogleFonts.rajdhani(
                            fontSize: kFontSize14.sp,
                            fontWeight: FontWeight.bold,
                            color: kIconColor,
                          ),
                        ),

                        Text('${schoolDocuments[0]['adr']}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: GoogleFonts.rajdhani(
                            fontSize: kFontSize14.sp,
                            fontWeight: FontWeight.w500,
                            color: kIconColor,
                          ),
                        ),
                        Text('${schoolDocuments[0]['date']}',
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


              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: schoolDocuments[0]['camp'] == true?Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            SchoolCountConst(title: schoolDocuments[0]['spc'].toString(),desc: 'Posts',),
                            VerticalDivider(),
                            SchoolCountConst(title: schoolDocuments[0]['sf'].toString(),desc: 'Faculties',),
                            VerticalDivider(),
                            SchoolCountConst(title: schoolDocuments[0]['sd'].toString(),desc: 'Departments',),

                          ],
                        ),
                      ),
                      space(),

                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            SchoolCountConst(title: schoolDocuments[0]['stc'].toString(),desc: 'Teachers',),
                            VerticalDivider(),
                            SchoolCountConst(title: schoolDocuments[0]['ssc'].toString(),desc: 'Students',),

                          ],
                        ),
                      ),
                    ],
                  ):

                  Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            SchoolCountConst(title: schoolDocuments[0]['spc'].toString(),desc: 'Posts',),
                            VerticalDivider(),
                            SchoolCountConst(title: schoolDocuments[0]['stc'].toString(),desc: 'Teachers',),
                            VerticalDivider(),
                            SchoolCountConst(title: schoolDocuments[0]['ssc'].toString(),desc: 'Students',),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),


              space(),
              space(),






              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kClassMateList2.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        fontSize:kFontsize.sp,
                        fontWeight: FontWeight.bold,
                        color: kExpertColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfTeachers()));
                      },
                      child: Text(kClassMateList4,

                        style: GoogleFonts.rajdhani(
                          decoration: TextDecoration.underline,
                          fontSize:kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          color: kAGreen,
                        ),
                      ),
                    ),
                  ],
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

                      return  GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfClassmate()));

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

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kClassMateList3.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        fontSize:kFontsize.sp,
                        fontWeight: FontWeight.bold,
                        color: kExpertColor,
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfTeachers()));
                      },
                      child: Text(kClassMateList4,

                        style: GoogleFonts.rajdhani(
                          decoration: TextDecoration.underline,
                          fontSize:kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          color: kAGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,

                child: ListView.builder(
                    itemCount: teachersList.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {

                      return  Container(
                        width: MediaQuery.of(context).size.width * kSchoolProfileW,
                        height: MediaQuery.of(context).size.height * kSchoolProfileH,
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



                      space(),
                      space(),
              SchoolProfilePosts(),
            ],
          ),
        )

    )

    );
  }

  Future<void> getSchoolDetails() async {
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('schoolUsers')
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length > 0) {
        for( DocumentSnapshot doc in documents){
          setState(() {
            schoolDocuments.add(doc.data());

          });
        }

      }

        }catch(e){
      setState(() {
        progress = false;
      });
      SchClassConstant.displayToastError(title: kError);

    }
}


  Future<void> getStudent() async {

if(SchClassConstant.isUniStudent){
    FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
        .where('dept',isEqualTo: SchClassConstant.schDoc['dept'])
        .orderBy('ts',descending: true).limit(20)
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
          print(workingDocuments);

        }
      }else{
        setState(() {
          progress = true;
        });
      }
    });

  }else if((SchClassConstant.isCampusProprietor) || (SchClassConstant.isLecturer)){

  FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
      .orderBy('ts',descending: true).limit(20)
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
    }else{
      setState(() {
        progress = true;
      });
    }
  });
  }else if((SchClassConstant.isHighSchProprietor) || (SchClassConstant.isTeacher)){
  FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
      .orderBy('ts',descending: true).limit(20)
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
    }else{
      setState(() {
        progress = true;
      });
    }
  });
  } else{
  FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
      .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
      .orderBy('ts',descending: true).limit(6)
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
    }else{
      setState(() {
        progress = true;
      });
    }
  });

  }
  }

  void getTeachers() {
    if (SchClassConstant.isUniStudent) {
      FirebaseFirestore.instance.collection('schoolTutors').doc(
          SchClassConstant.schDoc['schId']).collection('tutors')
          .where('dept', isEqualTo: SchClassConstant.schDoc['dept'])

          .orderBy('ts', descending: true).limit(6)
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
        } else {
          setState(() {
            progress = true;
          });
        }
      });
    } else if ((SchClassConstant.isCampusProprietor) || (SchClassConstant.isLecturer)){
      FirebaseFirestore.instance.collection('schoolTutors').doc(
          SchClassConstant.schDoc['schId']).collection('tutors')
          .orderBy('ts', descending: true).limit(6)
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
        } else {
          setState(() {
            progress = true;
          });
        }
      });
  } else{
      FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers')
          .orderBy('ts',descending: true).limit(6)
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
