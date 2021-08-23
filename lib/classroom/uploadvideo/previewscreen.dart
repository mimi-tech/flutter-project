import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/subjects.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/delete_thumbnail.dart';
import 'package:sparks/classroom/golive/publish_live.dart';
import 'package:sparks/classroom/golive/publishcongratulation.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadprogressbar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:video_player/video_player.dart';

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

class PreviewScreen extends StatefulWidget {
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<String> dataList = [];
  late UploadTask uploadTask;

  Future getThumbnail() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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

    UploadVariables.fileName = file;

    int fileSize = file!.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        UploadVariables.thumbnail = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  List<String> comments = <String>['Intersting', 'good tutorial'];

  bool _publishModal = false;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  String get filePath => 'sessionThumbnails/${DateTime.now()}';

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

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: kWhitecolor,
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UploadingProgress(),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Column(
                        children: <Widget>[
                          //ToDo:getting the progress of image upload

                          if (UploadVariables.thumbnail == null)
                            InkWell(
                              onTap: () {
                                getThumbnail();
                              },
                              child: Image(
                                image: AssetImage(
                                    'images/classroom/tumbnail_picker.png'),
                                height: ScreenUtil().setHeight(40),
                                width: ScreenUtil().setWidth(40),
                              ),
                            )
                          else
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      getThumbnail();
                                    },
                                    child: Image.file(
                                      UploadVariables.thumbnail!,
                                      width: 45.0,
                                      height: 44.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10.0)),
                                  DeleteThumbnail(delete: () {
                                    setState(() {
                                      UploadVariables.thumbnail = null;
                                    });
                                  })
                                ]),

                          UploadVariables.thumbnail == null
                              ? Text(
                                  kAddthumbnail,
                                  style: TextStyle(
                                    fontSize: kFontsize.sp,
                                    color: kAshmainthumbnailcolor,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text('')
                        ],
                      ),
                    ),

                    Divider(
                      color: kAshthumbnailcolor,
                      thickness: kThickness,
                    ),
                    Container(
                        child: Center(
                            child: Text(
                      kPreview,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: kPreviewcolor,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                      ),
                    ))),

                    UploadVariables.url != null
                        ? Stack(
                            children: <Widget>[
                              UploadVariables.thumbnail == null
                                  ? Container(
                                      height: ScreenUtil().setHeight(250),
                                      child: Center(
                                        child: ShowUploadedVideo(
                                          videoPlayerController:
                                              VideoPlayerController.network(
                                                  UploadVariables.url!),
                                          looping: false,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      child: Image.file(
                                        UploadVariables.thumbnail!,
                                        height: ScreenUtil().setHeight(250),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Center(
                                  child: ButtonTheme(
                                height: ScreenUtil().setHeight(250),
                                child: RaisedButton(
                                    shape: CircleBorder(),
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    child: GestureDetector(
                                        onTap: () {
                                          UploadVariables.videoUrlSelected =
                                              UploadVariables.url;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayingVideos()));
                                        },
                                        child:
                                            Icon(Icons.play_arrow, size: 100))),
                              ))
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            width: double.infinity,
                            height: ScreenUtil().setHeight(160),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: klistnmber,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    kUploading,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: kFontsize.sp,
                                      color: kUploadingcolor,
                                      fontFamily: 'Rajdhani',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  kContbelow,
                                  style: TextStyle(
                                    fontSize: kFontsize.sp,
                                    color: kWhitecolor,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                    ///title preview
                    Card(
                      elevation: 5.0,
                      child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: kHorizontal,
                          ),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  kliveformtitle + "" + ':',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: kFloatbtn,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Text(
                                UploadVariables.title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  color: kBlackcolor,
                                  fontFamily: 'RajdhaniMedium',
                                ),
                              ),

                              ///description

                              Text(
                                kliveformdesc + "" + ':',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: kFloatbtn,
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Text(
                                  UploadVariables.description!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: kFontsize.sp,
                                    color: kBlackcolor,
                                    fontFamily: 'RajdhaniMedium',
                                  ),
                                ),
                              ),
                            ],
                          ))),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: kHorizontal, top: 18.0, right: kHorizontal),
                      child: Center(
                        child: Text(
                          kPreviewgood,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: kBlackcolor2,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    //ToDo: Add to playlist
                    UploadVariables.url != null
                        ? GestureDetector(
                            onTap: () async {
                              User? currentUser =
                                  FirebaseAuth.instance.currentUser;
                              setState(() {
                                UploadVariables.currentUser = currentUser!.uid;

                                UploadVariables.selectedVideo =
                                    UploadVariables.url;
                              });

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: PlaylistScreen()));
                            },
                            child: Text(kPlaylist,
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  color: kFbColor,
                                  fontFamily: 'Rajdhani',
                                )),
                          )
                        : Text(''),
                    SizedBox(
                      height: 20.0,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(60),
                      child: RaisedButton(
                        onPressed: () async {
                          //check if video has finished uploading to fireBase storage
                          if (UploadVariables.url == null) {
                            Fluttertoast.showToast(
                                msg: kSsuploadnotcomplete,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: kBlackcolor,
                                textColor: kFbColor);
                          } else {
                            // push to fireBase

                            setState(() {
                              _publishModal = true;
                            });

                            try {
                              // adding file to storage
                              if (UploadVariables.thumbnail != null) {
                                Reference ref = FirebaseStorage.instance
                                    .ref()
                                    .child(filePath);

                                uploadTask = ref.putFile(
                                    UploadVariables.thumbnail!,
                                    SettableMetadata(
                                      contentType: "image/jpeg",
                                    ));

                                final TaskSnapshot downloadUrl =
                                    await uploadTask;
                                final String url =
                                    await downloadUrl.ref.getDownloadURL();
                                UploadVariables.playlistUrl1 = url;

                                /*set to fireStore*/
                                sendToDatabase();
                              } else {
                                sendToDatabase();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Text(
                          kPublish2,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: kBlackcolor,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: kSsuploadcontbtn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            )));
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Published successfully',
        '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']} $kSnortification ',
        platformChannelSpecifics,
        payload: 'item x');
  }

  //send to fireBase

  sendToDatabase() async {
    var yt = Variables.dateFormat.format(Variables.selectedDate);

    User currentUser = FirebaseAuth.instance.currentUser!;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("sessionContent")
        .doc(currentUser.uid)
        .collection('userSessionUploads')
        .doc();
    documentReference.set({
      /*user session dateadded*/
      'date': date,
      /*user session title*/
      'title': UploadVariables.title,
      /*user session description*/
      'desc': UploadVariables.description,
      /*user thumbnail*/
      'tmb': UploadVariables.playlistUrl1 ?? 'null',
      'ts': now,
      /*Time user want video to be published*/
      'lt': yt,
      /*user uid*/
      'uid': currentUser.uid,
      /*user email address*/
      'email': currentUser.email,
      /*all contact visible*/
      'visi': UploadVariables.publicPrivate,

      /*Age limit selected*/
      'alimit': UploadVariables.childrenAdult,
      /*uploaded Video*/
      'vido': UploadVariables.url,
      'views': 0,

      /*category*/
      'cat': UploadVariables.category,
      /*Rating*/
      'rate': 0,
      /*age restrictions*/
      'age': UploadVariables.ageRestriction,
      /*live publishing*/
      'publish': 'publish',
      /*document Id*/
      'vi_id': documentReference.id,
      'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
      'ln': GlobalVariables.loggedInUserObject.nm!['ln'],
      'pix': GlobalVariables.loggedInUserObject.pimg,
      'comm': 0,
      'share': 0,
      'like': 0,
      'sup': 'sessionContent',
      'sub': 'userSessionUploads',
      'aoi': GlobalVariables.loggedInUserObject.aoi,
      'hobb': GlobalVariables.loggedInUserObject.hobb,
      'spec': GlobalVariables.loggedInUserObject.spec,
      'suid': GlobalVariables.loggedInUserObject.id,
    });

    //ToDO:send the contacts to fireBase
    FirebaseFirestore.instance
        .collection("sessionContent")
        .doc(currentUser.uid)
        .collection('userSessionUploads')
        .doc(documentReference.id)
        .collection('contacts')
        .doc(documentReference.id)
        .set({
      'scont': FieldValue.arrayUnion(ufriends.litems),
    });
    /*//ToDo:send comments to fireBase
  FirebaseFirestore.instance
      .collection("sessioncontent")
      .doc(currentUser.uid)
      .collection('usersessionuploads')
      .doc(documentReference.documentID)
      .collection('comments').doc(
      documentReference.documentID)
      .setData({
    'comm': FieldValue.arrayUnion(comments),
  });*/
    setState(() {
      _publishModal = false;
      ufriends.litems.clear();
      UploadVariables.url = '';
      UploadVariables.thumbnail = null;

      UploadVariables.videoUrlSelected = null;
      UploadVariables.category = null;
      UploadVariables.playlistUrl1 = null;
      UploadVariables.playlistUrl2 = null;
      UploadVariables.url = null;
    });
    //Give the user a notification
    showNotification();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PublishSuccess(
              title: kClpublishsuccessful,
            )));
  }
}
