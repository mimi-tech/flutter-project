import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';
import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/progress_indicator.dart';
import 'package:sparks/classroom/courses/progress_indicator2.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_appbar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/golive/publishcongratulation.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertUpload extends StatefulWidget {
  @override
  _ExpertUploadState createState() => _ExpertUploadState();
}

class _ExpertUploadState extends State<ExpertUpload> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  String? sectionTitle;
  String? sectionDesc;
  int sectionCount = 1;
  String? videoUrl;
  File? pickedVideo;
  File? pickedImage;
  bool _publishModal = false;
  String? imageUrl;
  List<dynamic>? classes;
  String get filePaths => 'ExpertVideos/${DateTime.now()}';

  String get fileImagePaths => 'ExpertAttachment/${DateTime.now()}';
  String get fileThumbnail => 'expertThumbnail/${DateTime.now()}';
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  Future<void> _uploadVideo() async {
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

    //UploadVariables.fileName = file;

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        pickedVideo = file;
      });
      Reference ref = FirebaseStorage.instance.ref().child(filePaths);
      Constants.uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'videos/mp4',
        ),
      );

      final TaskSnapshot downloadUrl = await Constants.uploadTask!;
      videoUrl = await downloadUrl.ref.getDownloadURL();
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  /*uploading image*/

  Future<void> _selectImage() async {
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

    UploadVariables.fileName = file;

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        pickedImage = file;
      });
      Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
      Constants.uploadImageTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'images.pdf',
        ),
      );

      final TaskSnapshot downloadUrl = await Constants.uploadImageTask!;
      imageUrl = await downloadUrl.ref.getDownloadURL();
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  /*getting the month name*/
  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobar',
    'Novermber',
    'December'
  ];
  var currentMon = now.month;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAppBar(),
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
                          pickedVideo == null
                              ? OutlineButton(
                                  onPressed: () {
                                    _uploadVideo();
                                  },
                                  child: Text(
                                    'pick Video',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontsize.sp,
                                      color: kExpertColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : CourseUploadingProgress(),
                          pickedImage == null
                              ? OutlineButton(
                                  onPressed: () {
                                    _selectImage();
                                  },
                                  child: Text(
                                    'pick attachment',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: kFontsize.sp,
                                      color: kExpertColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : CourseSecondUploadingProgress(),
                        ],
                      ),

                      ///section title

                      spacer(),

                      ExpertTitle(
                        title: kClassSectionTitle,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: title,
                          maxLength: 200,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            sectionTitle = value;
                          },
                        ),
                      ),
                      spacer(),

                      ///section desc

                      spacer(),

                      ExpertTitle(
                        title: kClassSectionDesc,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: desc,
                          maxLength: 300,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            sectionDesc = value;
                          },
                        ),
                      ),
                      spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(kSCourseSection + " ",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )),
