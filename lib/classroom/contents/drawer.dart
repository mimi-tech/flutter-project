import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/courseAdmin/admin_page.dart';
import 'package:sparks/classroom/courseAdmin/admin_pin.dart';
import 'package:sparks/classroom/courseAdmin/confirm_admin.dart';
import 'package:sparks/classroom/courseAdmin/courseCompany.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/course_verify_company.dart';
import 'package:sparks/classroom/courseAdmin/expert_company.dart';
import 'package:sparks/classroom/courseAnalysis/daily_analysis.dart';
import 'package:sparks/classroom/expertAdmin/confirm_expert_admin.dart';
import 'package:sparks/classroom/expertAdmin/confirm_expert_company.dart';
import 'package:sparks/classroom/expertAdmin/confirm_lectuers_key.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_pin.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/expertAdmin/expert_class_page.dart';
import 'package:sparks/classroom/sparksCompanies/class/expert_companies.dart';

class DrawerBar extends StatefulWidget {
  @override
  _DrawerBarState createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  bool progress = false;
  var itemsData = [];
  bool progress3 = false;
  bool progress4 = false;
  bool expertProgress = false;
  var expertData = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
          child: Text(
        'nbnsbx',
      )),
      ListTile(
        onTap: () async {
          setState(() {
            progress3 = false;
            CourseAdminConstants.adminData.clear();
          });
          //check if user have unlock the key
          print(GlobalVariables.loggedInUserObject.id);
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('courseAdmin')
              .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
              .where('cr', isEqualTo: true)
              .get();

          final List<DocumentSnapshot> documents = result.docs;
          if (documents.length == 0) {
            print('uuuuuu');
            setState(() {
              progress3 = false;
            });
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AdminPin()));
          } else {
            for (DocumentSnapshot doc in documents) {
              CourseAdminConstants.adminData.add(doc.data);
            }

            setState(() {
              progress3 = false;
            });

            //add result
            print(CourseAdminConstants.adminData);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AdminPageOne()));
          }
        },
        leading: Icon(Icons.home),
        title: progress3
            ? Center(child: PlatformCircularProgressIndicator())
            : Text(
                'Course Admin',
                style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: kFontsize.sp,
                )),
              ),
      ),
      ListTile(
        onTap: () {
          /*get the course companies*/
          setState(() {
            progress = true;
            itemsData.clear();
          });

          print('iiiiiiiii$progress');

          try {
            FirebaseFirestore.instance
                .collection('courseCompany')
                .get()
                .then((value) {
              value.docs.forEach((result) {
                print('uuuuuu$result');
                setState(() {
                  itemsData.add(result.data());
                });
              });

              getCompany();
              setState(() {
                progress = false;
              });
            });
          } catch (e) {
            print('this is the catch ${e.toString()}');
          }

          setState(() {
            progress = false;
          });
        },
        leading: Icon(Icons.home),
        title: progress
            ? Center(child: CircularProgressIndicator())
            : Text(
                'Generate Course key',
                style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: kFontsize.sp,
                )),
              ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AllCoursesAnalysis()));
        },
        leading: Icon(Icons.home),
        title: Text(
          'Analysis',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
      ListTile(
        onTap: () {
          courseCompany();
        },
        leading: Icon(Icons.add),
        title: Text(
          'Add Course company',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
      ListTile(
        onTap: () {
          expertCompany();
        },
        leading: Icon(Icons.add),
        title: Text(
          'Add Expert Company',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
      ListTile(
        onTap: () {
          /*get the course companies*/
          setState(() {
            expertProgress = true;
            expertData.clear();
          });

          try {
            FirebaseFirestore.instance
                .collection('expertCompany')
                .get()
                .then((value) {
              value.docs.forEach((result) {
                setState(() {
                  expertData.add(result.data());
                });
              });

              getExpertCompany();
            });
          } catch (e) {
            print('this is the catch ${e.toString()}');
          }
          setState(() {
            expertProgress = false;
          });
        },
        leading: Icon(Icons.home),
        title: expertProgress == true
            ? Center(child: CircularProgressIndicator())
            : Text(
                'Generate Expert key',
                style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                  color: kBlackcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: kFontsize.sp,
                )),
              ),
      ),
      ListTile(
        onTap: () async {
          setState(() {
            progress4 = false;
          });
          //check if user have unlock the key for expert class

          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('companyAdmin')
              .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
              .where('cr', isEqualTo: true)
              .get();

          final List<DocumentSnapshot> documents = result.docs;
          if (documents.length == 0) {
            setState(() {
              progress4 = false;
            });
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ExpertAdminPin()));
          } else {
            setState(() {
              progress4 = false;
            });
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ExpertPage()));
          }
        },
        leading: Icon(Icons.home),
        title: Text(
          'Expert Class Admin',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
      ListTile(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => ConfirmLecturesKey());
        },
        leading: Icon(Icons.home),
        title: Text(
          'Expert Lecuters key',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SparksExpertCompanies()));
        },
        leading: Icon(Icons.home),
        title: Text(
          'sparks Expert company',
          style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
            color: kBlackcolor,
            fontWeight: FontWeight.bold,
            fontSize: kFontsize.sp,
          )),
        ),
      ),
    ]));
  }

/*creating course company*/
  void courseCompany() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmCourseCompany());
  }

/*creating expert company*/
  void expertCompany() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmExpertCompany());
  }

  void getCompany() {
    print(itemsData);
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: Text(
                  'Courses company(s)'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kMaincolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),
                ),
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: itemsData.length,
                        itemBuilder: (context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              getCompanyName(index);
                            },
                            leading: Icon(
                              Icons.ac_unit,
                              color: kFbColor,
                            ),
                            title: Text(
                              itemsData[index]['name'],
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ]));
  }

/*when user have selected, move to generate pin*/
  void getCompanyName(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmAdmin(
            name: itemsData[index]['name'], id: itemsData[index]['did']));
  }

  void getExpertCompany() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: Text(
                  'Expert class company(s)'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kMaincolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),
                ),
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: expertData.length,
                        itemBuilder: (context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              getExpertCompanyName(index);
                            },
                            leading: Icon(
                              Icons.ac_unit,
                              color: kFbColor,
                            ),
                            title: Text(
                              expertData[index]['name'],
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ]));
  }

  void getExpertCompanyName(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ConfirmExpertAdmin(
            name: expertData[index]['name'], id: expertData[index]['did']));
  }
}
