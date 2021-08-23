import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/gender_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg7 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg7({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg7State createState() => _PersonalReg7State();
}

class _PersonalReg7State extends State<PersonalReg7>
    with TickerProviderStateMixin {
  String gender = "";
  late AnimationController _controller;
  late Animation<Offset> offset;
  Animation<double>? _fadeAnimation;
  Gender _gender = Gender.NONE;

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
                    SlideTransition(
                      position: offset,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.12,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //TODO: Display the label: Select Your Gender.
                            Center(
                              child: Text(
                                kSelect_gender,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    color: kWhiteColour,
                                    fontSize: kFont_size_22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            //TODO: Choose your gender.
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    //TODO: Male gender
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _gender = Gender.MALE;
                                          gender = "male";
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          color: _gender == Gender.MALE
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
                                            kGender_male,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                color: _gender == Gender.MALE
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
                                          0.06,
                                    ),
                                    //TODO: Female gender.
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _gender = Gender.FEMALE;
                                          gender = "female";
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          color: _gender == Gender.FEMALE
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
                                            kGender_female,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                color: _gender == Gender.FEMALE
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
                          ],
                        ),
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
                                //TODO: Check if the gender field is empty.
                                if ((gender == null) || (gender == "")) {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: kUser_gender,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kVerifying_size.sp);
                                } else {
                                  setState(() {
                                    //TODO: Store user's gender.
                                    GlobalVariables.gender = gender;

                                    //TODO: Go to the eight page (Personal Account)
                                    widget.pageController.animateToPage(
                                      widget.currentPage.floor(),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
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
