import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/alumni/Storage.dart';
import 'package:sparks/alumni/alumniEntry.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'package:sparks/alumni/strings.dart';

enum GalleryOrCamera {
  CAMERA,
  GALLERY,
}

class AlumniCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlumniCreateState();
  }
}

class _AlumniCreateState extends State<AlumniCreate> {
  final TextEditingController chapterName = TextEditingController();
  final TextEditingController chapterLocation = TextEditingController();
  final picker = ImagePicker();
  File? selectedImage;

  bool showSpinner = false;
  Future<void> imageOptions() async {
    switch (await showDialog<GalleryOrCamera>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Choose Location',
                style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, GalleryOrCamera.CAMERA);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            color: kADeepOrange,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, GalleryOrCamera.GALLERY);
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.photo,
                            color: kADeepOrange,
                          ),
                          Text(
                            'Photo',
                            style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        })) {
      case GalleryOrCamera.CAMERA:
        getImageFromCamera();
        break;
      case GalleryOrCamera.GALLERY:
        getImageFromGallery();
        break;
    }
  }

  /// Function to pick image from phone camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  /// Function to pick image from phone photo gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  void createChapter() {
    //TODO:validate input data
    if (chapterName.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (chapterLocation.text == '') {
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
          .collection('sentSchoolRequest')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'schId': SchoolStorage.schoolId,
        'schName': SchoolStorage.schoolName,
        'cNm': chapterName.text,
        'cLcn': chapterLocation.text,
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "CHAPTER CREATED",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.white);
      Navigator.push(context,
          PageTransition(type: PageTransitionType.scale, child: School()));
    }
  }

  int? selectedRadio;
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: kADeepOrange, // add custom icons also
            ),
          ),
        ),
        backgroundColor: kAWhite,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40.0),
            child: Text(
              "Create Chapter",
              style: TextStyle(
                color: kABlack,
                fontFamily: "Rajdhani",
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          imageOptions();
                        },
                        child: selectedImage == null
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0, 40, 0, 15),
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset(
                                  "images/Alumni/apppic.svg",
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Container(
                        child: Text(
                          kAppBarAddPhotoOptional,
                          style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 25.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: chapterName,
                          decoration: InputDecoration(
                            hintText: kAppBarEnterNameOfSchool,
                            hintStyle: TextStyle(
                              color: kARed,
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: kAppBarName,
                            labelStyle: TextStyle(
                              color: kABlack,
                              fontFamily: "Rajdhani",
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      TextFormField(
                        controller: chapterLocation,
                        decoration: InputDecoration(
                            hintText: kAppBarEnterChapterLocation,
                            hintStyle: TextStyle(
                              color: kARed,
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: KAppBarChapter,
                            labelStyle: TextStyle(
                              color: kABlack,
                              fontFamily: "Rajdhani",
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                kAppBarPrivacy,
                style: new TextStyle(
                    color: kABlack,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      activeColor: kADeepOrange,
                      onChanged: (dynamic val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      activeColor: kADeepOrange,
                      onChanged: (dynamic val) {
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.public),
                            ),
                            Container(
                              child: Text(
                                kAppBarPublic,
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.lock),
                            ),
                            Container(
                              child: Text(
                                kAppBarPrivacy,
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(10, 2, 0, 0),
                            child: Text(
                              kAppBarAccessToEveryOne,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(30, 2, 0, 0),
                            child: Text(
                              kAppBarToMembersOnly,
                            ),
                          ),
                        ]),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(45.0),
              height: 49.0,
              width: MediaQuery.of(context).size.width * 0.42,
              child: RaisedButton(
                elevation: 10.0,
                color: kADeepOrange,
                onPressed: () {
                  Storage.activitiesTab = 2;
                  createChapter();
                },
                splashColor: kAWhite,
                child: Text(
                  'Create Chapter',
                  style: TextStyle(
                      color: kAWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "Rajdhani"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
