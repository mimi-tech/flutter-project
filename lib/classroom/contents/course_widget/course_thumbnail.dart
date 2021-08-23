import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/classroom/contents/course_widget/promotion_video.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/next_button.dart';

import 'package:sparks/classroom/courses/thumbnail_progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseThumbnail extends StatefulWidget {
  @override
  _CourseThumbnailState createState() => _CourseThumbnailState();
}

class _CourseThumbnailState extends State<CourseThumbnail> {
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
        try {
          Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
          Constants.courseThumbnail = ref.putFile(
            imageURI!,
            SettableMetadata(
              contentType: 'images.pdf',
            ),
          );

          final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
          Constants.courseEditThumbnail =
              (await downloadUrl.ref.getDownloadURL());
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
    Constants.courseThumbnail = null;
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

                  ///course thumbnail
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
                    child: Constants.courseEditThumbnail == ''
                        ? Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(kSCourseThumbnail,
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
                                    getImageFromGallery();
                                  },
                                  child: SvgPicture.asset(
                                    'images/company/companylogo.svg',
                                  )),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Text(kSCourseThumbnail,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kTextcolorhintcolor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  )),
                              space(),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: InkWell(
                                      onTap: () {
                                        getImageFromGallery();
                                      },
                                      child: PDF.network(
                                        Constants.courseEditThumbnail!,
                                        placeHolder: Center(
                                            child: CircularProgressIndicator()),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        width: double.infinity,
                                      ),

                                      /*FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              image: (Constants.courseEditThumbnail),
                              placeholder: 'images/classroom/placeholder.jpg',
                            ),*/
                                    ),
                                  ),
                                ],
                              ),
                              space(),
                              ThumbnailProgressIndicator(),
                            ],
                          ),
                  ),

                  ///Next button
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.15,
                  ),
                  CourseNextButton(
                    next: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CoursePromotionVideo()));
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  space(),

                  ///Next button
                ],
              ),
            )));
  }
}
