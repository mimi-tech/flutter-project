import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/reusables/sign_in_form.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/login_signup_enum.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SparksLoginScreen extends StatefulWidget {
  static String id = kSparks_login;

  @override
  _SparksLoginScreenState createState() => _SparksLoginScreenState();
}

class _SparksLoginScreenState extends State<SparksLoginScreen> {
  //Variable declaration
  PermissionStatus? _appLocationStatus, _cameraRequestStatus;
  LoginSignupHeader headerSelected = LoginSignupHeader.LOGIN;

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
      [PermissionGroup.locationAlways, PermissionGroup.camera],
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: Center(
                                child: Text(
                                  kLogin_label,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: kFont_Size.sp,
                                      color: kFormLabelColour,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        /* This container recreates both the login and the sign up forms */
                        SignInForm(),
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
