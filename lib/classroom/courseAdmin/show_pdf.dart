import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_appbar.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ShowPdf extends StatefulWidget {
  ShowPdf({required this.userPdf});
  final String? userPdf;
  @override
  _ShowPdfState createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: EditAdminCourseAppBar(
              title: CourseAdminConstants.courseAdminName,
              pix: CourseAdminConstants.courseAdminPix,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    PDF.network(
                      widget.userPdf!,
                      placeHolder: Center(child: CircularProgressIndicator()),
                      height: MediaQuery.of(context).size.height * kPdfSize,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(50),
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: kFbColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            'Back',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontsize.sp,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )));
  }
}
