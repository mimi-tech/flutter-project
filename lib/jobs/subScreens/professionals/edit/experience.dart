import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class EditExperience extends StatefulWidget {
  @override
  _EditExperienceState createState() => _EditExperienceState();
}

class _EditExperienceState extends State<EditExperience> {
  final TextEditingController _aboutMeController = TextEditingController();

  //TODO: for experience controller
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  //TODO: for edit  experience controller
  final TextEditingController _companyControllerEdit = TextEditingController();
  final TextEditingController _jobRoleControllerEdit = TextEditingController();
  final TextEditingController _jobDescriptionControllerEdit =
      TextEditingController();
  final TextEditingController _jobLocationControllerEdit =
      TextEditingController();
  final TextEditingController _startDateControllerEdit =
      TextEditingController();
  final TextEditingController _endDateControllerEdit = TextEditingController();

  // for project controller
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectTitleControllerEdit =
      TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  final TextEditingController _projectDescriptionControllerEdit =
      TextEditingController();

  // for award controller
  final TextEditingController _awardTitleController = TextEditingController();
  final TextEditingController _awardTitleControllerEdit =
      TextEditingController();
  final TextEditingController _awardDescriptionController =
      TextEditingController();
  final TextEditingController _awardDescriptionControllerEdit =
      TextEditingController();

  //TODO: for  edit education controller
  final TextEditingController _schoolNameControllerEdit =
      TextEditingController();
  final TextEditingController _schoolLocationControllerEdit =
      TextEditingController();
  final TextEditingController _schoolStartDateControllerEdit =
      TextEditingController();
  final TextEditingController _schoolEndDateControllerEdit =
      TextEditingController();
  final TextEditingController _certificationControllerEdit =
      TextEditingController();
  final TextEditingController _courseControllerEdit = TextEditingController();

  //TODO: for education controller
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _certificationController =
      TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _schoolLocationController =
      TextEditingController();
  final TextEditingController _schoolStartDateController =
      TextEditingController();
  final TextEditingController _schoolEndDateController =
      TextEditingController();

  String? name;

  /// For Skills and Hobby
  String? skills;
  String? hobbies;
  final TextEditingController _skillsController = TextEditingController();

  // for edit skill
  final TextEditingController _skillsControllerEdit = TextEditingController();

