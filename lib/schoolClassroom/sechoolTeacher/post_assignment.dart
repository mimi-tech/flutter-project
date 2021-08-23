import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';


class PostAssignment extends StatefulWidget {
  PostAssignment({required this.assignment});
  final File assignment;
  @override
  _PostAssignmentState createState() => _PostAssignmentState();
}

class _PostAssignmentState extends State<PostAssignment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _un =  TextEditingController();
  String? schoolUn;


  String? url;


  String get fileImagePaths => 'teachersAssessment/${DateTime.now()}';
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

                        child: Text(kSchoolStudentAssignment.toUpperCase(),

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

                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Text(widget.assignment.toString(),

                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: kExpertColor,
                                  fontSize: kFontSize14.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),

                            TextFormField(
                              controller: _un,
                              cursorColor: (kMaincolor),
                              textCapitalization: TextCapitalization.sentences,
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kAssignmentDecoration,
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
                        color: kFbColor,
                        child:Text('Post'.toUpperCase(),
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
        //upload the file first
        Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
        Constants.courseThumbnail = ref.putFile(
          widget.assignment,
          SettableMetadata(
            contentType: 'images.pdf',
          ),
        );

        final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
        url = await downloadUrl.ref.getDownloadURL();

        //save to teachers feedback
      DocumentReference docRef = FirebaseFirestore.instance.collection('teachersAssessment').doc(SchClassConstant.schDoc['schId']).collection('assessments').doc();
      docRef.set({
        'id': docRef.id,
        'title': _un.text,
        'ass':true,
        'url':url,
        'curs':SchClassConstant.isLecturer?SchClassConstant.schDoc['curs']:'',
        'lv': SchClassConstant.schDoc['lv'],
        'cl':SchClassConstant.schDoc['cl'],
        'schId': SchClassConstant.schDoc['schId'],
        'tc': SchClassConstant.schDoc['tc'],
        'tcId': SchClassConstant.schDoc['id'],
        'ts': DateTime.now().toString(),
        'rec':0
      });

      teacherIsUploadingAssessment(SchClassConstant.schDoc);
      SchClassConstant.displayBotToastCorrect(title:'Uploaded successfully');



      Navigator.pop(context);
      setState(() {
        progress = false;
      });
      SchClassConstant.displayBotToastCorrect(title: 'Posted');

  }catch(e){
        Navigator.pop(context);
        setState(() {
          progress = false;
        });
        SchClassConstant.displayBotToastCorrect(title: kError);

      }
    }

    }

  void teacherIsUploadingAssessment(DocumentSnapshot doc) {

    //tell the management that this teacher has uploaded a lesson
    if(SchClassConstant.isLecturer){
      ///if this is a campus teacher

      FirebaseFirestore.instance.collection('schoolTutors')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('tutors')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic ac = value.data()!['ac'] == null?0:value.data()!['ac'];
        dynamic ad = value.data()!['ad'] == null?0:value.data()!['ad'];
        dynamic aw = value.data()!['aw'] == null?0:value.data()!['aw'];
        dynamic  am = value.data()!['am'] == null?0:value.data()!['am'];
        dynamic ay = value.data()!['ay'] == null?0:value.data()!['ay'];


        FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
          'uc':ac + 1,
          'ud': value.data()!['day'] == DateTime.now().day?ad + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?aw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?am + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?ay + 1:1,
          'lot':DateTime.now().toString(),
          'ayr':DateTime.now().year,
          'amth':DateTime.now().month,
          'aday':DateTime.now().day,
          'awky':Jiffy().week,

        },SetOptions(merge:  true));


        campusTeacherAnalysis(doc);


      });




    }else{
      ///if this is a high school teacher

      FirebaseFirestore.instance.collection('teachers')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('schoolTeachers')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic ac = value.data()!['ac'] == null?0:value.data()!['ac'];
        dynamic ad = value.data()!['ad'] == null?0:value.data()!['ad'];
        dynamic aw = value.data()!['aw'] == null?0:value.data()!['aw'];
        dynamic  am = value.data()!['am'] == null?0:value.data()!['am'];
        dynamic ay = value.data()!['ay'] == null?0:value.data()!['ay'];



        FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
          'uc':ac + 1,
          'ud': value.data()!['day'] == DateTime.now().day?ad + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?aw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?am + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?ay + 1:1,
          'ayr':DateTime.now().year,
          'amth':DateTime.now().month,
          'aday':DateTime.now().day,
          'awky':Jiffy().week,

        },SetOptions(merge:  true));

        campusTeacherAnalysis(doc);
      });


    }

  }



  Future<void> campusTeacherAnalysis(DocumentSnapshot doc) async {
    ///Daily Analysis
    final snapShot = await FirebaseFirestore.instance.collection('campusAnalysisDaily')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('daily').doc('${DateTime.now().day}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
        .get();

    if (snapShot == null || !snapShot.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisDaily')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('daily')
          .doc('${DateTime.now().day}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .set({

        'ts':DateTime.now().toString(),
        'ac':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
      },SetOptions(merge:  true));


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisDaily')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('daily')
          .doc('${DateTime.now().day}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])

          .get().then((resultData) {
        resultData.reference.set({
          'ac': resultData.data()!['ac'] == null?1:resultData.data()!['ac'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }

    ///Weekly Analysis


    final snapShotWeekly = await FirebaseFirestore.instance.collection('campusAnalysisWeekly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('weekly').doc('${Jiffy().week}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();

    if (snapShotWeekly == null || !snapShotWeekly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisWeekly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('weekly').doc('${Jiffy().week}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id']) .set({

        'wk':Jiffy().week,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'ac':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
      },SetOptions(merge:  true));


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisWeekly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('weekly').doc('${Jiffy().week}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .get().then((resultData) {
        resultData.reference.set({
          'ac': resultData.data()!['ac'] == null?1:resultData.data()!['ac'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });

    }

    ///Monthly analysis

    final snapShotMonthly = await FirebaseFirestore.instance.collection('campusAnalysisMonthly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('monthly').doc('${DateTime.now().month}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id']).get();

    if (snapShotMonthly == null || !snapShotMonthly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisMonthly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('monthly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id']) .set({

        'mth':DateTime.now().month,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'ac':1
      });


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisMonthly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('monthly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .get().then((resultData) {
        resultData.reference.set({
          'ac': resultData.data()!['ac'] == null?1:resultData.data()!['ac'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }




    ///Yearly analysis

    final snapShotYearly = await FirebaseFirestore.instance.collection('campusAnalysisYearly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('yearly').doc('${DateTime.now().month}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();

    if (snapShotYearly == null || !snapShotYearly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisYearly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('yearly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .set({
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'ac':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
      });


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisYearly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('yearly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .get().then((resultData) {
        resultData.reference.set({
          'ac': resultData.data()!['ac'] == null?1:resultData.data()!['ac'] + 1,
        },SetOptions(merge: true));
      });
    }



  }


}


