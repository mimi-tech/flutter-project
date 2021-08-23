import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:rxdart/subjects.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

import 'package:sparks/classroom/golive/publishcongratulation.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

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
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class CongratulationPublish extends StatefulWidget {
  @override
  _CongratulationPublish createState() => _CongratulationPublish();
}

class _CongratulationPublish extends State<CongratulationPublish> {
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
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
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

  static var now = new DateTime.now();

  bool _publishModal = false;
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  late UploadTask uploadTask;
  String filePath = 'sessionthumbnails/${DateTime.now()}';
  List<String> comments = <String>[
    'u killed it',
    'guy u are too much',
    'amazing'
  ];

  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _publishModal,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(Variables.imageURI!), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(28.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      size: 42,
                      color: kWhitecolor,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: kBlackcolor.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      )),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Center(
                              child: Text(Variables.title!,
                                  style: Variables.textstyles)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Divider(
                            height: 0.0,
                            color: kWhitecolor.withOpacity(0.5),
                            thickness: 2.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                              child: Text('',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rajdhani',
                                    color: kMaincolor,
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                              child: Text('',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rajdhani',
                                    color: kWhitecolor.withOpacity(0.5),
                                  ))),
                        ),
                        Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(60),
                          margin: EdgeInsets.symmetric(
                            vertical: 24.0,
                            horizontal: 20.0,
                          ),
                          child: RaisedButton(
                            elevation: 5.0,
                            color: kBlackcolor,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: kWhitecolor),
                            ),
                            child: Text(
                              kClPublish,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rajdhani',
                                color: kFbColor,
                              ),
                            ),
                            onPressed: () async {
                              var now = new DateTime.now();
                              var yt = Variables.dateFormat
                                  .format(Variables.selectedDate);
                              User currentUser =
                                  FirebaseAuth.instance.currentUser!;

                              setState(() {
                                _publishModal = true;
                              });
                              try {
                                int randomNumber = random.nextInt(1000000000);

                                //TODO:first upload to fire storage
                                Reference ref = FirebaseStorage.instance
                                    .ref()
                                    .child(filePath);

                                uploadTask = ref.putFile(Variables.imageURI!);
                                SettableMetadata(
                                  contentType: 'images.jpg',
                                );
                                final TaskSnapshot downloadUrl =
                                    (await uploadTask);
                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());

                                //Todo: adding file to database

                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection("sessionContent")
                                        .doc(currentUser.uid)
                                        .collection('publishedLive')
                                        .doc();
                                documentReference.set({
                                  'date': date,
                                  'dt': Variables.selectedDate.toString(),
                                  'title': Variables.title,
                                  'desc': Variables.desc,
                                  'tmb': url,
                                  'lt': yt,
                                  'dtime': Variables.selectedDate,
                                  'uid': currentUser.uid,
                                  'email': currentUser.email,
                                  /*all contact visible*/
                                  'visi': UploadVariables.publicPrivate,
                                  /*Age limit selected*/
                                  'alimit': UploadVariables.childrenAdult,
                                  /*uploaded Video*/
                                  'vido': '',

                                  /*age restrictions*/
                                  'age': UploadVariables.ageRestriction,
                                  /*document Id*/
                                  'vi_id': documentReference.id,
                                  'publish': 'live',
                                  'fn': GlobalVariables
                                      .loggedInUserObject.nm!['fn'],
                                  'ln': GlobalVariables
                                      .loggedInUserObject.nm!['ln'],
                                  'pix':
                                      GlobalVariables.loggedInUserObject.pimg,
                                  'vNum': randomNumber,
                                  'comm': 0,
                                  'share': 0,
                                  'like': 0,
                                  'rate': 0,
                                  'views': 0,
                                  'sup': 'sessionContent',
                                  'sub': 'publishedLive',
                                  'aoi': GlobalVariables.loggedInUserObject.aoi,
                                  'hobb':
                                      GlobalVariables.loggedInUserObject.hobb,
                                  'spec':
                                      GlobalVariables.loggedInUserObject.spec,
                                  'suid': GlobalVariables.loggedInUserObject.id,
                                });
                                //ToDO:send the contacts to fireBase
                                FirebaseFirestore.instance
                                    .collection("sessionContent")
                                    .doc(currentUser.uid)
                                    .collection('publishedLive')
                                    .doc(documentReference.id)
                                    .collection('contacts')
                                    .doc(documentReference.id)
                                    .set({
                                  'scont':
                                      FieldValue.arrayUnion(ufriends.litems),
                                });

                                notifySuccess();

                                //ToDo:notify the user that time have reached for going live

                                var scheduledNotificationDateTime =
                                    Variables.selectedDate;
                                var vibrationPattern = Int64List(4);
                                vibrationPattern[0] = 0;
                                vibrationPattern[1] = 1000;
                                vibrationPattern[2] = 5000;
                                vibrationPattern[3] = 2000;

                                var androidPlatformChannelSpecifics =
                                    AndroidNotificationDetails(
                                        'your other channel id',
                                        'your other channel name',
                                        'your other channel description',
                                        icon: 'secondary_icon',
                                        sound:
                                            RawResourceAndroidNotificationSound(
                                                'slow_spring_board'),
                                        largeIcon:
                                            DrawableResourceAndroidBitmap(
                                                'sample_large_icon'),
                                        vibrationPattern: vibrationPattern,
                                        enableLights: true,
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0),
                                        ledColor: const Color.fromARGB(
                                            255, 255, 0, 0),
                                        ledOnMs: 1000,
                                        ledOffMs: 500);
                                var iOSPlatformChannelSpecifics =
                                    IOSNotificationDetails(
                                        sound: 'slow_spring_board.aiff');
                                var platformChannelSpecifics =
                                    NotificationDetails(
                                        android:
                                            androidPlatformChannelSpecifics,
                                        iOS: iOSPlatformChannelSpecifics);
                                await flutterLocalNotificationsPlugin.schedule(
                                    0,
                                    'scheduled title',
                                    'scheduled body',
                                    scheduledNotificationDateTime,
                                    platformChannelSpecifics);

                                setState(() {
                                  _publishModal = false;
                                });
                                setState(() {
                                  UploadUfriends.litems.clear();
                                  Variables.title = '';
                                  Variables.desc = '';
                                  Variables.imageURI = null;
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PublishSuccess(
                                      title: kClpublishsuccessful,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } catch (e) {
                                setState(() {
                                  _publishModal = false;
                                });
                                print(e);
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> notifySuccess() async {
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
        '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']} you will be live on ${DateFormat('EE, d MMM, yyyy').format(Variables.selectedDate)} ',
        platformChannelSpecifics,
        payload: 'item x');
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen with payload: ${(_payload ?? '')}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
