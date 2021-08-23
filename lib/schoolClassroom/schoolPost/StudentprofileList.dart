import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schoolPost/reportStudents.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentsSavedPost.dart';
class StudentProfileList extends StatefulWidget {
  StudentProfileList({required this.doc});
  final List<dynamic> doc;

  @override
  _StudentProfileListState createState() => _StudentProfileListState();
}

class _StudentProfileListState extends State<StudentProfileList> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: kHorizontal),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.report),
                    onTap: (){
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              ReportStudent(doc:widget.doc));
                    },
                    title: Text('Report'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentSavedPost()));

                    },
                    leading: Icon(Icons.save),
                    title: Text('Saved Post'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
