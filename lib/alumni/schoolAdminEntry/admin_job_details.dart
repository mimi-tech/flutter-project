import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/alumni/color/colors.dart';

class AdminJobsDetails extends StatefulWidget {
  @override
  _AdminJobsDetailsState createState() => _AdminJobsDetailsState();
}

class _AdminJobsDetailsState extends State<AdminJobsDetails> {
  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;

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
                margin: EdgeInsets.only(left: 65.0),
                child: Text(
                  "Software Developer",
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
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'images/alumni/HAVARD.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Google LLc",
                          style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: kADeepOrange,
                          ),
                        ),
                      ),
                      Text(
                        "Software Developer",
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Full-time",
                                style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: kABlack),
                              ),
                            ),
                            Text(
                              "NGN12,000 - 15,000/month",
                              style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                "Baltimore,Md Usa",
                                style: TextStyle(
                                    fontFamily: "Rajdhani",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: kABlack),
                              ),
                            ),
                            Text(
                              "Jan 8,2020 - Jan 2,2020",
                              style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                    color: kADeepOrange,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: Text(
                        "Job Description",
                        style: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: kADarkBlue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide()),
                          hintText: "Write a Text",
                          hintStyle: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          labelStyle: TextStyle(
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: Text(
                        "Required Skills :",
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Add Skill",
                            hintStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelStyle: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.format_list_numbered,
                              color: Colors.cyan,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                          Container(
                            child: Text(
                              "Add Skill",
                              style: TextStyle(
                                fontFamily: "Rajdhani",
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: kABlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40.0,
              width: double.infinity,
              child: RaisedButton(
                elevation: 15,
                onPressed: () {},
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
