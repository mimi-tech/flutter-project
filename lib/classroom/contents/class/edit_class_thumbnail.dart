import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/classroom/contents/class/edit_class_note.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/expert_class/expert_note.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparks/classroom/expert_class/expert_constants/expert_btn.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:page_transition/page_transition.dart';

class EditExpertThumbnail extends StatefulWidget {
  @override
  _EditExpertThumbnailState createState() => _EditExpertThumbnailState();
}

class _EditExpertThumbnailState extends State<EditExpertThumbnail> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  String get filePaths => 'expertVideos/${DateTime.now()}';
  String get fileImagePaths => 'expertThumbnail/${DateTime.now()}';
  File? videoUrl;
  bool videoSuccess = false;
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

    //ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSVideoSize) {
      setState(() {
        ExpertConstants.videoFile = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  /*for the video thumbnail*/

  File? imageURI;

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
        ExpertConstants.imageFile = file;
      });

      /*upload to fireBase*/

      setState(() {
        videoSuccess = true;
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
            appBar: EditExpertAppBar(
              detailsColor: kFbColor,
              videoColor: kBlackcolor,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ExpertEditConstants.tmb != null &&
                              ExpertConstants.imageFile == null
                          ? GestureDetector(
                              onTap: () {
                                getImageFromGallery();
                              },
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                imageUrl: ExpertEditConstants.tmb!,
                                fit: BoxFit.cover,
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setHeight(100),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                getImageFromGallery();
                              },
                              child: Image.file(
                                ExpertConstants.imageFile!,
                                width: MediaQuery.of(context).size.width * 0.19,
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                fit: BoxFit.cover,
                              ),
                            ),
                      SizedBox(width: 10.0),
                      OutlineButton(
                        onPressed: () {
                          getImageFromGallery();
                        },
                        child: ExpertConstants.imageFile == null
                            ? GestureDetector(
                                onTap: () {
                                  getImageFromGallery();
                                },
                                child: Text(
                                  'change thumbnail',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: kFontsize.sp,
                                    color: kExpertColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ExpertConstants.imageFile = null;
                                  });
                                },
                                child: Text(
                                  'Delete thumbnail',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: kFontsize.sp,
                                    color: kFbColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                  ExpertTitle(
                    title: kExpertPromotionalVideo,
                  ),
                  spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 12),
                    alignment: Alignment.topRight,
                    child: OutlineButton(
                      onPressed: () {
                        getVideo();
                      },
                      child: ExpertConstants.videoFile == null
                          ? GestureDetector(
                              onTap: () {
                                getVideo();
                              },
                              child: Text(
                                'change video',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  color: kExpertColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  ExpertConstants.videoFile = null;
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
                  ),
                  ExpertEditConstants.promoVideo != null &&
                          ExpertConstants.videoFile == null
                      ? Container(
                          height:
                              MediaQuery.of(context).size.height * kVideoHeight,
                          child: Stack(
                            children: <Widget>[
                              ExpertEditConstants.tmb == null
                                  ? Center(
                                      child: ShowUploadedVideo(
                                        videoPlayerController:
                                            VideoPlayerController.network(
                                                ExpertEditConstants.promoVideo!),
                                        looping: false,
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      imageUrl: ExpertEditConstants.tmb!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: ScreenUtil().setHeight(400),
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
                                          ExpertEditConstants.promoVideo;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayingVideos()));
                                    },
                                    child: Icon(Icons.play_arrow, size: 40)),
                              )),
                            ],
                          ),
                        )
                      : Container(
                          height:
                              MediaQuery.of(context).size.width * kVideoHeight,
                          child: Stack(
                            children: <Widget>[
                              ExpertConstants.imageFile == null
                                  ? Center(
                                      child: ShowUploadedVideo(
                                        videoPlayerController:
                                            VideoPlayerController.file(
                                                ExpertConstants.videoFile!),
                                        looping: false,
                                      ),
                                    )
                                  : InkWell(
                                      child: Image.file(
                                        ExpertConstants.imageFile!,
                                        height: ScreenUtil().setHeight(250),
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
                                    onPressed: () {},
                                    child: Icon(Icons.play_arrow, size: 40)),
                              )),
                            ],
                          ),
                        ),
                  spacer(),
                  spacer(),
                  ExpertBtn(
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
    if ((ExpertConstants.imageFile == null) &&
        (ExpertEditConstants.tmb == null)) {
      Fluttertoast.showToast(
          msg: kImageError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          timeInSecForIosWeb: 10,
          textColor: kFbColor);
    } else if ((ExpertConstants.videoFile == null) &&
        (ExpertEditConstants.promoVideo == null)) {
      Fluttertoast.showToast(
          msg: kVideoError,
          timeInSecForIosWeb: 10,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.topToBottom, child: EditExpertNote()));
    }
  }
}
