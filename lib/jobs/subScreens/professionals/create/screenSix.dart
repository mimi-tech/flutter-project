import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenSeven.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenSix extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenSix({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenSixState createState() =>
      _CreateProfessionalScreenSixState();
}

class _CreateProfessionalScreenSixState
    extends State<CreateProfessionalScreenSix> {
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _schoolLocationController =
      TextEditingController();
  final TextEditingController _schoolStartController = TextEditingController();
  final TextEditingController _schoolEndController = TextEditingController();
  final TextEditingController _schoolDecreeController = TextEditingController();
  final TextEditingController _courseOfStudyController =
      TextEditingController();

  List<Widget> showEducationInput = [];
  List<Widget> educationDisplay = [];
  var listEducation = [];
  int count = 0;

  String? educationAnswerGroupValue = ProfessionalStorage.hasEducation;
  void educationChangeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        educationAnswerGroupValue = "yes";
        ProfessionalStorage.hasEducation = "yes";
        showEducationForm();
      });
    } else if (value == "no") {
      setState(() {
        educationAnswerGroupValue = "no";
        ProfessionalStorage.hasEducation = "no";
        showEducationInput = [];
        educationDisplay = [];
        count = 0;
        ProfessionalStorage.education = [];
      });
    }
  }

  void displayAll() {
    if (ProfessionalStorage.hasEducation == "yes") {
      print(ProfessionalStorage.education);
      listEducation = ProfessionalStorage.education;
      showEducationForm();
      displayEducation();
    }
  }

  void displayEducation() {
    for (var item in listEducation) {
      setState(() {
        count++;
        educationDisplay.add(Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  Text(
                    "Education $count",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(20.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['schoolName'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['schoolLocation'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['certification'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['course'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['start'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 10.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['end'],
                        softWrap: true,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
      });

      /// The line of code below is very very very important. Please don't remove
      listEducation = [];
    }
  }

  void showEducationForm() {
    setState(() {
      showEducationInput.add(
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: HintText(
              hintText: "Wonderful! Tell us about it.",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _schoolNameController,
                      labelText: "Enter your school name",
                      hintText: "St Peter Clever Seminary",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _schoolLocationController,
                      labelText: "Enter Location",
                      hintText: "Nigeria",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _schoolStartController,
                      labelText: "Enter Start Date",
                      hintText: "6th January 2008",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _schoolEndController,
                      labelText: "Enter End Date Or Present",
                      hintText: "Present",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _schoolDecreeController,
                      labelText: "Certification",
                      hintText: "BSC",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _courseOfStudyController,
                      labelText: "Course Of Study",
                      hintText: "Computer Science",
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              _addEducation();
            },
            child: Text("Add"),
            color: Colors.white,
            textColor: Colors.black,
          ),
        ]),
      );
    });
  }

  void _addEducation() {
    //TODO: validate user input
    if (_schoolNameController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolStartController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolEndController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolDecreeController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_courseOfStudyController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var education = {
        "schoolName":
            ReusableFunctions.capitalizeWords(_schoolNameController.text),
        "schoolLocation":
            ReusableFunctions.capitalizeWords(_schoolLocationController.text),
        "certification":
            ReusableFunctions.capitalizeWords(_schoolDecreeController.text),
        "course":
            ReusableFunctions.capitalizeWords(_courseOfStudyController.text),
        "start": _schoolStartController.text,
        "end": _schoolEndController.text,
      };

      //TODO: add the object to the list
      ProfessionalStorage.education.add(education);
      listEducation.add(education);
      //TODO: clear the content of the text controllers
      education = {};
      _schoolNameController.clear();
      _schoolDecreeController.clear();
      _courseOfStudyController.clear();
      _schoolEndController.clear();
      _schoolStartController.clear();
      _schoolLocationController.clear();
//TODO: display the data in the list of maps
      displayEducation();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayAll();
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak

    _schoolNameController.dispose();
    _schoolEndController.dispose();
    _schoolStartController.dispose();
    _schoolLocationController.dispose();
    _schoolDecreeController.dispose();
    _courseOfStudyController.dispose();

    listEducation = [];
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
              Logo(),
              //ToDo:company details
              SchoolConstants(
                  details:
                      "You are doing great ${GlobalVariables.loggedInUserObject.nm!["fn"]}"),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Any Education History?",
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 0.0),
                child: Card(
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
                                      value: "yes",
                                      groupValue: educationAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          educationChangeAnswerTypeState(val),
                                    ),
                                    Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Radio(
                                      value: "no",
                                      groupValue: educationAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          educationChangeAnswerTypeState(val),
                                    ),
                                    Text(
                                      'No',
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
              ),

              Container(
                  margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                  child: Column(
                    children: educationDisplay,
                  )),

              Column(
                children: showEducationInput,
              ),

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateProfessionalScreenSeven()));
  }
}
