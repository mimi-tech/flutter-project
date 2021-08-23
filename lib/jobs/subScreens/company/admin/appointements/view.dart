import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class ViewAppointmentRequest extends StatefulWidget {
  @override
  _ViewAppointmentRequestState createState() => _ViewAppointmentRequestState();
}

class _ViewAppointmentRequestState extends State<ViewAppointmentRequest> {
  final TextEditingController _userEmailController = TextEditingController();

  Stream? _stream;

  bool showSpinner = false;

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('appointmentLetter')
        .doc(AppointmentStorage.companyId)
        .collection('companyAppointmentLetterPages')
        .doc(AppointmentStorage.mainCompanyId)
        .collection('companyAppointmentLetterDetails')
        .doc(AppointmentStorage.appointmentId)
        .snapshots();

    _userEmailController.text = ProfessionalStorage.email!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AppointmentStorage.mainCompanyId = null;
    AppointmentStorage.appointmentId = null;
    AppointmentStorage.companyId = null;
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
                            backgroundColor: kLight_orange,
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
          print(singleAppointmentDocument);
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
                            'Send Appointment Letter',
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
                                                      fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['date'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
                                    child: Text(
                                      singleAppointmentDocument['rnm'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: ScreenUtil().setSp(16.0),
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
                                            fontSize: 15.sp,
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
                                            fontSize: ScreenUtil().setSp(16.0),
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
                                            fontSize: 15.sp,
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
                                            fontSize: ScreenUtil().setSp(16.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: ScreenUtil().setSp(16.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 0.0, 15.0),
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
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
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        18.0, 15.0, 0.0, 10.0),
                                    child: Text(
                                      singleAppointmentDocument['conMsg'],
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ResumeInput(
                                controller: _userEmailController,
                                labelText: "Enter User Email",
                                hintText: "user@gmail.com",
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      onPressed: () async {
                                        if (_userEmailController.text == '') {
                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Please a profile email is required",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: kLight_orange,
                                              textColor: Colors.white);
                                        } else {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          final QuerySnapshot
                                              professionalResult =
                                              await FirebaseFirestore.instance
                                                  .collection('professionals')
                                                  .where('email',
                                                      isEqualTo:
                                                          _userEmailController
                                                              .text)
                                                  .get();
                                          final List<DocumentSnapshot>
                                              professionalDocument =
                                              professionalResult.docs;

                                          if (professionalDocument.length ==
                                              0) {
                                            setState(() {
                                              showSpinner = false;
                                            });

                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    " Sorry ${_userEmailController.text} Don't Have A Profile ON Sparks.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: kLight_orange,
                                                textColor: Colors.white);
                                          } else {
                                            final QuerySnapshot result =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'sentAppointmentLetters')
                                                    .doc(AppointmentStorage
                                                        .companyId)
                                                    .collection(
                                                        'sentAppointmentLettersCompanyPage')
                                                    .doc(AppointmentStorage
                                                        .mainCompanyId)
                                                    .collection(
                                                        'sentAppointmentLettersDetails')
                                                    .where('uEmail',
                                                        isEqualTo:
                                                            _userEmailController
                                                                .text)
                                                    .where('apId',
                                                        isEqualTo:
                                                            AppointmentStorage
                                                                .appointmentId)
                                                    .get();
                                            final List<DocumentSnapshot>
                                                documents = result.docs;
                                            print(documents.length);

                                            if (documents.length >= 1) {
                                              setState(() {
                                                showSpinner = false;
                                              });

                                              Fluttertoast.showToast(
                                                  timeInSecForIosWeb: 45,
                                                  msg:
                                                      " sorry this appointment letter has already been sent to ${_userEmailController.text}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor:
                                                      kLight_orange,
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
                                                            'sentAppointmentLetters')
                                                        .doc(AppointmentStorage
                                                            .companyId)
                                                        .collection(
                                                            'sentAppointmentLettersCompanyPage')
                                                        .doc(AppointmentStorage
                                                            .mainCompanyId)
                                                        .collection(
                                                            'sentAppointmentLettersDetails')
                                                        .doc();

                                                documentReference.set({
                                                  'cid': AppointmentStorage
                                                      .companyId,
                                                  'mCid': AppointmentStorage
                                                      .mainCompanyId,
                                                  'cnm':
                                                      singleAppointmentDocument[
                                                          'cnm'],
                                                  'cAds':
                                                      singleAppointmentDocument[
                                                          'cAds'],
                                                  'cCity':
                                                      singleAppointmentDocument[
                                                          'cCity'],
                                                  'cState':
                                                      singleAppointmentDocument[
                                                          'cState'],
                                                  'cZcd':
                                                      singleAppointmentDocument[
                                                          'cZcd'],
                                                  'rnm':
                                                      singleAppointmentDocument[
                                                          'rnm'],
                                                  'rAds':
                                                      singleAppointmentDocument[
                                                          'rAds'],
                                                  'rCity':
                                                      singleAppointmentDocument[
                                                          'rCity'],
                                                  'rState':
                                                      singleAppointmentDocument[
                                                          'rState'],
                                                  'rZcd':
                                                      singleAppointmentDocument[
                                                          'rZcd'],
                                                  'apMsg':
                                                      singleAppointmentDocument[
                                                          'apMsg'],
                                                  'coMsg':
                                                      singleAppointmentDocument[
                                                          'coMsg'],
                                                  'rpMsg':
                                                      singleAppointmentDocument[
                                                          'rpMsg'],
                                                  'aloMsg':
                                                      singleAppointmentDocument[
                                                          'aloMsg'],
                                                  'rrMsg':
                                                      singleAppointmentDocument[
                                                          'rrMsg'],
                                                  'msMsg':
                                                      singleAppointmentDocument[
                                                          'msMsg'],
                                                  'whMsg':
                                                      singleAppointmentDocument[
                                                          'whMsg'],
                                                  'vaMsg':
                                                      singleAppointmentDocument[
                                                          'vaMsg'],
                                                  'skMsg':
                                                      singleAppointmentDocument[
                                                          'skMsg'],
                                                  'paMsg':
                                                      singleAppointmentDocument[
                                                          'paMsg'],
                                                  'tmMsg':
                                                      singleAppointmentDocument[
                                                          'tmMsg'],
                                                  'crtMsg':
                                                      singleAppointmentDocument[
                                                          'crtMsg'],
                                                  'amtMsg':
                                                      singleAppointmentDocument[
                                                          'amtMsg'],
                                                  'hrNm':
                                                      singleAppointmentDocument[
                                                          'hrNm'],
                                                  'conMsg':
                                                      singleAppointmentDocument[
                                                          'conMsg'],
                                                  'lur':
                                                      singleAppointmentDocument[
                                                          'lur'],
                                                  'apId':
                                                      singleAppointmentDocument[
                                                          'id'],
                                                  'date':
                                                      DateTime.now().toString(),
                                                  'sapId': documentReference.id,
                                                  'uEmail':
                                                      _userEmailController.text,
                                                  'time': DateTime.now()
                                                });
                                                setState(() {
                                                  showSpinner = false;
                                                });
                                                Fluttertoast.showToast(
                                                    timeInSecForIosWeb: 45,
                                                    msg:
                                                        "An Appointment Letter Has Been Sent to ${_userEmailController.text}",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white);
                                              } catch (err) {
                                                print(err);
                                              }
                                            }
                                          }
                                        }
                                      },
                                      color: Colors.black,
                                      child: Text(
                                        'Send',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(18.0),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
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
