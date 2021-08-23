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
import 'package:sparks/social/showComments.dart';
import 'package:sparks/social/socialConstants/PlayingSocialVideos.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialConstants/social_icons_light.dart';
import 'package:sparks/social/social_video_stream.dart';
import 'package:video_player/video_player.dart';
class PlaySocialVideo extends StatefulWidget {
  PlaySocialVideo({required this.doc});
  final DocumentSnapshot doc;

  @override
  _PlaySocialVideoState createState() => _PlaySocialVideoState();
}

class _PlaySocialVideoState extends State<PlaySocialVideo> {
  dynamic likeCount = 0;
  dynamic shareCount = 0;
  dynamic rating;

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
                child: PlayingSocialVideo(
                  videoPlayerController: VideoPlayerController.network(UploadVariables.videoUrlSelected!),

                  looping: false,
                ),
              ),

              SocialIconsLight(
                views: (){},
                comments: (){_commentCount();},
                rating: (){_showRating();},
                share: (){_shareCount();},
                like: (){_likeCount();},
                viewsNumber: widget.doc['views'].toString(),
                commentsNumber: widget.doc['comm'].toString(),
                ratingNumber: widget.doc['rate'].toString(),
                likeNumber: likeCount.toString(),
                shareNumber:shareCount.toString(),

                saveUrl: widget.doc['prom'],
                saveName:widget.doc['name'] == null?widget.doc['title']:widget.doc['name'] ,
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
        builder: (context) {return SocialVideoStream(doc:widget.doc);});
  }

  void _commentCount() {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MessageStream(doc:widget.doc)));

  }

  Future<void> _shareCount() async {

    Share.share(widget.doc['prom'] == null?widget.doc['vido']:widget.doc['prom']);

    FirebaseFirestore.instance.collection(widget.doc['sup']).doc(widget.doc['suid']).collection(widget.doc['sub'])
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['share'] + 1;
        comm.reference.set({
          'share':count,
        },SetOptions(merge: true));

      });
    });
    setState(() {
      likeCount = likeCount + 1;
    });

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('sharedVideos')
        .where('id', isEqualTo: widget.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedVideos').add({
        'id':widget.doc['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'oid':widget.doc['suid'],
        'ofn':widget.doc['fn'],
        'oln':widget.doc['ln'],

      });

    }

  }

  Future<void> _likeCount() async {
try{

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedVideos')
        .where('id', isEqualTo: widget.doc['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      FirebaseFirestore.instance.collection(widget.doc['sup']).doc(
          widget.doc['suid']).collection(widget.doc['sub'])
          .where('id', isEqualTo: widget.doc['id'])
          .get()
          .then((value) {
        value.docs.forEach((comm) {
          var count = comm.data()['like'] + 1;
          comm.reference.set({
            'like': count,
          }, SetOptions(merge: true));
        });
      });

      setState(() {
        likeCount = likeCount + 1;
      });

      //push to database
      FirebaseFirestore.instance.collection('likedVideos').add({
        'id':widget.doc['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,


      });
    }
  }catch(e){
  print('ttttttt$e');
  }
  }


    //update database check if this user have rated this video








  Future<void> _submitRating() async {
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('ratedVideos')
          .where('id', isEqualTo: widget.doc['id'])
          .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length >= 1) {
        SchClassConstant.displayBotToastError(title: kRated);

      }else {
        //update video rating count

        FirebaseFirestore.instance.collection(widget.doc['sup']).doc(widget.doc['suid']).collection(widget.doc['sub']).doc(widget.doc['id'] ).get().then((result) {
          dynamic total = result.data()!['rate'] + SocialConstant.ratingCount;

          result.reference.set({
            'rate': total,

          }, SetOptions(merge: true));
        });


        //push to database
        FirebaseFirestore.instance.collection('ratedVideos').add({
          'id':widget.doc['id'],
          'uid':GlobalVariables.loggedInUserObject.id,
          'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
          'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
          'ts':DateTime.now().toString(),
          'pimg':GlobalVariables.loggedInUserObject.pimg,


        });
        SchClassConstant.displayBotToastCorrect(title: kRatedThanks);

      }}catch(e){
      print(e);
    }
  }

  void _showRating() {
    SocialConstant.showRating(submit: (){_submitRating();});
  }

}