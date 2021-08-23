import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/edit/entry.dart';
import 'package:sparks/jobs/subScreens/company/admin/appointements/view.dart';
import 'package:sparks/jobs/subScreens/company/createAppointmentLetter/entry.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppointmentRequestSent extends StatefulWidget {
  @override
  _AppointmentRequestSentState createState() => _AppointmentRequestSentState();
}

class _AppointmentRequestSentState extends State<AppointmentRequestSent> {
  final _auth = FirebaseAuth.instance;

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CreateAppointmentEntry()));
            },
            child: Container(
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
                    'View New Appointment',
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
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointmentLetter')
                  .doc(CompanyStorage.companyId)
                  .collection('companyAppointmentLetterPages')
                  .doc(CompanyStorage.pageId)
                  .collection('companyAppointmentLetterDetails')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final appointmentLetters = snapshot.data.docs;

                  List<Map<String, dynamic>?> appointmentLetters =
                      snapshot.data!.docs.map((DocumentSnapshot doc) {
                    return doc.data as Map<String, dynamic>?;
                  }).toList();
                  if (appointmentLetters.isEmpty) {
                    return NoResult(
                      message: "No Appointment Letter Created",
                    );
                  } else {
                    List<Widget> cardWidgets = [];
                    for (Map<String, dynamic>? appointmentLetter
                        in appointmentLetters) {
                      DateTime date = DateTime.parse(appointmentLetter!['date']);

                      String displayDay = timeago.format(date);

                      final cardWidget = Card(
                        elevation: 6,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: double.infinity,
                              minHeight: ScreenUtil().setSp(150)),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 32,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: appointmentLetter['lur'],
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          width: 40.0,
                                          height: 40.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'APPOINTMENT LETTER ',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(15),
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
                                              fontSize: ScreenUtil().setSp(12),
                                              fontWeight: FontWeight.bold,
                                              color: kLight_orange),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        ReusableFunctions.smallSentence(30, 30,
                                            '${appointmentLetter['apMsg']}...'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(15),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    ReusableFunctions.capitalizeWords(
                                        appointmentLetter['cAds'])!,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18),
                                          fontWeight: FontWeight.bold,
                                          color: kLight_orange),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        AppointmentStorage.mainCompanyId =
                                            appointmentLetter['cId'];
                                        AppointmentStorage.appointmentId =
                                            appointmentLetter['id'];
                                        AppointmentStorage.companyId =
                                            UserStorage.loggedInUser.uid;
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child:
                                                    ViewAppointmentRequest()));
                                      },
                                      child: Text("View \$ Send"),
                                      color: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        AppointmentStorage.mainCompanyId =
                                            appointmentLetter['cId'];
                                        AppointmentStorage.appointmentId =
                                            appointmentLetter['id'];
                                        AppointmentStorage.companyId =
                                            UserStorage.loggedInUser.uid;
                                        AppointmentStorage.companyName =
                                            appointmentLetter['cnm'];
                                        AppointmentStorage.companyAddress =
                                            appointmentLetter['cAds'];
                                        AppointmentStorage.companyCity =
                                            appointmentLetter['cCity'];
                                        AppointmentStorage.companyState =
                                            appointmentLetter['cState'];
                                        AppointmentStorage.companyZipCode =
                                            appointmentLetter['cZcd'];
                                        AppointmentStorage.recipientName =
                                            appointmentLetter['rnm'];
                                        AppointmentStorage.recipientAddress =
                                            appointmentLetter['rAds'];
                                        AppointmentStorage.recipientCity =
                                            appointmentLetter['rCity'];
                                        AppointmentStorage.recipientState =
                                            appointmentLetter['rState'];
                                        AppointmentStorage.recipientZipCode =
                                            appointmentLetter['rZcd'];
                                        AppointmentStorage.appointmentMessage =
                                            appointmentLetter['apMsg'];
                                        AppointmentStorage.commencementMessage =
                                            appointmentLetter['coMsg'];
                                        AppointmentStorage.reportingMessage =
                                            appointmentLetter['rpMsg'];
                                        AppointmentStorage.allocationMessage =
                                            appointmentLetter['aloMsg'];
                                        AppointmentStorage.rolesMessage =
                                            appointmentLetter['rrMsg'];
                                        AppointmentStorage.salaryMessage =
                                            appointmentLetter['msMsg'];
                                        AppointmentStorage.workingHoursMessage =
                                            appointmentLetter['whMsg'];
                                        AppointmentStorage.vacationMessage =
                                            appointmentLetter['vaMsg'];
                                        AppointmentStorage.sickMessage =
                                            appointmentLetter['skMsg'];
                                        AppointmentStorage.paternityMessage =
                                            appointmentLetter['paMsg'];
                                        AppointmentStorage.terminationMessage =
                                            appointmentLetter['tmMsg'];
                                        AppointmentStorage.copyrightsMessage =
                                            appointmentLetter['crtMsg'];
                                        AppointmentStorage.amendmentMessage =
                                            appointmentLetter['amtMsg'];
                                        AppointmentStorage.humanResourceName =
                                            appointmentLetter['hrNm'];
                                        AppointmentStorage.confirmationMessage =
                                            appointmentLetter['conMsg'];
                                        AppointmentStorage.logoUrl =
                                            appointmentLetter['lur'];

                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: EditAppointmentEntry()));
                                      },
                                      child: Text("Edit"),
                                      color: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
      ),
    );
  }
}
