import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/proprietor_verifyun.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/verify_sch_admin.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/verify_teacher.dart';
import 'package:sparks/schoolClassroom/studentFolder/check_entry.dart';

class SchoolAdminInterface extends StatefulWidget {
  @override
  _SchoolAdminInterfaceState createState() => _SchoolAdminInterfaceState();
}

class _SchoolAdminInterfaceState extends State<SchoolAdminInterface> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: Duration(milliseconds: 400),
    curve: Curves.decelerate,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: kHorizontal),
      child: Column(
        children: [
          Text(kComeIn.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kFbColor,
                fontSize:kTwentyTwo.sp,
              ),
            ),
          ),
          space(),
          Row(
            children: [
              IconButton(icon: Icon(Icons.radio_button_unchecked,color: kFbColor,), onPressed: (){
                checkIsStudent();

              }),

              Text('Student'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            ],
          ),

          space(),
          Row(
            children: [
              IconButton(icon: Icon(Icons.radio_button_unchecked,color: kFbColor,), onPressed: (){
                checkIsAdmin();

              }),

              Text(kComeIn2.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            ],
          ),
          space(),
          Row(
            children: [
              IconButton(icon: Icon(Icons.radio_button_unchecked,color: kFbColor,), onPressed: (){

                //verify the teacher's pin

                Navigator.pop(context);

                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    builder: (context) {
                      return VerifyTeacher();
                    });



              }),

              Text(kComeIn3.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            ],
          ),
          space(),


          Row(
            children: [
              IconButton(icon: Icon(Icons.radio_button_unchecked,color: kFbColor,), onPressed: (){
                checkIsProprietor();
              }),

              Text(kComeIn4.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlackcolor,
                    fontSize: kFontsize.sp,
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    )
    ));
  }

  void checkIsProprietor() {
    //let the proprietor enter his school username
    Navigator.pop(context);

    showModalBottomSheet(
      isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return ProprietorVerifyUn();
        });


  }

  void checkIsAdmin() {
    Navigator.pop(context);

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return VerifySchoolAdmin();
        });

  }

  void checkIsStudent() {
    Navigator.pop(context);

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return CheckStudent();
        });
  }
}
