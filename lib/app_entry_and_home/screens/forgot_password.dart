import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/email_validator.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_login_screen.dart';
import 'package:sparks/app_entry_and_home/services/auth.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ResetPassword extends StatefulWidget {
  static String id = kForgotPass;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late String _emailAddress;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'images/app_entry_and_home/sparksbg.png',
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      child: Center(
                        child: Image.asset(
                          "images/app_entry_and_home/brand.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              kPassword_reset,
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                                color: kWhiteColour,
                                fontSize: kEmail_Verification_Size.sp,
                              ),
                            ),
                            Text(
                              kPasword_reset_subTitle,
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                color: kWhiteColour,
                                fontSize: kFont_size.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.12,
                        right: MediaQuery.of(context).size.height * 0.08,
                      ),
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        maxLength: 50,
                        maxLengthEnforced: true,
                        cursorColor: kWhiteColour,
                        style: TextStyle(
                          color: kWhiteColour,
                        ),
                        decoration: InputDecoration(
                          hintText: kEmailHint,
                          counterStyle: TextStyle(
                            color: kWhiteColour,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                          ),
                          icon: Icon(
                            Icons.mail_outline,
                            color: kWhiteColour,
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kWhiteColour,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: kWhiteColour,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                            fontSize: kFormErrorFontSize,
                            color: kFormErrorMessageColour,
                          ),
                        ),
                        validator: (valuePassed) {
                          if (valuePassed!.isEmpty)
                            return 'Enter your email address.';
                          else if (EmailValidator.validateEmail(valuePassed) !=
                              null)
                            return EmailValidator.validateEmail(valuePassed);
                          else
                            return null;
                        },
                        onSaved: (valuePassed) {
                          setState(() {
                            _emailAddress = valuePassed!.trim();
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07,
                        right: MediaQuery.of(context).size.height * 0.05,
                      ),
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            minHeight:
                                MediaQuery.of(context).size.height * 0.05,
                          ),
                          child: Text(
                            kResetPassword_info,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kFontSizeAnonynousUser.sp,
                              fontFamily: 'Rajdhani',
                              color: kWhiteColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07,
                        right: MediaQuery.of(context).size.height * 0.05,
                      ),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            //TODO: Retrieve the user's email and send a password reset link to it
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              dynamic message = await _authService
                                  .passwordRecovery(_emailAddress);
                              if (message != null) {
                                scaffoldKey.currentState!.showSnackBar(
                                  SnackBar(
                                    backgroundColor: kResendColor,
                                    duration: Duration(seconds: 5),
                                    content: Row(
                                      children: <Widget>[
                                        Icon(Icons.email),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        Text(message),
                                      ],
                                    ),
                                  ),
                                );

                                //TODO: Route the user to the sign in screen.
                                Navigator.pushNamed(
                                    context, SparksLoginScreen.id);
                              }
                            }
                          },
                          child: Image.asset(
                              'images/app_entry_and_home/sendemail.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
