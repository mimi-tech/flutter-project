import 'dart:async';
import 'dart:io';
import 'package:sparks/classroom/courses/Course_message.dart';
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

class PromotionVideo extends StatefulWidget {
  @override
  _PromotionVideoState createState() => _PromotionVideoState();
}

class _PromotionVideoState extends State<PromotionVideo> {
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
    Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
  }

  File? videoUrl;

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
        videoSuccess = false;
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
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CourseAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
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
                  child: videoUrl == null
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
                                          VideoPlayerController.file(videoUrl!),
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
                                        child:
                                            Icon(Icons.play_arrow, size: 40)),
                                  )),
                                ],
                              ),
                            ),
                            videoSuccess == false
                                ? Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            _uploadVideo();
                                          },
                                          child: Icon(Icons.file_upload,
                                              size: 50, color: kMaincolor)),
                                      Text('Upload',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBlackcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ))
                                    ],
                                  )
                                : CoursePromotionIndicator(),
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
        ],
      ),
    ));
  }

  void _uploadVideo() {
    setState(() async {
      videoSuccess = true;
      try {
        Reference ref = FirebaseStorage.instance.ref().child(filePaths);
        Constants.coursePromotion = ref.putFile(
          videoUrl!,
          SettableMetadata(
            contentType: 'video.mp4',
          ),
        );

        final TaskSnapshot downloadUrl = (await Constants.coursePromotion!);
        Constants.coursePromotionUrl = (await downloadUrl.ref.getDownloadURL());
      } catch (e) {
        print(e);
      }
    });
  }

  void nextScreen() {
    if ((Constants.coursePromotionUrl == null) ||
        (Constants.coursePromotionUrl == '')) {
      Fluttertoast.showToast(
          msg: kSCoursePromotion,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CourseMessage()));
    }
  }
}
