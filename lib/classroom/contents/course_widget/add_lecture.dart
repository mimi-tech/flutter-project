import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/contents/course_widget/lectures.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';

import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/alert_animation.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/progress_indicator.dart';
import 'package:sparks/classroom/courses/progress_indicator2.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AddLectureEdit extends StatefulWidget {
  @override
  _AddLectureEditState createState() => _AddLectureEditState();
}

class _AddLectureEditState extends State<AddLectureEdit>
    with TickerProviderStateMixin {
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Constants.uploadImageTask = null;
    Constants.uploadTask = null;
  }

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _title = TextEditingController();
  TextEditingController _section = TextEditingController();
  int count = 1;
  int sectionCount = 1;
  String? url;
  String? imageUrl;
  //String docId;
  String get filePaths => 'courseVideos/${DateTime.now()}';
  String get fileImagePaths => 'Attachment/${DateTime.now()}';
  bool _publishModal = false;
  String? docRef;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: UpdateCourse(),
            appBar: EditAppBar(
              detailsColor: kBlackcolor,
              videoColor: kBlackcolor,
              updateColor: kBlackcolor,
              addColor: kStabcolor,
              publishColor: kBlackcolor,
            ),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //ToDo:Add icon
                          GestureDetector(
                            onTap: () {
                              _uploadVideo();
                            },
                            child: Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(50),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.file_upload,
                                    color: kWhiteColour)),
                          ),

                          //ToDo:Attach a document for this video
                          GestureDetector(
                            onTap: () {
                              _selectAttachment();
                            },
                            child: Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(50),
                                decoration: BoxDecoration(
                                    color: kFbColor, shape: BoxShape.circle),
                                child: Icon(Icons.attach_file,
                                    color: kWhiteColour)),
                          )
                        ],
                      ),
                      CourseUploadingProgress(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      CourseSecondUploadingProgress(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RemoveIcon(removeIcon: () {
                            _removeLecture();
                          }),
                          Text(kSCourseLecture + " ",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )),
                          //counting of section

                          Text(count.toString(),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor2,
                                  fontSize: 22.sp,
                                ),
                              )),

                          AddIcon(iconFunction: () {
                            counting();
                          }),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                FadeHeading(
                                  title: kSCourseLecturetitle,
                                ),
                                OutlineButton(
                                  onPressed: () {},
                                  child: Text(count.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kBlackcolor2,
                                          fontSize: 22.sp,
                                        ),
                                      )),
                                ),

                                /*lecture counting*/
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                controller: _title,
                                maxLength: 100,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  Constants.kSCourseLectureTitle = value;
                                },
                                onChanged: (String value) {
                                  Constants.kSCourseLectureTitle = value;
                                },
                                validator: Validator.validateTitle,
                              ),
                            ),

                            //ToDo:section title
                            Row(
                              children: <Widget>[
                                FadeHeading(
                                  title: kSCourseSectionTitle,
                                ),
                                OutlineButton(
                                  onPressed: () {},
                                  child: Text(sectionCount.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kBlackcolor2,
                                          fontSize: 22.sp,
                                        ),
                                      )),
                                )
                              ],
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                controller: _section,
                                maxLength: 100,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  Constants.kSCourseLectureSections = value;
                                },
                                onChanged: (String value) {
                                  Constants.kSCourseLectureSections = value;
                                },
                                validator: Validator.validateTitle,
                              ),
                            ),
                            //ToDo:displaying the section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(kSCourseSection + " ",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlackcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    )),
                                //counting of section

                                Text(sectionCount.toString(),
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlackcolor2,
                                        fontSize: 22.sp,
                                      ),
                                    )),

                                AddIcon(iconFunction: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  countingSection();
                                })
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            Text(
                              kSCourseDone,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(30)),
                            CoursePublishBtn(
                              title: kDone,
                              publish: () {
                                Constants.uploadImageTask = null;
                                Constants.uploadTask = null;
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.topToBottom,
                                        child: LectureCourses()));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                    ],
                  ),
                ),
              ),
            )));
  }

  void countingSection() {
    Animation<Offset> animation;
    AnimationController animationController;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 200),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });
    if (((url == null) && (imageUrl == null))) {
      Fluttertoast.showToast(
          msg: kSCourseUploadError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: AlertAnimation(
                    animation: animation, sectionCount: sectionCount),
                content: Text(kSCourseCheckSection,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kBlackcolor,
                        fontSize: kFontsize.sp,
                      ),
                    )),
                actions: <Widget>[
                  LectureDialog(
                    title: kSYes,
                    bgColor: kFbColor,
                    upload: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.pop(context);
                      addData();
                    },
                  ),
                  LectureDialog(
                    title: kSNo,
                    bgColor: klistnmber,
                    upload: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
    }
    /*else{
      Fluttertoast.showToast(
          msg: kSCourseUploadError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }*/
  }

  Future<void> addData() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    /*send to dataBase*/

    FirebaseAuth.instance.currentUser;

    setState(() {
      _publishModal = true;
    });
