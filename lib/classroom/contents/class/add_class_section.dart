import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/edit_expert_sections.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/progress_indicator.dart';
import 'package:sparks/classroom/courses/progress_indicator2.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_appbar.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AddClassSectionEdit extends StatefulWidget {
  AddClassSectionEdit({required this.classSectionCounts});
  int classSectionCounts;

  @override
  _AddClassSectionEditState createState() => _AddClassSectionEditState();
}

class _AddClassSectionEditState extends State<AddClassSectionEdit> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  String? sectionTitle;
  String? sectionDesc;
  int sectionCount = 1;
  String? videoUrl;
  File? pickedVideo;
  File? pickedImage;
  bool _publishModal = false;
  String? imageUrl;

  String get filePaths => 'ExpertVideos/${DateTime.now()}';

  String get fileImagePaths => 'ExpertAttachment/${DateTime.now()}';

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  Future<void> _uploadVideo() async {
    /// Ellis = I commented out the old implementation and used the new
    /// implementation (refer the the package documentation)

    // File file = await FilePicker.getFile(
    //   type: FileType.video,
    // );

    File? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    //UploadVariables.fileName = file;

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        pickedVideo = file;
      });
      Reference ref = FirebaseStorage.instance.ref().child(filePaths);

      // Create your custom metadata.
      SettableMetadata metadata = SettableMetadata(
        contentType: "videos/mp4",
      );

      Constants.uploadTask = ref.putFile(
        file,
        metadata,
      );

      final TaskSnapshot downloadUrl = await Constants.uploadTask!;
      videoUrl = await downloadUrl.ref.getDownloadURL();
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  /*uploading image*/

  Future<void> _selectImage() async {
    File? file;

    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    UploadVariables.fileName = file;

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        pickedImage = file;
      });
      Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
      Constants.uploadImageTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'images.pdf',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: EditExpertAppBar(
              detailsColor: kBlackcolor,
              videoColor: kFbColor,
            ),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          pickedVideo == null
                              ? OutlineButton(
                                  onPressed: () {
                                    _uploadVideo();
                                  },
                                  child: Text(
                                    'pick Video',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontsize.sp,
                                      color: kExpertColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : CourseUploadingProgress(),
                          pickedImage == null
                              ? OutlineButton(
                                  onPressed: () {
                                    _selectImage();
                                  },
                                  child: Text(
                                    'pick attachment',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontsize.sp,
                                      color: kExpertColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : CourseSecondUploadingProgress(),
                        ],
                      ),

                      ///section title

                      spacer(),

                      ExpertTitle(
                        title: kClassSectionTitle,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: title,
                          maxLength: 200,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            sectionTitle = value;
                          },
                        ),
                      ),
                      spacer(),

                      ///section desc

                      spacer(),

                      ExpertTitle(
                        title: kClassSectionDesc,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: desc,
                          maxLength: 300,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            sectionDesc = value;
                          },
                        ),
                      ),
                      spacer(),

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
//ToDo:counting of section

                          Text((widget.classSectionCounts + 1).toString(),
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

                      spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: Text(
                            'Note: Please tap on publish when you are through with adding  all your sections for this class',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            )),
                      ),
                      spacer(),

                      CoursePublishBtn(
                        title: kDone,
                        publish: () {
                          Constants.uploadImageTask = null;
                          Constants.uploadTask = null;
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.topToBottom,
                                  child: EditSections()));
                        },
                      ),

                      spacer(),
                    ],
                  ),
                ),
              ),
            )));
  }

  void countingSection() {
    /*check if input is empty*/

    if ((sectionTitle == null) || (sectionTitle == '')) {
      Fluttertoast.showToast(
          msg: 'Please' + " " + kClassSectionTitle,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((sectionDesc == null) || (sectionDesc == '')) {
      Fluttertoast.showToast(
          msg: 'Please' + " " + kClassSectionDesc,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (videoUrl == null) {
      Fluttertoast.showToast(
          msg: 'Please pick your video',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);

      /// TODO: Use snapshotEvents and listen on the events
      // } else if ((Constants.uploadTask.isInProgress) ||
      //     (Constants.uploadImageTask.isInProgress)) {
      //   Fluttertoast.showToast(
      //       msg: 'Upload in progress',
      //       toastLength: Toast.LENGTH_LONG,
      //       backgroundColor: kBlackcolor,
      //       textColor: kFbColor);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
              child: Text(
                  'Section' + sectionCount.toString() + " " + 'completed?')),
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
        ),
      );
    }
  }

  Future<void> addData() async {
    /*start uploading sections to database*/
    User currentUser = FirebaseAuth.instance.currentUser!;

    setState(() {
      _publishModal = true;
    });

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(currentUser.uid)
          .collection('classes')
          .doc(ExpertEditConstants.docId);
      documentReference.set({
        'id': documentReference.id,
        'class': FieldValue.arrayUnion([
          {
            'vido': videoUrl,
            'Sc': widget.classSectionCounts + 1,
            'title': sectionTitle,
            'at': imageUrl,
            'desc': sectionDesc,
          }
        ])
      }, SetOptions(merge: true)).whenComplete(() {
        setState(() {
          _publishModal = false;
          desc.clear();
          title.clear();
          sectionDesc = '';
          sectionTitle = '';

          imageUrl = null;
          videoUrl = null;

          pickedVideo = null;
          pickedImage = null;

          ExpertConstants.classId = documentReference.id;
          Constants.uploadImageTask = null;
          Constants.uploadTask = null;
        });
        Fluttertoast.showToast(
            msg: 'Section ' +
                (widget.classSectionCounts + 1).toString() +
                "" +
                'uploaded successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        setState(() {
          widget.classSectionCounts++;
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
