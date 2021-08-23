import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/company/createJobs/finalScreen.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class CreateJobsScreenSix extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateJobsScreenSix({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateJobsScreenSixState createState() => _CreateJobsScreenSixState();
}

class _CreateJobsScreenSixState extends State<CreateJobsScreenSix> {
  bool showSpinner = false;
  String? benefit;
  int _count = PostJobFormStorage.jobBenefit!.length;
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
      _addData(_benefitController.text, PostJobFormStorage.jobBenefit);
      benefit = null;
      _benefitController.clear();
    }
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _benefitController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
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
                Logo(),
                //ToDo:company details
                SchoolConstants(
                    details: "${PostJobFormStorage.companyName} POST JOB"),

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
                                i < PostJobFormStorage.jobBenefit!.length;
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
                                            "${i + 1}. ${PostJobFormStorage.jobBenefit![i]} ",
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
                                                    PostJobFormStorage
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
                                                                              Fluttertoast.showToast(msg: "jobBenefit field is empty", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white);
                                                                            } else {
                                                                              //pass data to the main controller
                                                                              setState(() {
                                                                                PostJobFormStorage.jobBenefit![i] = _jobBenefitControllerEdit.text;
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
                                                                        "${i + 1}.${PostJobFormStorage.jobBenefit![i]} ",
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
                                                                              PostJobFormStorage.jobBenefit!.remove(PostJobFormStorage.jobBenefit![i]);
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
                      publish();
                    },
                    color: kLight_orange,
                    textColor: Colors.white,
                    child: Text(
                      "Publish",
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(22.0),
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: Indicator(
                    nextBtn: () {
                      publish();
                    },
                    percent: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }

  List<String> searchKeyWords() {
    List<String> result = [];

    HashSet<String> sWords = new HashSet<String>();

    String jobTitle = PostJobFormStorage.jobTitle!;
    String location = PostJobFormStorage.jobLocation!;
    String duration = PostJobFormStorage.jobCategory!;
    String jobType = PostJobFormStorage.jobType!;
    String companyName = PostJobFormStorage.companyName!;

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

  void publish() {
    if (PostJobFormStorage.jobBenefit!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Job qualification is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      List<String> search = searchKeyWords();

      String status = "open";
      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('jobs')
          .doc(PostJobFormStorage.mainCompanyId)
          .collection('companyJobs')
          .doc();
      documentReference.set({
        'cid': PostJobFormStorage.companyId,
        'cnm': PostJobFormStorage.companyName,
        'jbt': PostJobFormStorage.jobBenefit,
        'jcg': PostJobFormStorage.jobCategory,
        'skl': PostJobFormStorage.skills,
        'jrSt': PostJobFormStorage.responsibility,
        'jlt': PostJobFormStorage.jobLocation,
        'jqt': PostJobFormStorage.jobQualification,
        'sum': PostJobFormStorage.jobSummary,
        'jtl': PostJobFormStorage.jobTitle,
        'jtp': PostJobFormStorage.jobType,
        'jtm': DateTime.now().toString(),
        'status': status,
        'search': search,
        'lur': PostJobFormStorage.logoUrl,
        'srn': PostJobFormStorage.salaryRangeMin,
        'srx': PostJobFormStorage.salaryRangeMax,
        'user': UserStorage.loggedInUser.email,
        'mainId': PostJobFormStorage.mainCompanyId,
        'id': documentReference.id,
        'time': DateTime.now()
      });
      Fluttertoast.showToast(
          msg: "Job Published Successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);

      setState(() {
        showSpinner = false;
      });
      PostJobFormStorage.mainCompanyId = null;
      PostJobFormStorage.companyId = null;
      PostJobFormStorage.companyName = null;
      PostJobFormStorage.jobTitle = null;
      PostJobFormStorage.jobLocation = null;
      PostJobFormStorage.jobCategory = null;
      PostJobFormStorage.jobSummary = null;
      PostJobFormStorage.responsibility = [];
      PostJobFormStorage.jobQualification = [];
      PostJobFormStorage.salaryRangeMin = null;
      PostJobFormStorage.salaryRangeMax = null;
      PostJobFormStorage.skills = [];
      PostJobFormStorage.jobType = null;
      PostJobFormStorage.jobBenefit = [];
      PostJobFormStorage.logoUrl = null;

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FinalScreen()));
    }
  }
}
