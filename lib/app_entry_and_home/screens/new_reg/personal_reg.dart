import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_1.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_10.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_11.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_12.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_13.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_14.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_15.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_16.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_17.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_2.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_3.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_4.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_5.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_6.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_7.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_8.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_9.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg_phone_verification.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/want_to_be_a_mentor.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/account_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg extends StatefulWidget {
  static const String id = kPersonal_reg;

  @override
  _PersonalRegState createState() => _PersonalRegState();
}

class _PersonalRegState extends State<PersonalReg>
    with TickerProviderStateMixin {
  int groupValue = 0;
  final PageController pageController = PageController();
  double? currentPage = 0.0;
  String radioChoice = "";
  AccountType? accountType;
  Widget? accountTypeChecked;
  static bool radioIsChecked = false;

  late AnimationController _controller,
      _scaleAnimationController,
      _personalScaleAnimationController,
      _ecommerceScaleAnimationController,
      _companyScaleAnimationController,
      _schoolScaleAnimationController;

  Animation<Offset>? _offsetAnimation;
  Animation<double>? _scaleAnimation,
      _scaleAnimation1,
      _scaleAnimation2,
      _scaleAnimation3,
      _scaleAnimation4;

  //TODO: Animates the check mark in the radio button.
  Widget animatedAccountTypeChecked = AnimatedCrossFade(
    crossFadeState:
        radioIsChecked ? CrossFadeState.showSecond : CrossFadeState.showSecond,
    duration: Duration(
      milliseconds: 2000,
    ),
    firstChild: Text(""),
    secondChild: FaIcon(
      FontAwesomeIcons.check,
      size: 18.0,
      color: kLight_orange,
    ),
    firstCurve: Curves.easeOut,
    secondCurve: Curves.easeIn,
    sizeCurve: Curves.bounceIn,
  );

  @override
  void initState() {
    accountType = AccountType.NONE;
    accountTypeChecked = Text("");

    //TODO: Initiates the animation attached to emoji.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));

    //TODO: Applies scale transition.
    _scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _personalScaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    _ecommerceScaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2800), vsync: this, value: 0.1);
    _companyScaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this, value: 0.1);
    _schoolScaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 3200), vsync: this, value: 0.1);

    _scaleAnimation = CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.easeIn);
    _scaleAnimation1 = CurvedAnimation(
        parent: _personalScaleAnimationController, curve: Curves.easeIn);
    _scaleAnimation2 = CurvedAnimation(
        parent: _ecommerceScaleAnimationController, curve: Curves.easeIn);
    _scaleAnimation3 = CurvedAnimation(
        parent: _companyScaleAnimationController, curve: Curves.easeIn);
    _scaleAnimation4 = CurvedAnimation(
        parent: _schoolScaleAnimationController, curve: Curves.easeIn);

    _scaleAnimationController.forward();
    _personalScaleAnimationController.forward();
    _ecommerceScaleAnimationController.forward();
    _companyScaleAnimationController.forward();
    _schoolScaleAnimationController.forward();

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleAnimationController.dispose();
    _personalScaleAnimationController.dispose();
    _ecommerceScaleAnimationController.dispose();
    _companyScaleAnimationController.dispose();
    _schoolScaleAnimationController.dispose();

    super.dispose();
  }

  //TODO: Create a progress indicator to track the user's progress.
  Widget createProgressIndicator(double progress, BuildContext context) {
    Widget? progressIndicator;

    int currentState = progress.floor();

    switch (currentState) {
      case 0:
        return customLinearIndicator(0.0, "0.0%", context);
      case 1:
        return customLinearIndicator(0.05, "5.0%", context);
      case 2:
        return customLinearIndicator(0.10, "10.0%", context);
      case 3:
        return customLinearIndicator(0.15, "15.0%", context);
      case 4:
        return customLinearIndicator(0.20, "20.0%", context);
      case 5:
        return customLinearIndicator(0.25, "25.0%", context);
      case 6:
        return customLinearIndicator(0.30, "30.0%", context);
      case 7:
        return customLinearIndicator(0.35, "35.0%", context);
      case 8:
        return customLinearIndicator(0.40, "40.0%", context);
      case 9:
        return customLinearIndicator(0.45, "45.0%", context);
      case 10:
        return customLinearIndicator(0.50, "50.0%", context);
      case 11:
        return customLinearIndicator(0.55, "55.0%", context);
      case 12:
        return customLinearIndicator(0.60, "60.0%", context);
      case 13:
        return customLinearIndicator(0.70, "70.0%", context);
      case 14:
        return customLinearIndicator(0.75, "75.0%", context);
      case 15:
        return customLinearIndicator(0.80, "80.0%", context);
      case 16:
        return customLinearIndicator(0.85, "85.0%", context);
      case 17:
        return customLinearIndicator(0.90, "90.0%", context);
      case 18:
        return customLinearIndicator(0.95, "95.0%", context);
      case 19:
        return customLinearIndicator(1.0, "100.0%", context);
      default:
        return progressIndicator!;
    }
  }

  //TODO: Custom linear progress indicator
  Widget customLinearIndicator(
      double linearProgress, String linearProgressLabel, BuildContext context) {
    Widget customLinearIndicator;

    //setState(() {
    customLinearIndicator = Padding(
      padding: EdgeInsets.all(10.0),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width * 0.4,
        lineHeight: MediaQuery.of(context).size.height * 0.005,
        percent: linearProgress,
        /*center: Text(
            linearProgressLabel,
            style: new TextStyle(
              fontSize: ScreenUtil().setSp(
                kFont_size_11,
                allowFontScalingSelf: true,
              ),
            ),
          ),*/
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: kPage_indicator,
        progressColor: kProfile,
      ),
    );
    // });

    return customLinearIndicator;
  }

  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColour,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView(
              children: <Widget>[
                //TODO: Personal Account Registration: First Page.
                PersonalReg1(
                  currentPage: 1.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Second Page.
                PersonalReg2(
                  currentPage: 2.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Third Page.
                PersonalReg3(
                  currentPage: 3.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Fourth Page.
                PersonalReg4(
                  currentPage: 4.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Fifth Page.
                PersonalReg5(
                  currentPage: 5.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Sixth Page.
                PersonalReg6(
                  currentPage: 6.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Seventh Page.
                PersonalReg7(
                  currentPage: 7.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Eight Page.
                PersonalReg8(
                  currentPage: 8.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Ninth Page.
                PersonalReg9(
                  currentPage: 9.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Phone number verification.
                PersonalPhoneVerification(
                  currentPage: 10.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Eleventh Page.
                PersonalReg10(
                  currentPage: 11.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Twelveth Page.
                PersonalReg11(
                  currentPage: 12.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Thirteenth Page.
                PersonalReg12(
                  currentPage: 13.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Fourteenth Page.
                WantToBeAMentor(
                  currentPage: 14.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Fifteenth Page.
                PersonalReg13(
                  currentPage: 15.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Sixteenth Page.
                PersonalReg14(
                  currentPage: 16.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Seventeenth Page.
                PersonalReg15(
                  currentPage: 17.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Eighteenth Page.
                PersonalReg16(
                  currentPage: 18.0,
                  pageController: pageController,
                ),
                //TODO: Personal Account Registration: Nineteenth Page.
                PersonalReg17(
                  currentPage: 19.0,
                  pageController: pageController,
                ),
              ],
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
            ),
            //TODO: Back button.
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: currentPage! > 0.0

                    ///accountGateWay. == null && currentPage! > 0.0
                    ? Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            //TODO: Go back to the previous page.
                            setState(() {
                              FocusScope.of(context).unfocus();
                              pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Card(
                              color: kProfile,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: kTransparent, width: 0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    13.0,
                                  ),
                                  bottomRight: Radius.circular(13.0),
                                ),
                              ),
                              elevation: 5.0,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: kWhiteColour,
                              ),
                            ),
                          ),
                        ),
                      )
                    : (currentPage! > 0.0 && currentPage! < 9.0)
                        ///(accountGateWay != null) && (currentPage! > 0.0 && currentPage! < 9.0)
                        ? Visibility(
                            visible: true,
                            child: GestureDetector(
                              onTap: () {
                                //TODO: Go back to the previous page.
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.14,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: Card(
                                  color: kProfile,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: kTransparent, width: 0),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        13.0,
                                      ),
                                      bottomRight: Radius.circular(13.0),
                                    ),
                                  ),
                                  elevation: 5.0,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: kWhiteColour,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (currentPage! > 9.0 && currentPage! < 14.0)
                            ///(accountGateWay != null) && (currentPage! > 9.0 && currentPage! < 14.0)
                            ? Visibility(
                                visible: true,
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO: Go back to the previous page.
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      if (currentPage! >= 11) {
                                        pageController.jumpToPage(
                                            (currentPage! - 1.0).floor());
                                      } else if (currentPage == 10) {
                                        pageController.jumpToPage(7);
                                      }
                                      /*pageController.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );*/
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    child: Card(
                                      color: kProfile,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: kTransparent, width: 0),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            13.0,
                                          ),
                                          bottomRight: Radius.circular(13.0),
                                        ),
                                      ),
                                      elevation: 5.0,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: kWhiteColour,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : (currentPage! > 9.0) ///(accountGateWay != null) && (currentPage! > 9.0)
                                ? Visibility(
                                    visible: true,
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO: Go back to the previous page.
                                        setState(() {
                                          FocusScope.of(context).unfocus();
                                          pageController.jumpToPage(7);
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        child: Card(
                                          color: kProfile,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: kTransparent, width: 0),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                13.0,
                                              ),
                                              bottomRight:
                                                  Radius.circular(13.0),
                                            ),
                                          ),
                                          elevation: 5.0,
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: kWhiteColour,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: false,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: Card(
                                        color: kProfile_reg_button,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: kWhiteColour, width: 0),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                              13.0,
                                            ),
                                            bottomRight: Radius.circular(13.0),
                                          ),
                                        ),
                                        elevation: 5.0,
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: kWhiteColour,
                                        ),
                                      ),
                                    ),
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
