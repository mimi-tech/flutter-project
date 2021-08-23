import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';

class EditAbout extends StatefulWidget {
  @override
  _EditAboutState createState() => _EditAboutState();
}

class _EditAboutState extends State<EditAbout> {
  final TextEditingController _professionalTitleController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  /// FocusNodes for the 'min price' & 'max price' TextFields
  /// TODO: Remove focus nodes if not necessary
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  /// These are the RangeValues for the RangeSlider Widget
  late double _lowPriceRange;
  late double _highPriceRange;

  /// The minimum and maximum values allowed for the price input
  double minRangeSliderValue = 0.0;
  double maxRangeSliderValue = 1000000.0;

  /// Boolean validator for 'MIN' and 'MAX' price TextFields
  bool isMinValid = true;
  bool isMaxValid = true;

  /// Note: This function is called in the "initState"
  void setDefaultValuesOfSalary() {
    setState(() {
      if (_minSalaryController.text.trim() == null ||
          _minSalaryController.text.trim() == "") {
        _lowPriceRange = 0;
      } else {
        _lowPriceRange = double.parse(_minSalaryController.text.trim());
      }

      if (_maxSalaryController.text.trim() == null ||
          _maxSalaryController.text.trim() == "") {
        _highPriceRange = 1000000;
      } else {
        _highPriceRange = double.parse(_maxSalaryController.text.trim());
      }
    });
  }

  bool isUploadComplete = false;
  String? downloadUrl;

  //TODO: function to get image from gallary
  Future getImageFromGallery() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile image =
        await (_picker.pickImage(source: ImageSource.gallery) as Future<XFile>);

    String fileName = image.path.split('/').last;
    if (fileName == null) {
      EditProfessionalStorage.profileName = "No Logo Selected!";
    } else {
      EditProfessionalStorage.profileName = fileName;
    }