//ToDo:counting of section

                          Text(sectionCount.toString(),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor2,
                                  fontSize: 22.sp,
                                ),
                              )),

                          AddIcon(iconFunction: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            countingSection();
                          })
                        ],
                      ),

                      spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: Text(
                            'Note: Please tap on publish when you are through with adding  all your sections for this class',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            )),
                      ),

                      spacer(),

                      CoursePublishBtn(
                        title: kPublish2,
                        publish: () {
                          nextPage();
                        },
                      ),

                      spacer(),
                    ],
                  ),
                ),
              ),
            )));
  }

  void countingSection() {
    /*check if input is empty*/

    if ((sectionTitle == null) || (sectionTitle == '')) {
      Fluttertoast.showToast(
          msg: 'Please' + " " + kClassSectionTitle,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((sectionDesc == null) || (sectionDesc == '')) {
      Fluttertoast.showToast(
          msg: 'Please' + " " + kClassSectionDesc,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (videoUrl == null) {
      Fluttertoast.showToast(
          msg: 'Please pick your video',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((Constants.uploadTask!.snapshot.state == TaskState.running) ||
        (Constants.uploadImageTask!.snapshot.state == TaskState.running)) {
      Fluttertoast.showToast(
          msg: 'Upload in progress',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: Center(
                    child: Text('Section' +
                        sectionCount.toString() +
                        " " +
                        'completed?')),
                content: Text(kSCourseCheckSection,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kBlackcolor,
                        fontSize: kFontsize.sp,
                      ),
                    )),
                actions: <Widget>[
                  LectureDialog(
                    title: kSYes,
                    bgColor: kFbColor,
                    upload: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.pop(context);
                      addData();
                    },
                  ),
                  LectureDialog(
                    title: kSNo,
                    bgColor: klistnmber,
                    upload: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
    }
  }

  Future<void> addData() async {
    /*start uploading sections to database*/
    User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _publishModal = true;
    });

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(ExpertConstants.expertKey[0]['uid'])
          .collection('classes')
          .doc(ExpertConstants.classId);
      documentReference.set({
        'id': documentReference.id,
        'class': FieldValue.arrayUnion([
          {
            'vido': videoUrl,
            'Sc': sectionCount,
            'title': sectionTitle,
            'at': imageUrl,
            'desc': sectionDesc,
          }
        ])
      }, SetOptions(merge: true)).whenComplete(() {
        setState(() {
          _publishModal = false;
          desc.clear();
          title.clear();
          sectionDesc = '';
          sectionTitle = '';

          imageUrl = null;
          videoUrl = null;

          pickedVideo = null;
          pickedImage = null;

          ExpertConstants.classId = documentReference.id;
          Constants.uploadImageTask = null;
          Constants.uploadTask = null;
        });
        Fluttertoast.showToast(
            msg: 'Section $sectionCount uploaded successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kSsprogresscompleted);

        setState(() {
          sectionCount++;
        });
      });
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Sorry an error occurred',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  Future<void> nextPage() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    var now = new DateTime.now();
    String? promoThumb;
    String? promoVideo;
    UploadTask uploadTask;
    try {
      setState(() {
        _publishModal = true;
      });

/*getting the class owner details*/
      try {
        await FirebaseFirestore.instance
            .collection("expertDetails")
            .doc(ExpertConstants.expertCompany[0]['id'])
            .collection('details')
            .doc()
            .set({
          'fn': ExpertConstants.expertKey[0]['fn'],
          'pix': ExpertConstants.expertKey[0]['pimg'],
          'tp': ExpertConstants.topic,
          'date': date,
          'uid': currentUser.uid,
          'sfn': GlobalVariables.loggedInUserObject.nm!['fn'],
          'sln': GlobalVariables.loggedInUserObject.nm!['ln'],
          'spix': GlobalVariables.loggedInUserObject.pimg,
          'email': currentUser.email,
          'id': ExpertConstants.expertCompany[0]['id'],
          'comN': ExpertConstants.expertCompany[0]['name'],
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
      /*getting the users count*/

      final snapShot = await FirebaseFirestore.instance
          .collection("companyExpertCount")
          .doc(ExpertConstants.expertCompany[0]['did'])
          .collection('expertCount')
          .doc(ExpertConstants.expertAdminDetails[0]['uid'])
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == docId doesn't exist.

        try {
          FirebaseFirestore.instance
              .collection("companyExpertCount")
              .doc(ExpertConstants.expertCompany[0]['did'])
              .collection('expertCount')
              .doc(currentUser.uid)
              .set({
            'vfd': 1,
            'vfm': 1,
            'vfy': 1,
            'vfw': 1,
            'id': ExpertConstants.expertCompany[0]['id'],
            'suid': currentUser.uid, //staff uid
            'sem': currentUser.email, //staff email
            'comN': ExpertConstants.expertCompany[0]['name'],
            'pix': ExpertConstants.expertCompany[0]['pimg'],
            'uid': ExpertConstants.expertCompany[0]['uid'],
            'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
            'ln': GlobalVariables.loggedInUserObject.nm!['ln'],

            'yr': DateTime.now().year,
            'mth': DateTime.now().month,
            'day': DateTime.now().day,
            'wkd': DateTime.now().weekday,
            'wky': Jiffy().week,
            'month': months[currentMon - 1],
            'date': date,
          });
        } catch (e) {
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }

        /*give a notification*/

      } else {
        //snapshot is  existing
        try {
          FirebaseFirestore.instance
              .collection("companyExpertCount")
              .doc(ExpertConstants.expertCompany[0]['did'])
              .collection('expertCount')
              .where('suid',
                  isEqualTo: ExpertConstants.expertAdminDetails[0]['uid'])
              .where('id', isEqualTo: ExpertConstants.expertCompany[0]['did'])
              .get()
              .then((value) {
            value.docs.forEach((result) {
              var month = result.data()['mth'];
              var currentYear = result.data()['yr'];
              var currentDay = result.data()['day'];
              var currentWeek = result.data()['wky'];

              result.reference.update({
                'vfd': currentDay == DateTime.now().day
                    ? result.data()['vfd'] + 1
                    : 1,
                'vfw':
                    currentWeek == Jiffy().week ? result.data()['vfw'] + 1 : 1,
                'vfm': month == DateTime.now().month
                    ? result.data()['vfm'] + 1
                    : 1,
                'vfy': currentYear == DateTime.now().year
                    ? result.data()['vfy'] + 1
                    : 1,
                'yr': DateTime.now().year,
                'mth': DateTime.now().month,
                'day': DateTime.now().day,
                'wkd': DateTime.now().weekday,
                'wky': Jiffy().week,
                'month': months[currentMon - 1],
              });
            });
          });
        } catch (e) {
          setState(() {
            _publishModal = false;
          });
          print('This is error1 $e');
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
      }

//get the videos uploaded and put in the collection that will be shown to users

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(ExpertConstants.expertKey[0]['uid'])
          .collection('classes')
          .where('id', isEqualTo: ExpertConstants.classId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        print('not existing');
      } else {
        for (DocumentSnapshot document in documents) {
          classes = List.from(document['class']);
          print(classes);
        }
      }

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("verifiedClasses")
          .doc(ExpertConstants.expertKey[0]['uid'])
          .collection('expertClasses')
          .doc();
      documentReference.set({
        'class': classes,
        'id': ExpertConstants.classId,
        'did': documentReference.id,
        'pdesc': ExpertConstants.job,
        'topic': ExpertConstants.topic,
        'subj': ExpertConstants.subTopic,
        'desc': ExpertConstants.description,
        'name': ExpertConstants.name,
        'req': FieldValue.arrayUnion(ExpertConstants.requirementItems),
        'lang': FieldValue.arrayUnion(ExpertConstants.language),
        'tmb': promoThumb,
        'prom': promoVideo,
        'note': ExpertConstants.note,
        'amt': ExpertConstants.amount,
        'cong': ExpertConstants.cong,
        'wel': ExpertConstants.welcome,
        'views': 1,
        'rate': 1,
        'date': date,
        'age': UploadVariables.ageRestriction,
        'age2': UploadVariables.childrenAdult,
        'verified': 'Verified',
        'ud': date,
        'date2': now,

        'sfn': GlobalVariables.loggedInUserObject.nm!['fn'],
        'sln': GlobalVariables.loggedInUserObject.nm!['ln'],
        'spix': GlobalVariables.loggedInUserObject.pimg,

        //company details
        'cid': ExpertConstants.expertCompany[0]['uid'],
        'cpix': ExpertConstants.expertCompany[0]['pix'],
        'cna': ExpertConstants.expertCompany[0]['name'],
        'cfn': ExpertConstants.expertCompany[0]['fn'],
        'cln': ExpertConstants.expertCompany[0]['ln'],

        //expert details
        'eid': ExpertConstants.expertKey[0]['uid'],
        'epix': ExpertConstants.expertKey[0]['pimg'],
        'pix': ExpertConstants.expertKey[0]['pimg'],
        'efn': ExpertConstants.expertKey[0]['fn'],
        'eln': ExpertConstants.expertKey[0]['ln'],
        'suid': ExpertConstants.expertKey[0]['uid'],
        'fn': ExpertConstants.expertKey[0]['fn'],
        'ln': ExpertConstants.expertKey[0]['ln'],

        //expert admin details
        'aid': ExpertConstants.expertAdminDetails[0]['uid'],
        'apix': ExpertConstants.expertAdminDetails[0]['pimg'],
        'afn': ExpertConstants.expertAdminDetails[0]['fn'],
        'aln': ExpertConstants.expertAdminDetails[0]['ln'],

        //sparks class handler details
        'sid': ExpertConstants.expertCompany[0]['suid'],
        'spi': ExpertConstants.expertCompany[0]['spix'],
        'spfn': ExpertConstants.expertCompany[0]['sfn'],
        'spln': ExpertConstants.expertCompany[0]['sln'],

        'comm': 0,
        'share': 0,
        'like': 0,
        'dct': 0,
        'sup': 'verifiedClasses',
        'sub': 'expertClasses',
        'aoi': GlobalVariables.loggedInUserObject.aoi,
        'hobb': GlobalVariables.loggedInUserObject.hobb,
        'spec': GlobalVariables.loggedInUserObject.spec,
      });

      setState(() {
        _publishModal = false;
        ExpertConstants.classId = '';
        ExpertConstants.videoFile = null;
        ExpertConstants.requirementItems.clear();
        ExpertConstants.language.clear();
        ExpertConstants.imageFile = null;
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PublishSuccess(
                title: kSClassSuccess,
              )));
    } catch (e) {
      print("this is $e");
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }
}

/*DateTime todayDate = DateTime.parse('2020-07-19 15:59:50.023329');

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final yesterday = DateTime(now.year, now.month, now.day - 2);
                    final tomorrow = DateTime(now.year, now.month, now.day + 1);

                    //final aDateTime = ...
                   // var dateToCheck;
                    final aDate = DateTime(todayDate.year, todayDate.month, todayDate.day);
                    if(aDate == today) {
                       print('today');
                    } else if(aDate == yesterday) {
                      print('yesterday');
                    } else if(aDate == tomorrow) {
                      print('tomorrow');
                    }*/
