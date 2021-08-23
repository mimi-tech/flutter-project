import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/newsBoardAppbar.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mma").format(now);
  String? messageText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: StuAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            SchoolPostConst.replyChatText == ''
                ? Text('')
                : Container(
              color: klistnmber.withOpacity(0.5),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        SchoolPostConst.replyChatText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: kHintColor,
                            fontSize: kFontSize14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          SchoolPostConst.replyChatText = '';
                        });
                      })
                ],
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      focusNode: SchoolPostConst.inputNode,
                      autofocus: true,
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        SchoolPostConst.replyChatText = '';
                      });
                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('teacherMessages')
                          .doc();
                      docRef.set({
                        'docId': docRef.id,
                        'tx': messageText,
                        'rep': SchoolPostConst.replyChatText == ''
                            ? ''
                            : SchoolPostConst.replyChatText,
                        'se': GlobalVariables.loggedInUserObject.em,
                        'uid': GlobalVariables.loggedInUserObject.id,
                        'tid':
                        SchClassConstant.schDoc['id'], //id of the student,
                        'tna': SchClassConstant.isStudent
                            ? '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}'
                            : SchClassConstant.schDoc['tc'],
                        'lv': SchClassConstant.schDoc['lv'],
                        'dt': date,
                        'cl': SchClassConstant.isLecturer
                            ? SchClassConstant.schDoc['dept']
                            : SchClassConstant.schDoc['cl'],
                        'tpin': SchClassConstant.schDoc['pin'],
                        'sid': SchClassConstant.schDoc['id'],
                        'schId': SchClassConstant.schDoc['schId'] //id of the teacher
                      });
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
}

class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  late var message;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teacherMessages')
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
          .where('cl',
          isEqualTo: SchClassConstant.isLecturer
              ? SchClassConstant.schDoc['dept']
              : SchClassConstant.schDoc['cl'])
          .orderBy('dt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          List<Map<String, dynamic>> messages =
          snapshot.data!.docs as List<Map<String, dynamic>>;
          List<MessageBubble> messageBubbles = [];
          for (Map<String, dynamic> message in messages) {
            final messageText = message['tx'];
            final messageSender = message['tid'];
            final messageuid = message['uid'];
            final messagecid = message['tid'];
            final messagename = message['tna'];
            final messagedate = message['dt'];
            final messagedocId = message['docId'];
            final messageReply = message['rep'];

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              uid: messageuid,
              cid: messagecid,
              name: messagename,
              date: messagedate,
              docId: messagedocId,
              reply: messageReply,
              isMe: SchClassConstant.schDoc['id'] == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return messageBubbles.length == 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              SchClassConstant.isTeacher
                  ? 'Please tell your student something'
                  : 'Say something to your Classmate',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: kFontsize.sp,
                fontWeight: FontWeight.w500,
                color: kBlackcolor,
              ),
            ),
          )
              : Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {this.sender,
        this.text,
        this.isMe,
        this.uid,
        this.cid,
        this.name,
        this.docId,
        this.date,
        this.reply});
  final String? sender;
  final String? text;
  final bool? isMe;
  final String? uid;
  final String? cid;
  final String? name;
  final String? date;
  final String? docId;
  final String? reply;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool isIcon = false;
  bool isMeIcon = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            widget.isMe!
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.name! + " " + widget.date!,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: klistnmber,
                      fontSize: kFontSize14.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isMeIcon = !isMeIcon;
                    });
                  },
                  child: Material(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    elevation: 5.0,
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: widget.reply == ''
                          ? Text(
                        widget.text!,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kBlackcolor,
                            fontSize: kFontSize14.sp,
                          ),
                        ),
                      )
                          : Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.reply!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: kBlackcolor.withOpacity(0.5),
                                fontSize: kFontSize14.sp,
                              ),
                            ),
                          ),
                          Divider(),
                          Text(
                            widget.text!,
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackcolor,
                                fontSize: kFontSize14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: isMeIcon,
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.reply,
                              color: kExpertColor,
                            ),
                            onPressed: () {
                              _replyChat(widget.docId, widget.text);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: kRed,
                            ),
                            onPressed: () {
                              _deleteChat(widget.docId);
                            }),
                      ],
                    ))
              ],
            )
                : Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name! + " " + widget.date!,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: klistnmber,
                        fontSize: kFontSize14.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        isIcon = !isIcon;
                      });
                    },
                    child: Material(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      elevation: 5.0,
                      color: Colors.pink,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: widget.reply == ''
                            ? Text(
                          widget.text!,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize: kFontSize14.sp,
                            ),
                          ),
                        )
                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.reply!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color:
                                  kBlackcolor.withOpacity(0.5),
                                  fontSize: kFontSize14.sp,
                                ),
                              ),
                            ),
                            Text(
                              widget.text!,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                  fontSize: kFontSize14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: isIcon,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.reply),
                              onPressed: () {
                                _replyChat(widget.docId, widget.text);
                              }),
                          //widget.isMe?IconButton(icon: Icon(Icons.delete), onPressed: (){}):Text(''),
                        ],
                      )),
                ],
              ),
            ),

            ///seeing messages sent to you
            /*   StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('teacherMessages')
                      .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
                      .where('cl',isEqualTo: SchClassConstant.isLecturer?SchClassConstant.schDoc['dept']:SchClassConstant.schDoc['cl'])
                      .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])


                      .orderBy('dt',descending: true).snapshots(),
                  builder: (context, snapshot) {
                    List<DocumentSnapshot> workingDocument = snapshot.data.documents;
                    //List<dynamic> workingDocument = items.where((element) => element['tid'] != SchClassConstant.schDoc['id']).toList();

                    if (workingDocument.length == 0) {
                      return Text('hhjgh');
                    } else {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: workingDocument.length,
                          itemBuilder: (context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${workingDocument[index]['tna']} ${DateFormat('EE-MM-yyyy hh:mm:a').format(DateTime.parse(workingDocument[index]['dt']))}',
                                    style: TextStyle(
                                      fontSize: ScreenUtil()
                                          .setSp(
                                          12,
                                          allowFontScalingSelf:
                                          true),
                                      fontWeight:
                                      FontWeight.w500,
                                      fontFamily: 'RobotoSlab',
                                      color: Colors.black38,
                                    )),
                                Material(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),


                                  elevation: 5.0,
                                  color: Colors.lightGreen,

                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    child: Text(workingDocument[index]['tx'] == null?'':workingDocument[index]['tx'],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontFamily: 'RobotoSlab',
                                          color: kWhitecolor,
                                        )),
                                  ),
                                ),
                              ],
                            );
                          }
                      );

                    }
                  })*/
          ],
        ),
      ),
    );
  }

  void _deleteChat(String? docId) {
    FirebaseFirestore.instance
        .collection('teacherMessages')
        .doc(docId)
        .delete();
  }

  void _replyChat(String? docId, String? text) {
    setState(() {
      SchoolPostConst.inputNode.requestFocus();
      SchoolPostConst.replyChatText = text!;
    });
  }
}
