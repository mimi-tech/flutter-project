import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenSix.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenFive extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenFive({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenFiveState createState() =>
      _CreateProfessionalScreenFiveState();
}

class _CreateProfessionalScreenFiveState
    extends State<CreateProfessionalScreenFive> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobStartController = TextEditingController();
  final TextEditingController _jobEndController = TextEditingController();

  List<Widget> showExperienceInput = [];
  List<Widget> experienceDisplay = [];
  int count = 0;
  var listExperience = [];

  String? experienceAnswerGroupValue = ProfessionalStorage.hasExperience;
  void experienceChangeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        experienceAnswerGroupValue = "yes";
        ProfessionalStorage.hasExperience = "yes";
        showExperienceForm();
      });
    } else if (value == "no") {
      setState(() {
        experienceAnswerGroupValue = "no";
        ProfessionalStorage.hasExperience = "no";
        showExperienceInput = [];
        experienceDisplay = [];
        count = 0;
        ProfessionalStorage.experience = [];
      });
    }
  }

  void displayAll() {
    if (ProfessionalStorage.hasExperience == "yes") {
      print(ProfessionalStorage.experience);
      listExperience = ProfessionalStorage.experience;
      showExperienceForm();
      displayExperience();
    }
  }

  void displayExperience() {
    for (var item in listExperience) {
      setState(() {
        count++;
        experienceDisplay.add(Column(
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
                    "Experience $count",
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
                      Icons.format_list_bulleted,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item["companyName"],
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
                        item['jobRole'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        item['jobLocation'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        item['jobDescription'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
      listExperience = [];
    }
  }

  void showExperienceForm() {
    setState(() {
      showExperienceInput.add(
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
                      controller: _companyNameController,
                      labelText: "Enter the company name",
                      hintText: "Google",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _jobRoleController,
                      labelText: "Enter Your Role",
                      hintText: "Lead GDG",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _jobLocationController,
                      labelText: "Enter Location",
                      hintText: "Nigeria",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _jobStartController,
                      labelText: "Enter Start Date",
                      hintText: "6th January 2008",
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _jobEndController,
                      labelText: "Enter End Date Or Present",
                      hintText: "Present",
                    ),
                  ),
                ),
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
                            borderSide:
                                BorderSide(color: kLight_orange, width: 1.0),
                          ),
                          hintText: "Tell us more about this experience"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              _addExperience();
            },
            child: Text("Add"),
            color: Colors.white,
            textColor: Colors.black,
          ),
        ]),
      );
    });
  }

  void _addExperience() {
    //TODO: validate user input
    if (_companyNameController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobRoleController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobStartController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobEndController.text == '') {
      Fluttertoast.showToast(
          msg: "field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var experience = {
        "companyName":
            ReusableFunctions.capitalizeWords(_companyNameController.text),
        "jobRole": ReusableFunctions.capitalizeWords(_jobRoleController.text),
        "jobLocation":
            ReusableFunctions.capitalizeWords(_jobLocationController.text),
        "start": _jobStartController.text,
        "end": _jobEndController.text,
        "jobDescription": _jobDescriptionController.text,
      };

      //TODO: add the object to the list
      ProfessionalStorage.experience.add(experience);
      listExperience.add(experience);
      //TODO: clear the content of the text controllers
      experience = {};
      _companyNameController.clear();
      _jobRoleController.clear();
      _jobDescriptionController.clear();
      _jobEndController.clear();
      _jobStartController.clear();
      _jobLocationController.clear();
//TODO: display the data in the list of maps
      displayExperience();
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

    _companyNameController.dispose();
    _jobRoleController.dispose();
    _jobDescriptionController.dispose();
    _jobEndController.dispose();
    _jobStartController.dispose();
    _jobLocationController.dispose();

    listExperience = [];
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
                  hintText: "Do you have any work experience?",
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
                                      groupValue: experienceAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          experienceChangeAnswerTypeState(val),
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
                                      groupValue: experienceAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          experienceChangeAnswerTypeState(val),
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
                    children: experienceDisplay,
                  )),

              Column(
                children: showExperienceInput,
              ),

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    print(ProfessionalStorage.hasExperience);
    print(ProfessionalStorage.experience);

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CreateProfessionalScreenSix()));
  }
}
