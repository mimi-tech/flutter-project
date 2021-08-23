import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_login_screen.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SparksLandingTourScreen extends StatelessWidget {
  static const String id = kSparks_landing_tour_screen;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/app_entry_and_home/sparksbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //TODO: Display company logo.
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.02,
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
                        //TODO: Display Description.
                        Center(
                          child: Text(
                            kWel_to_sparks_universe,
                            style: TextStyle(
                              fontSize: kSize_16.sp,
                              fontFamily: 'Berkshire Swash',
                              color: kWhiteColour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              //TODO: Do something when the sign up button is clicked.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PersonalReg();
                                  },
                                ),
                              );
                            },
                            child: Image(
                              image: AssetImage(
                                  'images/app_entry_and_home/signupbtn.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.04,
                                  right:
                                      MediaQuery.of(context).size.width * 0.015,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO: Do something when the login button is clicked.
                                    Navigator.pushNamed(
                                        context, SparksLoginScreen.id);
                                  },
                                  child: Image(
                                    image: AssetImage(
                                        'images/app_entry_and_home/signinbtn.png'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.015,
                                  right:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO: implement something when the tour button is clicked.
                                  },
                                  child: Image(
                                    image: AssetImage(
                                        'images/app_entry_and_home/tourbtn.png'),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
