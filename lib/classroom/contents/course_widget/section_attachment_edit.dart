import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_promotion_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';

class EditLectureAttachment extends StatefulWidget {
  final List<Section>? currentSections;
  final Course? currentLectures;
  final int? currentIndexOfLectures;

  final String sectionCount;
  final int sectionCountInt;
  final String? attachment;

  EditLectureAttachment({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.sectionCount,
    required this.sectionCountInt,
    required this.attachment,
  });

  @override
  _EditLectureAttachmentState createState() => _EditLectureAttachmentState(
        currentLectures: currentLectures,
        currentIndexOfLectures: currentIndexOfLectures,
        currentSections: currentSections,
        sectionCount: sectionCount,
        sectionCountInt: sectionCountInt,
        attachment: attachment,
      );
}

class _EditLectureAttachmentState extends State<EditLectureAttachment> {
  List<Section>? currentSections;
  final Course? currentLectures;
  final int? currentIndexOfLectures;

  final String sectionCount;
  final int sectionCountInt;
  String? attachment;

  _EditLectureAttachmentState({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.sectionCount,
    required this.sectionCountInt,
    required this.attachment,
  });

  String get filePaths => 'courseVideos/${DateTime.now()}';
  String? url;
  bool videoSuccess = false;

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  File? imageUrl;
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
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          getVideo();
                        },
                        child:
                            SvgPicture.asset('images/classroom/edit_add.svg')),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    GestureDetector(
                      onTap: () {
                        getVideo();
                      },
                      child: Text(
                        'Edit',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(30),
                    ),
                    GestureDetector(
                        onTap: () {
                          deleteAttachment();
                        },
                        child: Icon(
                          Icons.delete,
                          color: kFbColor,
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteAttachment();
                      },
                      child: Text(
                        'Delete',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Text(
                    'Lecture ${(currentIndexOfLectures! + 1).toString()}' +
                        " " +
                        widget.sectionCount +
                        " " +
                        'video attachemt',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kStabcolor,
                        fontSize: kFontsize.sp,
                      ),
                    )),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                widget.attachment == "" && imageUrl == null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        height: ScreenUtil().setHeight(200),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: klistnmber,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Text(
                            kNoAttachment,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          ),
                        ))
                    : Text(''),

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
                    child: imageUrl == null
                        ? Container(
                            child: Center(
                            child: PDF.network(
                              widget.attachment!,
                              placeHolder:
                                  Center(child: CircularProgressIndicator()),
                              height:
                                  MediaQuery.of(context).size.height * kPdfSize,
                              width: double.infinity,
                            ),
                          )

                            /*CachedNetworkImage(
                        placeholder: (context, url) =>  CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>  Icon(Icons.error),
                        imageUrl: widget.attachment,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.5,
                      ),*/

                            )
                        : Column(
                            children: <Widget>[
                              PDF.file(
                                imageUrl!,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: double.infinity,
                              ),
                              /* InkWell(
                        child:Image.file(imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.5,
                    )
                    ),*/
                            ],
                          )),
                CoursePromotionIndicator(),

                ///Next button
                SizedBox(
                  height: ScreenUtil().setHeight(20),
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
                        _updateAttachment();
                      }),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getVideo() async {
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
    if (fileSize <= kSVideoSize) {
      setState(() {
        imageUrl = file;
      });
      try {
        setState(() async {
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          Constants.coursePromotion = ref.putFile(
            file!,
            SettableMetadata(
              contentType: 'images.pdf',
            ),
          );

          final TaskSnapshot downloadUrl = (await Constants.coursePromotion!);
          url = (await downloadUrl.ref.getDownloadURL());
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

  void _updateAttachment() async {
    if (imageUrl == null) {
      Fluttertoast.showToast(
          msg: kSEditSectionError1,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);

      /// TODO: The way to implement this has changed, please refer to the documentation
      // } else if (Constants.coursePromotion.isInProgress) {
      //   Fluttertoast.showToast(
      //       msg: kSEditSectionError2,
      //       toastLength: Toast.LENGTH_LONG,
      //       backgroundColor: kBlackcolor,
      //       textColor: kFbColor);
    } else {
      /*go ahead and update section video*/

      setState(() {
        _publishModal = true;
      });

      /// sectionCountInt

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
            copyLectures.lectures[i].sections[j].at = url;
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

  Future<void> deleteAttachment() async {
    /*show delete dialog to the user*/
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  DeleteDialogSecond(oneDelete: () async {
                    Navigator.pop(context);

                    setState(() {
                      _publishModal = true;
                    });

                    /// sectionCountInt

                    // will use currentIndex
                    User currentUser = FirebaseAuth.instance.currentUser!;

                    Course copyLectures = currentLectures!;
                    Course editedLectures = Course();
                    List<Section> globalEditedSections = [];

                    for (int i = 0; i < copyLectures.lectures.length; i++) {
                      Lecture editedLecture = Lecture();
                      List<Section> editedSections = [];

                      for (int j = 0;
                          j < copyLectures.lectures[i].sections.length;
                          j++) {
                        if ((i == widget.currentIndexOfLectures) &&
                            (j == sectionCountInt)) {
                          copyLectures.lectures[i].sections[j].at = "";
                          editedSections
                              .add(copyLectures.lectures[i].sections[j]);
                        } else {
                          editedSections
                              .add(copyLectures.lectures[i].sections[j]);
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
                      for (int j = 0;
                          j < editedLectures.lectures[i].sections.length;
                          j++) {
                        Map editedLecture = {
                          'lecture': ([
                            {
                              'vido':
                                  editedLectures.lectures[i].sections[j].vido,
                              'Sc': j + 1,
                              'title':
                                  editedLectures.lectures[i].sections[j].title,
                              'at': editedLectures.lectures[i].sections[j].at,
                              'name':
                                  editedLectures.lectures[i].sections[j].name,
                              'Lcount': i + 1,
                            }
                          ])
                        };

                        editedLecturesLM.add(editedLecture);
                      }

                      lC.add(i + 1);
                    }

                    try {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
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
                  }),
                ]));
  }
}
