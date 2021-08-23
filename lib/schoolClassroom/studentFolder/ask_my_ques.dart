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


class StudentAskMyQuestion extends StatefulWidget {
  StudentAskMyQuestion({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentAskMyQuestionState createState() => _StudentAskMyQuestionState();
}

class _StudentAskMyQuestionState extends State<StudentAskMyQuestion> {
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

                        child: Text("Students Ask Question".toUpperCase(),

                          textAlign: TextAlign.center,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: kExpertColor,
                              fontSize:kTwentyTwo.sp,
                            ),
                          ),
                        ),
                      ),

                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Text('Ask your teacher a question concerning this lesson: ${widget.doc['title']}',

                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),

                            TextFormField(
                              controller: _un,
                              maxLength: 100,

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
        DocumentReference ref = FirebaseFirestore.instance.collection('studentsQuestions').doc(widget.doc['schId']).collection('questions').doc();
        ref.set({
          'did':ref.id,
          'id':widget.doc['id'],
          'title':widget.doc['title'],
          'desc':widget.doc['desc'],
          'stId':SchClassConstant.schDoc['did'],
          'lv':widget.doc['tsl'],
          'cl':widget.doc['tcl'],
          'schId':widget.doc['schId'],
          'fn':SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'msg':_un.text.trim(),
          'ts':DateTime.now().toString(),
          're':false,
          'se':false,
          'ans':"",

        });
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
