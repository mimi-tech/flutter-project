import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/finalScreen.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenEleven extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenEleven({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenElevenState createState() =>
      _CreateProfessionalScreenElevenState();
}

class _CreateProfessionalScreenElevenState
    extends State<CreateProfessionalScreenEleven> {
  bool showSpinner = false;
  String? cvDownloadUrl;

  String? cvAnswerGroupValue;
  void cvChangeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        cvAnswerGroupValue = "yes";
        ProfessionalStorage.hasCv = "yes";
        showCvUpload();
      });
    } else if (value == "no") {
      setState(() {
        cvAnswerGroupValue = "no";
        ProfessionalStorage.hasCv = "no";
        ProfessionalStorage.cv = null;
        showCvInput = [];
      });
    }
  }

  List<Widget> showCvInput = [];

  Future getCvPdf() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );

    File? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    setState(() {
      ProfessionalStorage.cv = file;
    });
  }

  Future upload() async {
    if (ProfessionalStorage.cv == null) {
      ReusableFunctions.showToastMessage2(
          "Please choose a cv", Colors.white, Colors.red);
    } else {
      setState(() {
        showSpinner = true;
      });

      final FirebaseStorage _storageBucket =
          FirebaseStorage.instanceFor(bucket: "gs://sparks-44la.appspot.com");
// Points to the root reference
      var storageRef = _storageBucket.ref().child('professionalCvs');

// Points to 'image'
      var imagesRef = storageRef.child(
          "${DateTime.now().toString()}+${UserStorage.loggedInUser.uid}");

      //uploads
      UploadTask uploadTask = imagesRef.putFile(ProfessionalStorage.cv!);
      TaskSnapshot taskSnapshot = await uploadTask;
      cvDownloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        showSpinner = false;
      });

      Fluttertoast.showToast(
          msg: "Cv upload complete",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);

      ProfessionalStorage.cvUrl = cvDownloadUrl;

      print(ProfessionalStorage.cvUrl);
    }
  }

  void showCvUpload() {
    setState(() {
      showCvInput.add(
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: HintText(
              hintText: "Awesome choose to upload.",
            ),
          ),
          RaisedButton(
            onPressed: () {
              upload();
            },
            color: Colors.black,
            textColor: Colors.white,
            child: Text(
              "Upload",
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(22.0),
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfessionalStorage.cv = null;
    ProfessionalStorage.hasCv = '';
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak

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
                    details:
                        "You are doing great ${GlobalVariables.loggedInUserObject.nm!["fn"]}"),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: HintText(
                    hintText: "Do you want to upload your CV?",
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
                                        groupValue: cvAnswerGroupValue,
                                        activeColor: Colors.red,
                                        onChanged: (dynamic val) =>
                                            cvChangeAnswerTypeState(val),
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
                                        groupValue: cvAnswerGroupValue,
                                        activeColor: Colors.red,
                                        onChanged: (dynamic val) =>
                                            cvChangeAnswerTypeState(val),
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

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Text(
                      "Upload your cv",
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          if (ProfessionalStorage.cv == null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  "images/jobs/clogo.svg",
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (ProfessionalStorage.hasCv == "yes") {
                                      getCvPdf();
                                    } else {
                                      ReusableFunctions.showToastMessage2(
                                          "select yes",
                                          Colors.white,
                                          Colors.red);
                                    }
                                  },
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text("Choose"),
                                ),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PDF.file(
                                  ProfessionalStorage.cv!,
                                  placeHolder: CircularProgressIndicator(),
                                  height: 80,
                                  width: 80,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 8,
                                                children: <Widget>[
                                                  PDF.file(
                                                    ProfessionalStorage.cv!,
                                                    placeHolder:
                                                        CircularProgressIndicator(),
                                                    height: 600,
                                                    width: 800,
                                                  ),
                                                ]));
                                  },
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text("View"),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (ProfessionalStorage.hasCv == "yes") {
                                      getCvPdf();
                                    } else {
                                      ReusableFunctions.showToastMessage2(
                                          "select yes",
                                          Colors.white,
                                          Colors.red);
                                    }
                                  },
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text("Choose"),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                    margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                    child: Column(
                      children: showCvInput,
                    )),

                //ToDo: Company btn
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                  child: RaisedButton(
                    onPressed: () {
                      publish();
                    },
                    color: kLight_orange,
                    textColor: Colors.white,
                    child: Text(
                      "Create",
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

  String name =
      "${GlobalVariables.loggedInUserObject.nm!["fn"]} ${GlobalVariables.loggedInUserObject.nm!["ln"]}";

  List<String> searchKeyWords() {
    List<String> result = [];
    String name =
        "${GlobalVariables.loggedInUserObject.nm!["fn"]} ${GlobalVariables.loggedInUserObject.nm!["ln"]}";

    HashSet<String> sWords = new HashSet<String>();

    String jobTitle = ProfessionalStorage.professionalTitle!;
    String location = ProfessionalStorage.location!;
    String duration = ProfessionalStorage.jobCategory!;
    String jobType = ProfessionalStorage.jobType!;
    String profName = name;

    sWords.add(jobTitle.toLowerCase());
    sWords.add(location.toLowerCase());
    sWords.add(duration.toLowerCase());
    sWords.add(jobType.toLowerCase());
    sWords.add(profName.toLowerCase());

    List<String> temp = sWords.toList();

    for (int i = 0; i < jobTitle.split(" ").length; i++) {
      sWords.add(jobTitle.split(" ")[i].toLowerCase());
    }

    for (int i = 0; i < profName.split(" ").length; i++) {
      sWords.add(profName.split(" ")[i].toLowerCase());
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
    List<String> profNameTemps = profName.split(" ")[0].split('');
    List<String> locationTemps = location.split(" ")[0].split('');
    List<String> durationTemps = duration.split(" ").join("").split("");
    List<String> jobTypeTemps = jobType.split(" ")[0].split('');

    String jobTitleSearchKeys = "";
    String locationSearchKeys = "";
    String durationSearchKeys = "";
    String jobTypeSearchKeys = "";
    String profSearchKeys = "";

    for (int i = 0; i < profNameTemps.length; i++) {
      profSearchKeys += profNameTemps[i].toLowerCase();

      sWords.add(profSearchKeys);
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
    String name =
        "${GlobalVariables.loggedInUserObject.nm!["fn"]} ${GlobalVariables.loggedInUserObject.nm!["ln"]}";
    List<String> search = searchKeyWords();
    setState(() {
      showSpinner = true;
    });

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('professionals')
        .doc(UserStorage.loggedInUser.uid);
    documentReference.set({
      "pTitle": ProfessionalStorage.professionalTitle!.toLowerCase(),
      "location": ProfessionalStorage.location!.toLowerCase(),
      "phone": ProfessionalStorage.phoneNumber,
      "abtMe": ProfessionalStorage.aboutMe,
      "hdp": ProfessionalStorage.hasDoneProject,
      "pjd": ProfessionalStorage.projects.length,
      "hra": ProfessionalStorage.hasReceivedAward,
      "awDs": ProfessionalStorage.award,
      "awards": ProfessionalStorage.award.length,
      "projects": ProfessionalStorage.projects,
      "search": search,
      "srn": ProfessionalStorage.salaryRangeMin,
      "srx": ProfessionalStorage.salaryRangeMax,
      "ajc": ProfessionalStorage.jobCategory,
      "ajt": ProfessionalStorage.jobType,
      "status": ProfessionalStorage.status,
      "hex": ProfessionalStorage.hasExperience,
      "experience": ProfessionalStorage.experience,
      "hed": ProfessionalStorage.hasEducation,
      "education": ProfessionalStorage.education,
      "skills": ProfessionalStorage.skills,
      "hobbies": ProfessionalStorage.hobbies,
      "hsv": ProfessionalStorage.hasService,
      "services": ProfessionalStorage.services,
      "hrf": ProfessionalStorage.hasReferral,
      "referee": ProfessionalStorage.referee,
      "hcv": ProfessionalStorage.hasCv,
      "cv": ProfessionalStorage.cvUrl,
      "imageUrl": GlobalVariables.loggedInUserObject.pimg,
      "userId": UserStorage.loggedInUser.uid,
      "name": name,
      "email": UserStorage.loggedInUser.email,
      "date": DateTime.now().toString(),
      "avgRt": 0,
      "rtc": 0,
      'time': DateTime.now(),
    });
    Fluttertoast.showToast(
        msg: "Created Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);

    setState(() {
      showSpinner = false;
    });
    ProfessionalStorage.professionalTitle = null;
    ProfessionalStorage.location = null;
    ProfessionalStorage.phoneNumber = null;
    ProfessionalStorage.aboutMe = null;
    ProfessionalStorage.hasDoneProject = null;
    ProfessionalStorage.hasReceivedAward = null;
    ProfessionalStorage.award = [];
    ProfessionalStorage.projects = [];
    ProfessionalStorage.salaryRangeMin = null;
    ProfessionalStorage.salaryRangeMax = null;
    ProfessionalStorage.jobCategory = null;
    ProfessionalStorage.jobType = null;
    ProfessionalStorage.status = null;
    ProfessionalStorage.hasExperience = null;
    ProfessionalStorage.experience = [];
    ProfessionalStorage.hasEducation = null;
    ProfessionalStorage.education = [];
    ProfessionalStorage.skills = [];
    ProfessionalStorage.hobbies = [];
    ProfessionalStorage.hasService = null;
    ProfessionalStorage.hasReferral = null;
    ProfessionalStorage.services = [];
    ProfessionalStorage.referee = [];
    ProfessionalStorage.cv = null;
    ProfessionalStorage.hasCv = null;
    ProfessionalStorage.cvUrl = null;

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfessionalFinalScreen()));
  }
}
