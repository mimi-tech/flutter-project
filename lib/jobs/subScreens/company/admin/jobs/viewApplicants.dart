import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/subScreens/resume/resume.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewApplicants extends StatefulWidget {
  @override
  _ViewApplicantsState createState() => _ViewApplicantsState();
}

class _ViewApplicantsState extends State<ViewApplicants> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('jobDetails')
            .where("cid", isEqualTo: CompanyStorage.pageId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final jobs = snapshot.data.docs;

            List<Map<String, dynamic>?> jobs =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (jobs.isEmpty) {
              return NoResult(
                message: "No Applicants Yet",
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? job in jobs) {
                //Todo: get  datetime from database
                DateTime date = DateTime.parse(job!['date']);

                String displayDay = timeago.format(date);
                final cardWidget = Card(
                  elevation: 3,
                  child: Container(
                    height: ScreenUtil().setHeight(150.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: kShade,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 32,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: job['lur'],
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
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: ScreenUtil().setSp(160),
                                          minHeight: ScreenUtil().setSp(2)),
                                      child: Text(
                                        ReusableFunctions.smallSentence(
                                            15, 15, job['nm']),
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setSp(160),
                                      minHeight: ScreenUtil().setSp(2)),
                                  child: Text(
                                    ReusableFunctions.smallSentence(
                                        19, 19, job['jtl']),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    RatingBar.builder(
                                      initialRating: job['avgRt'].toDouble(),
                                      minRating: 1,
                                      unratedColor: Colors.black,
                                      direction: Axis.horizontal,
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 18,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double) {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "${job['avgRt']} Rating",
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(18.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setSp(125),
                                      minHeight: ScreenUtil().setSp(2)),
                                  child: Text(
                                    "${ReusableFunctions.capitalize(job['jtp'])} - ${ReusableFunctions.capitalize(job['jcg'])}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Text(
                                  displayDay,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: kShade),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    ProfessionalStorage.id = job['uid'];
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: Resume()));
                                  },
                                  child: Text("View Portfolio"),
                                  color: kLight_orange,
                                  textColor: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print('has error');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          } else {
            print('nothing');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ReNavBarComponent extends StatelessWidget {
  ReNavBarComponent({required this.colour, this.text});

  final Color colour;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 9.0, 0.0),
      child: Text(
        text!,
        style: TextStyle(
            fontFamily: "Rajdhani",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colour),
      ),
    );
  }
}
