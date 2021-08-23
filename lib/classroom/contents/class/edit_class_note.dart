import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';

import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_btn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/classroom/contents/class/edit_message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/courses/course_promotion_indicator.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';

import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditExpertNote extends StatefulWidget {
  @override
  _EditExpertNoteState createState() => _EditExpertNoteState();
}

class _EditExpertNoteState extends State<EditExpertNote> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool videoSuccess = false;

  File? imageURI;
  String get fileImagePaths => 'expertNote/${DateTime.now()}';
  Future getImageFromGallery() async {
    var image;
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

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() async {
        imageURI = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Constants.courseThumbnail = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: EditExpertAppBar(
              detailsColor: kFbColor,
              videoColor: kBlackcolor,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  spacer(),
                  spacer(),
                  Text(
                    kNote,
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kExpertColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Text(
                      kNoteText,
                      style: GoogleFonts.rajdhani(
                        fontSize: kFontsize.sp,
                        color: kBlackcolor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  spacer(),
                  ExpertEditConstants.note != null || imageURI == null
                      ? GestureDetector(
                          child: PDF.network(
                          ExpertEditConstants.note!,
                          placeHolder:
                              Center(child: CircularProgressIndicator()),
                          height:
                              MediaQuery.of(context).size.height * kVideoHeight,
                          width: double.infinity,
                        ))
                      : PDF.file(
                          imageURI!,
                          height:
                              MediaQuery.of(context).size.height * kVideoHeight,
                          width: double.infinity,
                        ),
                  spacer(),
                  CoursePromotionIndicator(),
                  spacer(),
                  OutlineButton(
                    onPressed: () {
                      getImageFromGallery();
                    },
                    child: imageURI == null
                        ? Text(
                            'change note',
                            style: GoogleFonts.rajdhani(
                              fontSize: kFontsize.sp,
                              color: kFbColor,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                imageURI = null;
                              });
                            },
                            child: Text(
                              'cancel note',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                color: kFbColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                  ),
                  spacer(),
                  videoSuccess == true
                      ? ProgressIndicatorState()
                      : ExpertBtn(
                          next: () {
                            nextPage();
                          },
                          bgColor: kExpertColor,
                        ),
                  spacer(),
                ],
              ),
            )));
  }

  Future<void> nextPage() async {
    if ((imageURI == null) && (ExpertEditConstants.note == null)) {
      Fluttertoast.showToast(
          msg: kNoteError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        videoSuccess = true;
      });
      Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
      Constants.courseThumbnail = ref.putFile(
        imageURI!,
        SettableMetadata(
          contentType: 'images.pdf',
        ),
      );

      final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
      ExpertConstants.note = (await downloadUrl.ref.getDownloadURL());
      setState(() {
        videoSuccess = false;
      });

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.topToBottom,
              child: EditExpertMessage()));
    }
  }
}
