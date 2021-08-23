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
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/utils/social_likes.dart';
import 'package:sparks/schoolClassroom/utils/toReply_comments.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowReplyComments extends StatefulWidget {
  ShowReplyComments({required this.doc});
  final DocumentSnapshot? doc;

  @override
  _ShowReplyCommentsState createState() => _ShowReplyCommentsState();
}

class _ShowReplyCommentsState extends State<ShowReplyComments> {
  bool isOnReply = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('commentsReplied')
            .where('cid', isEqualTo: widget.doc!['id'])
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
            return Expanded(
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
                                margin: EdgeInsets.symmetric(horizontal: 30),
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
                                      maxWidth:
                                      MediaQuery.of(context).size.width,
                                      minHeight: ScreenUtil()
                                          .setHeight(constrainedReadMoreHeight),
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
                                              radius: 32,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  '${workingDocuments[index]['pimg']}',
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                      Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  width: 40.0,
                                                  height: 40.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kBlackcolor,
                                                  fontSize: kFontsize.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                            '${workingDocuments[index]['rtfn']} ${workingDocuments[index]['rtln']} ',
                                            style: GoogleFonts.rajdhani(
                                              fontSize: kFontsize.sp,
                                              color: kMaincolor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: workingDocuments[index]
                                                ['msg'],
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontsize.sp,
                                                  color: kBlackcolor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(Icons.timer,
                                                        color: kbtnsecond),
                                                    onPressed: () {}),
                                                Text(
                                                  '${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: klistnmber,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(Icons.thumb_up,
                                                        color: kbtnsecond),
                                                    onPressed: () {
                                                      _likeComment(
                                                          workingDocuments,
                                                          index);
                                                    }),
                                                Text(
                                                  '${workingDocuments[index]['like']}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: kExpertColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.verified,
                                                  color: kLightGreen,
                                                ),
                                                onPressed: () {
                                                  _replyComment(
                                                      workingDocuments, index);
                                                }),

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

  Future<void> _likeComment(
      List<Map<String, dynamic>> workingDocuments, int index) async {
    //check if comment have been liked by this user

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('likedComment')
        .where('id', isEqualTo: workingDocuments[index]['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      //increase the number of like for the comment
      FirebaseFirestore.instance
          .collection('commentsReplied')
          .doc(workingDocuments[index]['id'])
          .get()
          .then((value) {
        var count = value.data()!['like'] + 1;
        value.reference.set({
          'like': count,
        }, SetOptions(merge: true));
      });
      //create like collection
      DocumentReference docRef =
      FirebaseFirestore.instance.collection('likes').doc();
      docRef.set({
        'id': docRef.id,
        'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln': GlobalVariables.loggedInUserObject.nm!['ln'],
        'pimg': GlobalVariables.loggedInUserObject.pimg,
        'cid': workingDocuments[index]['id'],
        'ts': DateTime.now().toString(),
      });
    }
  }

  void _replyComment(List<Map<String, dynamic>> workingDocuments, int index) {
//viewLikes
    print(workingDocuments[index]['id']);
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return SocialLikes(
              doc: workingDocuments[index],
              cid: workingDocuments[index]['cid']);
        });
  }
}

class SocialReplyComments extends StatefulWidget {
  SocialReplyComments({required this.doc});
  final DocumentSnapshot? doc;
  @override
  _SocialReplyCommentsState createState() => _SocialReplyCommentsState();
}

class _SocialReplyCommentsState extends State<SocialReplyComments> {
  final messageTextController = TextEditingController();
  String? messageText;
  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      messageTextController.text = '${widget.doc!['fn']} ${widget.doc!['ln']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlackcolor,
          title: Text(
            'Reply ${widget.doc!['fn']}'.toUpperCase(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ToReplyComment(doc: widget.doc),
            ShowReplyComments(doc: widget.doc),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      maxLines: null,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
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
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      FirebaseFirestore.instance.collection('commentsReplied').doc();
      docRef.set({
        'fn': GlobalVariables.loggedInUserObject.nm!['fn'],
        'ln': GlobalVariables.loggedInUserObject.nm!['ln'],
        'pimg': GlobalVariables.loggedInUserObject.pimg,
        'msg': messageText,
        'title': widget.doc!['title'],
        'ofn': widget.doc!['ofn'],
        'oln': widget.doc!['oln'], //course last name,
        'oid': widget.doc!['id'], //course id
        'ts': DateTime.now().toString(),
        'id': docRef.id,
        'cid': widget.doc!['id'],
        're': 0,
        'like': 0,
        'sup': widget.doc!['sup'],
        'sub': widget.doc!['sub'],
        'own': widget.doc!['own'],
        'rtfn': widget.doc!['fn'], //reply to first name
        'rtln': widget.doc!['ln'], //reply to first name
      });

      //increase the number of reply
      FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.doc!['id'])
          .get()
          .then((value) {
        var count = value.data()!['re'] + 1;
        value.reference.set({
          're': count,
        }, SetOptions(merge: true));
      });

      //increase the number of comment for the tutorial

      FirebaseFirestore.instance
          .collection(widget.doc!['sup'])
          .doc(widget.doc!['own'])
          .collection(widget.doc!['sub'])
          .where('id', isEqualTo: widget.doc!['id'])
      //.doc(workingDocuments[index]['id'])
          .get()
          .then((value) {
        value.docs.forEach((comm) {
          var count = comm.data()['comm'] + 1;
          comm.reference.set({
            'comm': count,
          }, SetOptions(merge: true));
        });
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
