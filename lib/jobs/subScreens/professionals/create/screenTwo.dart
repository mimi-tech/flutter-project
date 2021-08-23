import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenThree.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenTwo extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenTwo({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenTwoState createState() =>
      _CreateProfessionalScreenTwoState();
}

class _CreateProfessionalScreenTwoState
    extends State<CreateProfessionalScreenTwo> {
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();

  List<Widget> showProjectInput = [];
  List<Widget> projectDisplay = [];
  int count = 0;

  var listProjects = [];

  void displayAll() {
    if (ProfessionalStorage.hasDoneProject == "yes") {
      listProjects = ProfessionalStorage.projects;
      showProjectForm();
      displayProjects();
    }
  }

  String? answerGroupValue = ProfessionalStorage.hasDoneProject;
  void changeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        answerGroupValue = "yes";
        ProfessionalStorage.hasDoneProject = "yes";
        showProjectForm();
      });
    } else if (value == "no") {
      setState(() {
        answerGroupValue = "no";
        ProfessionalStorage.hasDoneProject = "no";
        showProjectInput = [];
        projectDisplay = [];
        count = 0;
        ProfessionalStorage.projects = [];
      });
    }
  }

  void displayProjects() {
    for (var item in listProjects) {
      setState(() {
        count++;
        projectDisplay.add(Column(
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
                    "Project $count",
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
                        item['title'],
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
                        item['description'],
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
      listProjects = [];
    }
  }

  void showProjectForm() {
    setState(() {
      showProjectInput.add(
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: HintText(
              hintText: "Awesome! Tell us about the project.",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Container(
                    child: ResumeInput(
                      controller: _projectTitleController,
                      labelText: "Tell us the name of the project.",
                      hintText: "Software Management",
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
                      controller: _projectDescriptionController,
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kLight_orange, width: 1.0),
                          ),
                          hintText: "Tell us more about this project"),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _addProject();
                  },
                  child: Text("Add"),
                  color: Colors.white,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }

  void _addProject() {
    //TODO: validate user input
    if (_projectTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_projectDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "description field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var projects = {
        "title":
            ReusableFunctions.capitalizeWords(_projectTitleController.text),
        "description": _projectDescriptionController.text,
      };

      //TODO: add the object to the list
      ProfessionalStorage.projects.add(projects);
      listProjects.add(projects);
      //TODO: clear the content of the text controllers
      projects = {};
      _projectTitleController.clear();
      _projectDescriptionController.clear();

//TODO: display the data in the list of maps
      displayProjects();
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
    _projectTitleController.dispose();
    _projectDescriptionController.dispose();
    listProjects = [];

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

              //ToDo:hint text

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: HintText(
                  hintText: "Have you done or engaged in any project?",
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
                                      groupValue: answerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          changeAnswerTypeState(val),
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
                                      groupValue: answerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          changeAnswerTypeState(val),
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
                    children: projectDisplay,
                  )),
              Column(
                children: showProjectInput,
              ),

              //ToDo: Company btn
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Indicator(
                  nextBtn: () {
                    goToNext();
                  },
                  percent: 0.2,
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
        builder: (context) => CreateProfessionalScreenThree()));
  }
}
