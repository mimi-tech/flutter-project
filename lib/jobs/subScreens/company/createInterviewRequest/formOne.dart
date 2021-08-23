import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class InterviewFormOne extends StatefulWidget {
  const InterviewFormOne({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _InterviewFormOneState createState() => _InterviewFormOneState();
}

class _InterviewFormOneState extends State<InterviewFormOne> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();

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

  void validateAndStoreData() {
    if (_companyNameController.text == '') {
      Fluttertoast.showToast(
          msg: "name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "write job title",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "write job description",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_minSalaryController.text == '' &&
        _maxSalaryController.text == '') {
      Fluttertoast.showToast(
          msg: "enter salary range",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      InterviewFormStorage.salaryRangeMin = _minSalaryController.text;
      InterviewFormStorage.salaryRangeMax = _maxSalaryController.text;
      InterviewFormStorage.description = _jobDescriptionController.text;
      InterviewFormStorage.jobLocation = _jobLocationController.text;
      InterviewFormStorage.companyName = _companyNameController.text;
      InterviewFormStorage.jobTitle = _jobTitleController.text;
      widget.tabController!.animateTo(1);
    }
  }

  @override
  void initState() {
    super.initState();
    setDefaultValuesOfSalary();
    _companyNameController.text = InterviewFormStorage.companyName!;
    _jobLocationController.text = InterviewFormStorage.jobLocation!;
    _maxSalaryController.text = InterviewFormStorage.salaryRangeMax!;
    _minSalaryController.text = InterviewFormStorage.salaryRangeMin!;
    _jobTitleController.text = InterviewFormStorage.jobTitle!;
    _jobDescriptionController.text = InterviewFormStorage.description!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _companyNameController.dispose();
    _jobLocationController.dispose();
    _maxSalaryController.dispose();
    _minSalaryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
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
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
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
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: EditHintText(
                        hintText: "Job Summary",
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
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
                                        FilteringTextInputFormatter.digitsOnly
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
                                        FocusScope.of(context)
                                            .requestFocus(_maxPriceFocusNode);
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
                                        FilteringTextInputFormatter.digitsOnly
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RangeSlider(
                              activeColor: kMarketSecondaryColor,
                              inactiveColor: Color(0xffB9BEC5),
                              values:
                                  RangeValues(_lowPriceRange, _highPriceRange),
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
                            child: Text("Back To Home"),
                          ),
                          RaisedButton(
                            onPressed: () {
                              validateAndStoreData();
                            },
                            color: kLight_orange,
                            textColor: Colors.white,
                            child: Text("next"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