  //for hobbies edit
  final TextEditingController _hobbiesControllerEdit = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  _addData(data, list) {
    setState(() {
      if (data != null) {
        list.add(data);
      } else {
        Fluttertoast.showToast(
            msg: "Please fill the empty space",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });
  }

  List<dynamic>? skillList = [];
  void _addSkillRow() {
    _addData(
        ReusableFunctions.capitalizeWords(_skillsController.text), skillList);
    skills = null;
    _skillsController.clear();
  }

  List<dynamic>? hobbyList = [];
  void _addHobbiesRow() {
    _addData(
        ReusableFunctions.capitalizeWords(_hobbiesController.text), hobbyList);
    hobbies = null;
    _hobbiesController.clear();
  }

  //For Experience

  List<dynamic>? experienceList = [];
  void _addExperience() {
    //TODO: validate user input
    if (_jobRoleController.text == '') {
      Fluttertoast.showToast(
          msg: "job role field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyController.text == '') {
      Fluttertoast.showToast(
          msg: "company name cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyController.text == '') {
      Fluttertoast.showToast(
          msg: "company name cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "job description field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_startDateController.text == '') {
      Fluttertoast.showToast(
          msg: "start date field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_endDateController.text == '') {
      Fluttertoast.showToast(
          msg: "end date field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var experience = {
        "companyName":
            ReusableFunctions.capitalizeWords(_companyController.text),
        "jobRole": ReusableFunctions.capitalizeWords(_jobRoleController.text),
        "jobLocation":
            ReusableFunctions.capitalizeWords(_jobLocationController.text),
        "start": _startDateController.text,
        "end": _endDateController.text,
        "jobDescription": _jobDescriptionController.text,
      };

      //TODO: add the object to the list
      setState(() {
        experienceList!.add(experience);
        //TODO: clear the content of the text controllers
        experience = {};
        _jobRoleController.clear();
        _jobDescriptionController.clear();
        _companyController.clear();
        _jobLocationController.clear();
        _startDateController.clear();
        _endDateController.clear();
      });
    }
  }

// for Project
  List<dynamic>? projectList = [];
  void _addProject() {
    //TODO: validate user input
    if (_projectTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "job title field cannot be blank",
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
      var project = {
        "title":
            ReusableFunctions.capitalizeWords(_projectTitleController.text),
        "description": _projectDescriptionController.text,
      };

      //TODO: add the object to the list
      setState(() {
        projectList!.add(project);
        //TODO: clear the content of the text controllers
        project = {};
        _projectTitleController.clear();
        _projectDescriptionController.clear();
      });
    }
  }

  // for Project
  List<dynamic>? awardList = [];
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
      var award = {
        "title": ReusableFunctions.capitalizeWords(_awardTitleController.text),
        "description": _awardDescriptionController.text,
      };

      //TODO: add the object to the list
      setState(() {
        awardList!.add(award);
        //TODO: clear the content of the text controllers
        award = {};
        _awardTitleController.clear();
        _awardDescriptionController.clear();
      });
    }
  }

  // For Education

  List<dynamic>? educationList = [];
  void _addEducation() {
    //TODO: validate user input
    if (_schoolNameController.text == '') {
      Fluttertoast.showToast(
          msg: "school name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "school location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_certificationController.text == '') {
      Fluttertoast.showToast(
          msg: "certification field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_courseController.text == '') {
      Fluttertoast.showToast(
          msg: "course field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolStartDateController.text == '') {
      Fluttertoast.showToast(
          msg: "start date field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_schoolEndDateController.text == '') {
      Fluttertoast.showToast(
          msg: "end date field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var education = {
        "schoolName":
            ReusableFunctions.capitalizeWords(_schoolNameController.text),
        "certification":
            ReusableFunctions.capitalizeWords(_certificationController.text),
        "course": ReusableFunctions.capitalizeWords(_courseController.text),
        "schoolLocation":
            ReusableFunctions.capitalizeWords(_schoolLocationController.text),
        "start":
            ReusableFunctions.capitalizeWords(_schoolStartDateController.text),
        "end": ReusableFunctions.capitalizeWords(_schoolEndDateController.text),
      };

      //TODO: add the object to the list
      setState(() {
        educationList!.add(education);
        //TODO: clear the content of the text controllers
        education = {};
        _certificationController.clear();
        _courseController.clear();
        _schoolNameController.clear();
        _schoolLocationController.clear();
        _schoolStartDateController.clear();
        _schoolEndDateController.clear();
      });
    }
  }

  //for form validation and update
  bool showSpinner = false;
  void validateAndUpdate() {
    // if( _aboutMeController.text == ''){
    //   Fluttertoast.showToast(
    //       msg: "Please write about yourself",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }else if(EditProfessionalStorage.experience.isEmpty){
    //   Fluttertoast.showToast(
    //       msg: "Add at least one experience",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }else if(EditProfessionalStorage.education.isEmpty){
    //   Fluttertoast.showToast(
    //       msg: "Add at least one education",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }else if(EditProfessionalStorage.skills.isEmpty & EditProfessionalStorage.hobbies.isEmpty){
    //   Fluttertoast.showToast(
    //       msg: "Please fill the empty spaces",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }else{

    setState(() {
      showSpinner = true;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('professionals')
        .doc(EditProfessionalStorage.id);
    documentReference.update({
      "experience": experienceList,
      "projects": projectList,
      "awDs": awardList,
      "education": educationList,
      "hobbies": hobbyList,
      "skills": skillList,
      "abtMe": _aboutMeController.text,
    });
    setState(() {
      showSpinner = false;
    });
    Fluttertoast.showToast(
        msg: "Experience updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutMeController.text = EditProfessionalStorage.aboutMe!;
    experienceList = EditProfessionalStorage.experience;
    awardList = EditProfessionalStorage.award;
    projectList = EditProfessionalStorage.projects;
    educationList = EditProfessionalStorage.education;
    skillList = EditProfessionalStorage.skills;
    hobbyList = EditProfessionalStorage.hobbies;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _aboutMeController.dispose();
    _jobDescriptionController.dispose();
    _jobRoleController.dispose();
    _companyController.dispose();
    _jobLocationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _companyControllerEdit.dispose();
    _jobRoleControllerEdit.dispose();
    _jobDescriptionControllerEdit.dispose();
    _jobLocationControllerEdit.dispose();
    _startDateControllerEdit.dispose();
    _endDateControllerEdit.dispose();
    _projectTitleController.dispose();
    _projectTitleControllerEdit.dispose();
    _projectDescriptionController.dispose();
    _projectDescriptionControllerEdit.dispose();
    _awardTitleController.dispose();
    _awardTitleControllerEdit.dispose();
    _awardDescriptionController.dispose();
    _awardDescriptionControllerEdit.dispose();
    _schoolNameControllerEdit.dispose();
    _schoolLocationControllerEdit.dispose();
    _schoolStartDateControllerEdit.dispose();
    _schoolEndDateControllerEdit.dispose();
    _certificationControllerEdit.dispose();
    _courseControllerEdit.dispose();
    _schoolNameController.dispose();
    _certificationController.dispose();
    _courseController.dispose();
    _schoolLocationController.dispose();
    _schoolStartDateController.dispose();
    _schoolEndDateController.dispose();
    _skillsController.dispose();
    _skillsControllerEdit.dispose();
    _hobbiesControllerEdit.dispose();
    _hobbiesController.dispose();
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
            'EDIT JOB PROFILE',
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
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Icon(
                          Icons.find_replace,
                          color: kLight_orange,
                          size: 40.0,
                        ),
                      ),
                    ),
                    Text(
                      "EXPERIENCE EDIT",
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ResumeInput(
                  controller: _aboutMeController,
                  labelText: "Write about yourself",
                  hintText:
                      "I am a Software Engineer who is passionate about solving complex problems by Building technological solutions out of business needs",
                ),
              ),
//For experience
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Add Work Experience",
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
                            for (var i = 0; i < experienceList!.length; i++)
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
                                              Icons.find_replace,
                                              color: kLight_orange,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Work Experience ${i + 1}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _companyControllerEdit.text =
                                                  experienceList!.elementAt(
                                                      i)['companyName'];
                                              _jobDescriptionControllerEdit
                                                      .text =
                                                  experienceList!.elementAt(
                                                      i)['jobDescription'];
                                              _jobRoleControllerEdit.text =
                                                  experienceList!
                                                      .elementAt(i)['jobRole'];
                                              _jobLocationControllerEdit.text =
                                                  experienceList!.elementAt(
                                                      i)['jobLocation'];
                                              _startDateControllerEdit.text =
                                                  experienceList!
                                                      .elementAt(i)['start'];
                                              _endDateControllerEdit.text =
                                                  experienceList!
                                                      .elementAt(i)['end'];
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
                                                                          _companyControllerEdit,
                                                                      labelText:
                                                                          "enter company name",
                                                                      hintText:
                                                                          "Lead Engineer",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _jobRoleControllerEdit,
                                                                      labelText:
                                                                          "enter job role",
                                                                      hintText:
                                                                          "Lead Engineer",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            10,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              ScreenUtil().setHeight(180.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            maxLines:
                                                                                10,
                                                                            autofocus:
                                                                                true,
                                                                            controller:
                                                                                _jobDescriptionControllerEdit,
                                                                            decoration: new InputDecoration(
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: kLight_orange, width: 1.0),
                                                                                ),
                                                                                hintText: "Tell us more about this experience"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _jobLocationControllerEdit,
                                                                      labelText:
                                                                          "enter job location",
                                                                      hintText:
                                                                          "Canada Lab LLC",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _startDateControllerEdit,
                                                                      labelText:
                                                                          "Starting Date",
                                                                      hintText:
                                                                          "Sept 2017",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _endDateControllerEdit,
                                                                      labelText:
                                                                          "End Date",
                                                                      hintText:
                                                                          "Present",
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          ///validate for empty data.
                                                                          if (_jobRoleControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "job role field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_jobLocationControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "job location field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_companyControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "company name cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_jobDescriptionControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "job description field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_startDateControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "start date field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_endDateControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "end date field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              experienceList!.elementAt(i)['companyName'] = ReusableFunctions.capitalizeWords(_companyControllerEdit.text);
                                                                              experienceList!.elementAt(i)['jobDescription'] = ReusableFunctions.capitalizeWords(_jobDescriptionControllerEdit.text);
                                                                              experienceList!.elementAt(i)['jobRole'] = ReusableFunctions.capitalizeWords(_jobRoleControllerEdit.text);
                                                                              experienceList!.elementAt(i)['jobLocation'] = ReusableFunctions.capitalizeWords(_jobLocationControllerEdit.text);
                                                                              experienceList!.elementAt(i)['start'] = ReusableFunctions.capitalizeWords(_startDateControllerEdit.text);
                                                                              experienceList!.elementAt(i)['end'] = ReusableFunctions.capitalizeWords(_endDateControllerEdit.text);
                                                                            });
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "ok"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                                                      "Experience ${i + 1}",
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
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            experienceList!.remove(experienceList!.elementAt(i));
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "yes"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                  DisplayExperienceEdit(
                                      experienceDetails: experienceList, i: i),
                                ],
                              ),
                          ],
                        )),
                    Container(
                      child: ResumeInput(
                        controller: _companyController,
                        labelText: "enter company name",
                        hintText: "Lead Engineer",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _jobRoleController,
                        labelText: "enter job role",
                        hintText: "Lead Engineer",
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
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
                                  hintText:
                                      "Tell us more about this experience"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _jobLocationController,
                        labelText: "enter job location",
                        hintText: "Canada Lab LLC",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _startDateController,
                        labelText: "Starting Date",
                        hintText: "Sept 2017",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _endDateController,
                        labelText: "End Date",
                        hintText: "Present",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addExperience();
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

              // for project edit

              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Add Projects",
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
                            for (var i = 0; i < projectList!.length; i++)
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
                                              Icons.find_replace,
                                              color: kLight_orange,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Project ${i + 1}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _projectTitleControllerEdit.text =
                                                  projectList!
                                                      .elementAt(i)['title'];
                                              _projectDescriptionControllerEdit
                                                      .text =
                                                  projectList!.elementAt(
                                                      i)['description'];
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
                                                                          _projectTitleControllerEdit,
                                                                      labelText:
                                                                          "enter project title",
                                                                      hintText:
                                                                          "Delivery Application",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            10,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              ScreenUtil().setHeight(180.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            maxLines:
                                                                                10,
                                                                            autofocus:
                                                                                true,
                                                                            controller:
                                                                                _projectDescriptionControllerEdit,
                                                                            decoration: new InputDecoration(
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: kLight_orange, width: 1.0),
                                                                                ),
                                                                                hintText: "Tell us more about this project"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          ///validate for empty data.
                                                                          if (_projectTitleControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "project title cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_projectDescriptionControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "project description cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              projectList!.elementAt(i)['title'] = ReusableFunctions.capitalizeWords(_projectTitleControllerEdit.text);
                                                                              projectList!.elementAt(i)['description'] = _projectDescriptionControllerEdit.text;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "ok"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                                                      "Project ${i + 1}",
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
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            projectList!.remove(projectList!.elementAt(i));
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "yes"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                  DisplayProjectsEdit(
                                      projectDetails: projectList, i: i),
                                ],
                              ),
                          ],
                        )),
                    Container(
                      child: ResumeInput(
                        controller: _projectTitleController,
                        labelText: "enter project title",
                        hintText: "Delivery App",
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
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
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
                                  hintText: "Tell us more about this project"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addProject();
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

              //For Education
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Add Education",
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
                            for (var i = 0; i < educationList!.length; i++)
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
                                              Icons.school,
                                              color: kLight_orange,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Education ${i + 1}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(25.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _schoolNameControllerEdit.text =
                                                  educationList!.elementAt(
                                                      i)['schoolName'];
                                              _certificationControllerEdit
                                                      .text =
                                                  educationList!.elementAt(
                                                      i)['certification'];
                                              _courseControllerEdit.text =
                                                  educationList!
                                                      .elementAt(i)['course'];
                                              _schoolLocationControllerEdit
                                                      .text =
                                                  educationList!.elementAt(
                                                      i)['schoolLocation'];
                                              _schoolStartDateControllerEdit
                                                      .text =
                                                  educationList!
                                                      .elementAt(i)['start'];
                                              _schoolEndDateControllerEdit
                                                      .text =
                                                  educationList!
                                                      .elementAt(i)['end'];
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
                                                                          _schoolNameControllerEdit,
                                                                      labelText:
                                                                          "Enter School Name",
                                                                      hintText:
                                                                          "ST Peters College",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _certificationControllerEdit,
                                                                      labelText:
                                                                          "Enter Certification",
                                                                      hintText:
                                                                          "BSC",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _courseControllerEdit,
                                                                      labelText:
                                                                          "Enter Course ",
                                                                      hintText:
                                                                          "computer science",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _schoolLocationControllerEdit,
                                                                      labelText:
                                                                          "Enter School Location",
                                                                      hintText:
                                                                          "Germany",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _schoolStartDateControllerEdit,
                                                                      labelText:
                                                                          "Starting Date",
                                                                      hintText:
                                                                          "Sept 2008",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        ResumeInput(
                                                                      controller:
                                                                          _schoolEndDateControllerEdit,
                                                                      labelText:
                                                                          "End Date",
                                                                      hintText:
                                                                          "Present",
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
                                                                          if (_schoolNameControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "school name field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_schoolLocationControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "school location field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_certificationControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "certification field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_courseControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "course field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_schoolStartDateControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "start date field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_schoolEndDateControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "end date field cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              educationList!.elementAt(i)['schoolName'] = ReusableFunctions.capitalizeWords(_schoolNameControllerEdit.text);
                                                                              educationList!.elementAt(i)['certification'] = ReusableFunctions.capitalizeWords(_certificationControllerEdit.text);
                                                                              educationList!.elementAt(i)['course'] = ReusableFunctions.capitalizeWords(_courseControllerEdit.text);
                                                                              educationList!.elementAt(i)['schoolLocation'] = ReusableFunctions.capitalizeWords(_schoolLocationControllerEdit.text);
                                                                              educationList!.elementAt(i)['start'] = ReusableFunctions.capitalizeWords(_schoolStartDateControllerEdit.text);
                                                                              educationList!.elementAt(i)['end'] = ReusableFunctions.capitalizeWords(_schoolEndDateControllerEdit.text);
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
                                        Padding(
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
                                                                      "Education ${i + 1}",
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
                                                                            educationList!.remove(educationList!.elementAt(i));
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
                                      ],
                                    ),
                                  ),
                                  DisplayEducationEdit(
                                      educationDetails: educationList, i: i)
                                ],
                              ),
                          ],
                        )),
                    Container(
                      child: ResumeInput(
                        controller: _schoolNameController,
                        labelText: "Enter School Name",
                        hintText: "ST Peters College",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _certificationController,
                        labelText: "Enter Certification",
                        hintText: "BSC",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _courseController,
                        labelText: "Enter Course ",
                        hintText: "computer science",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _schoolLocationController,
                        labelText: "Enter School Location",
                        hintText: "Germany",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _schoolStartDateController,
                        labelText: "Starting Date",
                        hintText: "Sept 2008",
                      ),
                    ),
                    Container(
                      child: ResumeInput(
                        controller: _schoolEndDateController,
                        labelText: "End Date",
                        hintText: "Present",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addEducation();
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

              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),

              //For Awards
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Add Awards",
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
                            for (var i = 0; i < awardList!.length; i++)
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
                                              Icons.find_replace,
                                              color: kLight_orange,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Award ${i + 1}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _awardTitleControllerEdit.text =
                                                  awardList!
                                                      .elementAt(i)['title'];
                                              _awardDescriptionControllerEdit
                                                      .text =
                                                  awardList!.elementAt(
                                                      i)['description'];
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
                                                                          _awardTitleControllerEdit,
                                                                      labelText:
                                                                          "enter award title",
                                                                      hintText:
                                                                          "Lead GDG",
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            10,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              ScreenUtil().setHeight(180.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            maxLines:
                                                                                10,
                                                                            autofocus:
                                                                                true,
                                                                            controller:
                                                                                _awardDescriptionControllerEdit,
                                                                            decoration: new InputDecoration(
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: kLight_orange, width: 1.0),
                                                                                ),
                                                                                hintText: "Tell us more about this award"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          ///validate for empty data.
                                                                          if (_awardTitleControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "award title cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else if (_awardDescriptionControllerEdit.text ==
                                                                              '') {
                                                                            Fluttertoast.showToast(
                                                                                msg: "award description cannot be blank",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                backgroundColor: Colors.red,
                                                                                textColor: Colors.white);
                                                                          } else {
                                                                            //pass data to the main controller
                                                                            setState(() {
                                                                              awardList!.elementAt(i)['title'] = ReusableFunctions.capitalizeWords(_awardTitleControllerEdit.text);
                                                                              awardList!.elementAt(i)['description'] = _awardDescriptionControllerEdit.text;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "ok"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                                                      "Award ${i + 1}",
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
                                                                            .spaceAround,
                                                                    children: [
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            awardList!.remove(awardList!.elementAt(i));
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "yes"),
                                                                        textColor:
                                                                            Colors.white,
                                                                      ),
                                                                      RaisedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        textColor:
                                                                            Colors.white,
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
                                  DisplayProjectsEdit(
                                      projectDetails: awardList, i: i),
                                ],
                              ),
                          ],
                        )),
                    Container(
                      child: ResumeInput(
                        controller: _awardTitleController,
                        labelText: "enter  title",
                        hintText: "Lead GDG",
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
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
                                    borderSide: BorderSide(
                                        color: kLight_orange, width: 1.0),
                                  ),
                                  hintText: "Tell us more about this Award"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addAward();
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

              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),

