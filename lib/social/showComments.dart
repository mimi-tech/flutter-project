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
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/chat/chatConstant.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/reply_comments.dart';
import 'package:sparks/social/social_likes.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialComments extends StatefulWidget {

  @override
  _SocialCommentsState createState() => _SocialCommentsState();
}

class _SocialCommentsState extends State<SocialComments> {

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
    return   Expanded(
      child: ListView(
      children: [
        ListView.builder(
              itemCount: workingDocuments.length,
              shrinkWrap: true,
              reverse: true,

            physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return workingDocuments.length == 0 && progress == false ?PlatformCircularProgressIndicator():
                workingDocuments.length == 0 && progress == true ? Text(kNoContent):Column(

                  children: [

                    Container(
                     decoration:BoxDecoration(
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),
                           bottomLeft: Radius.circular(30.0),
                           topRight: Radius.circular(30.0)),

                     ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),

                          child: ConstrainedBox(
                constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                ),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 32,
                child: ClipOval(

                child: CachedNetworkImage(

                imageUrl: '${ workingDocuments[index]['pimg']}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 40.0,
                height: 40.0,

                ),
                ),
                ),


                        Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',

                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlackcolor,
                              fontSize:kFontsize.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ReadMoreText(
                    workingDocuments[index]['msg'],

                    trimLines: 4,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' ...',
                    trimExpandedText: ' less',
                    style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,
                    ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.timer, color:kbtnsecond), onPressed: (){}),
                            Text('${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')}',

                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: klistnmber,
                                  fontSize:14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.thumb_up,color:kbtnsecond), onPressed: (){_likeComment(workingDocuments as List<DocumentSnapshot<Object>?>,index);}),
                            Text('${workingDocuments[index]['like']}',

                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kExpertColor,
                                  fontSize:14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.reply,color:kbtnsecond), onPressed: (){_replyComment(workingDocuments as List<DocumentSnapshot<Object>?>,index);}),
                            Text('${workingDocuments[index]['re']}',

                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kLightGreen,
                                  fontSize:14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(icon: Icon(Icons.verified,color:kLightGreen,), onPressed: (){_viewLikes(workingDocuments,index);
                        }),

                      ],
                    ),

                  ],
                ),
                ),
                    )),
                    Divider(thickness: 2,color: kMaincolor,),


                  ],
                );
              }),

        prog == true || _loadMoreProgress == true
            || _documents.length < SchClassConstant.streamCount
            ?Text(''):
        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
            onTap: (){loadMore();},
            child: SvgPicture.asset('images/classroom/load_more.svg',))
      ],
        ),
    );
      }






  Future<void> getReviews() async {

    stream =  FirebaseFirestore.instance.collection('comments')
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

    stream =   FirebaseFirestore.instance.collection('comments')
        .orderBy('ts', descending: true).startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount).snapshots()
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

  }

  Future<void> _likeComment(List<DocumentSnapshot?> workingDocuments, int index) async {

    //check if comment have been liked by this user


    final QuerySnapshot result = await FirebaseFirestore.instance.collection('likedComment')
        .where('id', isEqualTo: workingDocuments[index]!['id'])
        .where('uid', isEqualTo: GlobalVariables.loggedInUserObject.id)

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //increase the number of like for the comment

      FirebaseFirestore.instance.collection('comments').doc(workingDocuments[index]!['id']).get().then((value) {

        var count = value.data()!['like'] + 1;
        value.reference.set({
          'like': count,
        }, SetOptions(merge: true));

     });

    //create like collection
    DocumentReference  docRef = FirebaseFirestore.instance.collection('likes').doc();
    docRef.set({
      'id':docRef.id,
      'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
      'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
      'pimg':GlobalVariables.loggedInUserObject.pimg,
      'cid':workingDocuments[index]!['id'],
      'ts':DateTime.now().toString(),
    });


  }}

  void _replyComment(List<DocumentSnapshot?> workingDocuments, int index) {
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SocialReplyComments(doc:workingDocuments[index])));

  }

  void _viewLikes(List workingDocuments, int index) {
//viewLikes
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return SocialLikes(doc:workingDocuments[index],cid:workingDocuments[index]!['id']);
        });
  }


}



class MessageStream extends StatefulWidget {
  MessageStream({required this.doc});
  final DocumentSnapshot doc;
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {

  final messageTextController = TextEditingController();
  late final String messageText;
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlackcolor,
          title: Text('Comments'.toUpperCase(),

            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize:kFontsize.sp,
              ),
            ),
          ),
        ),
        body: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        SocialComments(),
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
              progress?CircularProgressIndicator(backgroundColor: kFbColor,):FlatButton(
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

  _sendComment()  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      progress = true;
    });
    try{
    DocumentReference docRef =  FirebaseFirestore.instance.collection('comments').doc();
    docRef.set({
      'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
      'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
      'pimg':GlobalVariables.loggedInUserObject.pimg,
      'msg':messageText,
      'title':widget.doc['topic'] == null?widget.doc['title']:widget.doc['topic'],
      'ofn':widget.doc['fn'],
      'oln':widget.doc['ln'],
      'oid':widget.doc['id'],
      'ts':DateTime.now().toString(),
      'id':docRef.id,
      're':0,
      'like':0,
      'sup':widget.doc['sup'],
      'sub':widget.doc['sub'],
      'own':widget.doc['suid'],



    });


    //send it to replied commit
   /* DocumentReference docRefs =  FirebaseFirestore.instance.collection('commentsReplied').doc();
    docRefs.set({
      'fn':GlobalVariables.loggedInUserObject.nm!['fn'],
      'ln':GlobalVariables.loggedInUserObject.nm!['ln'],
      'pimg':GlobalVariables.loggedInUserObject.pimg,
      'msg':messageText,
      'title':widget.doc['topic'] == null?widget.doc['title']:widget.doc['topic'],
      'ofn':widget.doc['fn'],
      'oln':widget.doc['ln'], //course id,
      'oid':widget.doc['id'],
      'cid':docRef.id,
      'ts':DateTime.now().toString(),
      'id':docRefs.id,
      're':0,
      'like':0,
      'sup':widget.doc['sup'],
      'sub':widget.doc['sub'],
      'own':widget.doc['suid'],


    });*/

    //increase the number of comment for the tutorial

    FirebaseFirestore.instance.collection(widget.doc['sup']).doc(widget.doc['suid']).collection(widget.doc['sub'])
        .where('id',isEqualTo:widget.doc['id'] )
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
    }catch(e){
      print('yyyyyyyy$e');
      setState(() {
        messageTextController.clear();
        progress = false;
      });
    }
  }
}

