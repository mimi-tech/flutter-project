import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/VirtualClass/liveReplyComments.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:timeago/timeago.dart' as timeago;

class SchoolLiveComments extends StatefulWidget {
  @override
  _SchoolLiveCommentsState createState() => _SchoolLiveCommentsState();
}

class _SchoolLiveCommentsState extends State<SchoolLiveComments> {
  bool progress = false;

  late StreamSubscription stream;
  List<Map<String, dynamic>> _documents = [];
  bool moreData = false;
  List<dynamic> liveComments = <dynamic>[];
  bool prog = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getComment();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream.cancel();
  }

  void getComment() {
    stream = FirebaseFirestore.instance
        .collection("liveVideoComment")
        .doc(videoId)
        .collection('videoComment')
        .snapshots()
        .listen((result) {
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          prog = true;
        });
      } else {
        liveComments.clear();
        _documents.clear();
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          setState(() {
            liveComments.add(document.data());
            _documents.add(data);
            prog = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          liveComments.length == 0 && prog == false
              ? PlatformCircularProgressIndicator()
              : liveComments.length == 0 && prog == true
              ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'No comment yet. Be the first to comment',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kMaincolor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Students Comments'.toUpperCase(),
                  style: GoogleFonts.pacifico(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kMaincolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: liveComments.length,
                  shrinkWrap: true,
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        Divider(
                          thickness: 0.5,
                          color: kMaincolor,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context)
                                      .size
                                      .width,
                                  minHeight: ScreenUtil().setHeight(
                                      constrainedReadMoreHeight),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:
                                            Colors.transparent,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              liveComments[index]
                                              ['pimg'],
                                              imageBuilder: (context,
                                                  imageProvider) =>
                                                  Container(
                                                    width: kImageWidth.w,
                                                    height:
                                                    kImageHeight.h,
                                                    decoration:
                                                    BoxDecoration(
                                                      shape:
                                                      BoxShape.circle,
                                                      image: DecorationImage(
                                                          image:
                                                          imageProvider,
                                                          fit: BoxFit
                                                              .cover),
                                                    ),
                                                  ),
                                              placeholder: (context,
                                                  url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context,
                                                  url, error) =>
                                                  Image.asset(
                                                      'images/classroom/user.png'),
                                            )),
                                        SizedBox(width: 5),
                                        Text(
                                          '${liveComments[index]['fn']}',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              color:
                                              Colors.orangeAccent,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ReadMoreText(
                                      liveComments[index]['msg'],
                                      trimLines: 4,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: ' ...',
                                      trimExpandedText: ' less',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: kFontsize.sp,
                                        color: kWhitecolor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                    Icons.timer,
                                                    color:
                                                    kbtnsecond),
                                                onPressed: () {}),
                                            Text(
                                              '${timeago.format(DateTime.parse(liveComments[index]['ts']), locale: 'en_short')}',
                                              style: GoogleFonts
                                                  .rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: klistnmber,
                                                  fontSize:
                                                  kFontSize14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                    Icons.reply,
                                                    color:
                                                    kbtnsecond),
                                                onPressed: () {
                                                  _replyComment(
                                                      _documents,
                                                      index);
                                                }),
                                            Text(
                                              '${liveComments[index]['re']}',
                                              style: GoogleFonts
                                                  .rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: kLightGreen,
                                                  fontSize:
                                                  kFontSize14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void _replyComment(List<Map<String, dynamic>> _documents, int index) {
    showBottomSheet(
        backgroundColor: kBlackcolor.withOpacity(0.5),
        context: context,
        //isScrollControlled: true,
        builder: (context) => LiveClassReplyComments(doc: _documents[index]));
    //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: LiveClassReplyComments(doc:_documents[index])));
  }
}

class LiveMessageStream extends StatefulWidget {
  @override
  _LiveMessageStreamState createState() => _LiveMessageStreamState();
}

class _LiveMessageStreamState extends State<LiveMessageStream> {
  final messageTextController = TextEditingController();
  String? messageText;
  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: kBlackcolor.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SchoolLiveComments(),
                  Container(
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageTextController,
                            maxLines: null,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: Constants.kCommentTextFieldDecoration,
                          ),
                        ),
                        progress
                            ? CircularProgressIndicator(
                          backgroundColor: kFbColor,
                        )
                            : FlatButton(
                          color: kWhitecolor,
                          height: 48,
                          onPressed: () {
                            _sendComment();
                          },
                          child: Text(
                            'Send',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kExpertColor,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  _sendComment() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      progress = true;
    });
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('liveVideoComment')
          .doc(videoId)
          .collection('videoComment')
          .doc();
      docRef.set({
        'fn': isTeacher
            ? SchClassConstant.schDoc['tc']
            : '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
        'msg': messageText,
        'pimg': SchClassConstant.isUniStudent || isTeacher
            ? GlobalVariables.loggedInUserObject.pimg
            : null,
        'oid': videoId,
        'ts': DateTime.now().toString(),
        'id': docRef.id,
        're': 0,
      });

//get the comments count
      FirebaseFirestore.instance
          .collection("liveVideoCommentCount")
          .doc(videoId)
          .get()
          .then((value) {
        if (value.exists) {
          var res = value.data()!['ct'] + 1;
          value.reference.set({'ct': res}, SetOptions(merge: true));
        } else {
          FirebaseFirestore.instance
              .collection("liveVideoCommentCount")
              .doc(videoId)
              .set({'ct': 1});
        }
      });

      setState(() {
        messageTextController.clear();
        progress = false;
      });
      print('successful');
    } catch (e) {
      print('yyyyyyyy$e');
      setState(() {
        messageTextController.clear();
        progress = false;
      });
    }
  }
}
