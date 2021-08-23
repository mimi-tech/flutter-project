import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class InterviewFormTwo extends StatefulWidget {
  const InterviewFormTwo({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _InterviewFormTwoState createState() => _InterviewFormTwoState();
}

class _InterviewFormTwoState extends State<InterviewFormTwo> {
  String? requirement;
  String? benefit;

  int _count = InterviewFormStorage.jobRequirement!.length;
  final TextEditingController _requirementController = TextEditingController();
  final TextEditingController _benefitController = TextEditingController();
  final TextEditingController _requirementControllerEdit =
      TextEditingController();
  final TextEditingController _benefitControllerEdit = TextEditingController();

  final TextEditingController _nameOfContactController =
      TextEditingController();
  final TextEditingController _jobRoleOfContactController =
      TextEditingController();
  final TextEditingController _phoneOfContactController =
      TextEditingController();

  final TextEditingController _nameOfContactControllerEdit =
      TextEditingController();
  final TextEditingController _jobRoleOfContactControllerEdit =
      TextEditingController();
  final TextEditingController _phoneOfContactControllerEdit =
      TextEditingController();

  final TextEditingController _interviewMessage = TextEditingController();
  final TextEditingController _interviewLocation = TextEditingController();
  _addData(data, list) {
    setState(() {
      if (data != null) {
        list.add(data);

        _count = _count + 1;
      } else {
        print('what the fuck');
        return null;
      }
    });
  }

  void _addRequirementRow() {
    if (_requirementController.text == '') {
      Fluttertoast.showToast(
          msg: "Requirement should not be empty",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(
          _requirementController.text, InterviewFormStorage.jobRequirement);
      requirement = null;
      _requirementController.clear();
    }
  }

  void _addBenefitRow() {
    if (_benefitController.text == '') {
      Fluttertoast.showToast(
          msg: "Benefit should not be empty",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(_benefitController.text, InterviewFormStorage.jobBenefit);
      benefit = null;
      _benefitController.clear();
    }
  }

  void _addContactPerson() {
    //TODO: validate user input
    if (_nameOfContactController.text == '') {
      Fluttertoast.showToast(
          msg: "name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobRoleOfContactController.text == '') {
      Fluttertoast.showToast(
          msg: "job role field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_phoneOfContactController.text == '') {
      Fluttertoast.showToast(
          msg: "phone field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var person = {
        "name":
            ReusableFunctions.capitalizeWords(_nameOfContactController.text),
        "role":
            ReusableFunctions.capitalizeWords(_jobRoleOfContactController.text),
        "phone":
            ReusableFunctions.capitalizeWords(_phoneOfContactController.text),
      };

      //TODO: add the object to the list
      setState(() {
        InterviewFormStorage.contactPerson!.add(person);
        //TODO: clear the content of the text controllers
        person = {};
        _nameOfContactController.clear();
        _jobRoleOfContactController.clear();
        _phoneOfContactController.clear();
      });
    }
  }

  void validateAndSaveData() {
    if (InterviewFormStorage.jobRequirement!.isEmpty &
        InterviewFormStorage.jobBenefit!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill the empty spaces",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_interviewLocation.text == '') {
      Fluttertoast.showToast(
          msg: "enter interview location",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_interviewMessage.text == '') {
      Fluttertoast.showToast(
          msg: "Write interview message",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      InterviewFormStorage.interviewMessage = _interviewMessage.text;
      InterviewFormStorage.interviewVenue = _interviewLocation.text;
      widget.tabController!.animateTo(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    child: Text(
                      InterviewFormStorage.jobLocation!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(20.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    child: Text(
                      "Salary \$${InterviewFormStorage.salaryRangeMin} - \$${InterviewFormStorage.salaryRangeMax}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: kNavBg),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Text(
                      InterviewFormStorage.description!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(14.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
//For Interview venue

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: EditHintText(
                      hintText: "Interview Location",
                    ),
                  ),
                  ResumeInput(
                    controller: _interviewLocation,
                    labelText: "Enter Interview Location",
                    hintText: "123 Rex tech estate street",
                    action: (value) {},
                  ),

//for interview message
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: EditHintText(
                      hintText: "Interview Message",
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
                              controller: _interviewMessage,
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

//for requirement
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Icon(
                                  Icons.blur_on,
                                  color: kLight_orange,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            Text(
                              "Job Requirement",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(25.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                        child: Column(
                          children: <Widget>[
                            for (var i = 0;
                                i < InterviewFormStorage.jobRequirement!.length;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        15.0, 30.0, 0.0, 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "${i + 1}. ${InterviewFormStorage.jobRequirement![i]} ",
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _requirementControllerEdit
                                                        .text =
                                                    InterviewFormStorage
                                                        .jobRequirement![i];
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            elevation: 8,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          ResumeInput(
                                                                        controller:
                                                                            _requirementControllerEdit,
                                                                        labelText:
                                                                            "Enter Requirement",
                                                                        hintText:
                                                                            "Job requirement",
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            ///validate for empty data.
                                                                            if (_requirementControllerEdit.text ==
                                                                                '') {
                                                                              Fluttertoast.showToast(msg: "Add at least one requirement", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                            } else {
                                                                              //pass data to the main controller
                                                                              setState(() {
                                                                                InterviewFormStorage.jobRequirement![i] = _requirementControllerEdit.text;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Ok",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Cancel",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]));
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: kLight_orange,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            elevation: 8,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        'Are You Sure You Want To Delete',
                                                                        style: GoogleFonts
                                                                            .rajdhani(
                                                                          textStyle: TextStyle(
                                                                              fontSize: ScreenUtil().setSp(18.0),
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "${i + 1}.${InterviewFormStorage.jobRequirement![i]} ",
                                                                        style: GoogleFonts
                                                                            .rajdhani(
                                                                          textStyle: TextStyle(
                                                                              fontSize: 15.sp,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              InterviewFormStorage.jobRequirement!.remove(InterviewFormStorage.jobRequirement![i]);
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "YES",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Cancel",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]));
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: kLight_orange,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _requirementController,
                          labelText: "Enter Job Requirement",
                          hintText: "Describe the requirement",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _addRequirementRow();
                            },
                            child: Container(
                              height: ScreenUtil().setHeight(100.0),
                              width: ScreenUtil().setWidth(100),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("images/jobs/add.png"),
                                  //fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // For Benefits Inputs
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Icon(
                                  Icons.blur_on,
                                  color: kLight_orange,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            Text(
                              "Job Benefits",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(25.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                        child: Column(
                          children: <Widget>[
                            for (var i = 0;
                                i < InterviewFormStorage.jobBenefit!.length;
                                i++)
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        15.0, 30.0, 0.0, 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "${i + 1}. ${InterviewFormStorage.jobBenefit![i]} ",
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _benefitControllerEdit.text =
                                                    InterviewFormStorage
                                                        .jobBenefit![i];
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            elevation: 8,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          ResumeInput(
                                                                        controller:
                                                                            _benefitControllerEdit,
                                                                        labelText:
                                                                            "Enter Benefit",
                                                                        hintText:
                                                                            "Job Benefit",
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            ///validate for empty data.
                                                                            if (_benefitControllerEdit.text ==
                                                                                '') {
                                                                              Fluttertoast.showToast(msg: "Add at least one benefit", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                            } else {
                                                                              //pass data to the main controller
                                                                              setState(() {
                                                                                InterviewFormStorage.jobBenefit![i] = _benefitControllerEdit.text;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Ok",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Cancel",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]));
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: kLight_orange,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            elevation: 8,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        'Are You Sure You Want To Delete',
                                                                        style: GoogleFonts
                                                                            .rajdhani(
                                                                          textStyle: TextStyle(
                                                                              fontSize: ScreenUtil().setSp(18.0),
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "${i + 1}.${InterviewFormStorage.jobBenefit![i]} ",
                                                                        style: GoogleFonts
                                                                            .rajdhani(
                                                                          textStyle: TextStyle(
                                                                              fontSize: 15.sp,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              InterviewFormStorage.jobBenefit!.remove(InterviewFormStorage.jobBenefit![i]);
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "YES",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                15.0,
                                                                                20.0,
                                                                                20.0,
                                                                                00.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                ScreenUtil().setHeight(40.0),
                                                                            width:
                                                                                ScreenUtil().setWidth(80.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Cancel",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: GoogleFonts.rajdhani(
                                                                                    textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]));
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: kLight_orange,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _benefitController,
                          labelText: "Enter Job Benefit",
                          hintText: "Describe the Benefit",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _addBenefitRow();
                            },
                            child: Container(
                              height: ScreenUtil().setHeight(100.0),
                              width: ScreenUtil().setWidth(100),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("images/jobs/add.png"),
                                  //fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

//for contact person

                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Add Contact Persons",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(23.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                for (var i = 0;
                                    i <
                                        InterviewFormStorage
                                            .contactPerson!.length;
                                    i++)
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            15.0, 30.0, 0.0, 5.0),
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                child: Icon(
                                                  Icons.account_circle,
                                                  color: kLight_orange,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Contact Person ${i + 1}",
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(18.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _jobRoleOfContactControllerEdit
                                                          .text =
                                                      InterviewFormStorage
                                                          .contactPerson!
                                                          .elementAt(i)['role'];
                                                  _nameOfContactControllerEdit
                                                          .text =
                                                      InterviewFormStorage
                                                          .contactPerson!
                                                          .elementAt(i)['name'];
                                                  _phoneOfContactControllerEdit
                                                          .text =
                                                      InterviewFormStorage
                                                          .contactPerson!
                                                          .elementAt(
                                                              i)['phone'];
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          SimpleDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              elevation: 8,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            ResumeInput(
                                                                          controller:
                                                                              _nameOfContactControllerEdit,
                                                                          labelText:
                                                                              "enter name of contact person",
                                                                          hintText:
                                                                              "Amadi Austin",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            ResumeInput(
                                                                          controller:
                                                                              _jobRoleOfContactControllerEdit,
                                                                          labelText:
                                                                              "enter job role of contact person",
                                                                          hintText:
                                                                              "Lead Engineer",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            ResumeInput(
                                                                          controller:
                                                                              _phoneOfContactControllerEdit,
                                                                          labelText:
                                                                              "enter phone number of contact person",
                                                                          hintText:
                                                                              "+2349037096290",
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              ///validate for empty data.
                                                                              if (_jobRoleOfContactControllerEdit.text == '') {
                                                                                Fluttertoast.showToast(msg: "job role field cannot be blank", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                              } else if (_phoneOfContactControllerEdit.text == '') {
                                                                                Fluttertoast.showToast(msg: "phone number field cannot be blank", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                              } else if (_nameOfContactControllerEdit.text == '') {
                                                                                Fluttertoast.showToast(msg: "name field cannot be blank", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                              } else {
                                                                                //pass data to the main controller
                                                                                setState(() {
                                                                                  InterviewFormStorage.contactPerson!.elementAt(i)['name'] = ReusableFunctions.capitalizeWords(_nameOfContactControllerEdit.text);
                                                                                  InterviewFormStorage.contactPerson!.elementAt(i)['role'] = ReusableFunctions.capitalizeWords(_jobRoleOfContactControllerEdit.text);
                                                                                  InterviewFormStorage.contactPerson!.elementAt(i)['phone'] = ReusableFunctions.capitalizeWords(_phoneOfContactControllerEdit.text);
                                                                                });
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 00.0),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                                color: Colors.red,
                                                                              ),
                                                                              height: ScreenUtil().setHeight(40.0),
                                                                              width: ScreenUtil().setWidth(80.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Ok",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.rajdhani(
                                                                                      textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 00.0),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                                color: Colors.red,
                                                                              ),
                                                                              height: ScreenUtil().setHeight(40.0),
                                                                              width: ScreenUtil().setWidth(80.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Cancel",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.rajdhani(
                                                                                      textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ]));
                                                },
                                                child: Container(
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: kLight_orange,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          SimpleDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              elevation: 8,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Are You Sure You Want To Delete',
                                                                          style:
                                                                              GoogleFonts.rajdhani(
                                                                            textStyle: TextStyle(
                                                                                fontSize: ScreenUtil().setSp(18.0),
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Contact Person ${i + 1}",
                                                                          style:
                                                                              GoogleFonts.rajdhani(
                                                                            textStyle: TextStyle(
                                                                                fontSize: 15.sp,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                InterviewFormStorage.contactPerson!.remove(InterviewFormStorage.contactPerson!.elementAt(i));
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 00.0),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                                color: Colors.red,
                                                                              ),
                                                                              height: ScreenUtil().setHeight(40.0),
                                                                              width: ScreenUtil().setWidth(80.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "YES",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.rajdhani(
                                                                                      textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 00.0),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                                color: Colors.red,
                                                                              ),
                                                                              height: ScreenUtil().setHeight(40.0),
                                                                              width: ScreenUtil().setWidth(80.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Cancel",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: GoogleFonts.rajdhani(
                                                                                      textStyle: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ]));
                                                },
                                                child: Container(
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: kLight_orange,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ExContent(
                                        dString: "images/jobs/dm.png",
                                        text1: InterviewFormStorage
                                            .contactPerson!
                                            .elementAt(i)['name'],
                                        text2: InterviewFormStorage
                                            .contactPerson!
                                            .elementAt(i)['role'],
                                        text3: InterviewFormStorage
                                            .contactPerson!
                                            .elementAt(i)['phone'],
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                          child: ResumeInput(
                            controller: _nameOfContactController,
                            labelText: "enter name of contact person",
                            hintText: "Austin Emeka",
                          ),
                        ),
                        Container(
                          child: ResumeInput(
                            controller: _jobRoleOfContactController,
                            labelText: "enter job role of contact person",
                            hintText: "Lead Engineer",
                          ),
                        ),
                        Container(
                          child: ResumeInput(
                            controller: _phoneOfContactController,
                            labelText: "enter phone number of contact person",
                            hintText: "+1239037096290",
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _addContactPerson();
                              },
                              child: Container(
                                height: ScreenUtil().setHeight(100.0),
                                width: ScreenUtil().setWidth(100),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/jobs/add.png"),
                                    //fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          widget.tabController!.animateTo(0);
                        },
                        color: kLight_orange,
                        textColor: Colors.white,
                        child: Text("previous"),
                      ),
                      RaisedButton(
                        onPressed: () {
                          validateAndSaveData();
                        },
                        color: kLight_orange,
                        textColor: Colors.white,
                        child: Text("view"),
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
  }
}
