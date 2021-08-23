import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/async_processor.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg14 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg14({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg14State createState() => _PersonalReg14State();
}

class _PersonalReg14State extends State<PersonalReg14>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offset;
  TextEditingController usernameController = TextEditingController();
  String personalUsername = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool showLoadingWidget = false;

  //TODO: Gets username entered by the user.
  _usernameListener() {
    String uName = usernameController.text;

    setState(() {
      personalUsername = uName;
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();
    usernameController.addListener(_usernameListener);
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
                        kLogin_details,
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
                      child: SlideTransition(
                        position: offset,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //TODO: Display the label: Enter your Username.
                            Center(
                              child: Text(
                                kEnter_user_name,
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
                            Center(
                              child: TextFormField(
                                autofocus: true,
                                controller: usernameController,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.center,
                                cursorColor: kWhiteColour,
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    color: kWhiteColour,
                                    fontSize: kFont_size_18.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kWhiteColour,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kWhiteColour,
                                    ),
                                  ),
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
                                //TODO: Display a data processing indicator
                                setState(() {
                                  //TODO: Show the process widget.
                                  showLoadingWidget = true;
                                  AsyncDialog.showLoadingDialog(
                                      context, _keyLoader, showLoadingWidget);
                                });

                                //TODO: Check if the username field is empty.
                                if ((personalUsername.trim() == null) ||
                                    (personalUsername.trim() == "")) {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: kUn_error_mgs,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kSize_16.sp);
                                } else if (personalUsername.trim() != null) {
                                  //TODO: Verify if the username already exist or not.
                                  //TODO: Make a connection to the database and check if that username exist.
                                  dynamic usernameExist =
                                      await DatabaseService()
                                          .isUsernameAvailable(
                                              personalUsername.trim());
                                  if ((usernameExist != null) &&
                                      (GlobalVariables.usernameExist ==
                                          false)) {
                                    setState(() {
                                      Navigator.of(context).pop();

                                      //TODO: Store the user's username
                                      GlobalVariables.username =
                                          personalUsername.trim();

                                      //TODO: Go to the fifteenth page (Personal Account)
                                      widget.pageController.animateToPage(
                                        widget.currentPage.floor(),
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });

                                    //TODO: Display an error message.
                                    Fluttertoast.showToast(
                                      msg: kPersonal_username_exist_err,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kSize_16.sp,
                                    );
                                  }
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
                      height: MediaQuery.of(context).size.height * 0.02,
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
