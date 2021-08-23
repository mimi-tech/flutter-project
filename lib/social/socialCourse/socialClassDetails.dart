import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/social/showComments.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
import 'package:sparks/social/socialConstants/social_icons.dart';
import 'package:sparks/social/socialCourse/cc_appbar.dart';

class SocialClassDetails extends StatefulWidget {
  SocialClassDetails({required this.doc});
  final DocumentSnapshot doc;

  @override
  _SocialClassDetailsState createState() => _SocialClassDetailsState();
}

class _SocialClassDetailsState extends State<SocialClassDetails> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
            appBar: CcAppBar(
              text4: 'A course on',
              text1: widget.doc['topic'],
              text2: widget.doc['efn'],
              text3: widget.doc['eln'],
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    space(),
                    DetailsContentText(title:'${widget.doc['wel']}'),
                    space(),
                    Divider(),

                    DetailsText(title: 'Class topic',),
                    DetailsContentText(title:'${widget.doc['topic']}'),
                    space(),

                    DetailsText(title: 'Class description',),
                    DetailsContentText(title:'${widget.doc['desc']}'),
                    space(),

                    DetailsText(title: 'Age restrictions',),
                    DetailsContentText(title:'${widget.doc['age']} ${widget.doc['age2']}'),
                    space(),

                    DetailsText(title: 'Published on',),
                    DetailsContentText(title:'${widget.doc['date']}'),
                    space(),

                    DetailsText(title: 'Modified on',),
                    DetailsContentText(title:'${widget.doc['date']}'),
                    space(),

                    DetailsText(title: 'Language used on this course',),
                    DetailsContentText(title:'${widget.doc['lang']}'),
                    space(),

                    DetailsText(title: 'Class inclusion',),
                    DetailsContentText(title:'${widget.doc['inc']}'),

                    space(),

                    DetailsText(title: 'Class Level',),
                    DetailsContentText(title:'${widget.doc['level']}'),
                    space(),

                    DetailsText(title: 'Class Amount',),
                    DetailsContentText(title:'${widget.doc['amt']}'),

                    space(),

                    SocialIcons(
                      views: (){},
                      comments: (){_commentCount();},
                      rating: (){_ratingCount();},
                      share: (){_shareCount();},
                      like: (){_likeCount();},
                      viewsNumber: widget.doc['views'].toString(),
                      commentsNumber: widget.doc['comm'].toString(),
                      ratingNumber: widget.doc['rate'].toString(),
                      likeNumber: widget.doc['like'].toString(),
                      shareNumber: widget.doc['share'].toString(), saveUrl: '', saveName: '',
                    ),
                    space(),
                    space(),

                  ],
                ),
              ),
            )

        ));
  }

  void _commentCount() {
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: MessageStream(doc:widget.doc)));

  }

  void _ratingCount() {
    SocialConstant.showRating(submit: (){_submitRating();});
  }
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
        //update the rating like count

        FirebaseFirestore.instance.collection(widget.doc['sup']).doc(widget.doc['suid']).collection(widget.doc['sub']).doc(widget.doc['id'] ).get().then((result) {
          dynamic total = result.data()!['rate'] + SocialConstant.ratingCount;

          result.reference.set({
            'rate': total,

          }, SetOptions(merge: true));
        });


        //push video rating to database
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
    }}

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
    }}

  void _likeCount() {}
}


class DetailsText extends StatelessWidget {
  DetailsText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.rajdhani(
          decoration: TextDecoration.underline,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: kExpertColor,
            fontSize:kFontsize.sp,
          ),
        )
    );

  }
}


class DetailsContentText extends StatelessWidget {
  DetailsContentText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: kBlackcolor,
            fontSize:kFontsize.sp,
          ),
        )
    );

  }
}
