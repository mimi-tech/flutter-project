import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/social/reaction_likes.dart';
import 'package:sparks/social/reaction_rate.dart';
import 'package:sparks/social/reaction_shares.dart';
import 'package:sparks/social/reaction_views.dart';
class SocialReactions extends StatefulWidget {
  SocialReactions({required this.doc});
  final DocumentSnapshot doc;
  @override
  _SocialReactionsState createState() => _SocialReactionsState();
}

class _SocialReactionsState extends State<SocialReactions> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //changing the status bar color
   stColor = kStatusbar;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          bottom: TabBar(
            tabs: [
              Tab(icon: SvgPicture.asset('images/classroom/views.svg'), text: "Views",),
              Tab(icon: Icon(Icons.thumb_up,color: kMaincolor), text: "Likes"),
              Tab(icon: SvgPicture.asset('images/classroom/star.svg'), text: "Rate"),
              Tab(icon: Icon(Icons.share,color: kMaincolor), text: "Share"),

            ],
          ),
          title: Text('Reactions'.toUpperCase(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ViewsReactions(doc:widget.doc),
            LikesReactions(doc:widget.doc),
            RateReactions(doc:widget.doc),
            ShareReactions(doc:widget.doc),
          ],
        ),
      ),
    );
  }
}
