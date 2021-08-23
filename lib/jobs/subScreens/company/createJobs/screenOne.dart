import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/company/constants.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/jobs/subScreens/company/createJobs/screenTwo.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CreateJobsScreenOne extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateJobsScreenOne({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateJobsScreenOneState createState() => _CreateJobsScreenOneState();
}

class _CreateJobsScreenOneState extends State<CreateJobsScreenOne> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobSummaryController = TextEditingController();

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _jobTitleController.dispose();
    _jobLocationController.dispose();
    _jobSummaryController.dispose();

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
        child: Column(
          children: <Widget>[
            //ToDo: The arrow for going back
            Logo(),
            //ToDo:company details
            SchoolConstants(
                details: "${PostJobFormStorage.companyName} POST JOB"),

            //ToDo:hint text
            HintText(
              hintText: "Job title",
            ),
            //ToDo:company details

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: kHorizontal, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    controller: _jobTitleController,
                    cursorColor: kComplinecolor,
                    style: Constants.textStyle,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: Constants.companyDecoration,
                  ),
                ],
              ),
            ),

            HintText(
              hintText: "Job Location",
            ),
            //ToDo:company details

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: kHorizontal, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    controller: _jobLocationController,
                    cursorColor: kComplinecolor,
                    style: Constants.textStyle,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: Constants.companyDecoration,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: HintText(
                hintText: "Job Summary",
              ),
            ),
            //ToDo:company details

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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

            //ToDo: Company btn
            Indicator(
              nextBtn: () {
                goToNext();
              },
              percent: 0.2,
            ),
          ],
        ),
      ),
    )));
  }

  void goToNext() {
    if (_jobTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "Job title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "Location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobSummaryController.text == '') {
      Fluttertoast.showToast(
          msg: "Please write a short summary",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      PostJobFormStorage.jobTitle =
          ReusableFunctions.capitalizeWords(_jobTitleController.text);
      PostJobFormStorage.jobLocation =
          ReusableFunctions.capitalizeWords(_jobLocationController.text);
      PostJobFormStorage.jobSummary = _jobSummaryController.text;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreateJobsScreenTwo()));
    }
  }
}
