import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/martial_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg8 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg8({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg8State createState() => _PersonalReg8State();
}

class _PersonalReg8State extends State<PersonalReg8>
    with TickerProviderStateMixin {
  String? _martialStatus;
  MartialStatus _martial = MartialStatus.NONE;
  late AnimationController _controller;
  late Animation<Offset> offset;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //TODO: Sparks main background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: A second faded background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/app_entry_and_home/new_images/faded_spark_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: Content of this screen starts here.
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: SizedBox(
                        child: Image(
                          width: 200.0,
                          height: 80.0,
                          image: AssetImage(
                            'images/app_entry_and_home/new_images/sparks_new_logo.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "images/app_entry_and_home/new_images/title_bg.png",
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        kTell_us,
                        style: TextStyle(
                          fontSize: kFont_size_18.sp,
                          color: kReg_title_colour,
                          fontFamily: 'Rajdhani',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //TODO: Display the label: Martial Status.
                          SlideTransition(
                            position: offset,
                            child: Center(
                              child: Text(
                                kMartial_status,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    color: kWhiteColour,
                                    fontSize: kFont_size_22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          //TODO: Choose your gender.
                          SlideTransition(
                            position: offset,
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    //TODO: Marital status: Single
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _martialStatus = "Single";
                                          _martial = MartialStatus.SINGLE;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          color:
                                              _martial == MartialStatus.SINGLE
                                                  ? kProfile
                                                  : kTransparent,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border(
                                            top: BorderSide(
                                              color: kProfile,
                                            ),
                                            right: BorderSide(
                                              color: kProfile,
                                            ),
                                            bottom: BorderSide(
                                              color: kProfile,
                                            ),
                                            left: BorderSide(
                                              color: kProfile,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            kMartial_status_1,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                color: _martial ==
                                                        MartialStatus.SINGLE
                                                    ? kWhiteColour
                                                    : kProfile,
                                                fontSize:
                                                    kFontSizeAnonynousUser.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    //TODO: Marital status: Married
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _martialStatus = "Married";
                                          _martial = MartialStatus.MARRIED;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          color:
                                              _martial == MartialStatus.MARRIED
                                                  ? kProfile
                                                  : kTransparent,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border(
                                            top: BorderSide(
                                              color: kProfile,
                                            ),
                                            right: BorderSide(
                                              color: kProfile,
                                            ),
                                            bottom: BorderSide(
                                              color: kProfile,
                                            ),
                                            left: BorderSide(
                                              color: kProfile,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            kMartial_status_2,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                color: _martial ==
                                                        MartialStatus.MARRIED
                                                    ? kWhiteColour
                                                    : kProfile,
                                                fontSize:
                                                    kFontSizeAnonynousUser.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _martialStatus = "Divorced";
                                          _martial = MartialStatus.DIVORCED;
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          color:
                                              _martial == MartialStatus.DIVORCED
                                                  ? kProfile
                                                  : kTransparent,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border(
                                            top: BorderSide(
                                              color: kProfile,
                                            ),
                                            right: BorderSide(
                                              color: kProfile,
                                            ),
                                            bottom: BorderSide(
                                              color: kProfile,
                                            ),
                                            left: BorderSide(
                                              color: kProfile,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            kMartial_status_3,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                color: _martial ==
                                                        MartialStatus.DIVORCED
                                                    ? kWhiteColour
                                                    : kProfile,
                                                fontSize:
                                                    kFontSizeAnonynousUser.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //TODO: Display progress indicator.
                          PersonalReg().createState().createProgressIndicator(
                              widget.currentPage, context),
                          //TODO: Display a circular next button.
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () async {
                                User? firebaseUser =
                                    FirebaseAuth.instance.currentUser;

                                if ((_martialStatus == null) ||
                                    (_martialStatus == "")) {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: kUser_marital,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kVerifying_size.sp);
                                } else {
                                  setState(() {
                                    //TODO: Store user's marital status.
                                    GlobalVariables.maritalStatus =
                                        _martialStatus;

                                    //TODO: Check if there is a logged in user or not
                                    if (firebaseUser == null) {
                                      //TODO: Go to the nineth page (Personal Account)
                                      widget.pageController.animateToPage(
                                        widget.currentPage.floor(),
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      //TODO: Go to the eleventh page (Personal Account)
                                      widget.pageController.jumpToPage(
                                        10,
                                      );
                                    }
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kProfile,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 42.0,
                                    color: kWhiteColour,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
