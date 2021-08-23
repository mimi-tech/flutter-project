import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class UserViewAppointment extends StatefulWidget {
  @override
  _UserViewAppointmentState createState() => _UserViewAppointmentState();
}

class _UserViewAppointmentState extends State<UserViewAppointment> {
  Stream? _stream;

  bool showSpinner = false;

  var date = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    print(UserStorage.sentInterviewRequestID);
    _stream = FirebaseFirestore.instance
        .collection('sentAppointmentLetters')
        .doc(UserStorage.companyID)
        .collection('sentAppointmentLettersCompanyPage')
        .doc(UserStorage.mainCompanyID)
        .collection('sentAppointmentLettersDetails')
        .doc(UserStorage.appointmentID)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    UserStorage.appointmentID = null;
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          Map<String, dynamic> singleAppointmentDocument =
              snapshot.data as Map<String, dynamic>;

          return WillPopScope(
              onWillPop: () => Future.value(true),
              child: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        elevation: 0.7,
                        automaticallyImplyLeading: true,
                        backgroundColor: kLight_orange,
                        centerTitle: true,
                        title: Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text(
                            '${singleAppointmentDocument['cnm']} Appointment Letter',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      body: ModalProgressHUD(
                        inAsyncCall: showSpinner,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                singleAppointmentDocument[
                                                    'cnm'],
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(22.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kComp),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'EMPLOYMENT LETTER',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['cnm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['cAds'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      '${singleAppointmentDocument['cCity']}  ${singleAppointmentDocument['cState']}  ${singleAppointmentDocument['cZcd']}',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['date'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 18.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['rnm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['rAds'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      '${singleAppointmentDocument['rCity']}  ${singleAppointmentDocument['rState']}  ${singleAppointmentDocument['rZcd']}',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      singleAppointmentDocument['rnm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['apMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '1. Day Of Commencement',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['coMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '2. Reporting',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['rpMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '3. Allocated Place Of Work',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['aloMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '4. Roles and Responsibilities',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['rrMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '5. Monthly Salary ',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['msMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '6. Working Hours',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['whMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '7. Leave',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      '7.1 Vacation',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(22.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['vaMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      '7.2 Sick Leave',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(22.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['skMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      '7.3 Paternity Leave',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(22.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['paMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '8. Termination',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 10.0),
                                    child: Text(
                                      'This contract can be terminated:',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(22.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['tmMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '9. Copyrights and Ownership',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['crtMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      '10. Amendment and Enforcement',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['amtMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      'Yours Faithfully',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      singleAppointmentDocument['hrNm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      'Human Resource Manager',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 10.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['cnm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 14.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['conMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 14.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(
                                      color: Colors.black,
                                      onPressed: () async {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        final QuerySnapshot result =
                                            await FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'AcceptedAppointmentLetter')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'AcceptedAppointmentLetterCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'AcceptedAppointmentLetterDetails')
                                                .where(
                                                    'uEmail',
                                                    isEqualTo:
                                                        UserStorage
                                                            .loggedInUser.email)
                                                .where(
                                                    'appId',
                                                    isEqualTo: UserStorage
                                                        .appointmentID)
                                                .get();
                                        final List<DocumentSnapshot>
                                            acceptedDocuments = result.docs;

                                        final QuerySnapshot declinedResult =
                                            await FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'DeclinedAppointmentLetters')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'DeclinedAppointmentLettersCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'DeclinedAppointmentLettersDetails')
                                                .where('uEmail',
                                                    isEqualTo: UserStorage
                                                        .loggedInUser.email)
                                                .where('appId',
                                                    isEqualTo:
                                                        InterviewFormStorage
                                                            .interviewId)
                                                .get();
                                        final List<DocumentSnapshot>
                                            declinedDocuments =
                                            declinedResult.docs;

                                        if (acceptedDocuments.length >= 1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you have accepted this application letter",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white);
                                        } else if (declinedDocuments.length >=
                                            1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you declined this appointment letter",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white);
                                        } else {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          try {
                                            DocumentReference
                                                documentReference =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'AcceptedAppointmentLetter')
                                                    .doc(UserStorage.companyID)
                                                    .collection(
                                                        'AcceptedAppointmentLetterCompanyPage')
                                                    .doc(UserStorage
                                                        .mainCompanyID)
                                                    .collection(
                                                        'AcceptedAppointmentLetterDetails')
                                                    .doc();

                                            documentReference.set({
                                              'cid': UserStorage.companyID,
                                              'mCid': UserStorage.mainCompanyID,
                                              'apMsg':
                                                  singleAppointmentDocument[
                                                      "apMsg"],
                                              'rCity':
                                                  singleAppointmentDocument[
                                                      "rCity"],
                                              'jtm': date,
                                              'appId':
                                                  UserStorage.appointmentID,
                                              'Id': documentReference.id,
                                              'uEmail': UserStorage
                                                  .loggedInUser.email,
                                              'uId':
                                                  UserStorage.loggedInUser.uid,
                                              'usImg':
                                                  "https://i.pinimg.com/originals/35/9f/ae/359fae7e8ad479e55d0dcbd4c7e7733c.jpg",
                                              'time': DateTime.now()
                                            });
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    "Congrats For Accepting This Appointment Letter",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white);
                                          } catch (err) {
                                            print(err);
                                            print('....');
                                          }
                                        }
                                      },
                                      child: new Text(
                                        "Accept",
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => SimpleDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 8,
                                            children: [
                                              Text(
                                                "Are you sure?",
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(18),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () async {
                                                      setState(() {
                                                        showSpinner = true;
                                                      });
                                                      final QuerySnapshot
                                                          acceptedResult =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'AcceptedAppointmentLetter')
                                                              .doc(UserStorage
                                                                  .companyID)
                                                              .collection(
                                                                  'AcceptedAppointmentLetterCompanyPage')
                                                              .doc(UserStorage
                                                                  .mainCompanyID)
                                                              .collection(
                                                                  'AcceptedAppointmentLetterDetails')
                                                              .where('uEmail',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .loggedInUser
                                                                          .email)
                                                              .where('appId',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .appointmentID)
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          acceptedDocuments =
                                                          acceptedResult.docs;
                                                      final QuerySnapshot result = await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'DeclinedAppointmentLetters')
                                                          .doc(UserStorage
                                                              .companyID)
                                                          .collection(
                                                              'DeclinedAppointmentLettersCompanyPage')
                                                          .doc(UserStorage
                                                              .mainCompanyID)
                                                          .collection(
                                                              'DeclinedAppointmentLettersDetails')
                                                          .where('uEmail',
                                                              isEqualTo:
                                                                  UserStorage
                                                                      .loggedInUser
                                                                      .email)
                                                          .where('appId',
                                                              isEqualTo:
                                                                  InterviewFormStorage
                                                                      .interviewId)
                                                          .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          documents =
                                                          result.docs;

                                                      if (documents.length >=
                                                          1) {
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                        Navigator.pop(context);

                                                        Fluttertoast.showToast(
                                                            timeInSecForIosWeb:
                                                                45,
                                                            msg:
                                                                "Sorry you have Declined this appointment letter",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white);
                                                      } else if (acceptedDocuments
                                                              .length >=
                                                          1) {
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                        Navigator.pop(context);
                                                        Fluttertoast.showToast(
                                                            timeInSecForIosWeb:
                                                                45,
                                                            msg:
                                                                "Sorry you have accepted this appointment letter",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white);
                                                      } else {
                                                        setState(() {
                                                          showSpinner = true;
                                                        });
                                                        try {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'DeclinedAppointmentLetters')
                                                                  .doc(UserStorage
                                                                      .companyID)
                                                                  .collection(
                                                                      'DeclinedAppointmentLettersCompanyPage')
                                                                  .doc(UserStorage
                                                                      .mainCompanyID)
                                                                  .collection(
                                                                      'DeclinedAppointmentLettersDetails')
                                                                  .doc();

                                                          documentReference
                                                              .set({
                                                            'cid': UserStorage
                                                                .companyID,
                                                            'mCid': UserStorage
                                                                .mainCompanyID,
                                                            'apMsg':
                                                                singleAppointmentDocument[
                                                                    "apMsg"],
                                                            'rCity':
                                                                singleAppointmentDocument[
                                                                    "rCity"],
                                                            'jtm': date,
                                                            'appId': UserStorage
                                                                .appointmentID,
                                                            'Id':
                                                                documentReference
                                                                    .id,
                                                            'uEmail': UserStorage
                                                                .loggedInUser
                                                                .email,
                                                            'uId': UserStorage
                                                                .loggedInUser
                                                                .uid,
                                                            'usImg':
                                                                "https://i.pinimg.com/originals/35/9f/ae/359fae7e8ad479e55d0dcbd4c7e7733c.jpg",
                                                            'time':
                                                                DateTime.now()
                                                                    .toString()
                                                          });
                                                          setState(() {
                                                            showSpinner = false;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              timeInSecForIosWeb:
                                                                  45,
                                                              msg:
                                                                  "Appointment letter rejected",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              backgroundColor:
                                                                  Colors.black,
                                                              textColor:
                                                                  Colors.white);
                                                        } catch (err) {
                                                          print(err);
                                                          print('....');
                                                        }
                                                      }
                                                    },
                                                    child: new Text(
                                                      "Decline",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: new Text(
                                                      "Cancel",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: new Text(
                                        "Decline",
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))));
        });
  }
}
