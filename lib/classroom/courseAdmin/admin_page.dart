import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courseAdmin/admin_tabs.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar.dart';
import 'package:sparks/classroom/courseAdmin/course_appbar_second.dart';
import 'package:sparks/classroom/courseAdmin/admin_courses.dart';
import 'package:sparks/classroom/courseAdmin/yes_no.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPageOne extends StatefulWidget {
  @override
  _AdminPageOneState createState() => _AdminPageOneState();
}

class _AdminPageOneState extends State<AdminPageOne> {
  var itemsData = [];
  var _documents = [];
  List<int> lectureCounts = <int>[];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  Widget spaceWidth() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.05,
    );
  }

  static DateTime now = DateTime.now();
  var date = DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  /*getting the month name*/
  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobar',
    'Novermber',
    'December'
  ];
  var currentMon = now.month;
  bool progress = false;

  static var dates = new DateTime.now().toString();
  static var dateParse = DateTime.parse(dates);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";

  bool _publishModal = false;
  String? filter;

  bool? _isChecked = false;
  bool? checkedValue = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourseData();
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
  }

  Widget bodyList(int index) {
    List<dynamic> count = List.from(itemsData[index]['Lc']);

    return Column(
      children: <Widget>[
        Card(
          color: CourseAdminConstants.selectedDoc.contains(index)
              ? Colors.white70
              : kWhitecolor,
          elevation: 20.0,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: kFbColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count.last.toString(),
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kWhitecolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 32,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: itemsData[index]['pix'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        itemsData[index]['fn'],
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          color: kFbColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        itemsData[index]['ln'],
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          color: kFbColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  spaceWidth(),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil().setWidth(constrainedReadMore),
                          minHeight:
                              ScreenUtil().setHeight(constrainedReadMoreHeight),
                        ),
                        child: ReadMoreText(
                          itemsData[index]['topic'],
                          trimLines: 2,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...',
                          trimExpandedText: 'show less',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text(
                        itemsData[index]['date'],
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          color: kPreviewcolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: kAshthumbnailcolor,
                thickness: kThickness,
              ),
              /*showing the admin tabs*/

              AdminTabs(
                openEmail: () async {
                  sendEmailToCourseCreator(index);
                },
                viewCourses: () {
                  moveToCourses(context, _documents[index], index);
                },
                verify: () {
                  verifyCourse(context, _documents[index], index);
                },
              ),
              space(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CourseAdminAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: CustomScrollView(slivers: <Widget>[
                CourseSilverAppBar(
                  matches: kStabcolor1,
                  friends: kSappbarcolor,
                  classroom: kSappbarcolor,
                  content: kSappbarcolor,
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  itemsData.length == 0 && progress == false
                      ? Center(child: ProgressIndicatorState())
                      : itemsData.length == 0 && progress == true
                          ? Center(
                              child: NoContentCreated(
                              title: kNoContentTitle,
                            ))
                          : Column(
                              children: <Widget>[
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _documents.length,
                                    itemBuilder: (context, int index) {
                                      return filter == null || filter == ""
                                          ? bodyList(index)
                                          : '${itemsData[index]['fn']}'
                                                  .toLowerCase()
                                                  .contains(
                                                      filter!.toLowerCase())
                                              ? bodyList(index)
                                              : Container();
                                    })
                              ],
                            )
                ]))
              ]),
            )));
  }

  Future<void> getCourseData() async {
    CourseAdminConstants.newCount.clear();
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('courses')
          .where('se', isEqualTo: false)
          .where('verified', isEqualTo: false)
          .orderBy('dt', descending: true)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());
            CourseAdminConstants.newCount.add(document);
          });
        }
      }
    } catch (e) {
      // return CircularProgressIndicator();
    }

    /*
    FirebaseFirestore.instance.collectionGroup('courses').where('se',isEqualTo: false)
        .where('verified',isEqualTo: false)
        .get()
    .then((value) {
    value.docs.forEach((result) {

    setState(() {
     */ /* itemsData.clear();
      _documents.clear();*/ /*
      _documents.add(result);
    itemsData.add(result.data());

     // lectureCounts.add(result.data['lc']);
    });


    });
    });*/
  }

  void moveToCourses(
      BuildContext context, DocumentSnapshot document, int index) {
    setState(() {
      CourseAdminConstants.selectedDoc.clear();
      CourseAdminConstants.selectedDoc.add(index);
      CourseAdminConstants.courseAdminDocId = document.id;
      CourseAdminConstants.courseAdminName = itemsData[index]['fn'];
      CourseAdminConstants.courseAdminPix = itemsData[index]['pi'];
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewCourses()));
  }

  void verifyCourse(
      BuildContext context, DocumentSnapshot document, int index) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.warning,
                      color: kFbColor,
                      size: 40,
                    ),
                  ),
                  space(),
                  Center(
                    child: Text(
                      'Hi ${itemsData[index]['fn']}',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kFbColor,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                  ),
                  space(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Text(
                      kVerifiedText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  ),
                  space(),
                  CheckboxListTile(
                    title: Text(
                      kVerifyAgreement,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                    value: _isChecked,
                    activeColor: klistnmber,
                    selected: _isChecked!,
                    checkColor: kFbColor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value;
                      });
                    },
                  ),
                  space(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: klistnmber,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: kFbColor,
                        onPressed: () {
                          if (_isChecked == true) {
                            Navigator.pop(context);
                            verifyThisCourse(_documents[index], index);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please check the box',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: kBlackcolor,
                                textColor: kFbColor);
                          }
                        },
                        child: Text(
                          'Yes',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]));
  }

  Future<void> verifyThisCourse(DocumentSnapshot document, int index) async {
    setState(() {
      _publishModal = true;
    });
    User currentUser = FirebaseAuth.instance.currentUser!;

    List<dynamic> lectures = List.from(itemsData[index]['lectures']);

    List<dynamic> target = List.from(itemsData[index]['targ']);

    List<dynamic> objective = List.from(itemsData[index]['obj']);

    List<dynamic> requirement = List.from(itemsData[index]['req']);

    List<dynamic> include = List.from(itemsData[index]['inc']);

    List<dynamic> language = List.from(itemsData[index]['lang']);

    List<dynamic> level = List.from(itemsData[index]['level']);

    List<dynamic> category = List.from(itemsData[index]['cate']);
    List<dynamic> lc = List.from(itemsData[index]['Lc']);

    try {
      print('iiiiiiiii');
      print(target);
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("verifiedCourses")
          .doc(itemsData[index]['uid'])
          .collection('userCourses')
          .doc();
      documentReference.set({
        'Lc': lc,
        'targ': target,
        'obj': objective,
        'req': requirement,
        'inc': include,
        'lang': language,
        'level': level,
        'cate': category,
        'lectures': lectures,
        'pdesc': itemsData[index]['pdesc'],
        'topic': itemsData[index]['topic'],
        'sub': itemsData[index]['sub'],
        'desc': itemsData[index]['desc'],
        'name': itemsData[index]['name'],

        'pur': itemsData[index]['pur'],
        'tmb': itemsData[index]['tmb'],
        'prom': itemsData[index]['prom'],
        'amt': itemsData[index]['amt'],
        'cong': itemsData[index]['cong'],
        'wel': itemsData[index]['wel'],
        'views': 1,
        'rate': 1,
        'date': itemsData[index]['date'],
        'age': itemsData[index]['age'],
        'age2': itemsData[index]['age2'],
        'verified': true,
        'ud': itemsData[index]['ud'],
        /*date uploaded */ 'dtu': itemsData[index]['now'],
        'uid': itemsData[index]['uid'],
        'fn': itemsData[index]['fn'],
        'ln': itemsData[index]['ln'],
        'email': itemsData[index]['email'],
        'pix': itemsData[index]['pix'],
        'oid': itemsData[index]['id'],
        'id': documentReference.id,
        'suid': CourseAdminConstants.adminData[0]['uid'], //staff uid
        'cuid': CourseAdminConstants.adminData[0]['cid'] //company id,
      });
      print('ttttttttttt');

      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(itemsData[index]['uid'])
          .collection('courses')
          .doc(document.id)
          .update({'verified': true});

      /* push the inspector data to database; who verified the course
*/
      DocumentReference doc = FirebaseFirestore.instance
          .collection("courseInspector")
          .doc(CourseAdminConstants.adminData[0]['id'])
          .collection('inspectedCourses')
          .doc();
      doc.set({
        'suid': currentUser.uid, //staff uid
        'sem': currentUser.email, //staff email
        'comN': CourseAdminConstants.adminData[0]['name'],
        'pix': CourseAdminConstants.adminData[0]['pimg'],
        'uid': CourseAdminConstants.adminData[0]['uid'],
        'cuid': document.id,
        'fn': CourseAdminConstants.adminData[0]['fn'],
        'cname': itemsData[index]['topic'],
        'date': date,

        'email': CourseAdminConstants.adminData[0]['email'],
        'ph': CourseAdminConstants.adminData[0]['ph'],
        'cfn': itemsData[index]['fn'],
        'cln': itemsData[index]['ln'],
        'yr': DateTime.now().year,
        'mth': DateTime.now().month,
        'day': DateTime.now().day,
        'wkd': DateTime.now().weekday,
        'cid': itemsData[index]['id'],
        'month': months[currentMon - 1],
        'wky': Jiffy().week,
        'time': "${Jiffy().hour}: ${Jiffy().minute}:${Jiffy().second}",
        'vf': true,
        'se': false
      });
/*updating the user count*/
      final snapShot = await FirebaseFirestore.instance
          .collection("companyVerifiedCourses")
          .doc(CourseAdminConstants.adminData[0]['id'])
          .collection('companyVerifiedCoursesCount')
          .doc(currentUser.uid)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
        FirebaseFirestore.instance
            .collection("companyVerifiedCourses")
            .doc(CourseAdminConstants.adminData[0]['id'])
            .collection('companyVerifiedCoursesCount')
            .doc(currentUser.uid)
            .set({
          'vfd': 1,
          'vfm': 1,
          'vfy': 1,
          'vfw': 1,
          'sed': 0,
          'sew': 0,
          'semth': 0,
          'sey': 0,
          'id': CourseAdminConstants.adminData[0]['id'],
          'suid': currentUser.uid, //staff uid
          'sem': currentUser.email, //staff email
          'comN': CourseAdminConstants.adminData[0]['name'],
          'pix': CourseAdminConstants.adminData[0]['pimg'],
          'uid': CourseAdminConstants.adminData[0]['uid'],
          'cuid': document.id,
          'fn': CourseAdminConstants.adminData[0]['fn'],
          'yr': DateTime.now().year,
          'mth': DateTime.now().month,
          'day': DateTime.now().day,
          'wkd': DateTime.now().weekday,
          'wky': Jiffy().week,
          'month': months[currentMon - 1],
          'date': date,
        });
        setState(() {
          CourseAdminConstants.newCount.removeAt(index);
          _documents.removeAt(index);
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kVerifiedSuccess,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        /*give a notification*/

      } else {
        //snapshot is  existing
        FirebaseFirestore.instance
            .collection('companyVerifiedCourses')
            .doc(CourseAdminConstants.adminData[0]['id'])
            .collection('companyVerifiedCoursesCount')
            .where('suid', isEqualTo: currentUser.uid)
            .where('id', isEqualTo: CourseAdminConstants.adminData[0]['id'])
            .get()
            .then((value) {
          value.docs.forEach((result) {
            var month = result.data()['mth'];
            var currentYear = result.data()['yr'];
            var currentDay = result.data()['day'];
            var currentWeek = result.data()['wky'];

            if (month == null) {
              result.reference.set({
                'vfd': 1,
                'vfm': 1,
                'vfy': 1,
                'vfw': 1,
                'sed': 0,
                'sew': 0,
                'semth': 0,
                'sey': 0,
                'id': CourseAdminConstants.adminData[0]['id'],
                'suid': currentUser.uid, //staff uid
                'sem': currentUser.email, //staff email
                'comN': CourseAdminConstants.adminData[0]['name'],
                'pix': CourseAdminConstants.adminData[0]['pimg'],
                'uid': CourseAdminConstants.adminData[0]['uid'],
                'cuid': document.id,
                'fn': CourseAdminConstants.adminData[0]['fn'],
                'yr': DateTime.now().year,
                'mth': DateTime.now().month,
                'day': DateTime.now().day,
                'wkd': DateTime.now().weekday,
                'wky': Jiffy().week,
                'month': months[currentMon - 1],
                'date': date,
              }, SetOptions(merge: true));
            } else {
              result.reference.update({
                'vfd': currentDay == DateTime.now().day
                    ? result.data()['vfd'] + 1
                    : 1,
                'vfw':
                    currentWeek == Jiffy().week ? result.data()['vfw'] + 1 : 1,
                'vfm': month == DateTime.now().month
                    ? result.data()['vfm'] + 1
                    : 1,
                'vfy': currentYear == DateTime.now().year
                    ? result.data()['vfy'] + 1
                    : 1,
                'yr': DateTime.now().year,
                'mth': DateTime.now().month,
                'day': DateTime.now().day,
                'wkd': DateTime.now().weekday,
                'wky': Jiffy().week,
                'month': months[currentMon - 1],
              });
            }
          });
        });
        setState(() {
          _documents.removeAt(index);
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kVerifiedSuccess,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        /*give a notification*/

      }
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      print(e.toString());
    }
  }

  void sendEmailToCourseCreator(int index) {
/*show dialog that ask the user if course has been seen enough*/
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: Center(
                  child: Text(
                    kSendEmail.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kFbColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Text(
                      kSendEmailVerify,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kBlackcolor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Text(
                      kSendEmailVerify2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kBlackcolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  space(),
                  CheckboxListTile(
                    title: Text(
                      kTerms,
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kExpertColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  YesNoBtn(
                      noTitle: 'Not now',
                      yesTitle: 'Yes,send',
                      no: () {
                        Navigator.pop(context);
                      },
                      yes: () {
                        if (checkedValue == true) {
                          Navigator.pop(context);
                          sendTheEmail(index);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please check the box',
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: kBlackcolor,
                              textColor: kFbColor);
                        }
                      })
                ]));
  }

  Future<void> sendTheEmail(int index) async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    /*send the email sender details to database for seen collection*/
    setState(() {
      _publishModal = true;
    });
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("courseInspector")
          .doc(CourseAdminConstants.adminData[0]['id'])
          .collection('inspectedCourses')
          .doc();

      documentReference.set({
        'suid': currentUser.uid, //staff uid
        'sem': currentUser.uid, //staff email
        'pix': CourseAdminConstants.adminData[0]['pimg'],
        'comN': CourseAdminConstants.adminData[0]['name'], //company name
        'comid': CourseAdminConstants.adminData[0]['id'], //company id
        'uid': CourseAdminConstants.adminData[0]['uid'],
        'cuid': documentReference.id,
        'fn': CourseAdminConstants.adminData[0]['fn'],
        'cname': itemsData[index]['topic'],
        'date': date,
        'email': CourseAdminConstants.adminData[0]['email'],
        'ph': CourseAdminConstants.adminData[0]['ph'],
        'cfn': itemsData[index]['fn'],
        'cln': itemsData[index]['ln'],
        'cid': itemsData[index]['id'],
        'yr': DateTime.now().year,
        'mth': DateTime.now().month,
        'day': DateTime.now().day,
        'today': formattedDate,
        'month': months[currentMon - 1],
        'vf': false,
        'se': true,
        'wky': Jiffy().week,
        'wkd': DateTime.now().weekday,
        'time': "${Jiffy().hour}:${Jiffy().minute}:${Jiffy().second}",
      });

      final snapShot = await FirebaseFirestore.instance
          .collection("companyVerifiedCourses")
          .doc(CourseAdminConstants.adminData[0]['id'])
          .collection('companyVerifiedCoursesCount')
          .doc(currentUser.uid)
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.
        FirebaseFirestore.instance
            .collection("companyVerifiedCourses")
            .doc(CourseAdminConstants.adminData[0]['id'])
            .collection('companyVerifiedCoursesCount')
            .doc(currentUser.uid)
            .set({
          'vfd': 0,
          'vfm': 0,
          'vfy': 0,
          'vfw': 0,
          'sed': 1,
          'sew': 1,
          'semth': 1,
          'sey': 1,
          'id': CourseAdminConstants.adminData[0]['id'],
          'suid': currentUser.uid, //staff uid
          'sem': currentUser.email, //staff email
          'comN': CourseAdminConstants.adminData[0]['name'],
          'pix': CourseAdminConstants.adminData[0]['pimg'],
          'uid': CourseAdminConstants.adminData[0]['uid'],
          'cuid': documentReference.id,
          'fn': CourseAdminConstants.adminData[0]['fn'],
          'yr': DateTime.now().year,
          'mth': DateTime.now().month,
          'day': DateTime.now().day,
          'wkd': DateTime.now().weekday,
          'wky': Jiffy().week,
          'month': months[currentMon - 1],
          'date': date,
        });
        setState(() {
          _documents.removeAt(index);
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kVerifiedSuccess,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        /*give a notification*/

      } else {
        //snapshot is  existing
        FirebaseFirestore.instance
            .collection('companyVerifiedCourses')
            .doc(CourseAdminConstants.adminData[0]['id'])
            .collection('companyVerifiedCoursesCount')
            .where('suid', isEqualTo: currentUser.uid)
            .where('id', isEqualTo: CourseAdminConstants.adminData[0]['id'])
            .get()
            .then((value) {
          value.docs.forEach((result) {
            var month = result.data()['mth'];
            var currentYear = result.data()['yr'];
            var currentDay = result.data()['day'];
            var currentWeek = result.data()['wky'];

            result.reference.update({
              'sed': currentDay == DateTime.now().day
                  ? result.data()['sed'] + 1
                  : 1,
              'sew': currentWeek == Jiffy().week ? result.data()['sew'] + 1 : 1,
              'semth': month == DateTime.now().month
                  ? result.data()['semth'] + 1
                  : 1,
              'sey': currentYear == DateTime.now().year
                  ? result.data()['sey'] + 1
                  : 1,
              'yr': DateTime.now().year,
              'mth': DateTime.now().month,
              'day': DateTime.now().day,
              'wkd': DateTime.now().weekday,
              'wky': Jiffy().week,
              'month': months[currentMon - 1],
            });
          });
        });
        setState(() {
          _documents.removeAt(index);
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kVerifiedSuccess,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        /*give a notification*/

      }

      //update the course to seen
      FirebaseFirestore.instance
          .collectionGroup('courses')
          .where('id', isEqualTo: itemsData[index]['id'])
          .get()
          .then((value) {
        value.docs.forEach((result) {
          result.reference.update({
            'se': true,
          });
        });
      });

      setState(() {
        _publishModal = false;
      });
      //Send message to the course creator

      var url =
          "mailto:${itemsData[index]['email']}?subject=${CourseAdminConstants.emailSubject}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }

      getCourseData();
    } catch (e) {
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }
}
