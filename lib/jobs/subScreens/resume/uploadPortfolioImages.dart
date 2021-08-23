import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class UploadPortfolioImages extends StatefulWidget {
  @override
  _UploadPortfolioImagesState createState() => _UploadPortfolioImagesState();
}

class _UploadPortfolioImagesState extends State<UploadPortfolioImages> {
  final TextEditingController categoryController = TextEditingController();
  String category = "Category";
  String _error = 'No Pictures Added';
  List<Asset> images = [];
  bool showSpinner = false;
  bool isUploadComplete = false;

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  Future<List<String>> uploadProductImages(List<File> productImages) async {
    String _productImagePath = 'prtImg/';
    List<String> uploadedImages = [];

    for (File file in productImages) {
      UploadTask storageUploadTask = FirebaseStorage.instance
          .ref()
          .child(_productImagePath +
              UserStorage.loggedInUser.uid +
              '/' +
              'portfolioImg' +
              DateTime.now().toString())
          .putFile(file);

      final TaskSnapshot downloadUrl = (await storageUploadTask);

      final String url = (await downloadUrl.ref.getDownloadURL());
      uploadedImages.add(url);
    }
    setState(() {
      isUploadComplete = true;
    });

    return uploadedImages;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Sparks App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<List<String>> saveImages(List<Asset> portfolioImages) async {
    if (portfolioImages.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Select Images",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    setState(() {
      showSpinner = true;
    });
    List<String> uploadedImages = [];

    for (Asset asset in portfolioImages) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      var storageRef =
          FirebaseStorage.instance.ref().child('AllPortfolioImages');

// Points to 'image'
      var storageUploadTask =
          storageRef.child("portfolioImg${DateTime.now().toString()}");

      UploadTask uploadTask = storageUploadTask.putData(imageData as Uint8List);

      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = (await downloadUrl.ref.getDownloadURL());
      uploadedImages.add(url);
    }

    return uploadedImages;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                          'Add Photo Category/Title',
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
                      hintText: 'Enter Photo Category/Title',
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Expanded(
                    child: Text(
                      'Select Photos For $category',
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
                  height: ScreenUtil().setHeight(300.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: ScreenUtil().setHeight(300.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: images.isEmpty
                            ? Center(
                                child: RaisedButton(
                                    onPressed: () {
                                      loadAssets();
                                    },
                                    color: kLight_orange,
                                    child: Text(
                                      ' $_error',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )))
                            : buildGridView(),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        loadAssets();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              height: ScreenUtil().setHeight(40.0),
                              width: ScreenUtil().setWidth(150.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 25.0,
                                      ),
                                      Text(
                                        'Add Pictures',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          if (categoryController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please input Category Field",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          } else if (images.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please Select Pictures",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                          } else {
                            saveImages(images).then((listOfImagesUrl) {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('PortfolioImagesCategory')
                                      .doc();
                              documentReference.set({
                                'userId': UserStorage.loggedInUser.uid,
                                'cgt': ReusableFunctions.capitalizeWords(
                                    categoryController.text),
                                'clt': listOfImagesUrl.length,
                                'fImg': listOfImagesUrl[0],
                                'id': documentReference.id,
                                'time': DateTime.now()
                              });
                              DocumentReference secDocumentReference =
                                  FirebaseFirestore.instance
                                      .collection('PortfolioImagesView')
                                      .doc(documentReference.id);
                              secDocumentReference.set({
                                'userId': UserStorage.loggedInUser.uid,
                                'cgt': ReusableFunctions.capitalizeWords(
                                    categoryController.text),
                                'fImg': listOfImagesUrl,
                                'clt': listOfImagesUrl.length,
                                'likes': 0,
                                'caId': documentReference.id,
                                'id': secDocumentReference.id,
                                'time': DateTime.now()
                              });

                              setState(() {
                                showSpinner = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Upload Complete",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);

                              Navigator.pop(context);
                              images = [];
                            });
                          }
                        },
                        color: kLight_orange,
                        child: Row(
                          children: [
                            showSpinner == false
                                ? Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                    size: 25.0,
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                            Text(
                              showSpinner == true ? 'UPLOADING' : 'UPLOAD',
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
