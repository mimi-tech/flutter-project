import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
class We extends StatefulWidget {
  @override
  _WeState createState() => _WeState();
}

class _WeState extends State<We> {

  final messageTextController = TextEditingController();
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:ss").format(now);
  String? messageText;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        print(messageText);
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print('hhhh');
                      messageTextController.clear();
                      FirebaseFirestore.instance.collection('teacherMessages').add({'tx':messageText,
                        'se':GlobalVariables.loggedInUserObject.em,
                        'uid':GlobalVariables.loggedInUserObject.id,'tid':SchClassConstant.schDoc['id'],//id of the student,
                        'tna':SchClassConstant.isStudent?'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}':SchClassConstant.schDoc['tc'],'lv':SchClassConstant.schDoc['lv'],'dt':date,'cl': SchClassConstant.isLecturer?SchClassConstant.schDoc['curs']:SchClassConstant.schDoc['cl'],
                        'tpin':SchClassConstant.schDoc['pin'],'sid':SchClassConstant.schDoc['id'],'schId':SchClassConstant.schDoc['schId']//id of the teacher
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
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('teacherMessages')
          .where('tid',isEqualTo: SchClassConstant.schDoc['id'])
          .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
          .where('cl',isEqualTo: SchClassConstant.isLecturer?SchClassConstant.schDoc['curs']:SchClassConstant.schDoc['cl'])

          .orderBy('dt',descending: true).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          print('jjjjjjjjj');

          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }else{
          final List<Map<String, dynamic>> workingDocuments =
          snapshot.data!.docs as List<Map<String, dynamic>>;

          return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: workingDocuments.length,
              itemBuilder: (context, int index) {

                return Column(
                  crossAxisAlignment:  CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(workingDocuments[index]['tna'] + " " + workingDocuments[index]['dt'] ,
                        style:TextStyle(
                          fontSize: kFontSize12.sp,
                          fontWeight:
                          FontWeight.w500,
                          fontFamily: 'RobotoSlab',
                          color: Colors.black54,
                        )),
                    Material(
                      borderRadius:  BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)) ,



                      elevation: 5.0,
                      color: Colors.lightBlueAccent,

                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(workingDocuments[index]['tx'],
                            style:TextStyle(
                              fontSize: kFontSize12.sp,
                              fontWeight:FontWeight.bold,
                              fontFamily: 'RobotoSlab',
                              color: kWhitecolor,
                            )),
                      ),
                    ),
                  ],
                );

              }
          );



        }},
    );
  }
}