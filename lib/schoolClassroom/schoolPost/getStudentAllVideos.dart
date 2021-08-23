import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/PlaySocialVideos.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';
import 'package:video_player/video_player.dart';

class StudentVideoStream extends StatefulWidget {
  StudentVideoStream({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentVideoStreamState createState() => _StudentVideoStreamState();
}

class _StudentVideoStreamState extends State<StudentVideoStream> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];




  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyVideos();
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: workingDocuments.length == 0 && progress == false ?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):
                workingDocuments.length == 0 && progress == true ? Text('No content'):
                Container(
                    color: kBlackcolor,
                    height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                    child: ListView.builder(
                        itemCount: workingDocuments.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Card(
                            color: kBlackcolor,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                                UploadVariables.videoUrlSelected = workingDocuments[index]['vido'];
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaySocialVideo(doc:_documents[index])));
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(kSocialVideoCurve),

                                  child: ShowUploadedVideo(
                                    videoPlayerController: VideoPlayerController.network(workingDocuments[index]['prom']),
                                    looping: false,
                                  ),
                                ),
                              ),
                            ),
                          );

                        })
                )

            )));
  }

    Future<void> getMyVideos() async {


      FirebaseFirestore.instance.collection('schoolPost').doc(SchClassConstant.schDoc['schId']).collection('campusPost')
          .where('uid',isEqualTo: widget.doc['uid'])
          .where('pub',isEqualTo: false)
          .where('txt',isEqualTo: false)

          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
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
      });

    }


    Future<void> loadMore() async {

      FirebaseFirestore.instance.collection('schoolPost').doc(SchClassConstant.schDoc['schId']).collection('campusPost')
          .where('uid',isEqualTo: widget.doc['uid'])

          .where('pub',isEqualTo: false)
          .where('txt',isEqualTo: false)

          .orderBy('ts',descending: true).
      startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if(documents.length == 0){
          setState(() {
            _loadMoreProgress = true;
          });

        }else {
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




