import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/socialConstants/PlayingSocialVideos.dart';
import 'package:sparks/social/socialCourse/cc_appbar.dart';
import 'package:sparks/social/socialCourse/socialClassDetails.dart';
import 'package:sparks/social/socialCourse/social_course_details.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:video_player/video_player.dart';

class SocialExpectClasses extends StatefulWidget {
  SocialExpectClasses({
    required this.doc,
    required this.item,
    required this.title,
  });
  final DocumentSnapshot doc;
  final List<DocumentSnapshot> item;
  final String title;
  @override
  _SocialExpectClassesState createState() => _SocialExpectClassesState();
}

class _SocialExpectClassesState extends State<SocialExpectClasses> {
  var showData = <dynamic>[];
  List<DocumentSnapshot> _documents = [];
  List<dynamic> classVideos = <dynamic>[];
  List<dynamic> classVideosAttachment = <dynamic>[];
  List<dynamic> classVideosAttachmentName = <dynamic>[];



  int progress = 0;


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/

    });


    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();

  }


  late String _localPath;
  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    print('Download Path: $_localPath');


    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: CcAppBar(
          text4: 'A class on',
          text1: widget.doc['topic'],
          text2: widget.doc['efn'],
          text3: widget.doc['eln'],
        ),
        body: StickyHeader(
        header: Row(
        children: [
        BtnSecond(next: (){
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialClassDetails(doc:widget.doc)));

        }, title: 'Course details', bgColor: kFbColor),

        BtnSecond(next: (){_down();}, title: 'Download', bgColor: kLightGreen),

        ],
        ),
        content:Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                ),
                child: ReadMoreText('${widget.doc['wel']}',

                  trimLines: 5,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' ...',
                  trimExpandedText: 'show less',
                  style:GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kBlackcolor,
                      fontSize:kFontsize.sp,
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                UploadVariables.videoUrlSelected = widget.doc['prom'];
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));

              },
              child:  Text('Watch what this class is all about!!',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kExpertColor,
                      fontSize:kFontsize.sp,
                    ),
                  )
              ),
            ),
            SizedBox(height:10),
            ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: classVideos.length,
                itemBuilder: (context, int index) {
                  return Card(
                      elevation: 20,
                      child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                              alignment: Alignment.topLeft,
                              child: Text('Section ${index + 1}',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kFbColor,
                                      fontSize: kTwentyTwo.sp,
                                    ),
                                  )
                              ),
                            ),

                            Row(
                              //mainAxisAlignment:MainAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                    Container(
                                      height:MediaQuery.of(context).size.height * 0.25,
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: ShowUploadedVideo(
                                        videoPlayerController: VideoPlayerController.network(classVideos[index]['vido']),
                                        looping: false,
                                      ),
                                    ),
                                    Align(

                                      child: ButtonTheme(
                                        //height: 50,
                                          shape: CircleBorder(),
                                          child: RaisedButton(
                                              color: Colors.transparent,
                                              textColor: Colors.white,
                                              onPressed: () {},
                                              child: GestureDetector(
                                                  onTap: () {
                                                    UploadVariables.videoUrlSelected = classVideos[index]['vido'];
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialCCVideos()));
                                                  },
                                                  child: Icon(Icons.play_arrow, size: 40)))),
                                    )
                                  ]),
                                ),
                                //spaceWidth(),
                                /*the title of the class sections*/
                                Column(

                                    children:<Widget>[

                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().setWidth(150),
                                            minHeight: ScreenUtil().setHeight(10),
                                          ),
                                          child: ReadMoreText(
                                            '${classVideos[index]['title']}',

                                            trimLines: 2,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' ...',
                                            trimExpandedText: 'show less',
                                            style:GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kBlackcolor,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // spaceWidth(),
/*the description of the section class*/


                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().setWidth(150),
                                            minHeight: ScreenUtil().setHeight(10),
                                          ),
                                          child: ReadMoreText(
                                            '${classVideos[index]['desc']}',

                                            trimLines: 2,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' ...',
                                            trimExpandedText: 'show less',
                                            style:GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: kBlackcolor,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),


                                    ]
                                ),



                              ],
                            ),
                          ])



                  );
                }
            ),
          ],
        )
    )
    ));
  }

  void getData() {
    _documents.clear();
    showData.clear();
    try {
      FirebaseFirestore.instance
          .collection(widget.doc['sup'])
          .doc(widget.doc['suid'])
          .collection(widget.doc['sub'])
          .where('id',isEqualTo: widget.doc['id'])
          .get()
          .then((value) {
        value.docs.forEach((result) {

          setState(() {

            _documents.add(result);
            showData.add(result.data());
            classVideos =  List.from(result.data()['class']);
            classVideosAttachment = List.from(result.data()['class']['at']);
            classVideosAttachmentName = List.from(result.data()['class']['title']);
          });

        });
      });
    }catch (e){
      print(e);
    }
  }

  Future<void> _down() async {
    //check if user have paid for this course

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('paidCourses')
        .where('id', isEqualTo: widget.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {




      final status = await Permission.storage.request();

      if (status.isGranted) {
        // final externalDir = await getExternalStorageDirectory();

        for(int i = 0; i < classVideos.length; i++) {
          final id = await FlutterDownloader.enqueue(
            url: classVideos[i]['vido'].sections[i].vido,
            savedDir: _localPath,
            //externalDir.path,
            fileName: '${classVideos[i]['name']}.mp4',
            showNotification: true,
            openFileFromNotification: true,
          );
          //download attachment

        }

        //download attachment

        for(int i = 0; i < classVideosAttachment.length; i++) {
        final id = await FlutterDownloader.enqueue(
          url: classVideosAttachment[i],
          savedDir: _localPath,
          //externalDir.path,
          fileName: '${classVideosAttachmentName[i]}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
      }
      } else {
        print("Permission denied");
      }
    }else{
      SchClassConstant.displayBotToastError(title: 'You have not paid for this course');

    }


  }
}
