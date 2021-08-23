import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/email_validator.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg9 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg9({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg9State createState() => _PersonalReg9State();
}

class _PersonalReg9State extends State<PersonalReg9>
    with TickerProviderStateMixin {
  String _phoneNumber = "";
  String _countryCode = "";
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode? focus;
  late AnimationController _controller;
  late Animation<Offset> offset;
  Animation<double>? _fadeAnimation;

  //TODO: This function helps validate user's phone number.
  _phoneNumberListener() {
    String phone = phoneNumberController.text;

    setState(() {
      _phoneNumber = phone;
    });
  }

  @override
  void initState() {
    //TODO: Add a listener to the phoneNumberController created.
    phoneNumberController.addListener(_phoneNumberListener);
    focus = FocusNode();
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
    focus!.dispose();
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
                      child: SlideTransition(
                        position: offset,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //TODO: Display the label: Enter your phone number.
                            Center(
                              child: Text(
                                kEnter_pn,
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
                            //TODO: Displays the phone number.
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: kWhiteColour,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 3,
                                      child: CountryCodePicker(
                                        initialSelection: 'NG',
                                        favorite: ['+234', 'NG'],
                                        onInit: (countryCode) {
                                          _countryCode = countryCode.toString();
                                        },
                                        onChanged: (countryCode) {
                                          _countryCode = countryCode.toString();
                                        },
                                        textStyle: TextStyle(
                                          fontSize: kSize_13.sp,
                                          fontFamily: 'Rajdhani',
                                          color: kWhiteColour,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Flexible(
                                      flex: 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            child: TextFormField(
                                              focusNode: focus,
                                              controller: phoneNumberController,
                                              keyboardType: TextInputType.phone,
                                              textAlign: TextAlign.left,
                                              cursorColor: kWhiteColour,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  color: kWhiteColour,
                                                  fontSize: kSize_13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: kTransparent,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: kTransparent,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                //TODO: Deactivate the virtual keyboard.
                                focus!.unfocus();

                                //TODO: Validates user's phone number.
                                if (_phoneNumber.trim() == "") {
                                  //TODO; Display a toast.
                                  Fluttertoast.showToast(
                                      msg: kUser_phone_err,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kVerifying_size.sp);
                                } else if (EmailValidator.validatePhoneNumber(
                                        _phoneNumber.trim()) !=
                                    null) {
                                  Fluttertoast.showToast(
                                      msg: EmailValidator.validatePhoneNumber(
                                          _phoneNumber.trim())!,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: kLight_orange,
                                      textColor: kWhiteColour,
                                      fontSize: kVerifying_size.sp);
                                } else if (EmailValidator.validatePhoneNumber(
                                        _phoneNumber.trim()) ==
                                    null) {
                                  String numberWithoutZero =
                                      EmailValidator.removeZeroFromPhoneNumber(
                                          _phoneNumber.trim());
                                  String userPhoneNum =
                                      _countryCode + numberWithoutZero;

                                  setState(() {
                                    //TODO: Store user's phone number.
                                    GlobalVariables.phoneNumber = userPhoneNum;
                                  });

                                  //TODO: Go to the tenth page (Personal Account)
                                  widget.pageController.animateToPage(
                                    widget.currentPage.floor(),
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
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
