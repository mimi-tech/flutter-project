import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_tab.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class ReportStudent extends StatefulWidget {
  ReportStudent({required this.doc});
  final List<dynamic> doc;

  @override
  _ReportStudentState createState() => _ReportStudentState();
}

class _ReportStudentState extends State<ReportStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _report =  TextEditingController();
  DocumentSnapshot? doc;
  String? schoolUn;
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

                      Padding(
                        padding: const EdgeInsets.all(12.0),

                        child: Text('Students Report'.toUpperCase(),

                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: kFbColor,
                              fontSize:kTwentyTwo.sp,
                            ),
                          ),
                        ),
                      ),
                      FadeHeading(title: 'Type your report',),

                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: _report,
                          maxLines: null,
                          maxLength: 200,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            schoolUn = value;
                          },
                          validator: Validator.validateSchUn,

                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                      progress?Center(child: PlatformCircularProgressIndicator()): RaisedButton(onPressed: (){
                        reportStudent();
                      },
                        color: kFbColor,
                        child:Text('Send'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),)



                    ]
                ))));
  }

  void reportStudent() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }


      setState(() {
        progress = true;
      });

    try{
      FirebaseFirestore.instance.collection('studentsReport').add({
        'msg':_report.text,
        'stId':widget.doc[0]['stId'],
        'sFn':widget.doc[0]['fn'],
        'sLn':widget.doc[0]['ln'],
        'stLv':widget.doc[0]['lv'],
        'stD':widget.doc[0]['dept'],
        'op': null,
        'rId':SchClassConstant.schDoc['id'],
        'rFn':SchClassConstant.schDoc['fn'],
        'rLn':SchClassConstant.schDoc['ln'],
        'rLv':SchClassConstant.schDoc['lv'],
        'schId':widget.doc[0]['schId'],
        'ts':DateTime.now().toString()
      });

      setState(() {
        progress = false;
      });

      Navigator.pop(context);
      SchClassConstant.displayToastCorrect(title: kPostSuccess);

    }catch(e){
      setState(() {
        progress = false;
      });

      SchClassConstant.displayToastError(title: kError);
    }}
}}

