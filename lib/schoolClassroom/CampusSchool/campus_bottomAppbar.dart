import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/All_studies.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/schoolFeeds.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_result.dart';


class CampusBottomBar extends StatefulWidget {
  @override
  _CampusBottomBarState createState() => _CampusBottomBarState();
}

class _CampusBottomBarState extends State<CampusBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: BottomAppBar(
        color: kSappbarbacground,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: SchoolAnnouncement()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.speaker,color:kStabcolor1),
                    Text(kSchoolStudentAn,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: kFontSize12.sp,
                          ),
                        )),
                  ],
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: SchoolResult()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.receipt_sharp,color:kWhitecolor),

                    Text(kSchoolStudentResult,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kWhitecolor,
                            fontSize: kFontSize12.sp,
                          ),
                        )),
                  ],
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: AdminStudies()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.book_online,color:kBlackcolor2),

                    // IconButton(icon: Icon(Icons.assessment), onPressed: (){}, color:kBlackcolor2,),
                    Text(kSchoolStudentStudies,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kWhitecolor,
                          fontSize: kFontSize12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push (context, PageTransition (type: PageTransitionType.bottomToTop, child: AllSchoolFeed()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.feedback,color:kBlackcolor2),

                    // IconButton(icon: Icon(Icons.assessment), onPressed: (){}, color:kBlackcolor2,),
                    Text('Feedback',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kWhitecolor,
                          fontSize: kFontSize12.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
