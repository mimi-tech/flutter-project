import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';

import 'schoolAdminEntry/Schooladminentry.dart';

class AddExperience extends StatefulWidget {
  @override
  _AddExperienceState createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  final TextEditingController workPlaceName = TextEditingController();
  final TextEditingController jobLocation = TextEditingController();
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController jobDescription = TextEditingController();
  final TextEditingController fromDay = TextEditingController();
  final TextEditingController fromMonth = TextEditingController();
  final TextEditingController fromYear = TextEditingController();
  final TextEditingController toDay = TextEditingController();
  final TextEditingController toMonth = TextEditingController();
  final TextEditingController toYear = TextEditingController();

  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;
  void addWorkingExperience() {
    //TODO:validate input data
    if (workPlaceName.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (jobLocation.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (jobTitle.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (jobDescription.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (fromDay.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (fromMonth.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (fromYear.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (toDay.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (toMonth.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (toYear.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else {
      //TODO: send to database

      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('notifyMySchool')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'schId': SchoolStorage.schoolId,
        'schName': SchoolStorage.schoolName,
        'wkpName': workPlaceName.text,
        'jobLct': jobLocation.text,
        "jobTle": jobTitle.text,
        "jobDsp": jobDescription.text,
        "frmDay": fromDay.text,
        "frmMonth": fromMonth.text,
        "fromYear": fromYear.text,
        "toDay": toDay.text,
        "toMonth": toMonth.text,
        "toYear": toYear.text,
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "REQUEST SENT",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
      Navigator.push(context,
          PageTransition(type: PageTransitionType.scale, child: AdminEntry()));
    }
  }

  bool val = false;

  onSwitchValueChanged(bool newVal) {
    setState(() {
      val = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kADarkRed,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 35.0),
                child: Text(
                  "Add Working Experience",
                  style: TextStyle(
                    fontFamily: "Rajdhani",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        leading: GestureDetector(
          onLongPress: () {},
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel, // add custom icons also
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        child: TextFormField(
                            controller: workPlaceName,
                            decoration: InputDecoration(
                              hintText: "Name of workplace",
                              hintStyle: TextStyle(
                                color: kARed,
                                fontFamily: "Rajdhani",
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              labelText: "Workplace Name",
                              labelStyle: TextStyle(
                                color: kABlack,
                                fontFamily: "Rajdhani",
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      TextFormField(
                          controller: jobLocation,
                          decoration: InputDecoration(
                            hintText: "Enter job location",
                            hintStyle: TextStyle(
                              color: kARed,
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: "Job Location",
                            labelStyle: TextStyle(
                              color: kABlack,
                              fontFamily: "Rajdhani",
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      TextFormField(
                          controller: jobTitle,
                          decoration: InputDecoration(
                            hintText: "Enter job title",
                            hintStyle: TextStyle(
                              color: kARed,
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: "Job Title",
                            labelStyle: TextStyle(
                              color: kABlack,
                              fontFamily: "Rajdhani",
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                          controller: jobDescription,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 7,
                          maxLength: 1000,
                          maxLengthEnforced: true,
                          decoration: InputDecoration(
                            labelText: "Job Description",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kADeepOrange,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: kABlack,
                              fontFamily: "Rajdhani",
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40.0,
              width: double.infinity,
              child: RaisedButton(
                elevation: 15,
                onPressed: () {
                  addWorkingExperience();
                  print(workPlaceName.text);
                  print(jobLocation.text);
                  print(jobTitle.text);
                  print(jobDescription.text);
                },
                color: kADeepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: kAWhite,
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
