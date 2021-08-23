import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/subScreens/professionals/create/screenEleven.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

class CreateProfessionalScreenTen extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  final Widget? example;
  CreateProfessionalScreenTen({
    Key? key,
    this.offsetBool,
    this.widthSlide,
    this.example,
  }) : super(key: key);
  @override
  _CreateProfessionalScreenTenState createState() =>
      _CreateProfessionalScreenTenState();
}

class _CreateProfessionalScreenTenState
    extends State<CreateProfessionalScreenTen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _recommendationController =
      TextEditingController();

  List<Widget> showReferralInput = [];
  List<Widget> referralDisplay = [];
  var listReferral = [];
  int count = 0;
  var referralDownloadUrl;
  bool showSpinner = false;

  String? referralAnswerGroupValue = ProfessionalStorage.hasReferral;
  void referralChangeAnswerTypeState(value) {
    if (value == "yes") {
      setState(() {
        referralAnswerGroupValue = "yes";
        ProfessionalStorage.hasReferral = "yes";
        showReferralForm();
      });
    } else if (value == "no") {
      setState(() {
        referralAnswerGroupValue = "no";
        ProfessionalStorage.hasReferral = "no";
        showReferralInput = [];
        referralDisplay = [];
        count = 0;
        ProfessionalStorage.referee = [];
      });
    }
  }

  void displayAll() {
    if (ProfessionalStorage.hasReferral == "yes") {
      print(ProfessionalStorage.referee);
      listReferral = ProfessionalStorage.referee;
      showReferralForm();
      displayReferral();
    }
  }

  void displayReferral() {
    for (var item in listReferral) {
      setState(() {
        referralDisplay.add(Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 5.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 32,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: item['image'],
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
                    "Referral ${ProfessionalStorage.referee.length}",
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  SvgPicture.asset(
                    "images/jobs/bullet.svg",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['name'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                  SvgPicture.asset(
                    "images/jobs/bullet.svg",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['occupation'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                  SvgPicture.asset(
                    "images/jobs/bullet.svg",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['recommendation'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                  SvgPicture.asset(
                    "images/jobs/bullet.svg",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['companyName'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                  SvgPicture.asset(
                    "images/jobs/bullet.svg",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['phoneNumber'],
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
      });

      /// The line of code below is very very very important. Please don't remove
      listReferral = [];
    }
  }

  void showReferralForm() {
    setState(() {
      showReferralInput.add(
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: HintText(
              hintText: "Awesome! Tell us more about him or her.",
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 0.0, 95.0, 0.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Card(
            child: Container(
              child: ResumeInput(
                controller: _nameController,
                labelText: "Enter Referral Name",
                hintText: "Amadi Austin",
              ),
            ),
          ),
          Card(
            child: Container(
              child: ResumeInput(
                controller: _occupationController,
                labelText: "Enter occupation",
                hintText: "Programmer",
              ),
            ),
          ),
          Card(
            child: Container(
              child: ResumeInput(
                controller: _companyNameController,
                labelText: "Company Name",
                hintText: "Google",
              ),
            ),
          ),
          Card(
            child: Container(
              child: ResumeInput(
                controller: _phoneNumberController,
                labelText: "Enter phone number",
                hintText: "09037096290",
              ),
            ),
          ),
          Card(
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
                      borderSide: BorderSide(color: kLight_orange, width: 1.0),
                    ),
                    hintText: "State his recommendation about you"),
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (_nameController.text == '') {
                ReusableFunctions.showToastMessage2(
                    "name field cannot be blank", Colors.white, Colors.red);
              } else if (_occupationController.text == '') {
                ReusableFunctions.showToastMessage2(
                    "occupation field cannot be blank",
                    Colors.white,
                    Colors.red);
              } else if (_recommendationController.text == '') {
                ReusableFunctions.showToastMessage2(
                    "recommendation field is empty", Colors.white, Colors.red);
              } else if (_companyNameController.text == '') {
                ReusableFunctions.showToastMessage2(
                    "company name field is empty", Colors.white, Colors.red);
              } else if (_phoneNumberController.text == '') {
                ReusableFunctions.showToastMessage2(
                    "phone number field is empty", Colors.white, Colors.red);
              } else if (ProfessionalStorage.referralImage == null) {
                ReusableFunctions.showToastMessage2(
                    "No referral image selected", Colors.white, Colors.red);
              } else {
                uploadReferralImage().then((url) => _addReferral(url));
              }
            },
            child: Text("Add"),
            color: Colors.white,
            textColor: Colors.black,
          ),
        ]),
      );
    });
  }

  void _addReferral(url) {
//TODO: create the object with the input text values
    print("enter");
    print(ProfessionalStorage.referralImageName);
    var referee = {
      "image": url,
      "name": ReusableFunctions.capitalize(_nameController.text),
      "occupation": ReusableFunctions.capitalize(_occupationController.text),
      "recommendation": _recommendationController.text,
      "companyName": ReusableFunctions.capitalize(_companyNameController.text),
      "phoneNumber": _phoneNumberController.text
    };

    //TODO: add the object to the list
    ProfessionalStorage.referee.add(referee);
    listReferral.add(referee);
    //TODO: clear the content of the text controllers
    referee = {};
    _nameController.clear();
    _occupationController.clear();
    _recommendationController.clear();
    _companyNameController.clear();
    _phoneNumberController.clear();
    ProfessionalStorage.referralImage = null;
    ProfessionalStorage.referralImageName = "No image selected";

//TODO: display the data in the list of maps
    displayReferral();
  }

  PickedFile? pickedFile;
  Future getReferralImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    pickedFile = await picker.getImage(source: ImageSource.gallery);
    String fileName = pickedFile!.path.split('/').last;
    if (fileName == null) {
      ProfessionalStorage.referralImageName = "No Image Selected!";
    } else {
      setState(() {
        ProfessionalStorage.referralImageName = fileName;
      });
    }
    setState(() {
      ProfessionalStorage.referralImage = File(pickedFile!.path);
    });
  }

  Future uploadReferralImage() async {
    setState(() {
      showSpinner = true;
    });

    final FirebaseStorage _storageBucket =
        FirebaseStorage.instanceFor(bucket: "gs://sparks-44la.appspot.com");
// Points to the root reference
    var storageRef = _storageBucket.ref().child('professionalReferralImages');

// Points to 'image'
    var imagesRef = storageRef.child(
        "${DateTime.now().toString()}+${ProfessionalStorage.referralImageName}");

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

    return referralDownloadUrl;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfessionalStorage.referralImageName = "No Image Selected!";
    displayAll();
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak

    _nameController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _occupationController.dispose();
    _recommendationController.dispose();
    listReferral = [];
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
                    hintText: "Do you have any referral?",
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
                                        groupValue: referralAnswerGroupValue,
                                        activeColor: Colors.red,
                                        onChanged: (dynamic val) =>
                                            referralChangeAnswerTypeState(val),
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
                                        groupValue: referralAnswerGroupValue,
                                        activeColor: Colors.red,
                                        onChanged: (dynamic val) =>
                                            referralChangeAnswerTypeState(val),
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

                Container(
                    margin: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                    child: Column(
                      children: referralDisplay,
                    )),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                    child: Text(
                      "Referral Image",
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
                      margin: EdgeInsets.fromLTRB(45.0, 5.0, 45.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          if (ProfessionalStorage.referralImage == null)
                            InkWell(
                              onTap: () {
                                if (ProfessionalStorage.hasReferral == "yes") {
                                  getReferralImageFromGallery();
                                } else {
                                  ReusableFunctions.showToastMessage2(
                                      "select yes", Colors.white, Colors.red);
                                }
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "images/jobs/clogo.svg",
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.black,
                                    ),
                                    // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    height: ScreenUtil().setHeight(20.0),
                                    width: ScreenUtil().setWidth(60.0),
                                    margin: EdgeInsets.fromLTRB(
                                        40.0, 10.0, 40.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Choose',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            InkWell(
                              onTap: () {
                                if (ProfessionalStorage.hasReferral == "yes") {
                                  getReferralImageFromGallery();
                                } else {
                                  ReusableFunctions.showToastMessage2(
                                      "select yes", Colors.white, Colors.red);
                                }
                              },
                              child: Row(
                                children: [
                                  Image.file(
                                    ProfessionalStorage.referralImage!,
                                    width: 45.0,
                                    height: 44.0,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.black,
                                    ),
                                    // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    height: ScreenUtil().setHeight(20.0),
                                    width: ScreenUtil().setWidth(60.0),
                                    margin: EdgeInsets.fromLTRB(
                                        40.0, 10.0, 40.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Choose',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  children: showReferralInput,
                ),

                //ToDo: Company btn

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Indicator(
                    nextBtn: () {
                      goToNext();
                    },
                    percent: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    print(ProfessionalStorage.hasReferral);
    print(ProfessionalStorage.referee);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateProfessionalScreenEleven()));
  }
}
