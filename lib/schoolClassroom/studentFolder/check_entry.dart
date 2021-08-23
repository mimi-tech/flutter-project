import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/techers-tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/access_denied.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_page.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class CheckStudent extends StatefulWidget {
  @override
  _CheckStudentState createState() => _CheckStudentState();
}

class _CheckStudentState extends State<CheckStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _un =  TextEditingController();
  TextEditingController _pin =  TextEditingController();
  DocumentSnapshot? doc;
  String? schoolUn;
  String? schoolPin;
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

                        child: Text("School Students Verification".toUpperCase(),

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
                            FadeHeading(title: 'Enter username',),

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

                            FadeHeading(title: 'Enter pin',),

                            TextFormField(
                              controller: _pin,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,

                              ],
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                              onSaved: (String? value) {
                                schoolPin = value;
                              },
                              validator: Validator.validateSchTeacher,

                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                      progress?Center(child: PlatformCircularProgressIndicator()): RaisedButton(onPressed: (){
                        verifyUn();
                      },
                        color: kExpertColor,
                        child:Text('Verify'.toUpperCase(),
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
      //check if proprietor  username and uid matches
      try{
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('students')
            .where('un', isEqualTo: _un.text.trim())
            .where('pin', isEqualTo: int.parse(_pin.text.trim()))

            //.orderBy('ts')
            .get();

        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length == 1) {
          //check if student has access

          for( doc in documents) {
            Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;

            createIdentity(doc!);
            if (data['ass'] == true) {
              setState(() {
                progress = false;
                SchClassConstant.schDoc = doc!;
                SchClassConstant.isStudent = true;
              });
              Navigator.pop(context);
              //move the proprietor to school admin page
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CampusPostScreen()));
              //get login time and set online true for this student
              getOnlineHighStudentCampus(doc!);
            } else {
              Navigator.pop(context);
              setState(() {
                progress = false;
              });
              //student does not have an access
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AccessDenied()));
            }
          }
        }else{
          //its a university students
          getUniversityStudent();
        }


      }catch(e){
        setState(() {
          progress = false;
        });
        //Navigator.pop(context);
        print(e);
        SchClassConstant.displayToastError(title: kError);

      }
    }
  }

  Future<void> getUniversityStudent() async {
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('campusStudents')
          .where('un', isEqualTo: _un.text.trim())
          .where('pin', isEqualTo: int.parse(_pin.text.trim()))

      //.orderBy('ts')
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 1) {
        //check if student has access

        for( doc in documents) {
          Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;

          createIdentity(doc!);
          if (data['ass'] == true) {


            setState(() {
              progress = false;
              SchClassConstant.schDoc = doc!;
              SchClassConstant.isStudent = true;
              SchClassConstant.isUniStudent = true;
            });
            Navigator.pop(context);
            //move the proprietor to school admin page
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CampusPostScreen()));

            //get login time and set online true for this student
            getOnlineHighStudentCampus(doc!);
          } else {
            Navigator.pop(context);
            setState(() {
              progress = false;
            });
            //student does not have an access
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AccessDenied()));
          }
        }
      }else{
        setState(() {
          progress = false;
        });
        SchClassConstant.displayToastError(title: 'Access Denied');
      }


    }catch(e){
      setState(() {
        progress = false;
      });
      //Navigator.pop(context);
      print(e);
      SchClassConstant.displayToastError(title: kError);

    }
  }



  Future<void> createIdentity(DocumentSnapshot doc) async {
//check if the school ahs been added before
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('schoolIdentity')
          .where('schId', isEqualTo: data['schId'])
          .where('pin', isEqualTo: data['pin'])
          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 0) {

        DocumentReference docId =  FirebaseFirestore.instance.collection('schoolIdentity').doc();
        docId.set({
          'uid':GlobalVariables.loggedInUserObject.id,
          'id':docId.id,
          'ts':DateTime.now().toString(),
          'logo':data['logo'],
          'name':data['sN'],
          'str':data['str'],
          'st':data['st'],
          'cty':data['cty'],
          'schId':data['schId'],
          'pin':data['pin'],
          'cl':data['cl'],
          'lv':data['lv'],
          'un':data['un'],
          'isT':false,
          'isSt':true,
          'isAd':false,
          'isP':false



        });
      }}catch(e){
    }}


  void getOnlineHighStudentCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('classroomStudents').doc(doc['schId']).collection('students').doc(doc['id']).set({
      'ol':DateTime.now().toString(),
      'off':'',
      'onl':true,

    },SetOptions(merge: true));
  }

  void getOnlineStudentCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('uniStudents')
        .doc(doc['schId']).collection('campusStudents').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
      'ol':DateTime.now().toString(),
      'off':'',
      'onl':true,
        'olc':value.data()!['olc'] + 1
    },SetOptions(merge: true));
  });

}}
