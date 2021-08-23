import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/allPostVideos.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentPostProfile.dart';
import 'package:sparks/schoolClassroom/studentFolder/studentsVideoPostVertical.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:video_player/video_player.dart';

class StudentVideoPostsHorizontal extends StatefulWidget {
  StudentVideoPostsHorizontal({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentVideoPostsHorizontalState createState() => _StudentVideoPostsHorizontalState();
}

class _StudentVideoPostsHorizontalState extends State<StudentVideoPostsHorizontal> {

  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoPost();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => setState((){}));

    Future.delayed(const Duration(seconds: 10), () async {
      _timer.cancel();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return   workingDocuments.length == 0 ? Text(''):

    Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        workingDocuments.length < 2?Text(''):GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentVideoPostsVertical(doc:widget.doc)));

          },
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('see all',
                style: GoogleFonts.rajdhani(
                  fontSize:kFontsize.sp,
                  color: kLightGreen,
                  fontWeight: FontWeight.bold,

                ),),
            ),
          ),
        ),
        Container(
          height: 250.0,
          child: Card(
            elevation: 10,
            child: ListView.builder(
                itemCount: workingDocuments.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int index) {

                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [



                          Container(
                            //color:kFbColor,
                            width: MediaQuery.of(context).size.width * kStuPostW,
                            height: MediaQuery.of(context).size.height * kStuPostH,
                            child: Stack(
                              //alignment:Alignment.topRight,
                                children: [

                                  Align(
                                    alignment:Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(SchClassConstant.isUniStudent){
                                          SchoolPostConst.doc = _documents[index];
                                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsPostProfile(doc:_documents[index])));

                                        }},
                                      child: Container(
                                        //width: MediaQuery.of(context).size.width * 0.6,
                                          height: 40,
                                          color: kWhitecolor,

                                          child:Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.transparent,
                                                child: ClipOval(
                                                  child: CachedNetworkImage(

                                                    imageUrl: workingDocuments[index]['pimg'],
                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    width: 20.0,
                                                    height: 20.0,

                                                  ),
                                                ),
                                              ),

                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * kStuPostTextW),

                                                    child: Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.rajdhani(
                                                        fontSize: kFontSize12.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: kBlackcolor,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * kStuPostTextW),
                                                    child: Text('${workingDocuments[index]['dept']} department',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.rajdhani(
                                                        fontSize: kFontSize14.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: kBlackcolor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Spacer(),
                                              Row(
                                                children: [
                                                  SvgPicture.asset("images/classroom/views.svg",color: kFbColor,),
                                                  Text(workingDocuments[index]['view'].toString(),

                                                    style: GoogleFonts.rajdhani(
                                                      fontSize: kFontSize12.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: klistnmber,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllSchoolPostVideos()));

                                    },
                                    child: Center(
                                      child: ShowUploadedVideo(
                                        videoPlayerController:
                                        VideoPlayerController.network(workingDocuments[index]['vido']),
                                        looping: false,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment:Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset("images/classroom/uploadvideo.svg"),
                                      )),

                                  Align(
                                      alignment:Alignment.bottomCenter,

                                      child:Container(
                                        height: 40,
                                        color: kWhitecolor,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * kStuPostTextW),

                                              child: Text(workingDocuments[index]['title'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontSize12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: kBlackcolor,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Material(
                                                  color:kFbColor,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text('Profile',
                                                      style: GoogleFonts.rajdhani(
                                                        fontSize: kFontSize12.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: kWhitecolor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Icon(Icons.person,color: kFbColor,)                                    ],
                                            ),

                                          ],
                                        ),
                                      )
                                  ),

                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Future<void> getVideoPost() async {
    workingDocuments.clear();

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('schoolPost').doc(widget.doc['schId']).collection('campusPost')
        .where('stId',isEqualTo: widget.doc['id'])
        .where('txt',isEqualTo: false)
        .orderBy('ts',descending: true).limit(10)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length != 0) {
      for (DocumentSnapshot document in documents) {
        setState(() {
          workingDocuments.add(document.data());
          _documents.add(document);
        });

      }

    }
  }}


