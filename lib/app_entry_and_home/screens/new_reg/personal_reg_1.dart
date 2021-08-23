import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/custom_radio/custom_radio.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/account_enum.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/company/screens/second_screen.dart';
import 'package:sparks/company/screens/username.dart';
import 'package:sparks/market/screens/market_home.dart';
import 'package:sparks/market_registration/market_reg_model/market_info.dart';
import 'package:sparks/market_registration/market_registration.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sparks/school_reg/screens/second_screen.dart';
import 'package:sparks/school_reg/screens/username_screen.dart';

class PersonalReg1 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg1({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg1State createState() => _PersonalReg1State();
}

class _PersonalReg1State extends State<PersonalReg1>
    with TickerProviderStateMixin {
  String radioChoice = "";
  AccountType? accountType;
  Widget? accountTypeChecked;
  static bool radioIsChecked = false;

  final _auth = FirebaseAuth.instance;

  /// Currently loggedIn user
  late User loggedInUser;

  bool _modalHudIndicator = false;

  late AnimationController _controller,
      _scaleAnimationController,
      _personalScaleAnimationController,
      _ecommerceScaleAnimationController,
      _companyScaleAnimationController,
      _schoolScaleAnimationController;

  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation,
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
      size: 12.0,
      color: kLight_orange,
    ),
    firstCurve: Curves.easeOut,
    secondCurve: Curves.easeIn,
    sizeCurve: Curves.bounceIn,
  );

  /// Function to get the currently logged in user
  void getCurrentUser() async {
    User? value = _auth.currentUser;
    if (value != null) {
      loggedInUser = value;
    }
    /*await _auth.currentUser().then((value) {
      if (value != null) {
        loggedInUser = value;
      }
    }).catchError((onError) {
      print("Error: $onError");
    });*/
  }

  /// Method to extract the needed info from the currently logged in user and create a Market Account
  Future<void> getMarketInfo() async {
    QuerySnapshot querySnapshot;
    // List<DocumentSnapshot> documentSnapshot = [];
    List<Map<String, dynamic>?> documentSnapshot = [];

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection("username")
          .where("id", isEqualTo: loggedInUser.uid)
          .get();

      // documentSnapshot = querySnapshot.docs;

      documentSnapshot = querySnapshot.docs.map((DocumentSnapshot doc) {
        return doc.data as Map<String, dynamic>?;
      }).toList();

      String? username;

      username = documentSnapshot[0]!['un'];

      MarketInfo marketInfo = MarketInfo(
        id: loggedInUser.uid,
        un: username,
        em: loggedInUser.email,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("Market")
          .doc("marketInfo")
          .set(marketInfo.toJson());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedInUser.uid)
          .update({
        "acct": FieldValue.arrayUnion(
          [
            {
              "act": "Market",
              "dp": false,
            }
          ],
        )
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> marketConfirmCreation(context) async {
    return showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          'Are you sure you want to create Market Account?',
          style: GoogleFonts.rajdhani(
            fontSize: ScreenUtil().setSp(20),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: Text(
              'Yes',
              style: GoogleFonts.rajdhani(
                fontSize: ScreenUtil().setSp(18),
                color: Colors.green,
                fontWeight: FontWeight.w800,
              ),
            ),
            onPressed: () async {
              print("Yes pressed!");
              Navigator.pop(context);
              setState(() {
                _modalHudIndicator = true;
              });

              await getMarketInfo().then((value) {
                setState(() {
                  _modalHudIndicator = false;
                  Navigator.pushReplacementNamed(context, MarketHome.id);
                });
              }).catchError((onError) {
                print(onError);
              });
            },
          ),
          PlatformDialogAction(
            child: Text(
              "No",
              style: GoogleFonts.rajdhani(
                fontSize: ScreenUtil().setSp(18),
                color: Colors.red,
                fontWeight: FontWeight.w800,
              ),
            ),
            onPressed: () {
              print("No pressed!");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getCurrentUser();

    accountType = AccountType.NONE;
    accountTypeChecked = Text("");

    //TODO: Initializes the animation attached to emoji.
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _modalHudIndicator,
      dismissible: false,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //TODO: Sparks main background.
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            )),
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
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                //TODO: Display company logo.
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SizedBox(
                      child: Image(
                        width: 150.0,
                        height: 60.0,
                        image: AssetImage(
                          'images/app_entry_and_home/new_images/sparks_new_logo.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ),
                    //TODO: handles the emojticon and the radio buttons.
                    Flexible(
                      flex: 9,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Center(
                              child: SlideTransition(
                                position: _offsetAnimation,
                                child: SvgPicture.asset(
                                  "images/app_entry_and_home/new_images/smile.svg",
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Center(
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                alignment: Alignment.center,
                                child: Text(
                                  kAcct_type,
                                  style: TextStyle(
                                    fontSize: kFont_size.sp,
                                    fontFamily: 'Rajdhani',
                                    color: kWhiteColour,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  //TODO: A list of radio buttons displaying all the account types.
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //TODO: For Personal
                                            GlobalVariables.accountType
                                                    .contains("Personal")
                                                ? SizedBox()
                                                : FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: ScaleTransition(
                                                      scale: _scaleAnimation1,
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomRadio(
                                                        radioTag: kAcct_type_1,
                                                        radioSelected:
                                                            () async {
                                                          setState(() {
                                                            accountType =
                                                                AccountType
                                                                    .PERSONAL;
                                                            radioChoice =
                                                                "Personal";

                                                            //TODO: Store the user's choice.
                                                            GlobalVariables
                                                                .accountSelected = {
                                                              "act":
                                                                  radioChoice,
                                                              "dp": true,
                                                            };

                                                            //TODO: Go to the second page (Personal Account)
                                                            widget
                                                                .pageController
                                                                .animateToPage(
                                                              widget.currentPage
                                                                  .floor(),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              curve: Curves
                                                                  .easeInOut,
                                                            );
                                                          });
                                                        },
                                                        radioChecked: accountType ==
                                                                AccountType
                                                                    .PERSONAL
                                                            ? animatedAccountTypeChecked
                                                            : accountTypeChecked,
                                                      ),
                                                    ),
                                                  ),
                                            //TODO: For Market
                                            //Not ready yet
                                            /*GlobalVariables.accountType.contains("Market")
                                                ? SizedBox()
                                                : FittedBox(
                                              fit: BoxFit.contain,
                                              child: ScaleTransition(
                                                scale: _scaleAnimation2,
                                                alignment: Alignment.center,
                                                child: CustomRadio(
                                                  radioTag: kAcct_type_2,
                                                  radioSelected: () {
                                                    setState(() {
                                                      accountType =
                                                          AccountType.MARKET;
                                                      radioChoice = "Market";

                                                      //TODO: Store the user's choice.
                                                      GlobalVariables
                                                          .accountSelected = {
                                                        "act": radioChoice,
                                                        "dp": true,
                                                      };

                                                      if (loggedInUser != null) {
                                                        marketConfirmCreation(
                                                            context);
                                                      } else {
                                                        Navigator.pushNamed(context,
                                                            MarketRegistration.id);
                                                      }
                                                    });
                                                  },
                                                  radioChecked: accountType ==
                                                      AccountType.MARKET
                                                      ? animatedAccountTypeChecked
                                                      : accountTypeChecked,
                                                ),
                                              ),
                                            ),*/
                                            //TODO: For Company
                                            GlobalVariables.accountType
                                                    .contains("Company")
                                                ? SizedBox()
                                                : FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: ScaleTransition(
                                                      scale: _scaleAnimation3,
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomRadio(
                                                        radioTag: kAcct_type_3,
                                                        radioSelected: () {
                                                          setState(() {
                                                            accountType =
                                                                AccountType
                                                                    .COMPANY;
                                                            radioChoice =
                                                                "Company";

                                                            //TODO: Store the user's choice.
                                                            GlobalVariables
                                                                .accountSelected = {
                                                              "act":
                                                                  radioChoice,
                                                              "dp": true,
                                                            };

                                                            //TODO: For the company registration, this is your entry point.

                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SecondScreen()));
                                                          });
                                                        },
                                                        radioChecked: accountType ==
                                                                AccountType
                                                                    .COMPANY
                                                            ? animatedAccountTypeChecked
                                                            : accountTypeChecked,
                                                      ),
                                                    ),
                                                  ),
                                            //TODO: For School
                                            GlobalVariables.accountType
                                                    .contains("School")
                                                ? SizedBox()
                                                : FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: ScaleTransition(
                                                      scale: _scaleAnimation4,
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomRadio(
                                                        radioTag: kAcct_type_4,
                                                        radioSelected: () {
                                                          setState(() {
                                                            accountType =
                                                                AccountType
                                                                    .SCHOOL;
                                                            radioChoice =
                                                                "School";

                                                            //TODO: Store the user's choice.
                                                            GlobalVariables
                                                                .accountSelected = {
                                                              "act":
                                                                  radioChoice,
                                                              "dp": true,
                                                            };

                                                            //TODO: For the school registration, this is your entry point.
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SchoolSecondScreen()));
                                                          });
                                                        },
                                                        radioChecked: accountType ==
                                                                AccountType
                                                                    .SCHOOL
                                                            ? animatedAccountTypeChecked
                                                            : accountTypeChecked,
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
