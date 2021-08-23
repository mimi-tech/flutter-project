import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:video_player/video_player.dart';
class StudentRecordedActivities extends StatefulWidget {
  StudentRecordedActivities({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentRecordedActivitiesState createState() => _StudentRecordedActivitiesState();
}

class _StudentRecordedActivitiesState extends State<StudentRecordedActivities> {
  List<dynamic> workingDocuments = <dynamic>[];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  var _documents = <DocumentSnapshot>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }
  @override
  Widget build(BuildContext context) {
    return workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
    workingDocuments.length == 0 && progress == true ? NoTextComment(title: kNothing,):SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('This student watched these recorded videos'.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kBlackcolor,
                  fontSize: kFontsize.sp,
                ),
              ),

            ),
          ),


          ListView.builder(
              itemCount: workingDocuments.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return Card(
                    elevation: 10,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(workingDocuments[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(workingDocuments[index]['ts']))}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    decoration: TextDecoration.underline,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),

                                ),
                              ),
                              Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    workingDocuments[index]['tmb'] == null
                                        ? Container(width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width * 0.5,
                                      child: Center(
                                        child: ShowUploadedVideo(
                                          videoPlayerController: VideoPlayerController.network(workingDocuments[index]['vid']),
                                          looping: false,
                                        ),
                                      ),
                                    )
                                        : Image.network(
                                      workingDocuments[index]['tmb'],
                                      fit: BoxFit.cover,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: ScreenUtil().setHeight(80),
                                    ),
                                    Center(
                                        child: ButtonTheme(

                                            shape: CircleBorder(),
                                            height: ScreenUtil().setHeight(50),

                                            child: RaisedButton(
                                                color: Colors.transparent,
                                                textColor: Colors.white,
                                                onPressed: () {},
                                                child: GestureDetector(
                                                    onTap: () {
                                                      UploadVariables.videoUrlSelected =
                                                      workingDocuments[index]['vid'];
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                    },
                                                    child: Icon(
                                                        Icons.play_arrow,
                                                        size: 40)))))
                                  ]),

                              Divider(),
                              ShowRichText(color:kIconColor,title: 'By: ',titleText: workingDocuments[index]['tsn']),
                              ShowRichText(color:kIconColor,title: 'Title: ',titleText: workingDocuments[index]['tp']),
                              ShowRichText(color:kIconColor,title: 'Description: ',titleText: workingDocuments[index]['desc']),
                              ShowRichText(color:kIconColor,title: 'Date & time: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(workingDocuments[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(workingDocuments[index]['ts']))} '),




                            ]
                        )
                    )
                );
              }),

          prog == true || _loadMoreProgress == true
              || _documents.length < SocialConstant.streamLength
              ?Text(''):
          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
              onTap: (){loadMore();},
              child: SvgPicture.asset('assets/classroom/load_more.svg',))
        ],
      ),
    );}


  void getResult() {
    try{

      if(SchClassConstant.isTeacher){


        workingDocuments = SchClassConstant.studentsActivityItems.where(
                (element) => element['stId'] == widget.doc['id']
          && element['tcId'] == SchClassConstant.schDoc['id']
          && element['sc'] == true
        ).toList();
        if(workingDocuments.length == 0){
          setState(() {
            progress = true;
          });}



       /* FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
            .collection('sActivity')
            .where('stId',isEqualTo:  widget.doc['id'])
            .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
            .where('sc',isEqualTo:  true)
            .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
            .snapshots().listen((result) {
          final List < DocumentSnapshot > documents = result.docs;

          if (documents.length != 0) {
            workingDocuments.clear();
            for (DocumentSnapshot document in documents) {

              _lastDocument = documents.last;
              setState(() {
                workingDocuments.add(document.data());
                _documents.add(document);

              });
            }
          }else{

            setState(() {
              progress = true;
            });
          }
        });*/
      }else{


      FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
          .collection('sActivity')
          .where('stId',isEqualTo:  widget.doc['id'])
          .where('sc',isEqualTo:  true)
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });}


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {


    FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
        .collection('sActivity')
        .where('stId',isEqualTo:  widget.doc['id'])
        .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
        .where('sc',isEqualTo: true)
        .orderBy('ts',descending: true)
        .startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length == 0) {
        setState(() {
          _loadMoreProgress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          _lastDocument = documents.last;

          setState(() {
            moreData = true;
            _documents.add(document);
            workingDocuments.add(document.data());

            moreData = false;
          });
        }
      }
    });
  }

  }



