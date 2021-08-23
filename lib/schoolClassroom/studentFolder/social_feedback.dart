import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/techers-tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/access_denied.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_page.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class StudentSocialFeedback extends StatefulWidget {
  StudentSocialFeedback({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentSocialFeedbackState createState() => _StudentSocialFeedbackState();
}

class _StudentSocialFeedbackState extends State<StudentSocialFeedback> {
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

                        child: Text("Students Feedback".toUpperCase(),

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
                            Text('Give your teacher a feedback concerning this class: ${widget.doc['title']}',

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
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('socialFeedback')
            .where('title', isEqualTo: widget.doc['title'])
            .where('stId', isEqualTo: SchClassConstant.schDoc['did'])
            .where('lv', isEqualTo: widget.doc['tsl'])
            .where('id', isEqualTo: widget.doc['id'])
            .get();

        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length == 0) {

          //save to teachers feedback
          DocumentReference ref = FirebaseFirestore.instance.collection('socialClassFeedback').doc(widget.doc['schId']).collection('socialFeedback').doc();
          ref.set({
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
            'fid':ref.id

          });


          //update the lesson comment count

          FirebaseFirestore.instance.collection('socialClass').doc(widget.doc['schId']).collection('schoolSocials').doc(widget.doc['id']).get()
              .then((resultComm) {
            dynamic totalComment = resultComm.data()!['comm'] + 1;

            resultComm.reference.set({
              'comm':totalComment,

            },SetOptions(merge: true));
          });

          Navigator.pop(context);
          setState(() {
            progress = false;
          });
          SchClassConstant.displayBotToastCorrect(title: kSchoolStudentFee2);



        }else{
          Navigator.pop(context);
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: kSchoolStudentFeed);

          //student have given feedback before
        }



      }catch(e){
        setState(() {
          progress = false;
        });

        SchClassConstant.displayToastError(title: kError);

      }
    }
  }
}
