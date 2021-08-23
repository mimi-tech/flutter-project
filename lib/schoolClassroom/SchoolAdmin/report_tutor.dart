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


class AdminTeachersReport extends StatefulWidget {
  AdminTeachersReport({required this.doc});
  final DocumentSnapshot doc;
  @override
  _AdminTeachersReportState createState() => _AdminTeachersReportState();
}

class _AdminTeachersReportState extends State<AdminTeachersReport> {
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

                        child: Text("Tutors report".toUpperCase(),

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
                            Text('What did you find out concerning this tutor: ${widget.doc['tc']}',

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
                              maxLength: 150,
                              cursorColor: (kMaincolor),
                              maxLines: null,
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
      try{

        //save to teachers feedback
        DocumentReference ref = FirebaseFirestore.instance.collection('tutorsReport').doc(widget.doc['schId']).collection('report').doc();
        ref.set({
          'id':widget.doc['id'],
          'tc':widget.doc['tc'],
          'schId':widget.doc['schId'],
          'fn':SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'msg':_un.text.trim(),
          'ts':DateTime.now().toString(),
          'fid':ref.id

        });


        Navigator.pop(context);
        setState(() {
          progress = false;
        });
        SchClassConstant.displayToastCorrect(title: kSchoolStudentReport);



      }catch(e){
        setState(() {
          progress = false;
        });

        SchClassConstant.displayToastError(title: kError);

      }
    }
  }
}
