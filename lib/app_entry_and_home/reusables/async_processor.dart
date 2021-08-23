import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AsyncDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, bool dismissible) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => true,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.15,
                color: kWhiteColour,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitDoubleBounce(
                      color: kFormLabelColour,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      kValidating,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontSize: kFontSizeAnonynousUser.sp,
                          fontWeight: FontWeight.w900,
                          color: kProfile,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
