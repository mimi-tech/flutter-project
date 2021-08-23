import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/form_label_header.dart';
import 'package:sparks/app_entry_and_home/reusables/sign_in_form.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/login_signup_enum.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SparksSignUpScreen extends StatefulWidget {
  static String id = kSparks_sign_up;

  @override
  _SparksSignUpScreenState createState() => _SparksSignUpScreenState();
}

class _SparksSignUpScreenState extends State<SparksSignUpScreen> {
  //Variable declaration
  PermissionStatus? _appLocationStatus, _cameraRequestStatus;
  LoginSignupHeader headerSelected = LoginSignupHeader.SIGNUP;

  //TODO: Requesting permissions
  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.camera,
    ].request();

    _getPermission(statuses);
  }

  @override
  void initState() {
    super.initState();

    /* Ask for location and camera permission */
    /*PermissionHandler().requestPermissions(
      [Permission.locationAlways, Permission.camera],
    ).then(_getPermission);*/
    requestPermission();
  }

  /* This method is called from the initState method */
  void _getPermission(Map<Permission, PermissionStatus> value) {
    final locationRequestedPermission = value[Permission.locationAlways];
    final cameraRequestedPermission = value[Permission.camera];

    if ((locationRequestedPermission != PermissionStatus.granted) &&
        (cameraRequestedPermission != PermissionStatus.granted)) {
      //launch the device settings.
      openAppSettings();
    } else {
      _updatePermissionStatus(locationRequestedPermission);
    }
  }

  void _updatePermissionStatus(PermissionStatus? appPermissionStatus) {
    if (appPermissionStatus != _appLocationStatus) {
      setState(() {
        _appLocationStatus = appPermissionStatus;
      });
    }
    if (appPermissionStatus != _cameraRequestStatus) {
      setState(() {
        _cameraRequestStatus = appPermissionStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /* This is the screen background image */
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

            /* This is the app name */
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Image(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height * 0.14,
                      image: AssetImage(
                        'images/app_entry_and_home/brand.png',
                      ),
                    ),
                  ),

                  /* Sparks login and sign up section */
                  Container(
                    child: Stack(
                      children: <Widget>[
                        /* Background image */
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.07,
                            right: MediaQuery.of(context).size.width * 0.07,
                            bottom: MediaQuery.of(context).size.height * 0.05,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.63,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'images/app_entry_and_home/new_sparks_frame.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /* Add the form titles */
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 20.0,
                                ),
                                margin: EdgeInsets.only(
                                  left: 48.0,
                                  top: MediaQuery.of(context).size.height *
                                      0.002,
                                ),
                                height: 50.0,
                                child: FormLabelHeader(
                                  labelHeader: kLogin_label,
                                  alignHeader: TextAlign.left,
                                  labelHeaderColor:
                                      headerSelected == LoginSignupHeader.LOGIN
                                          ? kFormLabelColour
                                          : kWhiteColour,
                                  onPress: () {
                                    setState(() {
                                      headerSelected = LoginSignupHeader.LOGIN;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 20.0,
                                ),
                                margin: EdgeInsets.only(
                                  right: 48.0,
                                  top: MediaQuery.of(context).size.height *
                                      0.002,
                                ),
                                height: 50.0,
                                child: FormLabelHeader(
                                  labelHeader: kSignup_label,
                                  alignHeader: TextAlign.right,
                                  labelHeaderColor:
                                      headerSelected == LoginSignupHeader.SIGNUP
                                          ? kFormLabelColour
                                          : kWhiteColour,
                                  onPress: () {
                                    setState(() {
                                      headerSelected = LoginSignupHeader.SIGNUP;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        /* This container recreates both the login and the sign up forms */
                        headerSelected == LoginSignupHeader.LOGIN
                            ? SignInForm()
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
