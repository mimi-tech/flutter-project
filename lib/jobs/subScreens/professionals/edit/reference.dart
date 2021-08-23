import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class EditReferral extends StatefulWidget {
  @override
  _EditReferralState createState() => _EditReferralState();
}

class _EditReferralState extends State<EditReferral> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _recommendationController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // for referral edit
  final TextEditingController _nameControllerEdit = TextEditingController();
  final TextEditingController _occupationControllerEdit =
      TextEditingController();
  final TextEditingController _recommendationControllerEdit =
      TextEditingController();
  final TextEditingController _companyNameControllerEdit =
      TextEditingController();
  final TextEditingController _phoneNumberControllerEdit =
      TextEditingController();

  String? name;

  bool showSpinner = false;
  bool isUploadComplete = false;
  bool isReferralUploadComplete = false;
  var downloadUrl;
  var referralDownloadUrl;
  List<dynamic>? listReferee = [];

  Future getReferralImageFromGallery() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile image =
        await (_picker.pickImage(source: ImageSource.gallery) as Future<XFile>);

    String fileName = image.path.split('/').last;
    if (fileName == null) {
      ProfessionalStorage.referralImageName = "No Image Selected!";
    } else {
      ProfessionalStorage.referralImageName = fileName;
    }

    setState(() {
      ProfessionalStorage.referralImage = File(image.path);
    });
  }

  Future uploadReferralImage() async {
    setState(() {
      showSpinner = true;
    });
// Points to the root reference
    var storageRef =
        FirebaseStorage.instance.ref().child('professionalReferralImages');

// Points to 'image'
    var imagesRef = storageRef.child(ProfessionalStorage.referralImageName!);

    //uploads
    UploadTask uploadTask =
        imagesRef.putFile(ProfessionalStorage.referralImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    referralDownloadUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      showSpinner = false;
    });
    Fluttertoast.showToast(
        msg: "Referral Image Upload Complete",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);

    setState(() {
      isReferralUploadComplete = true;
    });
    print("hello upload");

    return referralDownloadUrl;
  }

  void _addReferral(url) {
    //TODO: validate user input
    if (isReferralUploadComplete == false) {
      Fluttertoast.showToast(
          msg: "Please a referral image is required",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_nameController.text == '') {
      Fluttertoast.showToast(
          msg: "name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_occupationController.text == '') {
      Fluttertoast.showToast(
          msg: "occupation field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_recommendationController.text == '') {
      Fluttertoast.showToast(
          msg: "recommendation field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyNameController.text == '') {
      Fluttertoast.showToast(
          msg: "company field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_phoneNumberController.text == '') {
      Fluttertoast.showToast(
          msg: "phone number field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var referee = {
        "image": url,
        "name": ReusableFunctions.capitalizeWords(_nameController.text),
        "occupation":
            ReusableFunctions.capitalizeWords(_occupationController.text),
        "recommendation": _recommendationController.text,
        "companyName":
            ReusableFunctions.capitalizeWords(_companyNameController.text),
        "phoneNumber": _phoneNumberController.text
      };

      //TODO: add the object to the list

      setState(() {
        listReferee!.add(referee);
        //TODO: clear the content of the text controllers
        referee = {};
        _nameController.clear();
        _occupationController.clear();
        _recommendationController.clear();
        _companyNameController.clear();
        _phoneNumberController.clear();
        ProfessionalStorage.referralImage = null;
        ProfessionalStorage.referralImageName = "No image selected";
      });

      setState(() {
        isReferralUploadComplete = false;
      });
    }
  }

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  void uploadData() async {
    try {
      setState(() {
        showSpinner = true;
      });
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('professionals')
          .doc(UserStorage.loggedInUser.uid);
      documentReference.update({
        "date": date,
        "referee": listReferee,
      });
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(
          msg: "Referral Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } catch (err) {
      print(err);
    }
  }

  void validateAndUploadData() {
    uploadData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listReferee = EditProfessionalStorage.referee;
    ProfessionalStorage.referralImageName = "No image Selected";
    ProfessionalStorage.referee = [];
    ProfessionalStorage.referralImage = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EditProfessionalStorage.referee = null;
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
              child: ListView(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Icon(
                            Icons.done_outline,
                            color: kLight_orange,
                            size: 40.0,
                          ),
                        ),
                      ),
                      Text(
                        "REFERRAL FORM",
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(22.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Add Referral",
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(20.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                  child: Column(
                    children: [
                      for (var i = 0; i < listReferee!.length; i++)
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 32,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: listReferee!
                                              .elementAt(i)['image'],
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
                                  Text(
                                    "Referral ${i + 1}",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(25.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => SimpleDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
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
                                                                "Referral ${i + 1}",
                                                                style: GoogleFonts
                                                                    .rajdhani(
                                                                  textStyle: TextStyle(
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
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
                                                                        listReferee!
                                                                            .remove(listReferee!.elementAt(i));
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    color:
                                                                        kLight_orange,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Text(
                                                                        "yes")),
                                                                RaisedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  color:
                                                                      kLight_orange,
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
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _nameControllerEdit.text =
                                            listReferee!.elementAt(i)['name'];
                                        _occupationControllerEdit.text =
                                            listReferee!
                                                .elementAt(i)['occupation'];
                                        _recommendationControllerEdit.text =
                                            listReferee!
                                                .elementAt(i)['recommendation'];
                                        _companyNameControllerEdit.text =
                                            listReferee!
                                                .elementAt(i)['companyName'];
                                        _phoneNumberControllerEdit.text =
                                            listReferee!
                                                .elementAt(i)['phoneNumber'];
                                        showDialog(
                                            context: context,
                                            builder: (context) => SimpleDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    elevation: 8,
                                                    children: <Widget>[
                                                      Container(
                                                        child: ResumeInput(
                                                          controller:
                                                              _nameControllerEdit,
                                                          labelText:
                                                              "Enter Referral Name",
                                                          hintText:
                                                              "Amadi Austin",
                                                        ),
                                                      ),
                                                      Container(
                                                        child: ResumeInput(
                                                          controller:
                                                              _occupationControllerEdit,
                                                          labelText:
                                                              "Enter occupation",
                                                          hintText:
                                                              "Programmer",
                                                        ),
                                                      ),
                                                      Container(
                                                        child: ResumeInput(
                                                          controller:
                                                              _recommendationControllerEdit,
                                                          labelText:
                                                              "Referral recommendation",
                                                          hintText:
                                                              "He is very good at what he does",
                                                        ),
                                                      ),
                                                      Container(
                                                        child: ResumeInput(
                                                          controller:
                                                              _companyNameControllerEdit,
                                                          labelText:
                                                              "Company Name",
                                                          hintText: "Google",
                                                        ),
                                                      ),
                                                      Container(
                                                        child: ResumeInput(
                                                          controller:
                                                              _phoneNumberControllerEdit,
                                                          labelText:
                                                              "Enter phone number",
                                                          hintText:
                                                              "09037096290",
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          RaisedButton(
                                                            onPressed: () {
                                                              ///validate for empty data.
                                                              if (_nameControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "name field cannot be blank",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              } else if (_occupationControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "occupation field cannot be blank",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              } else if (_recommendationControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "recommendation field cannot be blank",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              } else if (_companyNameControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "company field cannot be blank",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              } else if (_phoneNumberControllerEdit
                                                                      .text ==
                                                                  '') {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "phone number field cannot be blank",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              } else {
                                                                setState(() {
                                                                  listReferee!
                                                                      .elementAt(
                                                                          i)['name'] = ReusableFunctions
                                                                      .capitalizeWords(
                                                                          _nameControllerEdit
                                                                              .text);

                                                                  listReferee!
                                                                      .elementAt(
                                                                          i)['occupation'] = ReusableFunctions
                                                                      .capitalizeWords(
                                                                          _occupationControllerEdit
                                                                              .text);
                                                                  listReferee!.elementAt(
                                                                              i)[
                                                                          'recommendation'] =
                                                                      _recommendationControllerEdit
                                                                          .text;
                                                                  listReferee!
                                                                      .elementAt(
                                                                          i)['companyName'] = ReusableFunctions
                                                                      .capitalizeWords(
                                                                          _companyNameControllerEdit
                                                                              .text);
                                                                  listReferee!.elementAt(
                                                                              i)[
                                                                          'phoneNumber'] =
                                                                      _phoneNumberControllerEdit
                                                                          .text;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Text("ok"),
                                                            color:
                                                                kLight_orange,
                                                            textColor:
                                                                Colors.white,
                                                          ),
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("cancel"),
                                                            color:
                                                                kLight_orange,
                                                            textColor:
                                                                Colors.white,
                                                          ),
                                                        ],
                                                      ),
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
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Name:",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        listReferee!.elementAt(i)['name'],
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                                  Text(
                                    "Occupation:",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        listReferee!.elementAt(i)['occupation'],
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Recommendation',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      listReferee!
                                          .elementAt(i)['recommendation'],
                                      softWrap: true,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
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
                                  Text(
                                    "Company:",
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        listReferee!
                                            .elementAt(i)['companyName'],
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                                  Text(
                                    'PhoneNumber:',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        listReferee!
                                            .elementAt(i)['phoneNumber'],
                                        softWrap: true,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
                              child: Divider(
                                color: kShade,
                                thickness: 10.0,
                              ),
                            ),
                          ],
                        ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: Text(
                                "Referral Image",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(20.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
                                  if (ProfessionalStorage.referralImage == null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SvgPicture.asset(
                                          "images/jobs/clogo.svg",
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            getReferralImageFromGallery();
                                          },
                                          child: Text('choose'),
                                          color: Colors.black,
                                          textColor: Colors.white,
                                        ),
                                      ],
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.file(
                                          ProfessionalStorage.referralImage!,
                                          width: 45.0,
                                          height: 44.0,
                                          fit: BoxFit.cover,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            getReferralImageFromGallery();
                                          },
                                          child: Text('choose'),
                                          color: Colors.black,
                                          textColor: Colors.white,
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15.0, 0.0, 95.0, 0.0),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _nameController,
                          labelText: "Enter Referral Name",
                          hintText: "Amadi Austin",
                        ),
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _occupationController,
                          labelText: "Enter occupation",
                          hintText: "Programmer",
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
                                controller: _recommendationController,
                                decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLight_orange, width: 1.0),
                                    ),
                                    hintText: "specify your recommendation"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _companyNameController,
                          labelText: "Company Name",
                          hintText: "Google",
                        ),
                      ),
                      Container(
                        child: ResumeInput(
                          controller: _phoneNumberController,
                          labelText: "Enter phone number",
                          hintText: "09037096290",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (ProfessionalStorage.referralImage == null) {
                                ReusableFunctions.showToastMessage2(
                                    "No referral image selected",
                                    Colors.white,
                                    Colors.red);
                              } else {
                                uploadReferralImage()
                                    .then((url) => _addReferral(url));
                              }
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: () {
                                validateAndUploadData();
                                Navigator.pop(context);
                              },
                              child: Text('SAVE'),
                              color: kLight_orange,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
