import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/company/createAppointmentLetter/sample.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class FormThree extends StatefulWidget {
  const FormThree({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _FormThreeState createState() => _FormThreeState();
}

class _FormThreeState extends State<FormThree> {
  final TextEditingController _workingHoursMessageController =
      TextEditingController();
  final TextEditingController _terminationMessageController =
      TextEditingController();
  final TextEditingController _copyRightsMessageController =
      TextEditingController();
  final TextEditingController _vacationMessageController =
      TextEditingController();
  final TextEditingController _sickMessageController = TextEditingController();
  final TextEditingController _paternityMessageController =
      TextEditingController();

  void validateAndSaveData() {
    if (_workingHoursMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_terminationMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_copyRightsMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_vacationMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_sickMessageController.text == '' &&
        _paternityMessageController.text == "") {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      AppointmentStorage.workingHoursMessage =
          _workingHoursMessageController.text;
      AppointmentStorage.terminationMessage =
          _terminationMessageController.text;
      AppointmentStorage.copyrightsMessage = _copyRightsMessageController.text;
      AppointmentStorage.vacationMessage = _vacationMessageController.text;
      AppointmentStorage.sickMessage = _sickMessageController.text;
      AppointmentStorage.paternityMessage = _paternityMessageController.text;

      widget.tabController!.animateTo(3);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workingHoursMessageController.text =
        AppointmentStorage.workingHoursMessage!;
    _terminationMessageController.text = AppointmentStorage.terminationMessage!;
    _copyRightsMessageController.text = AppointmentStorage.copyrightsMessage!;
    _vacationMessageController.text = AppointmentStorage.vacationMessage!;
    _sickMessageController.text = AppointmentStorage.sickMessage!;
    _paternityMessageController.text = AppointmentStorage.paternityMessage!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _workingHoursMessageController.dispose();
    _terminationMessageController.dispose();
    _copyRightsMessageController.dispose();
    _vacationMessageController.dispose();
    _sickMessageController.dispose();
    _paternityMessageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
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
                                    height: MediaQuery.of(context).size.height,
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
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Stipulate working hours",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _workingHoursMessageController,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Termination Message",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _terminationMessageController,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Copyright  Message",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _copyRightsMessageController,
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Leave",
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Vacation Leave",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _vacationMessageController,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Sick Leave",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _sickMessageController,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Paternity Leave",
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                                controller: _paternityMessageController,
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
                              widget.tabController!.animateTo(1);
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
                              "Next",
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
    );
  }
}
