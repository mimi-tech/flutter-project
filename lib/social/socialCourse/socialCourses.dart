import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/socialCourse/cc_appbar.dart';
import 'package:sparks/social/socialCourse/social_courseSections.dart';
import 'package:sparks/social/socialCourse/social_course_details.dart';
import 'package:sparks/social/usersTabs/reviews.dart';

import 'package:sticky_headers/sticky_headers.dart';

class SocialCoursesClasses extends StatefulWidget {
  SocialCoursesClasses({
    required this.doc,
    required this.item,
    required this.title,
  });
  final DocumentSnapshot doc;
  final List<DocumentSnapshot> item;
  final String title;

  @override
  _SocialCoursesClassesState createState() => _SocialCoursesClassesState();
}

class _SocialCoursesClassesState extends State<SocialCoursesClasses> {
  Course globalLectures = Course();
  var showData = <dynamic>[];
  List<DocumentSnapshot> _documents = [];


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
          text4: 'A course on',
          text1: widget.doc['topic'],
          text2: widget.doc['fn'],
          text3: widget.doc['ln'],
        ),
        body:CustomScrollView(slivers: <Widget>[
           /* CcSliverAppBar(details: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: SocialCourseDetails(doc:widget.doc)));

            },download: (){_downloadMyCourse();},),
*/

        SliverList(
            delegate: SliverChildListDelegate([


             Column(
          children: _documents.map((doc) {
          List<dynamic> loadVideos = doc['lectures'];
              Course lectures = Course();

            int prevLectureCount;

            int currLectureCount;

            loadVideos.sort((a, b) {

    String printMap = json.encode(a['lecture'][0]['Lcount']);

    print("printMap = json.encode(a['lecture'][0]['Lcount'])");

    print('printMap: ' + printMap);

    return a['lecture'][0]['Lcount'].compareTo(b['lecture'][0]['Lcount']);

    });

        for (int i = 0; i < loadVideos.length; i++) {

      List<dynamic> section = loadVideos[i]['lecture'];

      Lecture  sLecture  = Lecture();

      Section sSection = Section();

      sSection.vido         = section[0]['vido'];
      sSection.sectionCount = section[0]['Sc'];
      sSection.title        = section[0]['title'];
      sSection.at           = section[0]['at'];
      sSection.name         = section[0]['name'];
      sSection.lCount       = section[0]['Lcount'];

      if (i == 0) {

        currLectureCount = section[0]['Lcount'];

        sLecture.index = currLectureCount;

        sLecture.sectionLength = 1;

        sLecture.sections.add(sSection);

        lectures.lectures.add(sLecture);

      }
      else {

        prevLectureCount = loadVideos[i - 1]['lecture'][0]['Lcount'];

        currLectureCount = loadVideos[i]['lecture'][0]['Lcount'];

        int lCount = loadVideos[i]['lecture'][0]['Lcount'];

        if (currLectureCount == prevLectureCount) {

          lectures.lectures[lCount - 1].sections.add(sSection);

          lectures.lectures[lCount - 1].sectionLength++;

        }
        else {

          if (lectures.lectures.length < lCount) {

            sLecture.index = currLectureCount;

            sLecture.sectionLength = 1;

            sLecture.sections.add(sSection);

            lectures.lectures.add(sLecture);

          }
          else {

            lectures.lectures[lCount].sections.add(sSection);

            lectures.lectures[lCount].sectionLength++;

          }

        }

      }

    }

    //globalLectures = lectures;

   return  StickyHeader(
     header: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
         BtnThird(next: (){
           Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SocialCourseDetails(doc:widget.doc)));

         }, title: 'Details', bgColor: kFbColor),

         BtnThird(next: (){_down(lectures.lectures);}, title: 'Download', bgColor: kLightGreen),
         BtnThird(next: (){
           Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseReviewScreen(doc:widget.doc)));

         }, title: 'reviews', bgColor: Colors.amber),

       ],
     ),
     content: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
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
             child:  Text('Watch what this course is all about!!',
                 style: GoogleFonts.rajdhani(
                   textStyle: TextStyle(
                     fontWeight: FontWeight.normal,
                     color: kExpertColor,
                     fontSize:kFontsize.sp,
                   ),
                 )
             ),
           ),
           SizedBox(height:10),

           ListView.builder(
            itemCount:lectures.lectures.length ,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, int index) {

                    return Column(
                      children: [
                    GestureDetector(
                    onTap: () async {

                      final value = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SocialSectionCourse(
                                currentSections: lectures.lectures[index].sections,
                                currentLectures: lectures,
                                currentIndexOfLectures: index,
                                doc:widget.doc,
                                lectureName:lectures.lectures[index].sections[0].name.toString(),

                              ),
                        ),
                      );

                      if (value != null && value == 'Done') {

                        getData();

                      }


                    },
              child: Card(
              elevation: 20,
              child: Column(
              children: <Widget>[
              SizedBox(height:20),
              Row(
              mainAxisAlignment:MainAxisAlignment.start,
              children: <Widget>[



              Column(
              children: <Widget>[

              Text('Lecture ${index + 1}',
              style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFbColor,
              fontSize: kTwentyTwo.sp,
              ),
              )
              ),

              Text('${lectures.lectures[index].sections.length} section(s)',
              style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: kBlackcolor,
              fontSize: 14.sp,
              ),
              )
              ),


              SizedBox(height:20),
              CachedNetworkImage(
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.12,
              placeholder: (context, url) =>  Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)),
              errorWidget: (context, url, error) =>  Icon(Icons.error),
              imageUrl: showData[index]['tmb'],

              ),
              ],
              ),
              SizedBox(width:10),

              Column(

              children:<Widget>[

              Container(
              child: ConstrainedBox(
              constraints: BoxConstraints(
              maxWidth: ScreenUtil().setWidth(constrainedReadMore),
              minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
              ),
              child: ReadMoreText('${lectures.lectures[index].sections[0].name}',

              trimLines: 2,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' ...',
              trimExpandedText: 'show less',
              style:GoogleFonts.rajdhani(
              textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: kBlackcolor,
             fontSize: kFontsize.sp,
              ),
              ),
              ),
              ),
              ),


              ]
              ),


              ],
              ),
                 SizedBox(height: 10,)

              ],

              )
              ),
              )
                      ],
                    );
                    }),
         ],
       ),
     ),
   );

    }).toList()
        )])
    )
    ])));

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
          });

        });
      });
    }catch (e){
      print(e);
    }
  }


  Future<void> _down(List<Lecture> lectures) async {


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

      for(int i = 0; i < lectures.length; i++) {
        final id = await FlutterDownloader.enqueue(
          url: lectures[i].sections[i].vido.toString(),
          savedDir: _localPath,
          //externalDir.path,
          fileName: '${lectures[i].sections[i].name}.mp4',
          showNotification: true,
          openFileFromNotification: true,
        );
        //download attachment

         await FlutterDownloader.enqueue(
          url: lectures[i].sections[i].at.toString(),
          savedDir: _localPath,
          //externalDir.path,
          fileName: '${lectures[i].sections[0].title}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
      }

      //download attachment

      /*for(int i = 0; i < lectures[i].sections.length; i++) {
        final id = await FlutterDownloader.enqueue(
          url: lectures[i].sections[i].at,
          savedDir: _localPath,
          //externalDir.path,
          fileName: '${lectures[i].sections[0].title}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
      }*/


      //check if user details is already in database
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('userDownloads')
          .where('id', isEqualTo: widget.doc['id'])
          .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 0) {
        ///update download count for this count
        FirebaseFirestore.instance.collection(widget.doc['sup']).doc(widget.doc['suid']).collection(widget.doc['sub']).doc(widget.doc['id']).get().then((result) {
          dynamic total = result.data()!['dct'] + 1;

          result.reference.set({
            'dct': total,

          }, SetOptions(merge: true));
        });

        FirebaseFirestore.instance.collection('userDownloads').add({

          'id':widget.doc['id'],
          'ts':DateTime.now().toString(),
          'pimg':GlobalVariables.loggedInUserObject.pimg,
          'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
          'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
          'oid':widget.doc['suid'],

        });
      }




    } else {
      print("Permission denied");
    }
  }else{
      SchClassConstant.displayBotToastError(title: 'You have not paid for this course');

    }

  }

}
