import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/resume/resume.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdminAppointmentAccepted extends StatefulWidget {
  @override
  _AdminAppointmentAcceptedState createState() =>
      _AdminAppointmentAcceptedState();
}

class _AdminAppointmentAcceptedState extends State<AdminAppointmentAccepted> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('AcceptedAppointmentLetter')
                .doc(CompanyStorage.companyId)
                .collection('AcceptedAppointmentLetterCompanyPage')
                .doc(CompanyStorage.pageId)
                .collection('AcceptedAppointmentLetterDetails')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // final acceptedAppointmentLetters = snapshot.data.docs;

                List<Map<String, dynamic>?> acceptedAppointmentLetters =
                    snapshot.data!.docs.map((DocumentSnapshot doc) {
                  return doc.data as Map<String, dynamic>?;
                }).toList();
                if (acceptedAppointmentLetters.isEmpty) {
                  return NoResult(
                    message: "No Appointment Letter Accepted",
                  );
                } else {
                  List<Widget> cardWidgets = [];
                  for (Map<String, dynamic>? acceptedAppointmentLetter
                      in acceptedAppointmentLetters) {
                    DateTime date =
                        DateTime.parse(acceptedAppointmentLetter!['jtm']);

                    String displayDay = timeago.format(date);

                    final cardWidget = Card(
                      elevation: 6,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          minHeight: ScreenUtil().setHeight(100.0),
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
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Container(
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 32,
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        acceptedAppointmentLetter[
                                                            'usImg'],
                                                    placeholder: (context,
                                                            url) =>
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'APPOINTMENT LETTER',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(15),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      ScreenUtil().setSp(315),
                                                  minHeight:
                                                      ScreenUtil().setSp(2)),
                                              child: Text(
                                                '${acceptedAppointmentLetter['uEmail']} Accepted Your Appointment Letter',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 6,
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
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ReusableFunctions.smallSentence(
                                              40,
                                              40,
                                              acceptedAppointmentLetter[
                                                  'rCity']),
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(18),
                                                fontWeight: FontWeight.bold,
                                                color: kLight_orange),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: RaisedButton(
                                    onPressed: () {
                                      ProfessionalStorage.id =
                                          acceptedAppointmentLetter['uId'];
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: Resume()));
                                    },
                                    color: kComp,
                                    child: Text(
                                      'View Profile',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
        ),
      ],
    ));
  }
}
