import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_questions.dart';


class TeacherReplyQuestions extends StatefulWidget {
  TeacherReplyQuestions({required this.doc});
  final DocumentSnapshot doc;
  @override
  _TeacherReplyQuestionsState createState() => _TeacherReplyQuestionsState();
}

class _TeacherReplyQuestionsState extends State<TeacherReplyQuestions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _un =  TextEditingController();
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
                        padding: const EdgeInsets.all(10.0),

                        child: Text("Reply Students Question".toUpperCase(),

                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: kExpertColor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      ),

                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Question: ',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kFbColor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.doc['msg'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kBlackcolor,
                                        fontSize: kFontsize.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            SizedBox(height: 10,),

                            TextFormField(
                              controller: _un,
                              maxLength: 200,

                              maxLines: null,
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                              onSaved: (String? value) {
                                schoolUn = value;
                              },
                              validator: Validator.validateSchUn,

                            ),


                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                      progress?Center(child: PlatformCircularProgressIndicator()): RaisedButton(onPressed: (){
                        verifyUn();
                      },
                        color: kExpertColor,
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

  Future<void> verifyUn() async {

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

      //check if feedback have been given by this student in this lesson
      try{
        //save to teachers feedback
        FirebaseFirestore.instance.collection('studentsQuestions').doc(widget.doc['schId']).collection('questions').doc(widget.doc['did']).set({

          'ts':DateTime.now().toString(),
          're':true,
          'se':true,
          'ans':_un.text.trim(),

        },SetOptions(merge: true));
        SchClassConstant.displayToastCorrect(title: 'Sent');

        Navigator.pop(context);
        //push back the bottom for questions

        showModalBottomSheet(
            isDismissible: false,
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0)),
            builder: (context) {
              return StudentsQuestions(doc:widget.doc);
            });

      }catch(e){
        setState(() {
          progress = false;
        });

        SchClassConstant.displayToastError(title: kError);

      }
    }
  }
}
