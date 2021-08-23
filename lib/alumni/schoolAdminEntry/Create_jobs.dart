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
import '../strings.dart';

enum GalleryOrCamera {
  CAMERA,
  GALLERY,
}

class CreateJobs extends StatefulWidget {
  @override
  _CreateJobsState createState() => _CreateJobsState();
}

class _CreateJobsState extends State<CreateJobs> {
  final TextEditingController skills = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController categoriesSelected = TextEditingController();
  final TextEditingController salaryMinimum = TextEditingController();
  final TextEditingController profession1 = TextEditingController();
  final TextEditingController profession2 = TextEditingController();
  final TextEditingController salaryMaximum = TextEditingController();
  final TextEditingController jobTimelineFrom = TextEditingController();
  final TextEditingController jobTimelineTo = TextEditingController();
  final TextEditingController jobDescription = TextEditingController();
  final picker = ImagePicker();
  File? selectedImage;
  get studentSchoolIdNumber => null;
  bool showSpinner = false;
  late UploadTask uploadTask;

  String get filePath => 'JobsLogo/${DateTime.now()}';
  Future<void> createJobs() async {
    //TODO:validate input data
    if (skills.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (profession1.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (profession2.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (companyName.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (salaryMinimum.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (salaryMaximum.text == '') {
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
    } else if (categoriesSelected.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (jobTimelineFrom.text == '') {
      Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white);
    } else if (jobTimelineTo.text == '') {
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
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      uploadTask = ref.putFile(selectedImage!);

      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('AlumniJobs').doc();
      documentReference.set({
        'uid': SchoolStorage.userId,
        'id': documentReference.id,
        'jbName': SchoolStorage.jobName,
        'sl': url,
        'skills': skills.text,
        "prfSn1": profession1.text,
        "prfSn2": profession2.text,
        'location': location.text,
        "compNme": companyName.text,
        "slrMnm": salaryMinimum.text,
        "slrMxm": salaryMaximum.text,
        "jbTitle": jobTitle.text,
        "jbCaty": categoriesSelected.text,
        "jbTleF": jobTimelineFrom.text,
        "jbTleT": jobTimelineTo.text,
        "jbDsc": jobDescription.text,
        'status': 'pending',
        'time': DateTime.now()
      });

      setState(() {
        showSpinner = false;
      });
      //TODO: display a toast and redirect to school page
      Fluttertoast.showToast(
          msg: "JOB CREATED",
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
                              fontSize: 18.sp,
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
  void initState() {
    // TODO: implement initState
    super.initState();
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
                margin: EdgeInsets.only(left: 80.0),
                child: Card(
                  elevation: 20.0,
                  color: kADarkRed,
                  child: Text(
                    "CREATE JOB",
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
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
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
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: companyName,
                                  decoration: InputDecoration(
                                      hintText: "Enter company name",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelText: "Company Name",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                TextFormField(
                                    controller: location,
                                    decoration: InputDecoration(
                                      hintText: "Enter location",
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
                                        fontSize: 20.0,
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
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                TextFormField(
                                    controller: skills,
                                    decoration: InputDecoration(
                                      hintText: "Enter skills",
                                      hintStyle: TextStyle(
                                        color: kARed,
                                        fontFamily: "Rajdhani",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelText: "Skills",
                                      labelStyle: TextStyle(
                                        color: kABlack,
                                        fontFamily: "Rajdhani",
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Specific profession",
                                      style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: profession1,
                                                decoration: InputDecoration(
                                                  hintText: "type here",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: profession2,
                                                decoration: InputDecoration(
                                                  hintText: "type here",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Salary Range",
                                      style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: salaryMinimum,
                                                decoration: InputDecoration(
                                                  hintText: "Minimum",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: salaryMaximum,
                                                decoration: InputDecoration(
                                                  hintText: "Maximum",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Job Timeline",
                                      style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: jobTimelineFrom,
                                                decoration: InputDecoration(
                                                  hintText: "From : mm,dd,yy",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                        Container(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                            elevation: 10.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: jobTimelineTo,
                                                decoration: InputDecoration(
                                                  hintText: "To : mm,dd,yy",
                                                  hintStyle: TextStyle(
                                                    color: kAGrey,
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Select Category",
                                      style: TextStyle(
                                          fontFamily: "Rajdhani",
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // DropDownField(
                                    //   controller: categoriesSelected,
                                    //   hintText: "choose Category",
                                    //   enabled: true,
                                    //   items: categories,
                                    //   onValueChanged: (value) {
                                    //     setState(() {
                                    //       selectCategory = value;
                                    //     });
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
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
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width * 0.3,
              child: RaisedButton(
                elevation: 15,
                onPressed: () {
                  if (skills.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (location.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (companyName.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (salaryMinimum.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (salaryMaximum.text == '') {
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
                  } else if (categoriesSelected.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (jobTimelineFrom.text == '') {
                    Fluttertoast.showToast(
                        msg: "All fields are required",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        textColor: Colors.white);
                  } else if (jobTimelineTo.text == '') {
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
                    try {
                      createJobs();
                    } catch (err) {
                      print("not working");
                      print(err);
                    }

                    print("see yashi ooh");
                  }
                },
                color: kADeepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Create",
                        style: TextStyle(
                            color: kAWhite,
                            fontFamily: "Rajdhani",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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

String selectCategory = "";

List<String> categories = [
  "Part-time",
  "Full-time",
  "Remote",
];
