import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenFive.dart';

class CreateProfessionalScreenFour extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenFour({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenFourState createState() =>
      _CreateProfessionalScreenFourState();
}

class _CreateProfessionalScreenFourState
    extends State<CreateProfessionalScreenFour> {
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();

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

  String? groupValue = ProfessionalStorage.jobCategory;
  String? jobTypeGroupValue = ProfessionalStorage.jobType;

  String? statusAnswerGroupValue = ProfessionalStorage.status;
  void statusChangeAnswerTypeState(value) {
    if (value == "available") {
      setState(() {
        statusAnswerGroupValue = "available";
        ProfessionalStorage.status = "available";
      });
    } else if (value == "notAvailable") {
      setState(() {
        statusAnswerGroupValue = "notAvailable";
        ProfessionalStorage.status = "not available";
      });
    }
  }

  void changeJobTypeState(value) {
    if (value == "In-Person") {
      setState(() {
        jobTypeGroupValue = "In-Person";
        ProfessionalStorage.jobType = "in person";
      });
    } else if (value == "Remote") {
      setState(() {
        jobTypeGroupValue = "Remote";
        ProfessionalStorage.jobType = "remote";
      });
    }
  }

  void changeCategoryState(value) {
    if (value == "Full-Time") {
      setState(() {
        groupValue = "Full-Time";
        ProfessionalStorage.jobCategory = "full time";
      });
    } else if (value == "Part-Time") {
      setState(() {
        groupValue = "Part-Time";
        ProfessionalStorage.jobCategory = "part time";
      });
    } else if (value == "Contract") {
      setState(() {
        groupValue = "Contract";
        ProfessionalStorage.jobCategory = "contract";
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
    statusAnswerGroupValue = ProfessionalStorage.status;
    _minSalaryController =
        TextEditingController(text: ProfessionalStorage.salaryRangeMin);
    _maxSalaryController =
        TextEditingController(text: ProfessionalStorage.salaryRangeMax);
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _minSalaryController.dispose();
    _maxSalaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/company/sparksbg.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //ToDo: The arrow for going back
              Logo(),
              //ToDo:company details
              SchoolConstants(
                  details:
                      "You are doing great ${GlobalVariables.loggedInUserObject.nm!["fn"]}"),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Employment Status?",
                ),
              ),

              Card(
                elevation: 4,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "available",
                                    groupValue: statusAnswerGroupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) =>
                                        statusChangeAnswerTypeState(val),
                                  ),
                                  Text(
                                    'Available',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "notAvailable",
                                    groupValue: statusAnswerGroupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) =>
                                        statusChangeAnswerTypeState(val),
                                  ),
                                  Text(
                                    'Not Available',
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
                child: HintText(
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
                                      value: 'Full-Time',
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
                                      value: 'Part-Time',
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
                                    value: 'Contract',
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
                child: HintText(
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
                                    value: "In-Person",
                                    groupValue: jobTypeGroupValue,
                                    activeColor: Colors.red,
                                    onChanged: (dynamic val) => changeJobTypeState(val),
                                  ),
                                  Text(
                                    'In-Person',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: "Remote",
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
                child: HintText(
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

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (_minSalaryController.text == '' && _maxSalaryController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter Salary Range",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      ProfessionalStorage.salaryRangeMin = _minSalaryController.text;
      ProfessionalStorage.salaryRangeMax = _maxSalaryController.text;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateProfessionalScreenFive()));
    }
  }
}
