import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/edit.dart';
import 'package:sparks/jobs/subScreens/company/admin/jobOfffers/view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class JobOfferRequestCreated extends StatefulWidget {
  @override
  _JobOfferRequestCreatedState createState() => _JobOfferRequestCreatedState();
}

class _JobOfferRequestCreatedState extends State<JobOfferRequestCreated> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            height: ScreenUtil().setHeight(60.0),
            width: ScreenUtil().setWidth(280.0),
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'View Created Job Offer Request',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(18.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobOfferRequest')
                  .doc(CompanyStorage.companyId)
                  .collection('companyJobOfferPages')
                  .doc(CompanyStorage.pageId)
                  .collection('companyJobOfferDetails')
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
                      message: "No jobOffer Request Available",
                    );
                  } else {
                    List<Widget> cardWidgets = [];
                    for (Map<String, dynamic>? jobOfferRequest
                        in jobOfferRequests) {
                      DateTime date = DateTime.parse(jobOfferRequest!['jtm']);

                      String displayDay = timeago.format(date);
                      final cardWidget = Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Container(
                              height: ScreenUtil().setHeight(180.0),
                              width: double.infinity,
                              child: Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'jobOffer INVITATION',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            displayDay,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12),
                                                  fontWeight: FontWeight.bold,
                                                  color: kLight_orange),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 32,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    jobOfferRequest['lur'],
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
                                        RaisedButton(
                                          onPressed: () {},
                                          color: Colors.black,
                                          textColor: Colors.white,
                                          child: Text(
                                            ReusableFunctions
                                                .displayProfessionalName(
                                                    jobOfferRequest['jtl'])!,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            onPressed: () {
                                              JobOfferFormStorage
                                                      .mainCompanyId =
                                                  jobOfferRequest['cid'];
                                              JobOfferFormStorage.jobId =
                                                  jobOfferRequest['id'];
                                              JobOfferFormStorage.companyId =
                                                  UserStorage.loggedInUser.uid;
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          ViewJobOfferRequest()));
                                            },
                                            color: kLight_orange,
                                            textColor: Colors.white,
                                            child: Text("View & Send"),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            JobOfferFormStorage.mainCompanyId =
                                                jobOfferRequest['cid'];
                                            JobOfferFormStorage.jobId =
                                                jobOfferRequest['id'];
                                            JobOfferFormStorage.companyId =
                                                UserStorage.loggedInUser.uid;
                                            JobOfferFormStorage.salaryRangeMax =
                                                jobOfferRequest['srx'];
                                            JobOfferFormStorage.description =
                                                jobOfferRequest['jdt'];
                                            JobOfferFormStorage.jobLocation =
                                                jobOfferRequest['jlt'];
                                            JobOfferFormStorage.companyName =
                                                jobOfferRequest['cnm'];
                                            JobOfferFormStorage.jobTitle =
                                                jobOfferRequest['jtl'];
                                            JobOfferFormStorage
                                                    .jobOfferMessage =
                                                jobOfferRequest['jof'];

                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: EditJobOffer()));
                                          },
                                          color: kLight_orange,
                                          textColor: Colors.white,
                                          child: Text("Edit"),
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  print('waiting');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.redAccent,
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
                          backgroundColor: Colors.redAccent,
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
          ),
        ],
      ),
    );
  }
}
