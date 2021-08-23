import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/edit_expert_sections.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class EditClassAttachment extends StatefulWidget {
  final int attachmentIndex;
  final String? attachment;
  final List<dynamic> classVideos;

  EditClassAttachment({
    required this.attachmentIndex,
    required this.attachment,
    required this.classVideos,
  });

  @override
  _EditClassAttachmentState createState() => _EditClassAttachmentState(
        classVideos: classVideos,
        attachmentIndex: attachmentIndex,
        attachment: attachment,
      );
}

class _EditClassAttachmentState extends State<EditClassAttachment> {
  List<dynamic> classVideos;
  int attachmentIndex;
  String? attachment;

  _EditClassAttachmentState({
    required this.classVideos,
    required this.attachmentIndex,
    required this.attachment,
  });

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  String get fileImagePaths => 'expertThumbnail/${DateTime.now()}';

  late UploadTask uploadTask;
  String? url;
  File? imageURI;
  bool checkUrl = false;
  Future getImageFromGallery() async {
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

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageURI = file;
        checkUrl = true;
      });

      print('this is the pdf selected $imageURI');
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  bool _publishModal = false;
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
                        OutlineButton(
                            onPressed: () {
                              deleteAttachment();
                            },
                            child: Text(
                              'Delete note',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                color: kFbColor,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
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
                      ],
                    ),
                    spacer(),
                    checkUrl == false
                        ? Column(
                            children: <Widget>[
                              widget.attachment == null
                                  ? GestureDetector(
                                      onTap: () {
                                        getImageFromGallery();
                                      },
                                      child: SvgPicture.asset(
                                        'images/company/companylogo.svg',
                                      ),
                                    )
                                  : GestureDetector(
                                      child: PDF.network(
                                      widget.attachment!,
                                      placeHolder: Center(
                                          child: CircularProgressIndicator()),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      width: double.infinity,
                                    ))
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              PDF.file(
                                imageURI!,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: double.infinity,
                              ),
                            ],
                          ),
                    spacer(),
                    spacer(),
                    spacer(),
                    CoursePublishBtn(
                      title: 'Update',
                      publish: () {
                        editAttachment();
                      },
                    ),
                    spacer(),
                  ],
                )),
              ),
            )));
  }

  Future<void> editAttachment() async {
    if (imageURI == null) {
      print('this is imageurl $imageURI');
      Fluttertoast.showToast(
          msg: 'No changes made',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        _publishModal = true;
      });
      try {
        Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
        uploadTask = ref.putFile(
          imageURI!,
          SettableMetadata(
            contentType: 'videos/mp4',
          ),
        );

        final TaskSnapshot downloadUrl = (await uploadTask);
        url = (await downloadUrl.ref.getDownloadURL());

        /*update the database*/

        //ExpertLecture expertLecture = ExpertLecture();

        for (int i = 0; i < classVideos.length; i++) {
          if (i == attachmentIndex) {
            classVideos[i]['at'] = url;
          }
        }

        try {
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('sessionContent')
              .doc(UploadVariables.currentUser)
              .collection('classes')
              .doc(ExpertEditConstants.docId);

          //DocumentSnapshot editDoc = await documentReference.get();

          documentReference.set({
            'class': classVideos,
          }, SetOptions(merge: true)).whenComplete(() {
            setState(() {
              _publishModal = false;
            });

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.topToBottom,
                child: EditSections(),
              ),
            );
          }).catchError((e) {
            setState(() {
              _publishModal = false;
            });

            print('Error: ${e.toString()}');
          });
        } catch (e) {
          setState(() {
            _publishModal = false;
          });

          Fluttertoast.showToast(
              msg: 'Sorry an error occured in updating section video.',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      } catch (e) {}
    }
  }

  void deleteAttachment() {}
}
