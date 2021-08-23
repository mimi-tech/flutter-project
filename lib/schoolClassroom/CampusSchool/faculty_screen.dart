import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_courses.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_dept.dart';
import 'package:sparks/schoolClassroom/CampusSchool/create_faculty.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_faculty.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_bottomAppbar.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';
import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class FacultyScreen extends StatefulWidget {
  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }
  //List<DocumentSnapshot> workingDocuments;
  bool progress = false;
  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic>? loadClasses;
  List<dynamic>? loadTeachers;
  List<dynamic>? loadTeachersPin;

  List<dynamic>? l;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  var _documents = <DocumentSnapshot>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartment();
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          appBar: StuAppBar(),
          body: CustomScrollView(slivers: <Widget>[
         ProprietorActivityAppBar(
            activitiesColor: kTextColor,
            classColor: kStabcolor1,
            newsColor: kTextColor,
            studiesColor: kTextColor,
          ),
            CampusSliverAppBar(
        campusBgColor: klistnmber,
        campusColor: kWhitecolor,
        deptBgColor: Colors.transparent,
        deptColor: klistnmber,
        recordsBgColor: Colors.transparent,
        recordsColor: klistnmber,
              adminsBgColor: Colors.transparent,
              adminsColor: klistnmber,
      ),
      SliverList(
          delegate: SliverChildListDelegate([

            workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
            workingDocuments.length == 0 && progress == true ? Column(
              children: [
                Text(kCampusNoFaculty,
                  textAlign:TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),

                ),

                RaisedButton(onPressed: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: CreateFaculty()));

                },
                  color: kExpertColor,
                  child:Text('Create faculty',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhitecolor,
                        fontSize: kFontsize.sp,
                      ),
                    ),

                  ),
                )
              ],
            ):
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: RaisedButton(onPressed: (){
                      Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: CreateFaculty()));

                    },
                      color: kLightGreen,
                      child:Text('Add new faculty',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhitecolor,
                            fontSize: kFontsize.sp,
                          ),
                        ),

                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: workingDocuments.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        List<Widget> getImages(){
                          List<Widget> list =  <Widget>[];

                          for(var i = 0; i < workingDocuments[index]['sub'].length; i++){
                            loadTeachers = workingDocuments[index]['sub'];
                            Widget w =  Center(
                              child: Column(children: <Widget>[
                                space(),
                                ListTile(

                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  leading:Icon(Icons.ac_unit,color: kFbColor,),
                                  title:Text(loadTeachers![i].toString(),
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kBlackcolor,
                                        fontSize: 20.sp,
                                      ),
                                    ),

                                  ) ,
                                  trailing: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                          onTap:(){
                                            Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: CampusCourses(doc:workingDocuments,name:workingDocuments[index]['sub'][i])));

                                          },
                                          //margin: EdgeInsets.only(right:20),
                                          child: Icon(Icons.add,color: kFacebookcolor,)),
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                          onTap:(){
                                            Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: CampusLecturersScreen(doc:workingDocuments,name:workingDocuments[index]['sub'][i])));

                                          },
                                          child: Icon(Icons.view_agenda,color: kFbColor,)),
                                    ],
                                  ),

                                ),
                              ]),
                            );
                            list.add(w);
                          }
                          return list;
                        }





                        return Card(
                          elevation: 10,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        Align(
                                          alignment: Alignment.topRight,
                                          child: EditIcon(removeIcon: (){
                                            editF(_documents,index);

                                          },title: 'Edit',),
                                        ),

                                        RichText(
                                          text: TextSpan(
                                              text:'Faculty of ',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: kBlackcolor,
                                              ),

                                              children: <TextSpan>[
                                                TextSpan(text: '${workingDocuments[index]['lv']}'.toUpperCase(),
                                                    style: GoogleFonts.rajdhani(
                                                      decoration: TextDecoration.underline,
                                                      textStyle: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: kExpertColor,
                                                        fontSize: kFontsize.sp,


                                                      ),))


                                              ]
                                          ),
                                        ),

                                        space(),
                                        Text('Department(s)',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: kSlivevcr,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),
                                        Column(
                                          //direction: Axis.vertical,
                                          children: getImages(),

                                        ),

                                        space(),
                                        Divider(),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'Created by ',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: kSlivevcr,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${workingDocuments[index]['crt']}',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kAGreen,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),



                                        space(),
                                        Divider(),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'Date & time ',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: kSlivevcr,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(workingDocuments[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(workingDocuments[index]['ts']))}',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kFbColor,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),

                                      ]
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  progress == true || _loadMoreProgress == true
                      || _documents.length < SchClassConstant.streamCount
                      ?Text(''):
                  moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                      onTap: (){loadMore();},
                      child: SvgPicture.asset('images/classroom/load_more.svg',))
                ],
              ),
            )
        ])
    )])));
  }





  Future<void> getDepartment() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('schoolFaculty').doc(SchClassConstant.schDoc['schId']).collection('faculty').
    orderBy('ts',descending: true).limit(SchClassConstant.streamCount)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          workingDocuments.add(document.data());

        });


      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('schoolFaculty').doc(SchClassConstant.schDoc['schId']).collection('faculty').
    orderBy('ts',descending: true).limit(SchClassConstant.streamCount).

    startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          workingDocuments.add(document.data());

          moreData = false;


        });
      }
    }}

  void editF(List<DocumentSnapshot> documents, int index) {
    Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: EditFaculty(doc:workingDocuments)));

  }
}
