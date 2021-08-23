import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market_registration/m_reg_const.dart';
import 'package:sparks/market_registration/m_reg_email_ver.dart';
import 'package:sparks/market_registration/m_reg_strings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/market_registration/market_reg_global_variables.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sparks/market_registration/market_reg_model/market_info.dart';

class MarketRegistration extends StatefulWidget {
  static String id = "market_registration";

  @override
  _MarketRegistrationState createState() => _MarketRegistrationState();
}

class _MarketRegistrationState extends State<MarketRegistration> {
  /// ModalProgressHud activator boolean value
  bool _creatingUser = false;

  /// Temporary store of the user's chosen fields
  String? _username;
  late String _phoneNumber;

  late String _countryCode;

  /// FocusNodes for all the TextFields
  final FocusNode _userNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNumNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  /// Form key for the market registration form
  final _formKey = GlobalKey<FormState>();

  /// Initializing FirebaseAuth Service
  final _auth = FirebaseAuth.instance;

  /// Controller for the phone verification alert dialog
  TextEditingController? _smsCodeController;

  late String _smsCode;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late MarketInfo marketInfo;

  TextStyle textStyle = GoogleFonts.rajdhani(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  /// Pop-up message when there's an error while signing up user
  void showToastMessage(String errorMessage, ToastGravity gravity) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white70,
      gravity: gravity,
    );
  }

  /// Function to remove "0" from user's inputted phone number
  String removeZeroAndAddCountryCode(String phoneNumber) {
    String formattedPhoneNumber;

    String removeZero = phoneNumber.substring(0, 1);

    if (removeZero == "0") {
      formattedPhoneNumber =
          _countryCode + (phoneNumber.substring(1, phoneNumber.length));
    } else {
      formattedPhoneNumber = _countryCode + phoneNumber;
    }

    return formattedPhoneNumber;
  }

  Future<String?> getDeviceID() async {
    String? phoneToken;
    await _firebaseMessaging.getToken().then((tokenID) {
      phoneToken = tokenID;
    }).catchError((onError) {
      print(onError);
    });

    return phoneToken;
  }

  /// Function to check is the chosen username exist in the Sparks Database
  Future<bool?> isUsernameAvailable(String personalUsername) async {
    bool? userNameAvailable;
    await FirebaseFirestore.instance
        .collection('username')
        .where("un", isEqualTo: personalUsername)
        .get()
        .then((value) {
      if (value.docs.length == 1) {
        userNameAvailable = false;
      } else {
        userNameAvailable = true;
      }
    }).catchError((onError) {
      showToastMessage("Error checking username", ToastGravity.BOTTOM);
    });
    return userNameAvailable;
  }

  /// Function to upload the user's data to Firebase
  Future<void> _uploadUsersDataToFirebase(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Market')
          .doc("marketInfo")
          .set(marketInfo.toJson());

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "acct": [
          {
            "act": "Market",
            "dp": true,
          }
        ],
        "tkn": [
          MarketRegGlobalVariables.phoneToken,
        ],
        "ol": true,
        "phne": [
          {
            "ph": MarketRegGlobalVariables.phoneNumber,
            "pnVd": MarketRegGlobalVariables.userPhoneId
          }
        ],
      });

      await FirebaseFirestore.instance
          .collection('username')
          .doc(user.uid)
          .set({
        'un': _username,
        'id': user.uid,
      });
    } catch (e) {
      showToastMessage(
          "Something went wrong. Check your internet connection and try again",
          ToastGravity.BOTTOM);
    }
  }

  /// Function to verify user's phone number and if verified proceeds to upload user's data to Firebase
  ///
  /// NOTE: This function should automatically retrieve the verification code sent to the user from Firebase
  Future<void> _verifyUsersPhoneNumber(context) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: removeZeroAndAddCountryCode(_phoneNumber.trim()),
        timeout: const Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {
          print("Auto verification running");
          try {
            UserCredential authResult =
                await _auth.signInWithCredential(credential);

            if (authResult.user != null) {
              MarketRegGlobalVariables.isPhoneNumberVerified = true;
              MarketRegGlobalVariables.userPhoneId = authResult.user!.uid;

              // UserCredential paerish = await _auth.signInWithEmailAndPassword(
              //     email: "dkjkdfjf", password: "ksjdlkf");
              //
              // authResult.user
              //     .linkWithCredential(paerish.credential)
              //     .then((value) {
              //   User kcHead = value.user;
              // }).catchError((onError) {
              //   print(onError.toString());
              // });

              _formKey.currentState!.save();

              _auth.signOut();

              UserCredential result =
                  await _auth.createUserWithEmailAndPassword(
                      email: MarketRegGlobalVariables.email!,
                      password: MarketRegGlobalVariables.password);

              User? user = result.user;

              if (user != null) {
                MarketRegGlobalVariables.phoneToken = await getDeviceID();

                marketInfo = MarketInfo(
                  id: user.uid,
                  un: MarketRegGlobalVariables.username,
                  em: MarketRegGlobalVariables.email,
                  emv: false,
                );

                await _uploadUsersDataToFirebase(user);

                await user.sendEmailVerification();

                setState(() {
                  _creatingUser = false;
                });

                Navigator.pushReplacementNamed(context, MarketRegEmailVer.id);
              }
            }
          } catch (e) {
            showToastMessage("Error creating account with phone number",
                ToastGravity.BOTTOM);
            setState(() {
              _creatingUser = false;
            });
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          showToastMessage(authException.message!, ToastGravity.BOTTOM);
          setState(() {
            _creatingUser = false;
          });
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          print("Code sent running");
          _showMyDialog(verificationId, context);
        },
        codeAutoRetrievalTimeout: (String value) {
          /// Do something here...
        },);
  }

  /// NOTE: This method only gets activated when auto-retrieval of Firebase verification code from the user's device fails
  Future<void> _showMyDialog(String verificationId, context) async {
    print("Show dialog: $verificationId");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            "Verify your phone number",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.w700,
              fontSize: ScreenUtil().setSp(20),
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Enter code here",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Resend',
                style: textStyle.copyWith(color: Colors.black87),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _creatingUser = true;
                });
                showToastMessage("Code resend successful", ToastGravity.BOTTOM);
                await _verifyUsersPhoneNumber(context);
              },
            ),
            SizedBox(
              width: ScreenUtil().setWidth(56),
            ),
            FlatButton(
              child: Text(
                'Verify',
                style: textStyle,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _creatingUser = true;
                });

                _smsCode = _smsCodeController!.text.trim();

                print("SMS code $_smsCode");

                try {
                  AuthCredential _credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: _smsCode);

                  UserCredential authResult =
                      await _auth.signInWithCredential(_credential);

                  if (authResult.user != null) {
                    print("Phone number sign up successful");

                    MarketRegGlobalVariables.isPhoneNumberVerified = true;
                    MarketRegGlobalVariables.userPhoneId = authResult.user!.uid;

                    print("Phone UID: ${MarketRegGlobalVariables.userPhoneId}");

                    _formKey.currentState!.save();

                    _auth.signOut();

                    print("Sign out successful");

                    UserCredential result =
                        await _auth.createUserWithEmailAndPassword(
                            email: MarketRegGlobalVariables.email!,
                            password: MarketRegGlobalVariables.password);

                    User? user = result.user;

                    if (user != null) {
                      MarketRegGlobalVariables.phoneToken = await getDeviceID();

                      marketInfo = MarketInfo(
                        id: user.uid,
                        un: MarketRegGlobalVariables.username,
                        em: MarketRegGlobalVariables.email,
                        emv: false,
                      );

                      await _uploadUsersDataToFirebase(user);

                      await user.sendEmailVerification();

                      setState(() {
                        _creatingUser = false;
                      });

                      Navigator.pushReplacementNamed(
                          context, MarketRegEmailVer.id);
                    }
                  }
                } catch (e) {
                  showToastMessage(
                      "Error creating account with phone", ToastGravity.BOTTOM);
                  setState(() {
                    _creatingUser = false;
                  });
                }
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: textStyle.copyWith(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _creatingUser = false;
                  _smsCodeController!.text = "";
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _smsCodeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _smsCodeController!.dispose();
    _userNameNode.dispose();
    _phoneNumNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialisation of the ScreenUtil package

    /// Screen size of device
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _creatingUser,
          child: Container(
            height: mediaQuery.height,
            width: mediaQuery.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/app_entry_and_home/sparksbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: mediaQuery.height),
                child: Column(
                  children: <Widget>[
                    /// Widget for the the Sparks logo and back-button
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: ScreenUtil().setHeight(56),
                                width: ScreenUtil().setWidth(56),
                                decoration: BoxDecoration(
                                  color: Color(0xffFF502F),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: mediaQuery.width * 0.32,
                              color: Colors.transparent,
                              child: Image(
                                image: AssetImage(
                                    'images/m_registration_images/sparks_logo.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.03,
                    ),

                    /// Widget for the header of the form 'E-commerce Sign Up'
                    Center(
                      child: Container(
                        width: mediaQuery.width * 0.88,
                        height: mediaQuery.height * 0.07,
                        decoration: BoxDecoration(
                          color: kFormHeaderColor.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            kMRegEcommerceSignUp,
                            style: kFormHeaderTextStyle,
                          ),
                        ),
                      ),
                    ),

                    /// Stack containing the Form & Sign Up button
                    Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: <Widget>[
                        /// E-Commerce Sign Up form Widget
                        Container(
                          padding: EdgeInsets.only(
                              top: 24.0, right: 32.0, left: 32.0, bottom: 24.0),
                          width: mediaQuery.width * 0.88,
                          height: mediaQuery.height * 0.56,
                          decoration: BoxDecoration(
                            color: kFormBodyColor.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  /// Username TextFormField
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    maxLength: 20,
                                    maxLengthEnforced: true,
                                    cursorColor: kFormPrimaryColor,
                                    style: kFormContentTextStyle,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _userNameNode,
                                    onFieldSubmitted: (term) {
                                      _userNameNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_phoneNumNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: kMRegUserName,
                                      counterStyle: TextStyle(
                                        color: kFromContentColor,
                                      ),
                                      prefixIcon: IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'images/m_registration_images/user_avatar.svg',
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFromContentColor,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFormPrimaryColor,
                                        ),
                                      ),
                                      hintStyle: kFormOverrideTextStyle,
                                      errorStyle:
                                          kFormOverrideTextStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return kUserNameErrorOne;
                                      else if (value.length < 2)
                                        return KUserNameErrorTwo;
                                      else
                                        return null;
                                    },
                                    onChanged: (value) {
                                      _username = value;
                                    },
                                    onSaved: (value) {
                                      MarketRegGlobalVariables.username =
                                          value!.trim();
                                    },
                                  ),
                                  SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  ),

                                  /// Phone Number TextFormField
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    maxLines: 1,
                                    maxLength: 18,
                                    maxLengthEnforced: true,
                                    cursorColor: kFormPrimaryColor,
                                    style: kFormContentTextStyle,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _phoneNumNode,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    onFieldSubmitted: (term) {
                                      _phoneNumNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_emailNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: kMRegPhoneNumber,
                                      prefixIcon: CountryCodePicker(
                                        padding: EdgeInsets.only(bottom: 4.0),
                                        initialSelection: 'NG',
                                        favorite: ['+234', 'NG'],
                                        onInit: (countryCode) {
                                          _countryCode = countryCode.toString();
                                        },
                                        onChanged: (countryCode) {
                                          _countryCode = countryCode.toString();
                                        },
                                        textStyle: GoogleFonts.rajdhani(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                        color: kFromContentColor,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFromContentColor,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFormPrimaryColor,
                                        ),
                                      ),
                                      hintStyle: kFormOverrideTextStyle,
                                      errorStyle:
                                          kFormOverrideTextStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^([0-9]+[0-9]*$)';
                                      RegExp regex = new RegExp(pattern as String);
                                      if (value!.isEmpty) {
                                        return kPhoneNumErrorOne;
                                      } else if (value.length < 4) {
                                        return kPhoneNumErrorTwo;
                                      } else if (!regex.hasMatch(value)) {
                                        return kPhoneNumErrorThree;
                                      } else
                                        return null;
                                    },
                                    onChanged: (value) {
                                      _phoneNumber = value;
                                      if (value.length == 3) {
                                        showToastMessage(
                                            "This number will be verified",
                                            ToastGravity.CENTER);
                                      }
                                    },
                                    onSaved: (value) {
                                      MarketRegGlobalVariables.phoneNumber =
                                          removeZeroAndAddCountryCode(
                                              value!.trim());

                                      print(
                                          "Save Phone Number: ${MarketRegGlobalVariables.phoneNumber}");
                                    },
                                  ),

                                  SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  ),

                                  /// Email TextFormField
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    maxLengthEnforced: true,
                                    cursorColor: kFormPrimaryColor,
                                    style: kFormContentTextStyle,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _emailNode,
                                    onFieldSubmitted: (term) {
                                      _emailNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_passwordNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: kMRegEmail,
                                      counterStyle: TextStyle(
                                        color: kFromContentColor,
                                      ),
                                      prefixIcon: IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'images/m_registration_images/mail_icon.svg',
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFromContentColor,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFormPrimaryColor,
                                        ),
                                      ),
                                      hintStyle: kFormOverrideTextStyle,
                                      errorStyle:
                                          kFormOverrideTextStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                                      RegExp regex = new RegExp(pattern as String);
                                      if (value!.isEmpty) {
                                        return kEmailErrorOne;
                                      } else if (!regex.hasMatch(value)) {
                                        return kEmailErrorTwo;
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      MarketRegGlobalVariables.email =
                                          value!.trim();
                                    },
                                  ),
                                  SizedBox(
                                    height: mediaQuery.height * 0.04,
                                  ),

                                  /// Password TextFormField
                                  TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    maxLengthEnforced: true,
                                    cursorColor: kFormPrimaryColor,
                                    style: kFormContentTextStyle,
                                    textInputAction: TextInputAction.done,
                                    focusNode: _passwordNode,
                                    onFieldSubmitted: (term) {
                                      _emailNode.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: kMRegPassword,
                                      counterStyle: TextStyle(
                                        color: kFromContentColor,
                                      ),
                                      prefixIcon: IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'images/m_registration_images/password_icon.svg',
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFromContentColor,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kFormPrimaryColor,
                                        ),
                                      ),
                                      hintStyle: kFormOverrideTextStyle,
                                      errorStyle:
                                          kFormOverrideTextStyle.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^([a-zA-Z0-9@*#]{8,})$';
                                      RegExp regex = new RegExp(pattern as String);
                                      if (value!.isEmpty) {
                                        return kPswdErrorOne;
                                      } else if (!regex.hasMatch(value))
                                        return kPswdErrorTwo;
                                      else
                                        return null;
                                    },
                                    onSaved: (value) {
                                      MarketRegGlobalVariables.password =
                                          value!.trim();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// Widget for the 'Sign Up' button
                        Positioned(
                          top: mediaQuery.height * 0.52,
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 24.0),
                              decoration: BoxDecoration(
                                color: kFormBodyColor.withOpacity(0.15),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 6.0),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                color: kMarketPrimaryColor,
                                child: Text(
                                  kMRegSignUp,
                                  style: kMFormSignUpTextStyle,
                                ),
                                onPressed: () async {
                                  /// Un-focus the onscreen keyboard
                                  FocusScope.of(context).unfocus();

                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _creatingUser = true;
                                    });
                                    bool? isUserNameAvailable;

                                    /// Checking for the availability of the user's chosen username
                                    try {
                                      await isUsernameAvailable(
                                              _username!.trim())
                                          .then((value) {
                                        isUserNameAvailable = value;
                                      });

                                      /// Perform this if the username is available
                                      if (isUserNameAvailable!) {
                                        /// Verifying the user's phone number
                                        ///
                                        /// NOTE: The "context" is passed from the "Buildcontext" into the [_verifyUsersPhoneNumber] function
                                        /// and then also passed into the [_showMyDialog] function so as to target the right "context"
                                        await _verifyUsersPhoneNumber(context);
                                      } else {
                                        setState(() {
                                          _creatingUser = false;
                                        });
                                        showToastMessage(
                                            "Username already exists, please choose another",
                                            ToastGravity.BOTTOM);
                                      }
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        _creatingUser = false;
                                      });
                                      showToastMessage(
                                          "An error occurred, please try again",
                                          ToastGravity.BOTTOM);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.06,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          kMRegOr,
                          style: kFormContentTextStyle,
                        ),
                        SizedBox(
                          height: mediaQuery.height * 0.02,
                        ),

                        /// Take a Tour button
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 8.0),
                          color: Color(0xff02B5EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/m_registration_images/tour_flag.svg',
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(8),
                              ),
                              Text(
                                kMRegTakeATour,
                                style: kMTourButton,
                              ),
                            ],
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
    );
  }
}
