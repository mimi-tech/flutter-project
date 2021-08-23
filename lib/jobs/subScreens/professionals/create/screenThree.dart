import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenFour.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenThree extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenThree({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenThreeState createState() =>
      _CreateProfessionalScreenThreeState();
}

class _CreateProfessionalScreenThreeState
    extends State<CreateProfessionalScreenThree> {
  final TextEditingController _awardTitleController = TextEditingController();
  final TextEditingController _awardDescriptionController =
      TextEditingController();

  List<Widget> showAwardInput = [];
  List<Widget> awardDisplay = [];
  int count = 0;
  var listAwards = [];

  String? awardAnswerGroupValue = ProfessionalStorage.hasReceivedAward;
  void awardChangeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        awardAnswerGroupValue = "yes";
        ProfessionalStorage.hasReceivedAward = "yes";
        showAwardForm();
      });
    } else if (value == "no") {
      setState(() {
        awardAnswerGroupValue = "no";
        ProfessionalStorage.hasReceivedAward = "no";
        showAwardInput = [];
        awardDisplay = [];
        count = 0;
        ProfessionalStorage.award = [];
      });
    }
  }

  void displayAll() {
    if (ProfessionalStorage.hasReceivedAward == "yes") {
      print(ProfessionalStorage.award);
      listAwards = ProfessionalStorage.award;
      showAwardForm();
      displayAwards();
    }
  }

  void displayAwards() {
    for (var item in listAwards) {
      setState(() {
        count++;
        awardDisplay.add(Column(
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
                    "Awards $count",
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
      listAwards = [];
    }
  }

  void showAwardForm() {
    setState(() {
      showAwardInput.add(
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
                      controller: _awardTitleController,
                      labelText: "Enter Award Title",
                      hintText: "Lead GDG",
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
                      controller: _awardDescriptionController,
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: kLight_orange, width: 1.0),
                          ),
                          hintText: "Tell us more about this award"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              _addAward();
            },
            child: Text("Add"),
            color: Colors.white,
            textColor: Colors.black,
          ),
        ]),
      );
    });
  }

  void _addAward() {
    //TODO: validate user input
    if (_awardTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_awardDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "description field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var awards = {
        "title": ReusableFunctions.capitalizeWords(_awardTitleController.text),
        "description": _awardDescriptionController.text,
      };

      //TODO: add the object to the list
      ProfessionalStorage.award.add(awards);
      listAwards.add(awards);
      //TODO: clear the content of the text controllers
      awards = {};
      _awardTitleController.clear();
      _awardDescriptionController.clear();

//TODO: display the data in the list of maps
      displayAwards();
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

    _awardTitleController.dispose();
    _awardDescriptionController.dispose();
    listAwards = [];
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
                  hintText: "Have you received any professional award?",
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
                                      groupValue: awardAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          awardChangeAnswerTypeState(val),
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
                                      groupValue: awardAnswerGroupValue,
                                      activeColor: Colors.red,
                                      onChanged: (dynamic val) =>
                                          awardChangeAnswerTypeState(val),
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
                    children: awardDisplay,
                  )),

              Column(
                children: showAwardInput,
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateProfessionalScreenFour()));
  }
}
