import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/Course_message.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:video_player/video_player.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseDescriptionThird extends StatefulWidget {
  @override
  _CourseDescriptionThirdState createState() => _CourseDescriptionThirdState();
}

class _CourseDescriptionThirdState extends State<CourseDescriptionThird> {
  String get filePaths => 'courseVideos/${DateTime.now()}';
  String get fileImagePaths => 'Attachment/${DateTime.now()}';
  bool success = false;
  bool videoSuccess = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
  }

  Widget space() {
    return SizedBox(height: ScreenUtil().setHeight(20));
  }

  File? imageURI;
  File? videoUrl;

  Future getImageFromGallery() async {
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

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageURI = file;
        Constants.promotionThumbnail = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
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

    int fileSize = file!.lengthSync();
    if (fileSize <= kSVideoSize) {
      setState(() {
        videoUrl = file;
        Constants.promotionVideoFile = file;
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            space(),

            ///course thumbnail
            Column(children: <Widget>[
              SingleChildScrollView(
                child: Container(
                    child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Text(kSCourseThumbnail,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextcolorhintcolor,
                              fontSize: kFontsize.sp,
                            ),
                          )),
                    ),
                    space(),
                    Text('Your promotion thumbnail and video',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFacebookcolor,
                            fontSize: kFontsize.sp,
                          ),
                        )),
                    imageURI == null
                        ? GestureDetector(
                            onTap: () {
                              getImageFromGallery();
                            },
                            child: Image(
                              image: AssetImage(
                                  'images/classroom/tumbnail_picker.png'),
                              height: 44.0,
                              width: 45.0,
                            ),
                          )
                        : Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  getImageFromGallery();
                                },
                                child: Container(
                                    //margin: EdgeInsets.only(bottom: kIconThumbnail),
                                    //alignment:Alignment.topRight,
                                    child: SvgPicture.asset(
                                  'images/classroom/edit_add.svg',
                                  height: kIconThumbnail,
                                )),
                              ),
                              InkWell(
                                onTap: () {
                                  getImageFromGallery();
                                },
                                child: Image.file(
                                  imageURI!,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ],
                          ),
                    space(),
                    videoUrl == null
                        ? GestureDetector(
                            onTap: () {
                              getVideo();
                            },
                            child: SvgPicture.asset(
                              'images/company/companylogo.svg',
                            ))
                        : Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  getVideo();
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.only(bottom: 5, right: 20),
                                    alignment: Alignment.topRight,
                                    child: SvgPicture.asset(
                                      'images/classroom/edit_add.svg',
                                      height: kIconThumbnail,
                                    )),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Stack(
                                  children: <Widget>[
                                    imageURI == null
                                        ? Center(
                                            child: ShowUploadedVideo(
                                              videoPlayerController:
                                                  VideoPlayerController.file(
                                                      videoUrl!),
                                              looping: false,
                                            ),
                                          )
                                        : InkWell(
                                            child: Image.file(
                                              imageURI!,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
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
                            ],
                          ),
                  ],
                )),
              ),
            ]),

            ///Next button
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            CourseNextButton(
              next: () {
                if ((imageURI == null) || (videoUrl == null)) {
                  Fluttertoast.showToast(
                      msg: 'Please pick your promotion video and thumbnail',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: kBlackcolor,
                      textColor: kFbColor);
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CourseMessage()));
                }
              },
            ),

            SizedBox(height: ScreenUtil().setHeight(10)),
          ],
        ),
      ),
    ));
  }
}
