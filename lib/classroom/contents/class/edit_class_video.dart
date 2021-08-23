import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/contents/class/edit_expert_sections.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:video_player/video_player.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';

class EditClassVideo extends StatefulWidget {
  final List<dynamic> classVideos;
  final int videoIndex;
  final String? video;

  EditClassVideo({
    required this.classVideos,
    required this.videoIndex,
    required this.video,
  });

  @override
  _EditClassVideoState createState() => _EditClassVideoState(
        classVideos: classVideos,
        videoIndex: videoIndex,
        video: video,
      );
}

class _EditClassVideoState extends State<EditClassVideo> {
  List<dynamic> classVideos;
  int videoIndex;
  String? video;

  _EditClassVideoState({
    required this.classVideos,
    required this.videoIndex,
    required this.video,
  });

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  String get filePaths => 'expertVideos/${DateTime.now()}';

  late UploadTask uploadTask;
  String? url;
  File? videoUrl;
  bool checkUrl = false;
  Future getImageFromGallery() async {
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

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        videoUrl = file;
        checkUrl = true;
      });

      print('videoUrl: $videoUrl');
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
                    OutlineButton(
                      onPressed: () {
                        getImageFromGallery();
                      },
                      child: videoUrl == null
                          ? Text(
                              'change video',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                color: kFbColor,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  videoUrl = null;
                                });
                              },
                              child: Text(
                                'cancel video',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  color: kFbColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                    ),
                    spacer(),
                    spacer(),
                    checkUrl == false
                        ? Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: ShowUploadedVideo(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            widget.video!),
                                    looping: false,
                                  ),
                                ),
                              ),
                              Center(
                                  child: ButtonTheme(
                                shape: CircleBorder(),
                                height: ScreenUtil().setHeight(100),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      UploadVariables.videoUrlSelected =
                                          widget.video;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayingVideos()));
                                    },
                                    child: Icon(Icons.play_arrow, size: 40)),
                              )),
                            ],
                          )
                        : Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: ShowUploadedVideo(
                                    videoPlayerController:
                                        VideoPlayerController.file(videoUrl!),
                                    looping: false,
                                  ),
                                ),
                              ),
                              Center(
                                  child: ButtonTheme(
                                shape: CircleBorder(),
                                height: ScreenUtil().setHeight(100),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    child: Icon(Icons.play_arrow, size: 40)),
                              )),
                            ],
                          ),
                    spacer(),
                    spacer(),
                    spacer(),
                    CoursePublishBtn(
                      title: 'Update',
                      publish: () {
                        editVideo();
                      },
                    ),
                    spacer(),
                  ],
                )),
              ),
            )));
  }

  Future<void> editVideo() async {
    if (videoUrl == null) {
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
        Reference ref = FirebaseStorage.instance.ref().child(filePaths);
        uploadTask = ref.putFile(
          videoUrl!,
          SettableMetadata(
            contentType: 'videos/mp4',
          ),
        );

        final TaskSnapshot downloadUrl = (await uploadTask);
        url = (await downloadUrl.ref.getDownloadURL());

        /*update the database*/

        //ExpertLecture expertLecture = ExpertLecture();

        for (int i = 0; i < classVideos.length; i++) {
          if (i == videoIndex) {
            classVideos[i]['vido'] = url;
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