//for skills
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
                              Icons.build,
                              color: kLight_orange,
                              size: 30.0,
                            ),
                          ),
                        ),
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
                        for (var i = 0; i < skillList!.length; i++)
                          Column(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "${i + 1}. ${skillList![i]} ",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _skillsControllerEdit.text =
                                              skillList![i];
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                                      _skillsControllerEdit,
                                                                  labelText:
                                                                      "Enter Your Skill",
                                                                  hintText:
                                                                      "Programming",
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      ///validate for empty data.
                                                                      if (_skillsControllerEdit
                                                                              .text ==
                                                                          '') {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Add at least one skill",
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            backgroundColor: Colors.red,
                                                                            textColor: Colors.white);
                                                                      } else {
                                                                        //pass data to the main controller
                                                                        setState(
                                                                            () {
                                                                          skillList![i] =
                                                                              ReusableFunctions.capitalizeWords(_skillsControllerEdit.text);
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "ok"),
                                                                  ),
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "cancel"),
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
                                                                .circular(10.0),
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
                                                                            ScreenUtil().setSp(
                                                                                18.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "${i + 1}.${skillList![i]} ",
                                                                  style: GoogleFonts
                                                                      .rajdhani(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                15.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        skillList!
                                                                            .remove(skillList![i]);
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "yes"),
                                                                  ),
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "cancel"),
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
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    child: ResumeInput(
                      controller: _skillsController,
                      labelText: "Enter Your Skill",
                      hintText: "Sleeping",
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

              // for hobbies
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
                              Icons.brush,
                              color: kLight_orange,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Text(
                          "Hobbies",
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
                        for (var i = 0; i < hobbyList!.length; i++)
                          Column(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "${i + 1}. ${hobbyList![i]} ",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _hobbiesControllerEdit.text =
                                              hobbyList![i];
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                                      _hobbiesControllerEdit,
                                                                  labelText:
                                                                      "Enter Your hobby",
                                                                  hintText:
                                                                      "Programming",
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      ///validate for empty data.
                                                                      if (_hobbiesControllerEdit
                                                                              .text ==
                                                                          '') {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Add at least one hobby",
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            backgroundColor: Colors.red,
                                                                            textColor: Colors.white);
                                                                      } else {
                                                                        //pass data to the main controller
                                                                        setState(
                                                                            () {
                                                                          hobbyList![i] =
                                                                              ReusableFunctions.capitalizeWords(_hobbiesControllerEdit.text);
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "ok"),
                                                                  ),
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "cancel"),
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
                                                                .circular(10.0),
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
                                                                            ScreenUtil().setSp(
                                                                                18.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "${i + 1}. ${hobbyList![i]} ",
                                                                  style: GoogleFonts
                                                                      .rajdhani(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                                15.0),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        hobbyList!
                                                                            .remove(hobbyList![i]);
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "yes"),
                                                                  ),
                                                                  RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "cancel"),
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
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    child: ResumeInput(
                      controller: _hobbiesController,
                      labelText: "Enter Your hobby",
                      hintText: "Sleeping",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _addHobbiesRow();
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

              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        onPressed: () {
                          validateAndUpdate();
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("save"),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
