import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/strings.dart';

enum GalleryOrCamera {
  CAMERA,
  GALLERY,
}

class Apply extends StatefulWidget {
  @override
  _ApplyState createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController workPlaceName = TextEditingController();
  final TextEditingController jobLocation = TextEditingController();
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController jobDescription = TextEditingController();
  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;
  void jobApplicationForm() {
    //TODO:validate input data
    if (name.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (email.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (phone.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (city.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (workPlaceName.text == '') {
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
    } else {
      //TODO: send to database

      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('jobApplicationForm')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'schId': SchoolStorage.schoolId,
        'schName': SchoolStorage.schoolName,
        'name': name.text,
        'email': email.text,
        "phone": phone.text,
        "city": city.text,
        'wkpName': workPlaceName.text,
        'jobLct': jobLocation.text,
        "jobTle": jobTitle.text,
        "jobDsp": jobDescription.text,
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "APPLICATION SENT",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
      Navigator.pop(context);
    }
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
                margin: EdgeInsets.only(left: 65.0),
                child: Text(
                  "Application Form",
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
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset('images/alumni/pic1.png'),
                    decoration: BoxDecoration(),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Google LLc",
                          style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Software Developer",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Full-time",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "NGN12,000-15,000 / month",
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      )
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 25.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                    controller: name,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kADeepOrange,
                                        ),
                                      ),
                                      hintText: "Enter your name",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kABlack,
                                        ),
                                      ),
                                      labelText: kAppBarName,
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.017,
                                ),
                                TextFormField(
                                    controller: email,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kADeepOrange,
                                        ),
                                      ),
                                      hintText: "Enter your email",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kABlack,
                                        ),
                                      ),
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.017,
                                ),
                                TextFormField(
                                    controller: phone,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kADeepOrange,
                                        ),
                                      ),
                                      hintText: "Enter phone number",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kABlack,
                                        ),
                                      ),
                                      labelText: "Phone",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.017,
                                ),
                                TextFormField(
                                    controller: city,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kADeepOrange,
                                        ),
                                      ),
                                      hintText: "Enter your city",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kABlack,
                                        ),
                                      ),
                                      labelText: "City",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Text(
                                "Working Experience",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: kADarkBlue,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                                controller: workPlaceName,
                                maxLines: null,
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
                              maxLines: null,
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
                              maxLines: null,
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
                              maxLines: null,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: kARed,
                                  fontFamily: "Rajdhani",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelText: "Job description",
                                labelStyle: TextStyle(
                                  color: kABlack,
                                  fontFamily: "Rajdhani",
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.57,
                                child: Row(
                                  children: [
                                    Container(
                                      child: SvgPicture.asset(
                                          "images/alumni/portfolio.svg"),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: kADeepOrange,
                                    ),
                                    Text(
                                      "Add Experience",
                                      style: TextStyle(
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 40.0,
              width: double.infinity,
              child: RaisedButton(
                elevation: 15,
                onPressed: () {
                  jobApplicationForm();
                },
                color: kADeepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Apply Now",
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
