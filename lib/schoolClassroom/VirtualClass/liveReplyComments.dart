import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/VirtualClass/live_toReplyComment.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:timeago/timeago.dart' as timeago;

class LiveReplyComments extends StatefulWidget {
  LiveReplyComments({required this.doc});
  final Map<String, dynamic> doc;

  @override
  _LiveReplyCommentsState createState() => _LiveReplyCommentsState();
}

class _LiveReplyCommentsState extends State<LiveReplyComments> {
  bool isOnReply = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('liveCommentsReplied')
            .where('cid', isEqualTo: widget.doc['id'])
        //.orderBy('ts', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressIndicatorState(),
            );
          } else {
            final List<Map<String, dynamic>> workingDocuments =
            snapshot.data!.docs as List<Map<String, dynamic>>;
            return workingDocuments.length == 0
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No one has replied.Be the first to reply this comment.',
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kMaincolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            )
                : Expanded(
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.builder(
                      itemCount: workingDocuments.length,
                      shrinkWrap: true,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        return Column(
                          children: [
                            Divider(
                              thickness: 2,
                              color: kMaincolor,
                            ),
                            Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 30),
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
                                            CachedNetworkImage(
                                              imageUrl:
                                              workingDocuments[index]
                                              ['pimg'],
                                              imageBuilder: (context,
                                                  imageProvider) =>
                                                  Container(
                                                    width: kImageWidth.w,
                                                    height: kImageHeight.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image:
                                                          imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                              placeholder: (context,
                                                  url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Image.asset(
                                                      'images/classroom/user.png'),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              '${workingDocuments[index]['fn']}',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color:
                                                  Colors.blueAccent,
                                                  fontSize: kFontsize.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                            '${workingDocuments[index]['rtfn']} ',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: kFontSize14.sp,
                                              color: kWhitecolor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: workingDocuments[
                                                index]['msg'],
                                                style:
                                                GoogleFonts.rajdhani(
                                                  fontSize: kFontsize.sp,
                                                  color: Colors.pink,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                              ),
                                            ],
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
                                                  '${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')}',
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

                                            /* Row(
                                              children: [
                                                IconButton(icon: Icon(Icons.reply,color:kbtnsecond), onPressed: (){_replyComment(workingDocuments,index);}),
                                                Text('${workingDocuments[index]['re']}',

                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kLightGreen,
                                                      fontSize: ScreenUtil().setSp(
                                                          kFontSize14, allowFontScalingSelf: true),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),*/
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
            );
          }
        });
  }
}

class LiveClassReplyComments extends StatefulWidget {
  LiveClassReplyComments({required this.doc});
  final Map<String, dynamic> doc;
  @override
  _LiveClassReplyCommentsState createState() => _LiveClassReplyCommentsState();
}

class _LiveClassReplyCommentsState extends State<LiveClassReplyComments> {
  final messageTextController = TextEditingController();
  String? messageText;
  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      messageTextController.text = '${widget.doc['fn']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: kBlackcolor.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LiveToReplyComment(doc: widget.doc),
                LiveReplyComments(doc: widget.doc),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          cursorColor: kMaincolor,
                          autofocus: true,
                          autocorrect: true,
                          maxLines: null,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
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
          ),
        ));
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
      DocumentReference docRef =
      FirebaseFirestore.instance.collection('liveCommentsReplied').doc();
      docRef.set({
        'fn': isTeacher
            ? SchClassConstant.schDoc['tc']
            : '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',

        'pimg': SchClassConstant.isUniStudent || isTeacher
            ? GlobalVariables.loggedInUserObject.pimg
            : null,
        'msg': messageText,
        'oid': videoId, //course id
        'ts': DateTime.now().toString(),
        'id': docRef.id,
        'cid': widget.doc['id'],
        're': 0,
        'rtfn': widget.doc['fn'], //reply to first name
        //'rtln':widget.doc['ln'],//reply to first name
      });

      //increase the number of reply
      FirebaseFirestore.instance
          .collection('liveVideoComment')
          .doc(videoId)
          .collection('videoComment')
          .doc(widget.doc['id'])
          .get()
          .then((value) {
        var count = value.data()!['re'] + 1;
        value.reference.set({
          're': count,
        }, SetOptions(merge: true));
      });

      setState(() {
        messageTextController.clear();
        progress = false;
      });
      print('successful');
    } catch (e) {
      print('rrrrrr$e');
    }
  }
}
