import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
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

class ReplaceClassSection extends StatefulWidget {
  final List<dynamic> classVideos;
  final int? sectionIndex;

  ReplaceClassSection({
    required this.classVideos,
    required this.sectionIndex,
  });

  @override
  _ReplaceClassSectionState createState() => _ReplaceClassSectionState(
        classVideos: classVideos,
        sectionIndex: sectionIndex,
      );
}

class _ReplaceClassSectionState extends State<ReplaceClassSection> {
  List<dynamic> classVideos;
  int? sectionIndex;

  _ReplaceClassSectionState({
    required this.classVideos,
    required this.sectionIndex,
  });

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
      Constants.uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'videos/mp4',
        ),
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
    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );

    File? file;

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
            appBar: ExpertAppBar(),
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

                          Text((sectionIndex! + 1).toString(),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor2,
                                  fontSize: 22.sp,
                                ),
                              )),
                        ],
                      ),

                      spacer(),

                      spacer(),
                      spacer(),

                      CoursePublishBtn(
                        title: 'Replace',
                        publish: () {
                          Constants.uploadImageTask = null;
                          Constants.uploadTask = null;

                          replaceClassSection();
                        },
                      ),

                      spacer(),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> replaceClassSection() async {
    /*start uploading sections to database*/
    User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _publishModal = true;
    });

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
    } else {
      try {
        for (int i = 0; i < classVideos.length; i++) {
          if (i == sectionIndex) {
            classVideos[i]['vido'] = videoUrl;
            classVideos[i]['Sc'] = sectionIndex;
            classVideos[i]['title'] = sectionTitle;
            classVideos[i]['at'] = imageUrl;
            classVideos[i]['desc'] = sectionDesc;
          }
        }

        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("sessionContent")
            .doc(currentUser!.uid)
            .collection('classes')
            .doc(ExpertEditConstants.docId);
        documentReference.set({
          'class': classVideos,
        }, SetOptions(merge: true)).whenComplete(() {
          setState(() {
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: 'Section $sectionCount replaced successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);

          setState(() {
            imageUrl = null;
            videoUrl = null;

            pickedVideo = null;
            pickedImage = null;

            ExpertConstants.classId = documentReference.id;
            Constants.uploadImageTask = null;
            Constants.uploadTask = null;
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EditSections()));
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
}
