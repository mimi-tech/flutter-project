import 'dart:async';
import 'dart:io';

import 'package:sparks/classroom/contents/course_widget/message.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';

import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_promotion_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CoursePromotionVideo extends StatefulWidget {
  @override
  _CoursePromotionVideoState createState() => _CoursePromotionVideoState();
}

class _CoursePromotionVideoState extends State<CoursePromotionVideo> {
  String get filePaths => 'courseVideos/${DateTime.now()}';

  bool videoSuccess = false;

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
  }

  late File videoUrl;

  Future getVideo() async {
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

    String _path = file.toString();

    String fileName = _path.split('/').last;

    //ToDo: send to fireBase storage
    int fileSize = file.lengthSync();
    if (fileSize <= kSVideoSize) {
      setState(() async {
        try {
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          Constants.coursePromotion = ref.putFile(
            videoUrl,
            SettableMetadata(
              contentType: 'video.mp4',
            ),
          );

          final TaskSnapshot downloadUrl = (await Constants.coursePromotion!);
          Constants.courseEditVideo = (await downloadUrl.ref.getDownloadURL());
        } catch (e) {
          print(e);
        }
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Constants.coursePromotion = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: UpdateCourse(),
      appBar: EditAppBar(
        detailsColor: kStabcolor,
        videoColor: kBlackcolor,
        updateColor: kBlackcolor,
        addColor: kBlackcolor,
        publishColor: kBlackcolor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(50)),
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 2.0,
                    color: klistnmber,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Constants.courseEditVideo == null
                    ? Column(
                        children: <Widget>[
                          Text(kSCoursePromotionVideo,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTextcolorhintcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )),
                          GestureDetector(
                            onTap: () {
                              getVideo();
                            },
                            child: SvgPicture.asset(
                              'images/company/companylogo.svg',
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Text(kSCoursePromotionVideo,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTextcolorhintcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.5,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: ShowUploadedVideo(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            Constants.courseEditVideo!),
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
                                      child: Icon(Icons.play_arrow, size: 40)),
                                )),
                              ],
                            ),
                          ),
                          CoursePromotionIndicator(),
                        ],
                      )),

            ///Next button
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            CourseNextButton(
              next: () {
                nextScreen();
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
          ],
        ),
      ),
    ));
  }

  void nextScreen() {
    if ((Constants.courseEditVideo == null) ||
        (Constants.courseEditVideo == '')) {
      Fluttertoast.showToast(
          msg: kSCoursePromotion,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditCourseMessage()));
    }
  }
}