/*send to database*/

    FirebaseFirestore.instance
        .collection("sessionContent")
        .doc(currentUser.uid)
        .collection('courses')
        .doc(Constants.docId)
        .set({
      'Lc': FieldValue.arrayUnion([count]),
      'lectures': FieldValue.arrayUnion([
        {
          'lecture': ([
            {
              'vido': url,
              'Sc': sectionCount,
              'title': Constants.kSCourseLectureSections,
              'at': imageUrl,
              'name': Constants.kSCourseLectureTitle,
              'Lcount': count,
            }
          ])
        }
      ])
    }, SetOptions(merge: true)).whenComplete(() {
      Fluttertoast.showToast(
          msg: 'Lecture $count  Section + $sectionCount uploaded successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kSsprogresscompleted);
      setState(() {
        _publishModal = false;
        sectionCount++;
        imageUrl = "";
        url = null;
        _section.clear();
        Constants.uploadImageTask = null;
        Constants.uploadTask = null;
      });
    }).catchError((e) {
      setState(() {
        _publishModal = false;
      });

      Fluttertoast.showToast(
          msg: kSorryError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    });
  }

  /*send video to database*/

  Future<void> _uploadVideo() async {
    String? _extension;

    String video = 'video';
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      //ToDo:open video file
      // File file = await FilePicker.getFile(
      //   type: FileType.video,
      // );

      late File file;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result != null) {
        file = File(result.files.single.path!);
      } else {
        // User canceled the picker
      }

//ToDo: send to fireBase storage
      int filesize = file.lengthSync();

      if (filesize <= kSVideoSize) {
        setState(() async {
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          Constants.uploadTask = ref.putFile(
            file,
            SettableMetadata(
              contentType: '$video/$_extension',
            ),
          );

          final TaskSnapshot downloadUrl = await Constants.uploadTask!;
          url = await downloadUrl.ref.getDownloadURL();
        });
      } else {
        Fluttertoast.showToast(
            msg: kSCourseError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }

  void counting() {
    setState(() {
      _title.clear();
      _section.clear();
      sectionCount = 1;
      count++;
    });
  }

  void _removeLecture() {
    setState(() {
      _title.clear();
      _section.clear();
      sectionCount = 1;

      if (count != 1) {
        count--;
      }
    });
  }

/*select attachment for this lecture*/
  Future<void> _selectAttachment() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.image,
    // );

    File? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    UploadVariables.fileName = file;

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() async {
        Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
        Constants.uploadImageTask = ref.putFile(
          file!,
          SettableMetadata(
            contentType: 'images.jpg',
          ),
        );

        final TaskSnapshot downloadUrl = await Constants.uploadImageTask!;
        imageUrl = await downloadUrl.ref.getDownloadURL();
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }
}
