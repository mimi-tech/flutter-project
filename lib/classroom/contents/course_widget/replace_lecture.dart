import 'dart:io';

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
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';

import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/alert_animation.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/progress_indicator.dart';
import 'package:sparks/classroom/courses/progress_indicator2.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReplaceLecture extends StatefulWidget {
  final Course toEditLectures;
  final int? currentIndexOfLectures;

  ReplaceLecture({
    required this.toEditLectures,
    required this.currentIndexOfLectures,
  });

  @override
  _ReplaceLectureState createState() => _ReplaceLectureState(
        toEditLectures: toEditLectures,
        currentIndexOfLectures: currentIndexOfLectures,
      );
}

class _ReplaceLectureState extends State<ReplaceLecture>
    with TickerProviderStateMixin {
  Course? toEditLectures;
  int? currentIndexOfLectures;

  _ReplaceLectureState({
    this.toEditLectures,
    this.currentIndexOfLectures,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    count = currentIndexOfLectures! + 1;
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Constants.uploadImageTask = null;
    Constants.uploadTask = null;
    checkReplace = false;
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
  bool checkReplace = false;
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
              videoColor: kStabcolor,
              updateColor: kBlackcolor,
              addColor: kBlackcolor,
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
                              _selectImage();
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
                          /* AddIcon(iconFunction: (){
                            counting();
                          }),

                          RemoveIcon(removeIcon:(){_removeLecture();}),*/
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
                                Navigator.pop(context, 'Done');
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
    if ((url != null) || (imageUrl != null)) {
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
    } else {
      Fluttertoast.showToast(
          msg: kSCourseUploadError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  Future<void> addData() async {
    /*send to dataBase*/

    User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _publishModal = true;
    });

    if (checkReplace == false) {
      Course copyLectures = toEditLectures!;
      Course editedLectures = Course();
      List<Section> globalEditedSections = [];

      print(
          'Number of Lectures (copyLectures.lectures.length): ${copyLectures.lectures.length}');

      for (int i = 0; i < copyLectures.lectures.length; i++) {
        Lecture editedLecture = Lecture();
        List<Section> editedSections = [];

        print('Lecture ${i + 1}');

        for (int j = 0; j < copyLectures.lectures[i].sections.length; j++) {
          print('Section ${j + 1}');

          if ((i == currentIndexOfLectures) && (j == sectionCount - 1)) {
            if (j == 0) {
              copyLectures.lectures[i].sections[j].vido = url;
              copyLectures.lectures[i].sections[j].sectionCount = j + 1;
              copyLectures.lectures[i].sections[j].title =
                  Constants.kSCourseLectureTitle;
              copyLectures.lectures[i].sections[j].at = imageUrl;
              copyLectures.lectures[i].sections[j].name =
                  Constants.kSCourseLectureSections;
              copyLectures.lectures[i].sections[j].lCount = i + 1;

              editedSections.add(copyLectures.lectures[i].sections[j]);

              for (int n = 1;
                  n < copyLectures.lectures[i].sections.length;
                  n++) {
                copyLectures.lectures[i].sections.removeAt(n);
              }
            } else {
              Section newSection = Section();

              newSection.vido = url;
              newSection.sectionCount = j + 1;
              newSection.title = Constants.kSCourseLectureTitle;
              newSection.at = imageUrl;
              newSection.name = Constants.kSCourseLectureSections;
              newSection.lCount = i + 1;

              editedSections.add(newSection);
            }
          }

          if (i != currentIndexOfLectures) {
            editedSections.add(copyLectures.lectures[i].sections[j]);
          }
        }

        editedLecture.sections.addAll(editedSections);
        editedLectures.lectures.add(editedLecture);
      }

      toEditLectures = copyLectures;

      List<Map> editedLecturesLM = [];
      List<int> lC = [];

      print(
          'Number of Edited Lectures (editedLectures.lectures.length): ${editedLectures.lectures.length}');

      for (int i = 0; i < editedLectures.lectures.length; i++) {
        print('Edited Lecture ${i + 1}');

        for (int j = 0; j < editedLectures.lectures[i].sections.length; j++) {
          print('Edited Section ${j + 1}');

          Map editedLecture = {
            'lecture': ([
              {
                'vido': editedLectures.lectures[i].sections[j].vido,
                'Sc': j + 1,
                'title': editedLectures.lectures[i].sections[j].title,
                'at': editedLectures.lectures[i].sections[j].at,
                'name': editedLectures.lectures[i].sections[j].name,
                'Lcount': i + 1,
              }
            ])
          };

          editedLecturesLM.add(editedLecture);
        }

        lC.add(i + 1);
      }

      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("sessionContent")
            .doc(currentUser!.uid)
            .collection('courses')
            .doc(Constants.docId);
        documentReference.set({
          'Lc': lC,
          'lectures': editedLecturesLM,
        }, SetOptions(merge: true)).whenComplete(() {
          setState(() {
            checkReplace = true;
            _publishModal = false;
            sectionCount++;
            Constants.kCourseDocId = documentReference.id;
            Constants.uploadImageTask = null;
            Constants.uploadTask = null;
          });
        });
      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: 'Sorry an error occured',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    } else {
      setState(() {
        _publishModal = true;
      });
      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("sessionContent")
            .doc(currentUser!.uid)
            .collection('courses')
            .doc(Constants.docId);
        documentReference.set({
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
          setState(() {
            _publishModal = false;
            sectionCount++;
            imageUrl = null;
            url = null;
            Constants.uploadImageTask = null;
            Constants.uploadTask = null;
            Constants.kCourseDocId = documentReference.id;
          });
        });
      } catch (e) {
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: 'Sorry an error occured',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }

  void _goToPreview() {}

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
      count--;
    });
  }

  Future<void> _selectImage() async {
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
      Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
      Constants.uploadImageTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'images.jpg',
        ),
      );

      final TaskSnapshot downloadUrl = await Constants.uploadImageTask!;
      imageUrl = await downloadUrl.ref.getDownloadURL();
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }
}
