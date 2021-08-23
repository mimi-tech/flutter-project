import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class ViewSchoolDepartment extends StatefulWidget {
  @override
  _ViewSchoolDepartmentState createState() => _ViewSchoolDepartmentState();
}

class _ViewSchoolDepartmentState extends State<ViewSchoolDepartment> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
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
  late var _lastDocument;
  var _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kSappbarbacground,
              title: Text(
                '${SchClassConstant.schDoc['name']} department'.toUpperCase(),
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kWhitecolor,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
            body: workingDocuments.length == 0 && progress == false
                ? Center(child: PlatformCircularProgressIndicator())
                : workingDocuments.length == 0 && progress == true
                ? Center(
                child: NoContentCreated(
                  title:
                  'You have not registered your school departments',
                ))
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      itemCount: workingDocuments.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        List<Widget> getImages() {
                          List<Widget> list = [];

                          for (var i = 0;
                          i <
                              workingDocuments[index]['tc']
                                  .length;
                          i++) {
                            loadTeachersPin =
                            workingDocuments[index]['pin'];
                            loadTeachers =
                            workingDocuments[index]['tc'];
                            Widget w = Center(
                              child: Column(children: <Widget>[
                                space(),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.ac_unit,
                                          color: kFbColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          loadTeachers![i].toString(),
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight:
                                              FontWeight.w500,
                                              color: kBlackcolor,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          loadTeachersPin![i]
                                              .toString(),
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight:
                                              FontWeight.w500,
                                              color: kBlackcolor,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ),
                                        /*IconButton(icon: Icon(Icons.copy), onPressed: (){
                                              Clipboard.setData( ClipboardData(
                                                  text: loadTeachersPin[i][index].toString()));
                                              Fluttertoast.showToast(
                                                  msg: 'Copied',
                                                  gravity: ToastGravity.CENTER,
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  backgroundColor: klistnmber,
                                                  textColor: kWhitecolor);
                                              Navigator.pop(context);

                                            },
                                            )*/
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                            );
                            list.add(w);
                          }
                          return list;
                        }

                        ///for subjects
                        List<Widget> getSubjects() {
                          List<Widget> list = [];

                          for (var i = 0;
                          i <
                              workingDocuments[index]['sub']
                                  .length;
                          i++) {
                            loadClasses =
                            workingDocuments[index]['sub'];
                            Widget w = Center(
                              child: Column(children: <Widget>[
                                space(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: kFbColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      loadClasses![i].toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: kBlackcolor,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
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
                              padding: const EdgeInsets.all(13.0),
                              child: Column(children: <Widget>[
                                Text(
                                  '${workingDocuments[index]['lv']} ${workingDocuments[index]['class']}'
                                      .toUpperCase(),
                                  style: GoogleFonts.rajdhani(
                                    decoration:
                                    TextDecoration.underline,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kExpertColor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),
                                ),
                                space(),
                                Text(
                                  'Class teachers',
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
                                Text(
                                  'Class subjects',
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
                                  children: getSubjects(),
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
                                        text:
                                        '${workingDocuments[index]['crt']}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
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
                                        text:
                                        '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(workingDocuments[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(workingDocuments[index]['ts']))}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: kFbColor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      }),
                  progress == true ||
                      _loadMoreProgress == true ||
                      _documents.length <
                          SchClassConstant.streamCount
                      ? Text('')
                      : moreData == true
                      ? PlatformCircularProgressIndicator()
                      : GestureDetector(
                      onTap: () {
                        loadMore();
                      },
                      child: SvgPicture.asset(
                        'assets/classroom/load_more.svg',
                      ))
                ],
              ),
            )));
  }

  Future<void> getDepartment() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('levelClasses')
        .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
        .orderBy('ts', descending: true)
        .limit(SchClassConstant.streamCount)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
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
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('levelClasses')
        .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
        .orderBy('ts', descending: true)
        .limit(SchClassConstant.streamCount)
        .startAfterDocument(_lastDocument)
        .limit(SchClassConstant.streamCount)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          workingDocuments.add(document.data());

          moreData = false;
        });
      }
    }
  }
}
