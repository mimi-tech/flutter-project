import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/async_processor.dart';
import 'package:sparks/app_entry_and_home/reusables/email_validator.dart';
import 'package:sparks/app_entry_and_home/screens/forgot_password.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'package:sparks/app_entry_and_home/services/auth.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  late String _email;
  late String _password;
  String _errorMgs = '';
  bool showLoadingWidget = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.09,
              left: MediaQuery.of(context).size.width * 0.13,
              right: MediaQuery.of(context).size.width * 0.13,
            ),
            height: MediaQuery.of(context).size.height * 0.46,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  maxLength: 50,
                  maxLengthEnforced: true,
                  cursorColor: kWhiteColour,
                  style: TextStyle(
                    color: kWhiteColour,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: kEmailHint,
                    counterStyle: TextStyle(
                      color: kWhiteColour,
                    ),
                    icon: Icon(
                      Icons.mail_outline,
                      color: kWhiteColour,
                    ),
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
                    else if (EmailValidator.validateEmail(valuePassed) != null)
                      return EmailValidator.validateEmail(valuePassed);
                    else
                      return null;
                  },
                  onSaved: (valuePassed) {
                    setState(() {
                      _email = valuePassed!.trim();
                    });
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.002,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  cursorColor: kWhiteColour,
                  style: TextStyle(
                    color: kWhiteColour,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: kPasswordHint,
                    icon: Icon(
                      Icons.lock,
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
                  validator: (valuePassed) => valuePassed!.length < 8
                      ? 'Enter a password, minimum of 8 characters'
                      : null,
                  onSaved: (valuePassed) {
                    setState(() {
                      _password = valuePassed!.trim();
                    });
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () async {
                          /*dynamic user = await _authService.signInAnonymously();
                      if(user == null)
                      {
                        Navigator.pushNamed(context, SparksLoginScreen.id);
                      }
                      else
                      {
                        Navigator.pushNamed(context, CreateSparksProfile.id);
                      }*/
                        },
                        child: Text(
                          '',
                          //kAnonymous_login,
                          style: TextStyle(
                            color: kFooterLabelTextColour,
                            fontFamily: 'Rajdhani',
                            fontWeight: FontWeight.bold,
                            fontSize: kFontSizeAnonynousUser.sp,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            //TODO: Do something when forgot password is clicked.
                            Navigator.pushNamed(
                              context,
                              ResetPassword.id,
                            );
                          },
                          child: Text(
                            kForgotPassword,
                            style: TextStyle(
                              color: kResendColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Center(
                    child: Text(
                      _errorMgs,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                        fontSize: kInvalidUserFontSize,
                        color: kFormErrorMessageColour,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.09,
                height: MediaQuery.of(context).size.height * 0.07,
                child: FlatButton(
                  onPressed: () async {
                    //TODO: Do something when login button is clicked.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      //TODO: Do something when login credential is valid.
                      setState(() {
                        //TODO: Show the process widget.
                        showLoadingWidget = true;
                        AsyncDialog.showLoadingDialog(
                            context, _keyLoader, showLoadingWidget);
                      });

                      dynamic user =
                          await _authService.signInWithEmailAndPassword(
                        _email,
                        _password,
                      );

                      //TODO: Check if the user is valid or not.
                      if (user == null) {
                        setState(() {
                          Navigator.of(context).pop();
                          _errorMgs = "Invalid User ID.";
                        });
                      } else {
                        setState(() {
                          _errorMgs = "";
                        });
                        Navigator.pushReplacementNamed(
                          context,
                          SparksLandingScreen.id,
                        );
                      }
                    }
                  },
                  child: Image.asset('images/app_entry_and_home/loginbtn.png'),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            child: Center(
              child: Text(
                kTake_a_tour,
                style: TextStyle(
                  color: kFooterLabelTextColour,
                  fontFamily: 'Rajdhani',
                  fontWeight: FontWeight.bold,
                  fontSize: kFontSizeAnonynousUser.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          /* This container wraps the tour button */
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.07,
              right: MediaQuery.of(context).size.width * 0.07,
            ),
            child: GestureDetector(
              onTap: () {
                //TODO: do something when the tour button is clicked.
              },
              child: Image(
                image: AssetImage('images/app_entry_and_home/take_tour.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
