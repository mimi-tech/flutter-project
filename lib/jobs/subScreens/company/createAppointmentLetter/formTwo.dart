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

class FormTwo extends StatefulWidget {
  const FormTwo({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _FormTwoState createState() => _FormTwoState();
}

class _FormTwoState extends State<FormTwo> {
  final TextEditingController _appointmentMessageController =
      TextEditingController();
  final TextEditingController _commencementMessageController =
      TextEditingController();
  final TextEditingController _reportingMessageController =
      TextEditingController();
  final TextEditingController _allocationMessageController =
      TextEditingController();
  final TextEditingController _rolesMessageController = TextEditingController();
  final TextEditingController _salaryMessageController =
      TextEditingController();

  void validateAndSaveData() {
    if (_appointmentMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_commencementMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_reportingMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_allocationMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_rolesMessageController.text == '' &&
        _salaryMessageController.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      AppointmentStorage.appointmentMessage =
          _appointmentMessageController.text;
      AppointmentStorage.commencementMessage =
          _commencementMessageController.text;
      AppointmentStorage.reportingMessage = _reportingMessageController.text;
      AppointmentStorage.allocationMessage = _allocationMessageController.text;
      AppointmentStorage.rolesMessage = _rolesMessageController.text;
      AppointmentStorage.salaryMessage = _salaryMessageController.text;
      widget.tabController!.animateTo(2);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appointmentMessageController.text = AppointmentStorage.appointmentMessage!;
    _commencementMessageController.text =
        AppointmentStorage.commencementMessage!;
    _reportingMessageController.text = AppointmentStorage.reportingMessage!;
    _allocationMessageController.text = AppointmentStorage.allocationMessage!;
    _rolesMessageController.text = AppointmentStorage.rolesMessage!;
    _salaryMessageController.text = AppointmentStorage.salaryMessage!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _appointmentMessageController.dispose();
    _commencementMessageController.dispose();
    _reportingMessageController.dispose();
    _allocationMessageController.dispose();
    _rolesMessageController.dispose();
    _salaryMessageController.dispose();
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
                        hintText: "Appointment Message",
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
                                controller: _appointmentMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                        hintText: "Commencement Message",
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
                                controller: _commencementMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                        hintText: "Reporting Message",
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
                                controller: _reportingMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                        hintText: "Allocation Message",
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
                                controller: _allocationMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                        hintText: "Roles and Responsibility Message",
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
                                controller: _rolesMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                        hintText: "About Salary",
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
                                controller: _salaryMessageController,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
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
                              widget.tabController!.animateTo(0);
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
