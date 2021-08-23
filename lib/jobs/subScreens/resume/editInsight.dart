import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/portfolioComponents.dart';
import 'package:sparks/jobs/subScreens/resume/uploadPortfolioInsight.dart';
import 'package:sparks/jobs/subScreens/resume/viewInsight.dart';

class EditInsight extends StatefulWidget {
  @override
  _EditInsightState createState() => _EditInsightState();
}

class _EditInsightState extends State<EditInsight> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController categoryContentController =
      TextEditingController();
  String? category = "Category";

  bool showSpinner = false;
  bool showSpinnerForFinalUpload = false;
  bool isUploadComplete = false;

  bool isInsightImageUploadComplete = false;

  String insightImageName = "No image selected";
  File? insightImage;
  String? insightImageUrl;
  var listInsights = [];

  Future getInsightImageFromGallery() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile image =
        await (_picker.pickImage(source: ImageSource.gallery) as Future<XFile>);

    String fileName = image.path.split('/').last;
    if (fileName == null) {
      insightImageName = "No Image Selected!";
    } else {
      insightImageName = fileName;
    }

    setState(() {
      insightImage = File(image.path);
    });
  }

  Future uploadInsightImage() async {
    setState(() {
      showSpinner = true;
    });
// Points to the root reference
    var storageRef =
        FirebaseStorage.instance.ref().child('professionalInsightPicture');

// Points to 'image'
    var imagesRef =
        storageRef.child(categoryController.text + insightImageName);

    //uploads
    UploadTask uploadTask = imagesRef.putFile(insightImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    insightImageUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      isInsightImageUploadComplete = true;
      showSpinner = false;
    });
    Fluttertoast.showToast(
        msg: "Picture upload complete",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  void uploadData() {
    setState(() {
      showSpinner = true;
      showSpinnerForFinalUpload = true;
    });

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('PortfolioInsightCategory').doc();
    documentReference.set({
      'userId': UserStorage.loggedInUser.uid,
      'inLt': listInsights.length,
      'tImg': listInsights.elementAt(0)['image'],
      'id': documentReference.id,
      'time': DateTime.now()
    });
    DocumentReference secDocumentReference = FirebaseFirestore.instance
        .collection('PortfolioInsightContent')
        .doc(documentReference.id);
    secDocumentReference.set({
      'userId': UserStorage.loggedInUser.uid,
      'insight': listInsights,
      'caId': documentReference.id,
      'id': secDocumentReference.id,
      'time': DateTime.now()
    });

    setState(() {
      showSpinner = false;
      showSpinnerForFinalUpload = false;
    });
    Fluttertoast.showToast(
        msg: "Upload Complete",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);

    Navigator.pop(context);
  }

  void addInsight() {
    //TODO: validate user input
    if (isInsightImageUploadComplete == false) {
      Fluttertoast.showToast(
          msg: "Please upload an insight picture",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (categoryController.text == '') {
      Fluttertoast.showToast(
          msg: "Category title field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (categoryContentController.text == '') {
      Fluttertoast.showToast(
          msg: "Category content field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
//TODO: create the object with the input text values
      var insight = {
        "image": insightImageUrl,
        "insightTitle":
            ReusableFunctions.capitalizeWords(categoryController.text),
        "insightDescription": categoryContentController.text,
      };

      //TODO: add the object to the list
      setState(() {
        listInsights.add(insight);
        //TODO: clear the content of the text controllers
        insight = {};
        categoryContentController.clear();
        categoryController.clear();
        insightImage = null;
        insightImageName = "No image selected";
        insightImageUrl = null;
        category = null;
      });

      setState(() {
        isInsightImageUploadComplete = false;
      });
    }
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
            'Insight Edit',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(18.0),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('PortfolioInsightContent')
                        .where("userId", isEqualTo: ProfessionalStorage.id)
                        .where("id", isEqualTo: ProfileStorage.insightId)
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      ProfessionalStorage.portfolioImageClickedId =
                          ProfileStorage.insightId;
                      if (!snapshot.hasData) {
                        return Container(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: kLight_orange,
                                onPressed: () {
                                  if (UserStorage.loggedInUser.uid ==
                                      ProfessionalStorage.id) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: UploadPortfolioInsight()));
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    Text(
                                      'Select Insight',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        DocumentSnapshot insights = snapshot.data!.docs[0];

                        Map<String, dynamic> data =
                            insights.data() as Map<String, dynamic>;

                        var insightsList = data['insight'];

                        return Column(
                          children: [
                            for (var i = 0; i < insightsList.length; i++)
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ProfileStorage.insightContent =
                                          insightsList.elementAt(i);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: ViewInsight()));
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                25.0, 0.0, 0.0, 10.0),
                                            child: Text(
                                              insightsList
                                                  .elementAt(i)['insightTitle'],
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(15.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SecondImageShow(
                                            imageUrl: insightsList
                                                .elementAt(i)['image'],
                                            colour: Colors.orangeAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        15.0, 0.0, 95.0, 0.0),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }
                    }),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.asset(
                        "images/jobs/bag.svg",
                        height: ScreenUtil().setHeight(20.0),
                        width: ScreenUtil().setWidth(20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add Insight Category/Title',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: categoryController,
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                      if (category == '') {
                        setState(() {
                          category = "Category";
                        });
                      }
                    },
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: kLight_orange, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Enter Insight Category/Title',
                    ),
                  ),
                )),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Text(
                          "Insight Picture",
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(18.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            if (insightImage == null)
                              InkWell(
                                onTap: () {
                                  getInsightImageFromGallery();
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "images/jobs/clogo.svg",
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                  getInsightImageFromGallery();
                                },
                                child: Row(
                                  children: [
                                    Image.file(
                                      insightImage!,
                                      width: 45.0,
                                      height: 44.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.black,
                                      ),
                                      // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                      height: ScreenUtil().setHeight(20.0),
                                      width: ScreenUtil().setWidth(60.0),
                                      margin: EdgeInsets.fromLTRB(
                                          40.0, 10.0, 40.0, 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          uploadInsightImage();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'upload',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 20.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                insightImageName,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 0.0, 95.0, 0.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Write description for $category insight',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: ScreenUtil().setHeight(240.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          maxLines: 15,
                          minLines: 10,
                          controller: categoryContentController,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kLight_orange, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            ),
                            hintText: 'Write Detailed Description',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          addInsight();
                        },
                        color: Colors.black,
                        child: Text(
                          'Add Insight',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          if (listInsights.length == 0) {
                            Fluttertoast.showToast(
                                msg: "No insight added",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          } else {
                            uploadData();
                          }
                        },
                        color: kLight_orange,
                        child: Row(
                          children: [
                            showSpinnerForFinalUpload == false
                                ? Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                    size: 25.0,
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                            Text(
                              showSpinnerForFinalUpload == true
                                  ? 'UPLOADING'
                                  : 'UPLOAD',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
