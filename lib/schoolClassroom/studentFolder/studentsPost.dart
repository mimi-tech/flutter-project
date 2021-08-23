import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/schoolPost/postComments.dart';
import 'package:sparks/schoolClassroom/schoolPost/postLikeByStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSharedByStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/schoolPost/seeImagePost.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentPostProfile.dart';
import 'package:sparks/schoolClassroom/schoolPost/videosInHorizontalView.dart';
import 'package:sparks/schoolClassroom/schoolPost/watchPostVideos.dart';
import 'package:sparks/schoolClassroom/studentFolder/studentHorizontalVideos.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/utils/postIcons.dart';
import 'package:sparks/schoolClassroom/utils/postIconsSecond.dart';
import 'package:sparks/schoolClassroom/utils/postPlayingVideos.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class StudentsPostScreen extends StatefulWidget {
  StudentsPostScreen({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentsPostScreenState createState() => _StudentsPostScreenState();
}

class _StudentsPostScreenState extends State<StudentsPostScreen> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> multiPix = <dynamic>[];
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
  int count = 1;
  bool isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStudentPosts();

  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('${widget.doc['fn']} ${widget.doc['ln']} post'.toUpperCase(),
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              fontWeight: FontWeight.bold,
              color: kWhitecolor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      StudentVideoPostsHorizontal(doc:widget.doc),

                      workingDocuments.length == 0 && progress == false ?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):
                      workingDocuments.length == 0 && progress == true ?Center(
                        child: Text(kNoSPost,
                          style: GoogleFonts.rajdhani(
                            fontSize:kFontsize.sp,
                            fontWeight: FontWeight.bold,
                            color: kBlackcolor,
                          ),
                        ),
                      ):
                      ListView.builder(
                          itemCount: workingDocuments.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, int index) {

                            return Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(SchClassConstant.isUniStudent){
                                        SchoolPostConst.doc = _documents[index];
                                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsPostProfile(doc:_documents[index])));

                                      }},
                                    child: Row(
                                      children: [
                                        ProfilePix(pix: workingDocuments[index]['pimg'],),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                              style: GoogleFonts.rajdhani(
                                                fontSize:kFontsize.sp,
                                                fontWeight: FontWeight.bold,
                                                color: kBlackcolor,
                                              ),
                                            ),

                                            Text('${workingDocuments[index]['dept']} department',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontSize14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: klistnmber,
                                              ),
                                            ),
                                            Text('${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')} ago',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontSize14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: klistnmber,
                                              ),
                                            ),


                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  workingDocuments[index]['mpix'] == true?
                                  Stack(
                                    children: [

                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SeeImagePost(doc:_documents[index])));

                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              kSocialVideoCurve),

                                          child: FadeInImage.assetNetwork(

                                            //height: MediaQuery.of(context).size.height * kSocialVideoCurve3,
                                            fit: BoxFit.cover,
                                            image: ('${workingDocuments[index]['pix'][0]}'.toString()),
                                            placeholder: 'images/classroom/user.png',),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.add,color: kIconColor,),
                                              Text(workingDocuments[index]['ct'].toString(),
                                                style: GoogleFonts.rajdhani(
                                                  fontSize:kFontsize.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: kExpertColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )

                                      :workingDocuments[index]['txt'] == true?

                                  Container(

                                    decoration:BoxDecoration(
                                        borderRadius:BorderRadius.circular(6.0),
                                        color: Color(int.parse(workingDocuments[index]['bg'])).withOpacity(1)
                                    ),
                                    child:  Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:18.0,bottom:18),

                                        child: Text(workingDocuments[index]['msg'],
                                          textAlign:TextAlign.center,
                                          style: GoogleFonts.rajdhani(

                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                            color: kWhitecolor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                      :GestureDetector(
                                    onLongPress:(){
                                      SchoolPostConst.doc = _documents[index];

                                      UploadVariables.videoUrlSelected = workingDocuments[index]['vido'];
                                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WatchPostVideos(doc:_documents[index])));

                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          //width: MediaQuery.of(context).size.width,
                                          //height: MediaQuery.of(context).size.height * kSocialVideoCurve2,
                                          child:PlayingSchoolPostVideos(
                                            videoPlayerController: VideoPlayerController.network(workingDocuments[index]['vido']),
                                            looping: false,
                                            playing: isPlaying,
                                          ),

                                          /*PlayingSchoolPostVideos(
                         videoPlayerController: VideoPlayerController.network(workingDocuments[index]['vido']),
                         looping: false,
                          playing: isPlaying,
                        ),
*/
                                          /*AspectRatio(
                            aspectRatio: 16 / 9,
                            child: BetterPlayerListVideoPlayer(
                              BetterPlayerDataSource(
                                  BetterPlayerDataSourceType.network, workingDocuments[index]['vido']),
                              key: Key(workingDocuments[index]['vido'].hashCode.toString()),
                              playFraction: 0.8,
                            ),
                          ),*/
                                        ),


                                      ],
                                    ),
                                  ),
                                  SchoolPostIconsSecond(
                                    viewLikes: (){
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => StudentsLikePost(doc: _documents[index],));},


                                    viewShare: (){
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => StudentsSharedPost(doc: _documents[index],));
                                    },


                                    myColor:kWhitecolor,
                                    comments: (){
                                      Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: PostCommentStream(doc:_documents[index])));

                                    },
                                    share: (){ if(workingDocuments[index]['txt']== false) {
                                      _shareCount(index);
                                    }},
                                    like: (){_likeCount(index);},

                                    commentsNumber: workingDocuments[index]['com'].toString(),
                                    likeNumber: workingDocuments[index]['like'].toString(),
                                    shareNumber:workingDocuments[index]['share'].toString(),
                                    saveVideo: (){
                                      if( workingDocuments[index]['txt'] == true){
                                        _saveThisVideo(index);

                                      }},

                                    viewsNumber: workingDocuments[index]['txt'] == true || workingDocuments[index]['txt'] == null?Visibility(
                                        visible:false,
                                        child: Text('')):Row(
                                      children: [
                                        SvgPicture.asset('images/classroom/views.svg',color: kIconColor,height: 15,width: 15,),
                                        //IconButton(icon:SvgPicture.asset('images/classroom/views.svg'), onPressed:widget.views,),
                                        Text(workingDocuments[index]['view'].toString(),
                                          style: GoogleFonts.rajdhani(fontSize: 12.sp,
                                            color:kIconColor,
                                            fontWeight: FontWeight.bold,

                                          ),),
                                      ],
                                    ),
                                  ),


                                ],
                              ),
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
        ),



              ));

  }

  Future<void> getStudentPosts() async {


    FirebaseFirestore.instance.collection('schoolPost').doc(SchClassConstant.schDoc['schId']).collection('campusPost')
        .where('stId',isEqualTo: widget.doc['id'])
        .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
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
    });

  }


  Future<void> loadMore() async {

    FirebaseFirestore.instance.collection('schoolPost').doc(SchClassConstant.schDoc['schId']).collection('campusPost')
        .where('stId',isEqualTo: widget.doc['id'])
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



  Future<void> _likeCount(int index) async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedSchPost')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length >= 1) {


    }else {
      setState(() {
        workingDocuments[index]['like'] = workingDocuments[index]['like'] + 1;
      });

      FirebaseFirestore.instance.collection('schoolPost').doc(workingDocuments[index]['schId']).collection('campusPost')
          .doc(workingDocuments[index]['id'] )
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
        'id':workingDocuments[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],

      });

    }}

  Future<void> _shareCount(int index) async {

    Share.share(workingDocuments[index]['vido']);

    FirebaseFirestore.instance.collection('schoolPost').doc(workingDocuments[index]['schId']).collection('campusPost')

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
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedSchPost').add({
        'id':workingDocuments[index]['id'],
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

  Future<void> _saveThisVideo(int index) async {
//check if student have saved this video before
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost')
        .where('id', isEqualTo: workingDocuments[index]['id'])

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //push video saved to database
      DocumentReference docRef =  FirebaseFirestore.instance.collection('studentSavedPost').doc(GlobalVariables.loggedInUserObject.id).collection('savedPost').doc();
      docRef.set({

        'pid':workingDocuments[index]['id'],
        'uid':GlobalVariables.loggedInUserObject.id,
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ts':DateTime.now().toString(),
        'pimg':GlobalVariables.loggedInUserObject.pimg,
        'dept':SchClassConstant.schDoc['dept'],
        'lv':SchClassConstant.schDoc['lv'],
        'id':docRef.id,
        'post': workingDocuments[index]['vido'],
        'view':workingDocuments[index]['view'],
        'com':workingDocuments[index]['com'],
        'share':workingDocuments[index]['share'],
        'like':workingDocuments[index]['like']

      });
      SchClassConstant.displayToastCorrect(title: 'SavedSuccessfully');

    }else{
      SchClassConstant.displayToastError(title: 'You have saved this video already');
    }

  }

}
