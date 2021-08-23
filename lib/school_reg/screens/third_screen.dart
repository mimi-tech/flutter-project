import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/school_reg/country.dart';
import 'package:sparks/school_reg/sch_constants.dart';
import 'package:sparks/school_reg/screens/fourth_screen.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sparks/school_reg/state.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ThirdScreen extends StatefulWidget {
  final offsetBool;
  final double? widthSlide;
  ThirdScreen({Key? key, this.offsetBool, this.widthSlide}) : super(key: key);
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen>
    with TickerProviderStateMixin {
  bool userNameVisible = false;
  late Animation<Offset> animation;
  late AnimationController animationController;

  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  Future getImageFromGallery() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      Constants.logoImage = File(image!.path);
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });

    //ToDo:second animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // Don't forget to dispose the animation controller on class destruction
    animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/company/sparksbg.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  //ToDo: The arrow for going back
                  SingleChildScrollView(
                    child: Logo(),
                  ),
                  Column(
                    children: <Widget>[
                      //ToDo:company details
                      SchoolConstants(details: kSchoolLogo),

                      //ToDo:displaying company logo

                      SlideTransition(
                        position: animation,
                        child: Align(
                          alignment: Alignment.center,
                          child: Constants.logoImage == null
                              ? GestureDetector(
                                  onTap: () {
                                    getImageFromGallery();
                                  },
                                  child: SvgPicture.asset(
                                    'images/company/companylogo.svg',
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 40.0,
                                  child: ClipOval(
                                    child: Image.file(
                                      Constants.logoImage!,
                                      width: ScreenUtil().setWidth(100.0),
                                      height: ScreenUtil().setHeight(100),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        ),
                      ),
                      Text(
                        kSchoolLogoText,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kWhitecolor,
                          fontFamily: 'Rajdhani',
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: ScreenUtil().setHeight(kCompspace2)),

                  Center(
                    child: SlideTransition(
                      position: _offsetFloat,
                      child: Text(
                        kSchlocation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: kSsuploadcontbtn,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
//ToDo:get the company country and state
                  SizedBox(height: ScreenUtil().setHeight(kCompspace2)),

                  CompanyCountry(),
                  SizedBox(height: ScreenUtil().setHeight(kCompspace2)),
                  CompanyState(),

                  //ToDo:Enter Company username
                  SizedBox(height: ScreenUtil().setHeight(kCompspace2)),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: SlideTransition(
                            position: animation,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                LinearPercentIndicator(
                                  width: ScreenUtil().setWidth(160.0),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.4,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: kFbColor,
                                  backgroundColor: kComlinearprogressbar,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      goToNext();
                                    },
                                    child: CircleAvatar(
                                      radius: 30.0,
                                      child: Image(
                                        height: ScreenUtil().setHeight(70.0),
                                        width: ScreenUtil().setWidth(70.0),
                                        image: AssetImage(
                                            'images/company/next.png'),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }

  void goToNext() {
    if (Constants.selectedCountry == null) {
      Fluttertoast.showToast(
          msg: kCompanyselectserror,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (Constants.selectedState == null) {
      Fluttertoast.showToast(
          msg: kCompanyselectcerror,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if (Constants.logoImage == null) {
      Fluttertoast.showToast(
          msg: 'Please give us your school logo',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FourthScreen()));
    }
  }
}
