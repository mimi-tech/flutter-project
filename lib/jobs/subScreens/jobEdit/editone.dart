import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class EditOne extends StatefulWidget {
  @override
  _EditOneState createState() => _EditOneState();
}

class _EditOneState extends State<EditOne> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobSummaryController = TextEditingController();

  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();

  String? requirement;
  int _count = EditJobFormStorage.responsibility!.length;
  final TextEditingController _responsibilityController =
      TextEditingController();

  final TextEditingController _responsibilityControllerEdit =
      TextEditingController();
  String? qualification;

  final TextEditingController _qualificationController =
      TextEditingController();

  final TextEditingController _qualificationControllerEdit =
      TextEditingController();

  bool showSpinner = false;
  String? benefit;

  final TextEditingController _benefitController = TextEditingController();

  final TextEditingController _jobBenefitControllerEdit =
      TextEditingController();
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

  void _addBenefitRow() {
    if (_benefitController.text == '') {
      Fluttertoast.showToast(
          msg: "Job benefit required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(_benefitController.text, EditJobFormStorage.jobBenefit);
      benefit = null;
      _benefitController.clear();
    }
  }

  var _skillsController = TextEditingController();

  String? skills;

  void _addSkillRow() {
    if (_skillsController.text == '') {
      Fluttertoast.showToast(
          msg: "Skill is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(_skillsController.text, EditJobFormStorage.skills);
      skills = null;

      _skillsController.clear();
    }
  }

  void _addResponsibilityRow() {
    if (_responsibilityController.text == '') {
      Fluttertoast.showToast(
          msg: "Job Responsibility required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(
          _responsibilityController.text, EditJobFormStorage.responsibility);
      requirement = null;
      _responsibilityController.clear();
    }
  }

  void _addQualificationRow() {
    if (_qualificationController.text == '') {
      Fluttertoast.showToast(
          msg: "Job Qualification required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      _addData(
          _qualificationController.text, EditJobFormStorage.jobQualification);
      qualification = null;
      _qualificationController.clear();
    }
  }

  /// FocusNodes for the 'min price' & 'max price' TextFields
  /// TODO: Remove focus nodes if not necessary
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  /// These are the RangeValues for the RangeSlider Widget
  late double _lowPriceRange;
  late double _highPriceRange;

  /// The minimum and maximum values allowed for the price input
  double minRangeSliderValue = 0.0;
  double maxRangeSliderValue = 1000000.0;

  /// Boolean validator for 'MIN' and 'MAX' price TextFields
  bool isMinValid = true;
  bool isMaxValid = true;

  String? groupValue = EditJobFormStorage.jobCategory;
  String? jobTypeGroupValue = EditJobFormStorage.jobType;
  String? jobStatusValue = EditJobFormStorage.status;

  void changeJobStatusValue(value) {
    if (value == "open") {
      setState(() {
        jobStatusValue = "open";
        EditJobFormStorage.status = "open";
      });
    } else if (value == "closed") {
      setState(() {
        jobStatusValue = "closed";
        EditJobFormStorage.status = "closed";
      });
    }
  }

  void changeJobTypeState(value) {
    if (value == "inperson") {
      setState(() {
        jobTypeGroupValue = "inperson";
        EditJobFormStorage.jobType = "inperson";
      });
    } else if (value == "remote") {
      setState(() {
        jobTypeGroupValue = "remote";
        EditJobFormStorage.jobType = "remote";
      });
    }
  }

  void changeCategoryState(value) {
    if (value == "full time") {
      setState(() {
        groupValue = "full time";
        EditJobFormStorage.jobCategory = "full time";
      });
    } else if (value == "part time") {
      setState(() {
        groupValue = "part time";
        EditJobFormStorage.jobCategory = "part time";
      });
    } else if (value == "contract") {
      setState(() {
        groupValue = "contract";
        EditJobFormStorage.jobCategory = "contract";
      });
    }
  }

  /// Note: This function is called in the "initState"
  void setDefaultValuesOfSalary() {
    setState(() {
      if (_minSalaryController.text.trim() == null ||
          _minSalaryController.text.trim() == "") {
        _lowPriceRange = 0;
      } else {
        _lowPriceRange = double.parse(_minSalaryController.text.trim());
      }

      if (_maxSalaryController.text.trim() == null ||
          _maxSalaryController.text.trim() == "") {
        _highPriceRange = 1000000;
      } else {
        _highPriceRange = double.parse(_maxSalaryController.text.trim());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setDefaultValuesOfSalary();

    _minSalaryController =
        TextEditingController(text: EditJobFormStorage.salaryRangeMin);
    _maxSalaryController =
        TextEditingController(text: EditJobFormStorage.salaryRangeMax);

    groupValue = EditJobFormStorage.jobCategory;
    jobTypeGroupValue = EditJobFormStorage.jobType;

    print(EditJobFormStorage.jobId);
    print(EditJobFormStorage.companyId);
    print(EditJobFormStorage.logoUrl);
    print(EditJobFormStorage.jobType);

    _jobTitleController.text = EditJobFormStorage.jobTitle!;
    print(EditJobFormStorage.jobCategory);
    _jobSummaryController.text = EditJobFormStorage.jobSummary!;
    print(EditJobFormStorage.jobBenefit);
    print(EditJobFormStorage.jobQualification);
    print(EditJobFormStorage.responsibility);
    print(EditJobFormStorage.skills);
    print(EditJobFormStorage.companyName);
    _jobLocationController.text = EditJobFormStorage.jobLocation!;
    print(EditJobFormStorage.salaryRangeMin);
    print(EditJobFormStorage.salaryRangeMax);
    print(EditJobFormStorage.mainCompanyId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _jobTitleController.dispose();
    _jobLocationController.dispose();
    _jobSummaryController.dispose();

    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _minSalaryController.dispose();
    _maxSalaryController.dispose();

    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _responsibilityController.dispose();
    _responsibilityControllerEdit.dispose();

    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _qualificationController.dispose();
    _qualificationControllerEdit.dispose();

    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _skillsController.dispose();
    _benefitController.dispose();

    EditJobFormStorage.companyId = null;
    EditJobFormStorage.logoUrl = null;
    EditJobFormStorage.jobType = null;
    EditJobFormStorage.jobId = null;
    EditJobFormStorage.jobTitle = null;
    EditJobFormStorage.jobCategory = null;
    EditJobFormStorage.jobSummary = null;
    EditJobFormStorage.jobBenefit = [];
    EditJobFormStorage.jobQualification = [];
    EditJobFormStorage.responsibility = [];
    EditJobFormStorage.skills = [];
    EditJobFormStorage.companyName = null;
    EditJobFormStorage.jobLocation = null;
    EditJobFormStorage.salaryRangeMin = null;
    EditJobFormStorage.salaryRangeMax = null;
    EditJobFormStorage.mainCompanyId = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          automaticallyImplyLeading: true,
          backgroundColor: kLight_orange,
          centerTitle: true,
          title: Text(
            'EDIT JOB',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(18.0),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Status",
                ),
              ),

              Card(
                elevation: 4,
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            "Status",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(22.0),
                                  fontWeight: FontWeight.bold,
                                  color: kComp),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "open",
                                    groupValue: jobStatusValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) =>
                                        changeJobStatusValue(val),
                                  ),
                                  Text(
                                    'Open',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "closed",
                                    groupValue: jobStatusValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) =>
                                        changeJobStatusValue(val),
                                  ),
                                  Text(
                                    'Closed',
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Title",
                ),
              ),

              ResumeInput(
                controller: _jobTitleController,
                labelText: "Job Title",
                hintText: "Software Engineer",
                action: (value) {
                  EditJobFormStorage.jobTitle = value;
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Location",
                ),
              ),

              ResumeInput(
                controller: _jobLocationController,
                labelText: "Job Location",
                hintText: "Canada",
                action: (value) {
                  EditJobFormStorage.jobLocation = value;
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Summary",
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
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
                          controller: _jobSummaryController,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kLight_orange, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //ToDo:hint text
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Duration",
                ),
              ),
              //ToDo:company details

              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Card(
                  elevation: 8,
                  child: Container(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              "Job Category",
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(22.0),
                                    fontWeight: FontWeight.bold,
                                    color: kComp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Radio(
                                      value: 'full time',
                                      groupValue: groupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          changeCategoryState(val),
                                    ),
                                    Text(
                                      'Full-Time',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Radio(
                                      value: 'part time',
                                      groupValue: groupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          changeCategoryState(val),
                                    ),
                                    Text(
                                      'Part-Time',
                                      style: new TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 'contract',
                                    groupValue: groupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) =>
                                        changeCategoryState(val),
                                  ),
                                  Text(
                                    'Contract',
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Job Type",
                ),
              ),

              Card(
                elevation: 4,
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            "Job Type",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(22.0),
                                  fontWeight: FontWeight.bold,
                                  color: kComp),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "inperson",
                                    groupValue: jobTypeGroupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) => changeJobTypeState(val),
                                  ),
                                  Text(
                                    'InPerson',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "remote",
                                    groupValue: jobTypeGroupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) => changeJobTypeState(val),
                                  ),
                                  Text(
                                    'Remote',
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: EditHintText(
                  hintText: "Salary Or Pay Range",
                ),
              ),

              Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          /// TextField for the 'MIN' price input field
                          Flexible(
                            child: Container(
                              width: ScreenUtil().setWidth(96),
                              child: TextField(
                                controller: _minSalaryController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: kMSearchDrawerTextStyle,
                                keyboardType: TextInputType.number,
                                focusNode: _minPriceFocusNode,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kMarketPrimaryColor),
                                  ),
                                  hintText: 'MIN',
                                  hintStyle: kMSearchDrawerTextStyle,
                                ),
                                onSubmitted: (value) {
                                  _minPriceFocusNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_maxPriceFocusNode);
                                },
                                onChanged: (value) {
                                  if (value == null || value == '') {
                                    setState(() {
                                      _lowPriceRange = minRangeSliderValue;
                                    });
                                  } else if (double.parse(value) <=
                                          maxRangeSliderValue &&
                                      double.parse(value) >=
                                          minRangeSliderValue &&
                                      double.parse(value) <= _highPriceRange) {
                                    setState(() {
                                      _lowPriceRange = double.parse(value);
                                    });
                                  } else {
                                    setState(() {
                                      _lowPriceRange = minRangeSliderValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(44),
                          ),

                          /// TextField for the 'MAX' price input field
                          Flexible(
                            child: Container(
                              width: ScreenUtil().setWidth(96),
                              child: TextField(
                                controller: _maxSalaryController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: kMSearchDrawerTextStyle,
                                keyboardType: TextInputType.number,
                                focusNode: _maxPriceFocusNode,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kMarketPrimaryColor),
                                  ),
                                  hintText: 'MAX',
                                  hintStyle: kMSearchDrawerTextStyle,
                                  errorText:
                                      isMaxValid ? null : 'Shit not working',
                                ),
                                onSubmitted: (value) {
                                  _maxPriceFocusNode.unfocus();
                                },
                                onChanged: (value) {
                                  if (value == null || value == '') {
                                    setState(() {
                                      _highPriceRange = maxRangeSliderValue;
                                    });
                                  } else if (double.parse(value) <=
                                          maxRangeSliderValue &&
                                      double.parse(value) >=
                                          minRangeSliderValue &&
                                      double.parse(value) >= _lowPriceRange) {
                                    setState(() {
                                      _highPriceRange = double.parse(value);
                                    });
                                  } else {
                                    setState(() {
                                      _highPriceRange = maxRangeSliderValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RangeSlider for the 'Price Range'
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RangeSlider(
                        activeColor: kMarketSecondaryColor,
                        inactiveColor: Color(0xffB9BEC5),
                        values: RangeValues(_lowPriceRange, _highPriceRange),
                        divisions: 50,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _lowPriceRange = values.start.roundToDouble();
                            _highPriceRange = values.end.roundToDouble();
                            _minSalaryController.text =
                                values.start.toInt().toString();
                            _maxSalaryController.text =
                                values.end.toInt().toString();
                          });
                        },
                        min: minRangeSliderValue,
                        max: maxRangeSliderValue,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Job Responsibilities",
                ),
              ),

              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Icon(
                                Icons.build,
                                color: kLight_orange,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Text(
                            "Job Responsibilities",
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
                              i < EditJobFormStorage.responsibility!.length;
                              i++)
                            Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${i + 1}. ${EditJobFormStorage.responsibility![i]} ",
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
                                              _responsibilityControllerEdit
                                                      .text =
                                                  EditJobFormStorage
                                                      .responsibility![i];
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
                                                                          _responsibilityControllerEdit,
                                                                      labelText:
                                                                          "Enter responsibility",
                                                                      hintText:
                                                                          "Job responsibility",
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
                                                                          if (_responsibilityControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "Responsibility is empty",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              EditJobFormStorage.responsibility![i] = _responsibilityControllerEdit.text;
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                    child: Text(
                                                                      'Are You Sure You Want To Delete',
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                ScreenUtil().setSp(18.0),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      "${i + 1}.${EditJobFormStorage.responsibility![i]} ",
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
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
                                                                          setState(
                                                                              () {
                                                                            EditJobFormStorage.responsibility!.remove(EditJobFormStorage.responsibility![i]);
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                        controller: _responsibilityController,
                        labelText: "Enter Job Responsibility",
                        hintText: "Describe the Responsibility",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addResponsibilityRow();
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

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Job Qualifications",
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Icon(
                                Icons.build,
                                color: kLight_orange,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Text(
                            "Job Qualifications",
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
                              i < EditJobFormStorage.jobQualification!.length;
                              i++)
                            Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${i + 1}. ${EditJobFormStorage.jobQualification![i]} ",
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
                                              _qualificationControllerEdit
                                                      .text =
                                                  EditJobFormStorage
                                                      .jobQualification![i];
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
                                                                          _qualificationControllerEdit,
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
                                                                          if (_qualificationControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "qualification field is empty",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              EditJobFormStorage.jobQualification![i] = _qualificationControllerEdit.text;
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                    child: Text(
                                                                      'Are You Sure You Want To Delete',
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                ScreenUtil().setSp(18.0),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      "${i + 1}.${EditJobFormStorage.jobQualification![i]} ",
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
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
                                                                          setState(
                                                                              () {
                                                                            EditJobFormStorage.jobQualification!.remove(EditJobFormStorage.jobQualification![i]);
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                        controller: _qualificationController,
                        labelText: "Enter Job qualification ",
                        hintText: "Describe qualification",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addQualificationRow();
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

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Required Skills",
                ),
              ),

              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "SKILLS",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(20.0),
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
                          for (var item in EditJobFormStorage.skills!)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _count = _count - 1;
                                        EditJobFormStorage.skills!.remove(item);
                                      });
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _skillsController,
                        labelText: "Enter Job Skill",
                        hintText: "JavaScript",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addSkillRow();
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

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Job Benefits",
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Icon(
                                Icons.build,
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
                              i < EditJobFormStorage.jobBenefit!.length;
                              i++)
                            Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${i + 1}. ${EditJobFormStorage.jobBenefit![i]} ",
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
                                              _jobBenefitControllerEdit.text =
                                                  EditJobFormStorage
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
                                                                          _jobBenefitControllerEdit,
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
                                                                          if (_jobBenefitControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "jobBenefit field is empty",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              EditJobFormStorage.jobBenefit![i] = _jobBenefitControllerEdit.text;
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                    child: Text(
                                                                      'Are You Sure You Want To Delete',
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                ScreenUtil().setSp(18.0),
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      "${i + 1}.${EditJobFormStorage.jobBenefit![i]} ",
                                                                      style: GoogleFonts
                                                                          .rajdhani(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
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
                                                                          setState(
                                                                              () {
                                                                            EditJobFormStorage.jobBenefit!.remove(EditJobFormStorage.jobBenefit![i]);
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          Navigator.pop(
                                                                              context);
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          height:
                                                                              ScreenUtil().setHeight(40.0),
                                                                          width:
                                                                              ScreenUtil().setWidth(80.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                        labelText: "Enter jobBenefit ",
                        hintText: "Describe jobBenefit",
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
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: RaisedButton(
                  onPressed: () {
                    update();
                  },
                  color: kLight_orange,
                  textColor: Colors.white,
                  child: Text(
                    "Save",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(22.0),
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> searchKeyWords() {
    List<String> result = [];

    HashSet<String> sWords = new HashSet<String>();

    String jobTitle = EditJobFormStorage.jobTitle!;
    String location = EditJobFormStorage.jobLocation!;
    String duration = EditJobFormStorage.jobCategory!;
    String jobType = EditJobFormStorage.jobType!;
    String companyName = EditJobFormStorage.companyName!;

    sWords.add(jobTitle.toLowerCase());
    sWords.add(location.toLowerCase());
    sWords.add(duration.toLowerCase());
    sWords.add(jobType.toLowerCase());
    sWords.add(companyName.toLowerCase());

    List<String> temp = sWords.toList();

    for (int i = 0; i < jobTitle.split(" ").length; i++) {
      sWords.add(jobTitle.split(" ")[i].toLowerCase());
    }

    for (int i = 0; i < companyName.split(" ").length; i++) {
      sWords.add(companyName.split(" ")[i].toLowerCase());
    }

    int pointer = 0;

    while (pointer < temp.length) {
      for (int i = 0; i < temp.length; i++) {
        if (i != pointer && temp[pointer] != temp[i]) {
          sWords.add(temp[pointer] + " " + temp[i]);
        }
      }

      pointer++;
    }

    for (int i = 0; i < temp.length; i++) {
      if (i + 2 < temp.length) {
        sWords.add(temp[i] + " " + temp[i + 1] + " " + temp[i + 2]);
      }

      if (i + 3 > temp.length) break;
    }

    List<String> jobTitleTemps = jobTitle.split(" ")[0].split('');
    List<String> companyNameTemps = companyName.split(" ")[0].split('');
    List<String> locationTemps = location.split(" ")[0].split('');
    List<String> durationTemps = duration.split(" ").join("").split("");
    List<String> jobTypeTemps = jobType.split(" ")[0].split('');

    String jobTitleSearchKeys = "";
    String locationSearchKeys = "";
    String durationSearchKeys = "";
    String jobTypeSearchKeys = "";
    String companySearchKeys = "";

    for (int i = 0; i < companyNameTemps.length; i++) {
      companySearchKeys += companyNameTemps[i].toLowerCase();

      sWords.add(companySearchKeys);
    }

    for (int i = 0; i < jobTitleTemps.length; i++) {
      jobTitleSearchKeys += jobTitleTemps[i].toLowerCase();

      sWords.add(jobTitleSearchKeys);
    }
    for (int i = 0; i < locationTemps.length; i++) {
      locationSearchKeys += locationTemps[i].toLowerCase();

      sWords.add(locationSearchKeys);
    }
    for (int i = 0; i < durationTemps.length; i++) {
      durationSearchKeys += durationTemps[i].toLowerCase();

      sWords.add(durationSearchKeys);
    }
    for (int i = 0; i < jobTypeTemps.length; i++) {
      jobTypeSearchKeys += jobTypeTemps[i].toLowerCase();

      sWords.add(jobTypeSearchKeys);
    }

    result = sWords.toList();

    return result;
  }

  void update() {
    List<String> search = searchKeyWords();

    setState(() {
      showSpinner = true;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('jobs')
        .doc(EditJobFormStorage.mainCompanyId)
        .collection('companyJobs')
        .doc(EditJobFormStorage.jobId);
    documentReference.update({
      'cid': EditJobFormStorage.companyId,
      'cnm': EditJobFormStorage.companyName,
      'jbt': EditJobFormStorage.jobBenefit,
      'jcg': EditJobFormStorage.jobCategory,
      'skl': EditJobFormStorage.skills,
      'jrSt': EditJobFormStorage.responsibility,
      'jlt': _jobLocationController.text,
      'jqt': EditJobFormStorage.jobQualification,
      'sum': _jobSummaryController.text,
      'jtl': _jobTitleController.text,
      'jtp': EditJobFormStorage.jobType,
      'jtm': DateTime.now().toString(),
      'status': EditJobFormStorage.status,
      'search': search,
      'lur': EditJobFormStorage.logoUrl,
      'srn': _minSalaryController.text,
      'srx': _maxSalaryController.text,
      'time': DateTime.now()
    });
    ReusableFunctions.showToastMessage2(
        "updated successfully", Colors.white, Colors.black);
    Navigator.pop(context);

    setState(() {
      showSpinner = false;
    });
  }
}
