import 'dart:async';
import 'package:better_player/better_player.dart';
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
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postComments.dart';
import 'package:sparks/schoolClassroom/schoolPost/postLikeByStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSharedByStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/schoolProfile.dart';
import 'package:sparks/schoolClassroom/schoolPost/seeImagePost.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentPostProfile.dart';
import 'package:sparks/schoolClassroom/utils/postIconsSecond.dart';
import 'package:sparks/schoolClassroom/utils/postPlayingVideos.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class AllSchoolPostVideos extends StatefulWidget {
  @override
  _AllSchoolPostVideosState createState() => _AllSchoolPostVideosState();
}

class _AllSchoolPostVideosState extends State<AllSchoolPostVideos> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  List<dynamic> multiPix = <dynamic>[];
  var _documents = [];

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  bool _loadMoreProgress = false;
  bool moreData = false;
  late var _lastDocument;
  bool prog = false;
  bool isPlaying = false;
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
    getAllSchoolPost();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackcolor,
        appBar: AppBar(
          backgroundColor: kBlackcolor,
          title: Text(
            'School Video Posts',
            style: GoogleFonts.rajdhani(
              fontSize: kFontsize.sp,
              fontWeight: FontWeight.bold,
              color: kFbColor,
            ),
          ),
        ),
        body: workingDocuments.length == 0 && progress == false
            ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kFbColor,
            ))
            : workingDocuments.length == 0 && progress == true
            ? Text('No video has been posted')
            : SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  itemCount: workingDocuments.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return Card(
                      color: kBlackcolor,
                      elevation: 5,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SeeImagePost(doc:_documents[index])));

                              if (SchClassConstant.isUniStudent) {
                                SchoolPostConst.doc =
                                _documents[index];
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: StudentsPostProfile(
                                            doc: _documents[index])));
                              } else {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SchoolProfile()));
                              }
                            },
                            child: Row(
                              children: [
                                ProfilePix(
                                  pix: workingDocuments[index]
                                  ['pimg'],
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: kFontsize.sp,
                                        fontWeight: FontWeight.bold,
                                        color: kWhitecolor,
                                      ),
                                    ),
                                    Text(
                                      '${workingDocuments[index]['dept']}'
                                          .toUpperCase(),
                                      style: GoogleFonts.rajdhani(
                                        fontSize: kFontSize14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kExpertColor,
                                      ),
                                    ),
                                    Text(
                                      '${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')} ago',
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
                          PlayingSchoolPostVideos(
                            videoPlayerController: VideoPlayerController.network(workingDocuments[index]['vido']),
                            looping: false,
                            playing: isPlaying,
                          ),

                          SchoolPostIconsSecond(
                            viewLikes: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      StudentsLikePost(
                                        doc: _documents[index],
                                      ));
                            },

                            viewShare: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      StudentsSharedPost(
                                        doc: _documents[index],
                                      ));
                            },
                            myColor: kBlackcolor,
                            //views: (){},
                            comments: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType
                                          .bottomToTop,
                                      child: PostCommentStream(
                                          doc: _documents[index])));
                            },
                            share: () {
                              if (workingDocuments[index]['txt'] ==
                                  false) {
                                _shareCount(index);
                              }
                            },
                            like: () {
                              _likeCount(index);
                            },

                            commentsNumber: workingDocuments[index]
                            ['com']
                                .toString(),
                            likeNumber: workingDocuments[index]
                            ['like']
                                .toString(),
                            shareNumber: workingDocuments[index]
                            ['share']
                                .toString(),
                            saveVideo: () {
                              if (workingDocuments[index]['txt'] ==
                                  true) {
                                _saveThisVideo(index);
                              }
                            },

                            viewsNumber: workingDocuments[index]
                            ['txt'] ==
                                true ||
                                workingDocuments[index]['txt'] ==
                                    null
                                ? Visibility(
                                visible: false, child: Text(''))
                                : Row(
                              children: [
                                SvgPicture.asset(
                                  'images/classroom/views.svg',
                                  color: kIconColor,
                                  height: 15,
                                  width: 15,
                                ),
                                //IconButton(icon:SvgPicture.asset('images/classroom/views.svg'), onPressed:widget.views,),
                                Text(
                                  workingDocuments[index]
                                  ['view']
                                      .toString(),
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 12.sp,
                                    color: kIconColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              prog == true ||
                  _loadMoreProgress == true ||
                  _documents.length < SocialConstant.streamLength
                  ? Text('')
                  : moreData == true
                  ? PlatformCircularProgressIndicator()
                  : GestureDetector(
                  onTap: () {
                    loadMore();
                  },
                  child: SvgPicture.asset(
                    'assets/classroom/load_more.svg',
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllSchoolPost() async {
    FirebaseFirestore.instance
        .collection('schoolPost')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('campusPost')
        .where('pub', isEqualTo: false)
        .where('txt', isEqualTo: false)
        .orderBy('ts', descending: true)
        .limit(SocialConstant.streamLength)
        .snapshots()
        .listen((event) {
      final List<DocumentSnapshot> documents = event.docs;
      if (documents.length != 0) {
        workingDocuments.clear();
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          setState(() {
            _lastDocument = documents.last;
            workingDocuments.add(data);
            // workingDocuments.add(document.data());
            _documents.add(document);
          });
          print(data['msg']);
        }
      } else {
        setState(() {
          progress = true;
        });
      }
    });
  }

  Future<void> loadMore() async {
    FirebaseFirestore.instance
        .collection('schoolPost')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('campusPost')
        .where('pub', isEqualTo: false)
        .where('txt', isEqualTo: false)
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(SocialConstant.streamLength)
        .snapshots()
        .listen((event) {
      final List<DocumentSnapshot> documents = event.docs;
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

  Future<void> _likeCount(int index) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('likedSchPost')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length >= 1) {
    } else {
      setState(() {
        workingDocuments[index]['like'] = workingDocuments[index]['like'] + 1;
      });

      FirebaseFirestore.instance
          .collection('schoolPost')
          .doc(workingDocuments[index]['schId'])
          .collection('campusPost')
          .doc(workingDocuments[index]['id'])
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
        'id': workingDocuments[index]['id'],
        'uid': GlobalVariables.loggedInUserObject.id,
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ts': DateTime.now().toString(),
        'pimg': GlobalVariables.loggedInUserObject.pimg,
        'dept': SchClassConstant.schDoc['dept'],
        'lv': SchClassConstant.schDoc['lv'],
      });
    }
  }

  Future<void> _shareCount(int index) async {
    Share.share(workingDocuments[index]['vido']);

    FirebaseFirestore.instance
        .collection('schoolPost')
        .doc(workingDocuments[index]['schId'])
        .collection('campusPost')
        .get()
        .then((value) {
      value.docs.forEach((comm) {
        var count = comm.data()['share'] + 1;
        comm.reference.set({
          'share': count,
        }, SetOptions(merge: true));
      });
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('sharedVideos')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      //push video shared to database
      FirebaseFirestore.instance.collection('sharedSchPost').add({
        'id': workingDocuments[index]['id'],
        'uid': GlobalVariables.loggedInUserObject.id,
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ts': DateTime.now().toString(),
        'pimg': GlobalVariables.loggedInUserObject.pimg,
        'dept': SchClassConstant.schDoc['dept'],
        'lv': SchClassConstant.schDoc['lv'],
      });
    }
  }

  Future<void> _saveThisVideo(int index) async {
//check if student have saved this video before
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('studentSavedPost')
        .doc(GlobalVariables.loggedInUserObject.id)
        .collection('savedPost')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      //push video saved to database
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('studentSavedPost')
          .doc(GlobalVariables.loggedInUserObject.id)
          .collection('savedPost')
          .doc();
      docRef.set({
        'pid': workingDocuments[index]['id'],
        'uid': GlobalVariables.loggedInUserObject.id,
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ts': DateTime.now().toString(),
        'pimg': GlobalVariables.loggedInUserObject.pimg,
        'dept': SchClassConstant.schDoc['dept'],
        'lv': SchClassConstant.schDoc['lv'],
        'id': docRef.id,
        'post': workingDocuments[index]['vido']
      });
      SchClassConstant.displayToastCorrect(title: 'SavedSuccessfully');
    } else {
      SchClassConstant.displayToastError(
          title: 'You have saved this video already');
    }
  }
}