    setState(() {
      EditProfessionalStorage.profileLogo = File(image.path);
    });
  }

  //TODO: function to upload image to cloud store
  Future uploadResumeImage() async {
    setState(() {
      showSpinner = true;
    });
// Points to the root reference
    var storageRef = FirebaseStorage.instance.ref().child('professionalImages');

// Points to 'image'
    var imagesRef = storageRef.child(EditProfessionalStorage.profileName!);

    //uploads
    UploadTask uploadTask =
        imagesRef.putFile(EditProfessionalStorage.profileLogo!);
    TaskSnapshot taskSnapshot = await uploadTask;
    downloadUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      showSpinner = false;
    });
    Fluttertoast.showToast(
        msg: "Profile Image Upload Complete",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);

    setState(() {
      isUploadComplete = true;
    });
  }

  /// string variable for setting the two radio buttons to true or false
  String? jobTypeGroupValue;

  /// I am setting the In-Person button to true by default
  String? jobType;

  String? currentStatus;
  String? status;

  ///  string variable for setting the three check buttons to true or false
  ///  and I am setting the fullTimeCheckboxValue to true by default
  String? jobTypeCategory;
  String? jobCategory;
  bool showSpinner = false;

  void validateAndUpdateDataWithImage() {
    if (_professionalTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "professional title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_locationController.text == '') {
      Fluttertoast.showToast(
          msg: "location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('professionals')
          .doc(EditProfessionalStorage.id);

      documentReference.update({
        "pTitle": _professionalTitleController.text,
        "ajt": EditProfessionalStorage.jobType,
        "srn": _minSalaryController.text,
        "srx": _maxSalaryController.text,
        "ajc": EditProfessionalStorage.jobCategory,
        "location": _locationController.text,
        "status": EditProfessionalStorage.status,
        "imageUrl": downloadUrl,
        "name": _nameController.text,
        "phone": _phoneNumberController.text,
      });
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(
          msg: "About updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
    }
  }

  void validateAndUpdateDataWithoutImage() {
    if (_professionalTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "professional title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_locationController.text == '') {
      Fluttertoast.showToast(
          msg: "location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_nameController.text == '') {
      Fluttertoast.showToast(
          msg: "name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('professionals')
          .doc(EditProfessionalStorage.id);

      documentReference.update({
        "pTitle": _professionalTitleController.text,
        "ajt": EditProfessionalStorage.jobType,
        "srn": _minSalaryController.text,
        "srx": _maxSalaryController.text,
        "ajc": EditProfessionalStorage.jobCategory,
        "location": _locationController.text,
        "status": EditProfessionalStorage.status,
        "name": _nameController.text,
        "phone": _phoneNumberController.text,
      });
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(
          msg: "About updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
    }
  }

  void changeJobCategoryState(value) {
    if (value == "Full Time") {
      setState(() {
        jobTypeCategory = "Full Time";
        EditProfessionalStorage.jobCategory = "full time";
      });
    } else if (value == "Part Time") {
      setState(() {
        jobTypeCategory = "Part Time";
        EditProfessionalStorage.jobCategory = "part time";
      });
    } else if (value == "Contract") {
      setState(() {
        jobTypeCategory = "Contract";
        EditProfessionalStorage.jobCategory = "contract";
      });
    }
  }

  //TODO: Get values for the Job type details
  void changeJobTypeState(value) {
    if (value == "In-Person") {
      setState(() {
        jobTypeGroupValue = "In-Person";
        EditProfessionalStorage.jobType = "in person";
      });
    } else if (value == "Remote") {
      setState(() {
        jobTypeGroupValue = "Remote";
        EditProfessionalStorage.jobType = "remote";
      });
    }
  }

  void changeCurrentStatus(value) {
    if (value == "Available") {
      setState(() {
        currentStatus = "Available";
        EditProfessionalStorage.status = "available";
      });
    } else if (value == "Not Available") {
      setState(() {
        currentStatus = "Not Available";
        EditProfessionalStorage.status = "not available";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaultValuesOfSalary();

    _minSalaryController =
        TextEditingController(text: EditProfessionalStorage.salaryRangeMin);
    _maxSalaryController =
        TextEditingController(text: EditProfessionalStorage.salaryRangeMax);
    _professionalTitleController.text =
        EditProfessionalStorage.professionalTitle!;
    _locationController.text = EditProfessionalStorage.location!;
    _phoneNumberController.text = EditProfessionalStorage.phoneNumber!;
    _nameController.text = EditProfessionalStorage.profileName!;
    EditProfessionalStorage.profileName = "No Image Selected";

    jobTypeGroupValue =
        ReusableFunctions.capitalizeWords(EditProfessionalStorage.jobType);
    currentStatus =
        ReusableFunctions.capitalizeWords(EditProfessionalStorage.status);
    jobTypeCategory =
        ReusableFunctions.capitalizeWords(EditProfessionalStorage.jobCategory);
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    _professionalTitleController.dispose();
    super.dispose();
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
                          Icons.account_circle,
                          color: kLight_orange,
                          size: 40.0,
                        ),
                      ),
                    ),
                    Text(
                      "ABOUT FORM",
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
              ResumeInput(
                controller: _nameController,
                labelText: "change your profile name",
                hintText: "Amadi Austin",
                action: (value) {
                  EditProfessionalStorage.professionalTitle = value;
                },
              ),
              ResumeInput(
                controller: _professionalTitleController,
                labelText: "Professional Title",
                hintText: "Software Engineer",
                action: (value) {
                  EditProfessionalStorage.professionalTitle = value;
                },
              ),
              ResumeInput(
                controller: _locationController,
                labelText: "Current Location",
                hintText: "Germany",
                action: (value) {
                  EditProfessionalStorage.location = value;
                },
              ),
              ResumeInput(
                controller: _phoneNumberController,
                labelText: "Phone Number",
                hintText: "+2348909740479",
                action: (value) {
                  EditProfessionalStorage.phoneNumber = value;
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                child: Text(
                  'Available For',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(28.0),
                        fontWeight: FontWeight.bold,
                        color: kLight_orange),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                child: Text(
                  'Job Type',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(18.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "In-Person",
                          groupValue: jobTypeGroupValue,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) => changeJobTypeState(val),
                        ),
                        Text(
                          'In-Person',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 60.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Remote",
                          groupValue: jobTypeGroupValue,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) => changeJobTypeState(val),
                        ),
                        Text(
                          'Remote',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                child: Text(
                  'Job Category',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(18.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Full Time",
                          groupValue: jobTypeCategory,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) =>
                              changeJobCategoryState(val),
                        ),
                        Text(
                          'Full-Time',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Part Time",
                          groupValue: jobTypeCategory,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) =>
                              changeJobCategoryState(val),
                        ),
                        Text(
                          'Part-Time',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Contract",
                          groupValue: jobTypeCategory,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) =>
                              changeJobCategoryState(val),
                        ),
                        Text(
                          'Contract',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                child: Text(
                  'Current Status',
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(18.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Available",
                          groupValue: currentStatus,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) => changeCurrentStatus(val),
                        ),
                        Text(
                          'Available',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Not Available",
                          groupValue: currentStatus,
                          activeColor: Colors.red,
                          onChanged: (dynamic val) => changeCurrentStatus(val),
                        ),
                        Text(
                          'Not Available',
                          style: new TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Divider(
                  color: kShade,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    "Enter Salary Range Yearly(\$)",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          /// TextField for the 'MIN' price input field
                          Flexible(
                            child: Container(
                              width: ScreenUtil().setWidth(96),
                              child: TextField(
                                controller: _minSalaryController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: kMSearchDrawerTextStyle,
                                keyboardType: TextInputType.number,
                                focusNode: _minPriceFocusNode,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kMarketPrimaryColor),
                                  ),
                                  hintText: 'MIN',
                                  hintStyle: kMSearchDrawerTextStyle,
                                ),
                                onSubmitted: (value) {
                                  _minPriceFocusNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_maxPriceFocusNode);
                                },
                                onChanged: (value) {
                                  if (value == null || value == '') {
                                    setState(() {
                                      _lowPriceRange = minRangeSliderValue;
                                    });
                                  } else if (double.parse(value) <=
                                          maxRangeSliderValue &&
                                      double.parse(value) >=
                                          minRangeSliderValue &&
                                      double.parse(value) <= _highPriceRange) {
                                    setState(() {
                                      _lowPriceRange = double.parse(value);
                                    });
                                  } else {
                                    setState(() {
                                      _lowPriceRange = minRangeSliderValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(44),
                          ),

                          /// TextField for the 'MAX' price input field
                          Flexible(
                            child: Container(
                              width: ScreenUtil().setWidth(96),
                              child: TextField(
                                controller: _maxSalaryController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: kMSearchDrawerTextStyle,
                                keyboardType: TextInputType.number,
                                focusNode: _maxPriceFocusNode,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kMarketPrimaryColor),
                                  ),
                                  hintText: 'MAX',
                                  hintStyle: kMSearchDrawerTextStyle,
                                  errorText:
                                      isMaxValid ? null : 'Shit not working',
                                ),
                                onSubmitted: (value) {
                                  _maxPriceFocusNode.unfocus();
                                },
                                onChanged: (value) {
                                  if (value == null || value == '') {
                                    setState(() {
                                      _highPriceRange = maxRangeSliderValue;
                                    });
                                  } else if (double.parse(value) <=
                                          maxRangeSliderValue &&
                                      double.parse(value) >=
                                          minRangeSliderValue &&
                                      double.parse(value) >= _lowPriceRange) {
                                    setState(() {
                                      _highPriceRange = double.parse(value);
                                    });
                                  } else {
                                    setState(() {
                                      _highPriceRange = maxRangeSliderValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RangeSlider for the 'Price Range'
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RangeSlider(
                        activeColor: kMarketSecondaryColor,
                        inactiveColor: Color(0xffB9BEC5),
                        values: RangeValues(_lowPriceRange, _highPriceRange),
                        divisions: 50,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _lowPriceRange = values.start.roundToDouble();
                            _highPriceRange = values.end.roundToDouble();
                            _minSalaryController.text =
                                values.start.toInt().toString();
                            _maxSalaryController.text =
                                values.end.toInt().toString();
                          });
                        },
                        min: minRangeSliderValue,
                        max: maxRangeSliderValue,
                      ),
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Text(
                    "job profile image",
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(25.0),
                          fontWeight: FontWeight.bold,
                          color: kLight_orange),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      if (EditProfessionalStorage.profileLogo == null)
                        Row(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 15.0),
                              height: ScreenUtil().setHeight(50.0),
                              width: ScreenUtil().setWidth(50),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 32,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: EditProfessionalStorage.logoUrl!,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                getImageFromGallery();
                              },
                              child: Text("change"),
                              color: kLight_orange,
                              textColor: Colors.white,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: <Widget>[
                            Image.file(
                              EditProfessionalStorage.profileLogo!,
                              width: 45.0,
                              height: 44.0,
                              fit: BoxFit.cover,
                            ),
                            RaisedButton(
                              onPressed: () {
                                getImageFromGallery();
                              },
                              child: Text("change"),
                              color: kLight_orange,
                              textColor: Colors.white,
                            ),
                            RaisedButton(
                              onPressed: () {
                                uploadResumeImage();
                              },
                              child: Text("upload"),
                              color: kLight_orange,
                              textColor: Colors.white,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "${EditProfessionalStorage.profileName}",
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(14.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 0.0, 95.0, 0.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (EditProfessionalStorage.profileLogo == null) {
                            validateAndUpdateDataWithoutImage();
                          } else {
                            if (isUploadComplete == true) {
                              validateAndUpdateDataWithImage();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please Upload Image!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            }
                          }
                        },
                        child: Text("save"),
                        color: kLight_orange,
                        textColor: Colors.white,
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
