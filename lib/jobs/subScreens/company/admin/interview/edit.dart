import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class EditJobInterview extends StatefulWidget {
  @override
  _EditJobInterviewState createState() => _EditJobInterviewState();
}

class _EditJobInterviewState extends State<EditJobInterview> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();

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

  String? requirement;
  String? benefit;

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

    print(CompanyStorage.pageId);

    setDefaultValuesOfSalary();
    _companyNameController.text = InterviewFormStorage.companyName!;
    _jobLocationController.text = InterviewFormStorage.jobLocation!;
    _maxSalaryController.text = InterviewFormStorage.salaryRangeMax!;
    _minSalaryController.text = InterviewFormStorage.salaryRangeMin!;
    _jobTitleController.text = InterviewFormStorage.jobTitle!;
    _jobDescriptionController.text = InterviewFormStorage.description!;

    _interviewMessage.text = InterviewFormStorage.interviewMessage!;
    _interviewLocation.text = InterviewFormStorage.interviewVenue!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditHintText(
                            hintText: "Company Name",
                          ),
                        ),
                        ResumeInput(
                          controller: _companyNameController,
                          labelText: "Enter Company Name",
                          hintText: "Rex Tech Global",
                          action: (value) {},
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: EditHintText(
                            hintText: "Job Location",
                          ),
                        ),
                        ResumeInput(
                          controller: _jobLocationController,
                          labelText: "Enter Job Location",
                          hintText: "Germany",
                          action: (value) {},
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                          child: EditHintText(
                            hintText: "Job Title",
                          ),
                        ),
                        ResumeInput(
                          controller: _jobTitleController,
                          labelText: "Enter Job Title",
                          hintText: "Software Engineer",
                          action: (value) {},
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                          child: EditHintText(
                            hintText: "Job Summary",
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
                                    controller: _jobDescriptionController,
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
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: EditHintText(
                            hintText: "Salary Range",
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
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          style: kMSearchDrawerTextStyle,
                                          keyboardType: TextInputType.number,
                                          focusNode: _minPriceFocusNode,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kMarketPrimaryColor),
                                            ),
                                            hintText: 'MIN',
                                            hintStyle: kMSearchDrawerTextStyle,
                                          ),
                                          onSubmitted: (value) {
                                            _minPriceFocusNode.unfocus();
                                            FocusScope.of(context).requestFocus(
                                                _maxPriceFocusNode);
                                          },
                                          onChanged: (value) {
                                            if (value == null || value == '') {
                                              setState(() {
                                                _lowPriceRange =
                                                    minRangeSliderValue;
                                              });
                                            } else if (double.parse(value) <=
                                                    maxRangeSliderValue &&
                                                double.parse(value) >=
                                                    minRangeSliderValue &&
                                                double.parse(value) <=
                                                    _highPriceRange) {
                                              setState(() {
                                                _lowPriceRange =
                                                    double.parse(value);
                                              });
                                            } else {
                                              setState(() {
                                                _lowPriceRange =
                                                    minRangeSliderValue;
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
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          style: kMSearchDrawerTextStyle,
                                          keyboardType: TextInputType.number,
                                          focusNode: _maxPriceFocusNode,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kMarketPrimaryColor),
                                            ),
                                            hintText: 'MAX',
                                            hintStyle: kMSearchDrawerTextStyle,
                                            errorText: isMaxValid
                                                ? null
                                                : 'Shit not working',
                                          ),
                                          onSubmitted: (value) {
                                            _maxPriceFocusNode.unfocus();
                                          },
                                          onChanged: (value) {
                                            if (value == null || value == '') {
                                              setState(() {
                                                _highPriceRange =
                                                    maxRangeSliderValue;
                                              });
                                            } else if (double.parse(value) <=
                                                    maxRangeSliderValue &&
                                                double.parse(value) >=
                                                    minRangeSliderValue &&
                                                double.parse(value) >=
                                                    _lowPriceRange) {
                                              setState(() {
                                                _highPriceRange =
                                                    double.parse(value);
                                              });
                                            } else {
                                              setState(() {
                                                _highPriceRange =
                                                    maxRangeSliderValue;
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: RangeSlider(
                                  activeColor: kMarketSecondaryColor,
                                  inactiveColor: Color(0xffB9BEC5),
                                  values: RangeValues(
                                      _lowPriceRange, _highPriceRange),
                                  divisions: 50,
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _lowPriceRange =
                                          values.start.roundToDouble();
                                      _highPriceRange =
                                          values.end.roundToDouble();
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
                      ],
                    ),

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
                                  i <
                                      InterviewFormStorage
                                          .jobRequirement!.length;
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
                                                    fontSize: ScreenUtil()
                                                        .setSp(15.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                              children: <
                                                                  Widget>[
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
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              ///validate for empty data.
                                                                              if (_requirementControllerEdit.text == '') {
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
                                          ),
                                          Expanded(
                                            child: Padding(
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
                                                                          "${i + 1}.${InterviewFormStorage.jobRequirement![i]} ",
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
                                                                                InterviewFormStorage.jobRequirement!.remove(InterviewFormStorage.jobRequirement![i]);
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
                                                    fontSize: ScreenUtil()
                                                        .setSp(15.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                              children: <
                                                                  Widget>[
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
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              ///validate for empty data.
                                                                              if (_benefitControllerEdit.text == '') {
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
                                          ),
                                          Expanded(
                                            child: Padding(
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
                                                                          "${i + 1}.${InterviewFormStorage.jobBenefit![i]} ",
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
                                                                                InterviewFormStorage.jobBenefit!.remove(InterviewFormStorage.jobBenefit![i]);
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                            .elementAt(
                                                                i)['role'];
                                                    _nameOfContactControllerEdit
                                                            .text =
                                                        InterviewFormStorage
                                                            .contactPerson!
                                                            .elementAt(
                                                                i)['name'];
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
                                                                    child:
                                                                        Column(
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
                                                                              onTap: () {
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
                                                                              child: Container(
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
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
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
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            'Are You Sure You Want To Delete',
                                                                            style:
                                                                                GoogleFonts.rajdhani(
                                                                              textStyle: TextStyle(fontSize: ScreenUtil().setSp(18.0), fontWeight: FontWeight.bold, color: Colors.red),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "Contact Person ${i + 1}",
                                                                            style:
                                                                                GoogleFonts.rajdhani(
                                                                              textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  InterviewFormStorage.contactPerson!.remove(InterviewFormStorage.contactPerson!.elementAt(i));
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
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
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
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

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //widget.tabController.animateTo(0);
                            },
                            color: kLight_orange,
                            textColor: Colors.white,
                            child: Text("Back"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              updateInterviewRequest();
                            },
                            color: kLight_orange,
                            textColor: Colors.white,
                            child: Text("Update"),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  bool? showSpinner;

  void updateInterviewRequest() {
    setState(() {
      showSpinner = true;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('interviewRequest')
        .doc(UserStorage.loggedInUser.uid)
        .collection('companyInterviewsPages')
        .doc(CompanyStorage.pageId)
        .collection('companyInterviewDetails')
        .doc(InterviewFormStorage.interviewId);
    documentReference.update({
      'cid': CompanyStorage.pageId,
      'cnm': _companyNameController.text,
      'jbt': InterviewFormStorage.jobBenefit,
      'ims': _interviewMessage.text,
      'jdt': _jobDescriptionController.text,
      'jtl': _jobTitleController.text,
      'cpd': InterviewFormStorage.contactPerson,
      'jlt': _jobLocationController.text,
      'jrm': InterviewFormStorage.jobRequirement,
      'ivn': _interviewLocation.text,
      'jtm': DateTime.now().toString(),
      'srn': _minSalaryController.text,
      'srx': _maxSalaryController.text,
      'user': UserStorage.loggedInUser.email,
      'mainId': UserStorage.loggedInUser.uid,
      'id': documentReference.id,
      'time': DateTime.now()
    });
    Fluttertoast.showToast(
        msg: "Interview Request updated Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white);

    setState(() {
      showSpinner = false;
    });
    Navigator.pop(context);
  }
}
