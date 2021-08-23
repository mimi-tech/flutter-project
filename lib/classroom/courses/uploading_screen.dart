import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/course_widget/course_dialog.dart';

import 'package:sparks/classroom/courses/add_icon.dart';
import 'package:sparks/classroom/courses/alert_animation.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';

import 'package:sparks/classroom/courses/progress_indicator.dart';
import 'package:sparks/classroom/courses/progress_indicator2.dart';
import 'package:sparks/classroom/golive/publish_live.dart';
import 'package:sparks/classroom/golive/publishcongratulation.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails? notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class CreateCourses extends StatefulWidget {
  @override
  _CreateCoursesState createState() => _CreateCoursesState();
}

class _CreateCoursesState extends State<CreateCourses>
    with TickerProviderStateMixin {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  static late UploadTask uploadTask;
  static late UploadTask uploadImageTask;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    Constants.uploadImageTask = null;
    Constants.uploadTask = null;
  }

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _title = TextEditingController();
  TextEditingController _section = TextEditingController();
  int count = 1;
  int sectionCount = 2;
  String? url;
  String? imageUrl;
  //String docId;
  String get filePaths => 'courseVideos/${DateTime.now()}';
  String get fileImagePaths => 'Attachment/${DateTime.now()}';
  String get fileThumbnail => 'expertThumbnail/${DateTime.now()}';
  bool _publishModal = false;
  String? docRef;

  File? pickedVideo;
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CourseAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ],
                      ),

                      //ToDo:displaying the lecture
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RemoveIcon(removeIcon: () {
                            _removeLecture();
                          }),
                          Text(kSCourseLecture + " ",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              )),
