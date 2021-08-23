import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:sparks/alumni/components/generalComponent.dart';

enum GalleryOrCamera {
  CAMERA,
  GALLERY,
}

class ActivitiesCreateChapter extends StatefulWidget {
  @override
  _ActivitiesCreateChapterState createState() =>
      _ActivitiesCreateChapterState();
}

class _ActivitiesCreateChapterState extends State<ActivitiesCreateChapter> {
  final TextEditingController schoolName = TextEditingController();
  final TextEditingController chapterName = TextEditingController();
  final TextEditingController chapterLocation = TextEditingController();
  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;
  late UploadTask uploadTask;

  String get filePath => 'ChapterLogo/${DateTime.now()}';
  Future<void> createSchoolChapter() async {
    //TODO:validate input data
    if (schoolName.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (chapterName.text == '') {
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
//push chapter logo to firebase
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      uploadTask = ref.putFile(selectedImage!);

      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('createSchoolChapter')
          .doc(SchoolStorage.schoolId);
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'schId': SchoolStorage.schoolId,
        'sl': url,
        'schNam': schoolName.text,
        'chapName': chapterName.text,
        "chapLcn": chapterLocation.text,
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

      Navigator.pop(context);
    }
  }

  Future<void> imageOptions() async {
    switch (await showDialog<GalleryOrCamera>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Choose Image',
                style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 20.sp,
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
                              fontSize: 20.sp,
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
                              fontSize: 18.sp,
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

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kADarkRed,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 35.0),
                child: Card(
                  elevation: 20.0,
                  color: kADarkRed,
                  child: Text(
                    "CREATE SCHOOL CHAPTER",
                    style: TextStyle(
                      color: kAWhite,
                      fontFamily: "Rajdhani",
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 28, 0, 15),
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
                                          margin:
                                              EdgeInsets.fromLTRB(0, 40, 0, 15),
                                          alignment: Alignment.topCenter,
                                          child: SvgPicture.asset(
                                            "images/alumni/apppic.svg",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.11,
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Image.file(
                                            selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Container(
                                  child: Text(
                                    "Add photo",
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
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                    controller: schoolName,
                                    decoration: InputDecoration(
                                      hintText: "Enter school name",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelText: "School Name",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                TextFormField(
                                    controller: chapterName,
                                    decoration: InputDecoration(
                                      hintText: "Enter chapter name",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelText: "chapter Name",
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
                                      hintText: "Enter Location",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelText: "Location",
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width * 0.3,
              child: RaisedButton(
                elevation: 30,
                onPressed: () {
                  createSchoolChapter();
                },
                color: kADeepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Create",
                      style: TextStyle(
                          color: kAWhite,
                          fontFamily: "Rajdhani",
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold),
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
