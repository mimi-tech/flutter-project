import 'dart:io';
// // import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/alumni/color/colors.dart';
import '../activities_create_chapter.dart';
import 'package:page_transition/page_transition.dart';
import '../strings.dart';
import 'package:sparks/Alumni/schoolAdmin_profile/createdadmin_viewall.dart';
import 'package:sparks/Alumni/schoolAdmin_profile/createdchapter_viewall.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

_changeText() {}

class _ViewProfileState extends State<ViewProfile> {
  final picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  File? selectedImage;

  String? imageUrl;

  Widget _selectPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Delete",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Save post",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        initialValue: 0,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        offset: Offset(0, 100),
        icon: Icon(Icons.more_vert),
      );

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

  @override
  Widget build(BuildContext context) {
    Widget images_carousel = Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage("images/alumni/friends.jpg"),
          AssetImage("images/alumni/testing.png"),
          AssetImage("images/alumni/friends2.jpg"),
          AssetImage("images/alumni/friends3.jpg"),
        ],
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 100),
        dotSize: 2.0,
        dotIncreasedColor: kADeepOrange,
        dotSpacing: 8.0,
        indicatorBgPadding: 3.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My profile',
          style: TextStyle(
            fontFamily: "Rajdhani",
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: kABlack,
          ),
        ),
        backgroundColor: kAWhite,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  imageOptions();
                },
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                          width: 150.0,
                          height: 150.0,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150.0, height: 150.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          // padding:  const EdgeInsets.only(top: 30.0, left: 10.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt_sharp,
                              color: kAWhite,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "andre lyon",
                style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: kABlack,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "andrelyon78@gmail.com",
                style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: kABlack,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "images/alumni/college_admin.svg",
                    height: 17.0,
                    width: 17.0,
                  ),
                  Text(
                    " || ",
                  ),
                  Text(
                    "Harvard university Admin",
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: kABlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Container(
                      child: SvgPicture.asset(
                        "images/alumni/school_location.svg",
                        height: 16.0,
                        width: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    " || ",
                  ),
                  Text(
                    "Cambridge, MA, United States",
                    style: TextStyle(
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: kABlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                elevation: 2.0,
                color: kALightRed,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "School Admin",
                    style: new TextStyle(
                      color: kABlack,
                      fontSize: 15.0,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: AdminViewAll()));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.deepOrangeAccent,
                                      Colors.deepOrange
                                    ]),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 120.0,
                                  maxHeight: 40.0,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Created admin",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: ChapterViewAll()));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.deepOrangeAccent,
                                      Colors.deepOrange
                                    ]),
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 120.0,
                                  maxHeight: 40.0,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Created chapter",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