//ToDo:counting of lecture

                          Text(count.toString(),
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor2,
                                  fontSize: 22.sp,
                                ),
                              )),

                          AddIcon(iconFunction: () {
                            counting();
                          })
                        ],
                      ),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                FadeHeading(
                                  title: kSCourseLecturetitle,
                                ),
                                OutlineButton(
                                  onPressed: () {},
                                  child: Text(count.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kBlackcolor2,
                                          fontSize: 22.sp,
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                controller: _title,
                                maxLength: 100,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  Constants.kSCourseLectureTitle = value;
                                },
                                onChanged: (String value) {
                                  Constants.kSCourseLectureTitle = value;
                                },
                                validator: Validator.validateTitle,
                              ),
                            ),

                            //ToDo:section title
                            Row(
                              children: <Widget>[
                                FadeHeading(
                                  title: kSCourseSectionTitle,
                                ),
                                OutlineButton(
                                  onPressed: () {},
                                  child: Text(sectionCount.toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kBlackcolor2,
                                          fontSize: 22.sp,
                                        ),
                                      )),
                                )
                              ],
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: TextFormField(
                                controller: _section,
                                maxLength: 100,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String? value) {
                                  Constants.kSCourseLectureSections = value;
                                },
                                onChanged: (String value) {
                                  Constants.kSCourseLectureSections = value;
                                },
                                validator: Validator.validateDesc,
                              ),
                            ),

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
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            Text(
                              kSCourseDone,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(30)),
                            CoursePublishBtn(
                              title: kPublish2,
                              publish: () {
                                _goToPreview();
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ScreenUtil().setHeight(30)),
                    ],
                  ),
                ),
              ),
            )));
  }

  void counting() {
    setState(() {
      _title.clear();
      _section.clear();
      sectionCount = 1;
      count++;
    });
  }

  void _removeLecture() {
    setState(() {
      _title.clear();
      _section.clear();
      sectionCount = 1;
      if (count != 1) {
        count--;
      }
    });
  }

  Future<void> countingSection() async {
    Animation<Offset> animation;
    AnimationController animationController;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 200),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });
    if ((url != null) || (imageUrl != null)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                title: AlertAnimation(
                    animation: animation, sectionCount: sectionCount),
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
                ],
              ));
    } else {
      Fluttertoast.showToast(
          msg: kSCourseUploadError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  Future<void> _uploadVideo() async {
    String? _extension;

    String video = 'video';
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      //ToDo:open video file
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
      int filesize = file!.lengthSync();

      if (filesize <= kSVideoSize) {
        setState(() {
          pickedVideo = file;
        });
        setState(() async {
          Reference ref = FirebaseStorage.instance.ref().child(filePaths);
          Constants.uploadTask = ref.putFile(
            file!,
            SettableMetadata(
              contentType: '$video/$_extension',
            ),
          );

          final TaskSnapshot downloadUrl = await Constants.uploadTask!;
          url = await downloadUrl.ref.getDownloadURL();
        });
      } else {
        Fluttertoast.showToast(
            msg: kSCourseError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }

//ToDo:uploading image for attachment
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

    //ToDo: send to fireBase storage
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

  Future<void> addData() async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    setState(() {
      _publishModal = true;
    });

    //ToDo:Add section to fireBase
    //check if document id already exists
    final snapShot = await FirebaseFirestore.instance
        .collection("sessionContent")
        .doc(currentUser.uid)
        .collection('courses')
        .doc(Constants.kCourseDocId)
        .get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.

      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("sessionContent")
            .doc(currentUser.uid)
            .collection('courses')
            .doc();
        documentReference.set({
          'id': documentReference.id,
          'Lc': FieldValue.arrayUnion([count]),
          'lectures': FieldValue.arrayUnion([
            {
              'lecture': ([
                {
                  'vido': url,
                  'Sc': sectionCount,
                  'title': Constants.kSCourseLectureSections,
                  'at': imageUrl,
                  'name': Constants.kSCourseLectureTitle,
                  'Lcount': count,
                }
              ])
            }
          ])
        }).whenComplete(() {
          Fluttertoast.showToast(
              msg: 'Section $sectionCount uploaded successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);
          setState(() {
            _publishModal = false;
            sectionCount++;
            imageUrl = null;
            url = null;
            _section.clear();
            Constants.uploadImageTask = null;
            Constants.uploadTask = null;
            pickedVideo = null;
            pickedImage = null;
            Constants.kCourseDocId = documentReference.id;
          });
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
    } else {
      //lecture doesn't  exist yet'

      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("sessionContent")
            .doc(currentUser.uid)
            .collection('courses')
            .doc(Constants.kCourseDocId);
        documentReference.set({
          'id': documentReference.id,
          'Lc': FieldValue.arrayUnion([count]),
          'lectures': FieldValue.arrayUnion([
            {
              'lecture': ([
                {
                  'vido': url,
                  'Sc': sectionCount,
                  'title': Constants.kSCourseLectureSections,
                  'at': imageUrl,
                  'name': Constants.kSCourseLectureTitle,
                  'Lcount': count,
                }
              ])
            }
          ])
        }, SetOptions(merge: true)).whenComplete(() {
          Fluttertoast.showToast(
              msg: 'Section ${sectionCount--} uploaded successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);
          setState(() {
            _publishModal = false;
            _section.clear();
            sectionCount++;
            imageUrl = null;
            url = null;
            Constants.kCourseDocId = documentReference.id;
            Constants.uploadImageTask = null;
            Constants.uploadTask = null;
            pickedVideo = null;
            pickedImage = null;
          });
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

  Future<void> _goToPreview() async {
    var now = new DateTime.now();
    String promoThumb;
    String promoVideo;
    /*uploading the promotion video thumbnail*/
    /*uploading the promotional thumbnail*/

    try {
      setState(() {
        _publishModal = true;
      });
      Reference ref = FirebaseStorage.instance.ref().child(fileThumbnail);
      uploadImageTask = ref.putFile(
        Constants.promotionThumbnail!,
        SettableMetadata(
          contentType: 'image/jpg',
        ),
      );

      final TaskSnapshot downloadUrl = await uploadImageTask;
      promoThumb = await downloadUrl.ref.getDownloadURL();

      /*uploading the promotional video*/

      Reference videoRef = FirebaseStorage.instance.ref().child(filePaths);
      uploadTask = videoRef.putFile(
        Constants.promotionVideoFile!,
        SettableMetadata(
          contentType: 'video/mp4',
        ),
      );

      final TaskSnapshot downloadVideoUrl = await uploadTask;
      promoVideo = await downloadVideoUrl.ref.getDownloadURL();

//update the database

      User currentUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(currentUser.uid)
          .collection('courses')
          .doc(Constants.kCourseDocId)
          .update({
        'pdesc': Constants.courseJobProfile,
        'topic': Constants.courseTopic,
        'subj': Constants.kCourseSubTopic,
        'desc': Constants.courseDesc,
        'name': Constants.kCourseName,
        'targ': FieldValue.arrayUnion(TargetedStudents.items),
        'obj': FieldValue.arrayUnion(Objective.items),
        'req': FieldValue.arrayUnion(Requirements.items),
        'inc': FieldValue.arrayUnion(Included.items),
        'lang': FieldValue.arrayUnion(SelectedLanguage.data),
        'level': FieldValue.arrayUnion(SelectedLevel.data),
        'cate': FieldValue.arrayUnion(SelectedCate.data),
        'pur': Constants.coursePurpose,
        'tmb': promoThumb,
        'prom': promoVideo,
        'amt': Constants.courseAmount,
        'cong': Constants.courseCongMessage,
        'wel': Constants.courseWelcomeMessage,
        'views': 0,
        'rate': 0,
        'date': date,
        'age': UploadVariables.ageRestriction,
        'age2': UploadVariables.childrenAdult,
        'verified': false,
        'ud': date,
        'dt': now,
        'uid': currentUser.uid,
        'se': false,
        'up': false,
        'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln': GlobalVariables.loggedInUserObject.nm!['ln'],
        'pix': GlobalVariables.loggedInUserObject.pimg,
        'dct': 0,
        'comm': 0,
        'share': 0,
        'like': 0,
        'sup': 'verifiedCourses',
        'sub': 'userCourses',
        'aoi': GlobalVariables.loggedInUserObject.aoi,
        'hobb': GlobalVariables.loggedInUserObject.hobb,
        'spec': GlobalVariables.loggedInUserObject.spec,
        'suid': GlobalVariables.loggedInUserObject.id,
      });

      //ToDo:send comments to fireBase
      FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(currentUser.uid)
          .collection('publishedLive')
          .doc(Constants.kCourseDocId)
          .collection('courses')
          .doc(Constants.kCourseDocId)
          .set({
        'comm': FieldValue.arrayUnion([]),
      }).whenComplete(() {
        setState(() {
          Constants.kCourseDocId = '';
          _publishModal = false;
          UploadVariables.ageRestriction = null;
          UploadVariables.childrenAdult = null;
        });

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PublishSuccess(
                  title: kSCourseLectureSuccess,
                )));
      });

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Published successfully',
          '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']} Your course have been published, wait for verification ',
          platformChannelSpecifics,
          payload: 'item x');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Sorry an error occured',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }
}
