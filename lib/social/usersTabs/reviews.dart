import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialCourse/cc_appbar.dart';
import 'package:sparks/social/usersTabs/tabsTitle.dart';

class CourseReviewScreen extends StatefulWidget {
  CourseReviewScreen({required this.doc});
  final DocumentSnapshot doc;
  @override
  _CourseReviewScreenState createState() => _CourseReviewScreenState();
}

class _CourseReviewScreenState extends State<CourseReviewScreen> {
  final messageTextController = TextEditingController();
 late String messageText;


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        appBar: CcAppBar(
          text4: 'Review on',
          text1: widget.doc['topic'],
          text2: widget.doc['fn'],
          text3: widget.doc['ln'],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(doc:widget.doc),
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
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      messageTextController.clear();
                      FirebaseFirestore.instance.collection('courseReviews').add({
                        'msg':messageText,
                        'id':widget.doc['id'],
                        'ts':DateTime.now().toString(),
                        'pimg':GlobalVariables.loggedInUserObject.pimg,
                        'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
                        'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
                        'oid':widget.doc['suid'],

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
  MessagesStream({required this.doc});
  final DocumentSnapshot doc;
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {


  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;

  late StreamSubscription stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReviews();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: workingDocuments.length,
              itemBuilder: (BuildContext context, int index) {
                 return  workingDocuments.length == 0 && progress == false ?PlatformCircularProgressIndicator():
                 workingDocuments.length == 0 && progress == true ? NoContentText(title: kNoContent):Card(
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         ListTile(
                           leading: GestureDetector(
                             child: ClipOval(
                               //borderRadius: BorderRadius.circular(kSocialVideoCurve),

                               child: CachedNetworkImage(

                                 imageUrl: workingDocuments[index]['pimg'],
                                 placeholder: (context, url) => CircularProgressIndicator(),
                                 errorWidget: (context, url, error) => Icon(Icons.error),
                                 fit: BoxFit.cover,
                                 width: 40.0,
                                 height: 40.0,

                               ),
                             ),
                           ),

                           title:Text(workingDocuments[index]['fn'],
                             style: GoogleFonts.rajdhani(
                               fontSize: kFontSize14.sp,
                               color: klistnmber,
                               fontWeight: FontWeight.bold,

                             ),),
                           subtitle:Text(workingDocuments[index]['ln'],
                             style: GoogleFonts.rajdhani(
                               fontSize: kFontSize14.sp,
                               color: klistnmber,
                               fontWeight: FontWeight.bold,

                             ),),



                         ),


                         Padding(
                           padding: const EdgeInsets.only(left:12.0),
                           child: Text(DateFormat('EEEE, d MMM, yyyy h:mm a').format(DateTime.parse(workingDocuments[index]['ts'])),
                             style: GoogleFonts.rajdhani(fontSize: kFontSize14.sp,
                               color:kBlackcolor,
                               fontWeight: FontWeight.bold,

                             ),),
                         ),

                         Material(
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),
                               bottomLeft: Radius.circular(30.0),
                               topRight: Radius.circular(30.0)),

                           elevation: 5.0,
                           color: Colors.pink,

                           child: Padding(
                             padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                             child: Container(
                               child: ConstrainedBox(
                                 constraints: BoxConstraints(
                                   maxWidth: MediaQuery.of(context).size.width,
                                   minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                 ),
                                 child: ReadMoreText(workingDocuments[index]['msg'],

                                   trimLines: 5,
                                   colorClickableText: Colors.white,
                                   trimMode: TrimMode.Line,
                                   trimCollapsedText: ' ...',
                                   trimExpandedText: 'show less',
                                   style:GoogleFonts.rajdhani(
                                     textStyle: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       color: kWhitecolor,
                                       fontSize:14.sp,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 );

              },
            ),
            prog == true || _loadMoreProgress == true
                || _documents.length < SchClassConstant.streamCount
                ?Text(''):
            moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                onTap: (){loadMore();},
                child: SvgPicture.asset('images/classroom/load_more.svg',))
          ],
        ),
      ),
    );
  }

  Future<void> getReviews() async {

      stream = FirebaseFirestore.instance
        .collection('courseReviews')
        .where('id',isEqualTo: widget.doc['id'])
        .orderBy('ts', descending: true).limit(SchClassConstant.streamCount).snapshots().listen((result) {


    final List <DocumentSnapshot> documents = result.docs;

    if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      workingDocuments.clear();
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          _documents.add(document);
          workingDocuments.add(document.data());

          // PageConstants.getCompanies.clear();
        });
      }
    }
  });
}
  Future<void> loadMore() async {

    stream =  FirebaseFirestore.instance.collection('courseReviews')
        .where('id',isEqualTo: widget.doc['id'])

        .orderBy('ts',descending: true).startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount).snapshots()
        .listen((result) {

    final List <DocumentSnapshot> documents = result.docs;
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

}}



