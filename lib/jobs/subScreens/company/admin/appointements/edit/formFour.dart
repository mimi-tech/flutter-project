import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/company/createAppointmentLetter/sample.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class EditFormFour extends StatefulWidget {
  const EditFormFour({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _EditFormFourState createState() => _EditFormFourState();
}

class _EditFormFourState extends State<EditFormFour> {
  final TextEditingController _amendmentMessageController =
      TextEditingController();
  final TextEditingController _humanResourceController =
      TextEditingController();
  final TextEditingController _confirmationMessageController =
      TextEditingController();

  bool showSpinner = false;
  bool done = false;

  void validateAndSaveData() {
    if (_amendmentMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_humanResourceController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_confirmationMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      AppointmentStorage.amendmentMessage = _amendmentMessageController.text;
      AppointmentStorage.humanResourceName = _humanResourceController.text;
      AppointmentStorage.confirmationMessage =
          _confirmationMessageController.text;

      //TODO: submit to database

      var date = DateTime.now().toString();

      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('appointmentLetter')
          .doc(UserStorage.loggedInUser.uid)
          .collection('companyAppointmentLetterPages')
          .doc(CompanyStorage.pageId)
          .collection('companyAppointmentLetterDetails')
          .doc(AppointmentStorage.appointmentId);
      documentReference.update({
        'cnm': AppointmentStorage.companyName,
        'cAds': AppointmentStorage.companyAddress,
        'cCity': AppointmentStorage.companyCity,
        'cState': AppointmentStorage.companyState,
        'cZcd': AppointmentStorage.companyZipCode,
        'rnm': AppointmentStorage.recipientName,
        'rAds': AppointmentStorage.recipientAddress,
        'rCity': AppointmentStorage.recipientCity,
        'rState': AppointmentStorage.recipientState,
        'rZcd': AppointmentStorage.recipientZipCode,
        'apMsg': AppointmentStorage.appointmentMessage,
        'coMsg': AppointmentStorage.commencementMessage,
        'rpMsg': AppointmentStorage.reportingMessage,
        'aloMsg': AppointmentStorage.allocationMessage,
        'rrMsg': AppointmentStorage.rolesMessage,
        'msMsg': AppointmentStorage.salaryMessage,
        'whMsg': AppointmentStorage.workingHoursMessage,
        'vaMsg': AppointmentStorage.vacationMessage,
        'skMsg': AppointmentStorage.sickMessage,
        'paMsg': AppointmentStorage.paternityMessage,
        'tmMsg': AppointmentStorage.terminationMessage,
        'crtMsg': AppointmentStorage.copyrightsMessage,
        'amtMsg': AppointmentStorage.amendmentMessage,
        'hrNm': AppointmentStorage.humanResourceName,
        'conMsg': AppointmentStorage.confirmationMessage,
        'lur': AppointmentStorage.logoUrl,
        'date': date,
      });
      Fluttertoast.showToast(
          msg: "Appointment Letter updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white);
      setState(() {
        done = true;
      });

      setState(() {
        showSpinner = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amendmentMessageController.text = AppointmentStorage.amendmentMessage!;
    _humanResourceController.text = AppointmentStorage.humanResourceName!;
    _confirmationMessageController.text =
        AppointmentStorage.confirmationMessage!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (done == true) {
      AppointmentStorage.companyName = null;
      AppointmentStorage.companyAddress = null;
      AppointmentStorage.companyCity = null;
      AppointmentStorage.companyState = null;
      AppointmentStorage.companyZipCode = null;
      AppointmentStorage.recipientName = null;
      AppointmentStorage.recipientAddress = null;
      AppointmentStorage.recipientCity = null;
      AppointmentStorage.recipientState = null;
      AppointmentStorage.recipientZipCode = null;
      AppointmentStorage.appointmentMessage = null;
      AppointmentStorage.commencementMessage = null;
      AppointmentStorage.reportingMessage = null;
      AppointmentStorage.allocationMessage = null;
      AppointmentStorage.rolesMessage = null;
      AppointmentStorage.salaryMessage = null;
      AppointmentStorage.workingHoursMessage = null;
      AppointmentStorage.vacationMessage = null;
      AppointmentStorage.sickMessage = null;
      AppointmentStorage.paternityMessage = null;
      AppointmentStorage.terminationMessage = null;
      AppointmentStorage.copyrightsMessage = null;
      AppointmentStorage.amendmentMessage = null;
      AppointmentStorage.humanResourceName = null;
      AppointmentStorage.confirmationMessage = null;
      AppointmentStorage.logoUrl = null;

      _amendmentMessageController.dispose();
      _humanResourceController.dispose();
      _confirmationMessageController.dispose();
    } else {
      print('yook cool');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
              child: Container(
//                  height: screenData.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: RaisedButton(
                          color: kComp,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                      padding: EdgeInsets.only(top: 32.0),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: AppointmentSample(),
                                    ));
                          },
                          child: new Text(
                            "See Sample",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "amendment",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Container(
                                height: ScreenUtil().setHeight(180.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  maxLines: 10,
                                  autofocus: true,
                                  controller: _amendmentMessageController,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLight_orange, width: 1.0),
                                    ),
                                    hintText: "see sample",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ResumeInput(
                        controller: _humanResourceController,
                        labelText: "Human resource manager name",
                        hintText: "see sample",
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "Confirmation Message",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Container(
                                height: ScreenUtil().setHeight(180.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  maxLines: 10,
                                  autofocus: true,
                                  controller: _confirmationMessageController,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLight_orange, width: 1.0),
                                    ),
                                    hintText: "see sample",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: RaisedButton(
                              color: Colors.black,
                              onPressed: () {
                                widget.tabController!.animateTo(2);
                              },
                              child: new Text(
                                "Back",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: RaisedButton(
                              color: Colors.black,
                              onPressed: () {
                                validateAndSaveData();
                              },
                              child: new Text(
                                "update",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
