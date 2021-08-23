import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/job_shimmer.dart';
import 'package:sparks/jobs/subScreens/employment/viewJobOffer.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobOffer extends StatefulWidget {
  @override
  _JobOfferState createState() => _JobOfferState();
}

class _JobOfferState extends State<JobOffer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('sentJobOfferDetails')
            .where('uEmail', isEqualTo: UserStorage.loggedInUser.email)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final jobOfferRequests = snapshot.data.docs;

            List<Map<String, dynamic>?> jobOfferRequests =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (jobOfferRequests.isEmpty) {
              return NoResult(
                message: "No Job Offer Available",
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? jobOfferRequest in jobOfferRequests) {
                DateTime date = DateTime.parse(jobOfferRequest!['jtm']);

                String displayDay = timeago.format(date);

                final cardWidget = Card(
                  elevation: 6,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      minHeight: ScreenUtil().setHeight(180.0),
                    ),
                    child: Container(
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
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                        child: Container(
                          height: ScreenUtil().setHeight(180.0),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ReusableFunctions.smallSentence(
                                      25, 25, jobOfferRequest['cnm']),
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(22),
                                        fontWeight: FontWeight.bold,
                                        color: kLight_orange),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 32,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: jobOfferRequest['lur'],
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
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'JOB OFFER INVITATION',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                displayDay,
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(12),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kLight_orange),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                              ReusableFunctions.smallSentence(
                                                  40,
                                                  40,
                                                  '${jobOfferRequest['jof']}...'),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(15),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ReusableFunctions.smallSentence(
                                              40, 40, jobOfferRequest['jlt']),
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RaisedButton(
                                              onPressed: () {
                                                UserStorage.jobOfferRequestID =
                                                    jobOfferRequest['joId'];
                                                UserStorage.companyID =
                                                    jobOfferRequest['cid'];
                                                UserStorage.mainCompanyID =
                                                    jobOfferRequest['mCid'];
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child:
                                                            UserViewJobOfferRequest()));
                                              },
                                              color: Colors.black,
                                              textColor: Colors.white,
                                              child: Text("View"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
            return JobShimmer();
          } else if (snapshot.hasError) {
            print('has error');
            return JobShimmer();
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Center(
            //       child: CircularProgressIndicator(
            //         backgroundColor: Colors.red,
            //       ),
            //     ),
            //   ],
            // );
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
