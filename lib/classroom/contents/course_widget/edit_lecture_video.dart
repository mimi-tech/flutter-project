import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_promotion_indicator.dart';

import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_player/video_player.dart';

class EditLectureVideo extends StatefulWidget {
  final List<Section>? currentSections;
  final Course? currentLectures;
  final int? currentIndexOfLectures;

  final String sectionCount;
  final int sectionCountInt;
  final String? video;

  EditLectureVideo({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.sectionCount,
    required this.sectionCountInt,
    required this.video,
  });

  @override
  _EditLectureVideoState createState() => _EditLectureVideoState(
        currentLectures: currentLectures,
        currentIndexOfLectures: currentIndexOfLectures,
        currentSections: currentSections,
        sectionCount: sectionCount,
        sectionCountInt: sectionCountInt,
        video: video,
      );
}

class _EditLectureVideoState extends State<EditLectureVideo> {
  List<Section>? currentSections;
  final Course? currentLectures;
  final int? currentIndexOfLectures;

  final String sectionCount;
  final int sectionCountInt;
  String? video;

  _EditLectureVideoState({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.sectionCount,
    required this.sectionCountInt,
    required this.video,
  });

  String get filePaths => 'courseVideos/${DateTime.now()}';

  bool videoSuccess = false;

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  File? videoUrl;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Constants.coursePromotion = null;
  }

  bool _publishModal = false;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        color: KLightermaincolor,
                        textColor: Colors.white,
                        onPressed: () {
                          getVideo();
                        },
                        child: Text('Pick Video',
                            style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                              color: kBlackcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsize.sp,
                            )))),

                    Constants.coursePromotionUrl == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: ShowUploadedVideo(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            widget.video!),
                                    looping: false,
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
                                        getVideo();
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          UploadVariables.videoUrlSelected =
                                              widget.video;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayingVideos()));
                                        },
                                        child: Icon(Icons.play_arrow, size: 40),
                                      )),
                                )),
                              ],
                            ),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: ShowUploadedVideo(
                                        videoPlayerController:
                                            VideoPlayerController.network(
                                                widget.video!),
                                        looping: false,
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
                                            getVideo();
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              UploadVariables.videoUrlSelected =
                                                  Constants.coursePromotionUrl;
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayingVideos()));
                                            },
                                            child: Icon(Icons.play_arrow,
                                                size: 40),
                                          )),
                                    )),
                                  ],
                                ),
                              ),
                              CoursePromotionIndicator(),
                            ],
                          ),

                    ///Next button
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      height: ScreenUtil().setHeight(50),
                      width: double.infinity,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            kUpdate,
                            style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                              color: kWhitecolor,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsize.sp,
                            )),
                          ),
                          color: kFbColor,
                          onPressed: () {
                            _updateVideo();
                          }),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getVideo() async {
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

    String _path = file.toString();

    String fileName = _path.split('/').last;

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSVideoSize) {
      setState(() {
        videoUrl = file;
      });

      try {
        setState(() async {
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          Constants.coursePromotion = ref.putFile(
            file!,
            SettableMetadata(
              contentType: 'video.mp4',
            ),
          );

          final TaskSnapshot downloadUrl = (await Constants.coursePromotion!);
          Constants.coursePromotionUrl =
              (await downloadUrl.ref.getDownloadURL());
        });
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  void _updateVideo() async {
    if (videoUrl == null) {
      Fluttertoast.showToast(
          msg: kSEditSectionError1,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);

      /// TODO: Ellis to Miriam = The logic for this code block has been changed, please refer to the documentation
      // } else if (Constants.coursePromotion.isInProgress) {
      //   Fluttertoast.showToast(
      //       msg: kSEditSectionError2,
      //       toastLength: Toast.LENGTH_LONG,
      //       backgroundColor: kBlackcolor,
      //       textColor: kFbColor);
    } else {
      /*go ahead and update section video*/

      // Constants.coursePromotionUrl

      setState(() {
        _publishModal = true;
      });

      // will use currentIndex
      User currentUser = FirebaseAuth.instance.currentUser!;

      Course copyLectures = currentLectures!;
      Course editedLectures = Course();
      List<Section> globalEditedSections = [];

      for (int i = 0; i < copyLectures.lectures.length; i++) {
        Lecture editedLecture = Lecture();
        List<Section> editedSections = [];

        for (int j = 0; j < copyLectures.lectures[i].sections.length; j++) {
          if ((i == widget.currentIndexOfLectures) && (j == sectionCountInt)) {
            copyLectures.lectures[i].sections[j].vido =
                Constants.coursePromotionUrl;
            editedSections.add(copyLectures.lectures[i].sections[j]);
          } else {
            editedSections.add(copyLectures.lectures[i].sections[j]);
          }
        }

        if (editedSections.length != 0) {
          editedLecture.sections.addAll(editedSections);
          editedLectures.lectures.add(editedLecture);
          //editedLectures.lectures[i].sections.addAll(editedSections); // before

        }

        if (i == widget.currentIndexOfLectures) {
          globalEditedSections = editedSections;
        }
      }

      List<Map> editedLecturesLM = [];
      List<int> lC = [];

      for (int i = 0; i < editedLectures.lectures.length; i++) {
        for (int j = 0; j < editedLectures.lectures[i].sections.length; j++) {
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
            .doc(currentUser.uid)
            .collection('courses')
            .doc(Constants.docId);

        //DocumentSnapshot editDoc = await documentReference.get();

        documentReference.set({
          'Lc': lC,
          'lectures': editedLecturesLM,
        }, SetOptions(merge: true)).whenComplete(() {
          setState(() {
            _publishModal = false;
            currentSections = globalEditedSections;
          });

          Navigator.pop(context);
        }).catchError((e) {
          setState(() {
            _publishModal = false;
          });

          print('Error: ${e.toString()}');

          Fluttertoast.showToast(
              msg: 'Sorry an error occured',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
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
