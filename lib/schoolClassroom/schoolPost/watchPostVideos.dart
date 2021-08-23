import 'package:better_player/better_player.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/getStudentAllVideos.dart';
import 'package:sparks/schoolClassroom/schoolPost/postComments.dart';
import 'package:sparks/schoolClassroom/utils/postIcons.dart';
import 'package:sparks/schoolClassroom/utils/postPlayingVideos.dart';

import 'package:video_player/video_player.dart';
class WatchPostVideos extends StatefulWidget {
  WatchPostVideos({required this.doc});
  final DocumentSnapshot doc;

  @override
  _WatchPostVideosState createState() => _WatchPostVideosState();
}

class _WatchPostVideosState extends State<WatchPostVideos> {
  dynamic likeCount = 0;
  dynamic shareCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      likeCount = widget.doc['like'];
      shareCount = widget.doc['share'];
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackcolor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: (){
          displayBottomSheet();
        },
        child: Column(
            children: <Widget>[
              Expanded(
                child: PlayingSchoolPostVideos(
                  videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),
                  playing: true,
                  looping: false,
                ),
              ),

              SchoolPostIcons(
                views: (){},
                comments: (){_commentCount();},
                share: (){_shareCount();},
                like: (){_likeCount();},
                viewsNumber: widget.doc['view'].toString(),
                commentsNumber: widget.doc['com'].toString(),
                likeNumber: likeCount.toString(),
                shareNumber:shareCount.toString(),
                saveVideo: (){_saveThisVideo();},
              ),


            ]
        ),
      ),

    );
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        backgroundColor: kBlackcolor,
        isDismissible: true,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {return StudentVideoStream(doc:widget.doc);});
  }

  void _commentCount() {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: PostCommentStream(doc:widget.doc)));

  }




  Future<void> _likeCount() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedSchPost')
        .where('id', isEqualTo: widget.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {

      FirebaseFirestore.instance.collection('schoolPost').doc(widget.doc['schId']).collection('campusPost')
          .doc(widget.doc['id'] )
      //.doc(workingDocuments[index]['id'])
          .get()
          .then((value) {

        var count = value.data()!['like'] + 1;
        value.reference.set({
          'like': count,
        }, SetOptions(merge: true));


      });

      //push to database
      FirebaseFirestore.instance.collection('likedSchPost').add({
        'id':widget.doc['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],

      });

    }}

  Future<void> _shareCount() async {

    Share.share(widget.doc['vido']);

    FirebaseFirestore.instance.collection('schoolPost').doc(widget.doc['schId']).collection('campusPost')

        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['share'] + 1;
        comm.reference.set({
          'share':count,
        },SetOptions(merge: true));

      });
    });

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('sharedVideos')
        .where('id', isEqualTo: widget.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedSchPost').add({
        'id':widget.doc['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],

      });

    }

  }

  Future<void> _saveThisVideo() async {
//check if student have saved this video before
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost')
        .where('pid', isEqualTo: widget.doc['id'])

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video saved to database
      DocumentReference docRef =  FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost').doc();
      docRef.set({

        'pid':widget.doc['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],
        'id':docRef.id,
        'post': widget.doc['vido']

      });
      SchClassConstant.displayToastCorrect(title: 'SavedSuccessfully');

    }else{
      SchClassConstant.displayToastError(title: 'You have saved this video already');
    }

  }








}