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
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/studies.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/techers-tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/access_denied.dart';

class VerifyTeacher extends StatefulWidget {
  @override
  _VerifyTeacherState createState() => _VerifyTeacherState();
}

class _VerifyTeacherState extends State<VerifyTeacher> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _un =  TextEditingController();
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
                        padding: const EdgeInsets.all(10.0),

                        child: Text("School Teacher's Verification".toUpperCase(),

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
                      FadeHeading(title: kSchoolTechPin,),

                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: _un,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,

                          ],
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            schoolUn = value;
                          },
                          validator: Validator.validateSchTeacher,

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
        final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('schoolTeachers')
            .where('pin', isEqualTo: int.parse(_un.text.trim()))
            .orderBy('ts')
            .get();

        final List < DocumentSnapshot > documents = result.docs;
//check if teacher has access


          if (documents.length == 1) {
          for( doc in documents){

            createIdentity(doc!);
            setState(() {
              progress = false;
              SchClassConstant.schDoc = doc!;
              SchClassConstant.isTeacher = true;
            });
            if(documents[0]['ass'] == true){
            Navigator.pop(context);
            //change the isTeacher bool
            isTeacher = true;
            //move the teacher to school teachers page
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
            //get login time and set online true for this teacher
            getOnlineTeacherHighSchool(doc!);

            }else{
              setState(() {
                progress = false;
              });
//teacher does not have an access
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessDenied()));

              SchClassConstant.displayToastError(title: kSchoolUnDenied);
            }
          }
          }else {
            //check if tutor is from campus
            getTutor();
          }
          //if(data['camp'] == true){


      }catch(e){
        setState(() {
          progress = false;
        });
        //Navigator.pop(context);
        SchClassConstant.displayToastError(title: kError);

      }
    }
  }

  Future<void> getTutor() async {

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('tutors')
          .where('pin', isEqualTo: int.parse(_un.text.trim()))
          .orderBy('ts')
          .get();

      final List <DocumentSnapshot> documents = result.docs;
//check if teacher has access


        if (documents.length == 1) {
          for (doc in documents) {
            createIdentity(doc!);
            setState(() {
              progress = false;
              SchClassConstant.schDoc = doc!;
              SchClassConstant.isTeacher = true;
              SchClassConstant.isLecturer = true;
            });

            //check if tutor has access
            if(documents[0]['ass'] == true){
              isTeacher = true;
              Navigator.pop(context);
            //move the teacher to school admin page
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));
              //get login time and set online true for this teacher
              getOnlineTeacherCampus(doc!);
            }else{
              setState(() {
                progress = false;
              });
                     //teacher does not have an access
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessDenied()));

              SchClassConstant.displayToastError(title: kSchoolUnDenied);
            }

          }
        }else{

          setState(() {
            progress = false;
          });
          //No tutor found
          SchClassConstant.displayToastError(title: 'incorrect pin');

        }

    }catch(e){
      setState(() {
        progress = false;
      });
      SchClassConstant.displayToastError(title: kError);

    }
}


  Future<void> createIdentity(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//check if the school ahs been added before
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
          'name':data['name'],
          'str':data['str'],
          'st':data['st'],
          'cty':data['cty'],
          'schId':data['schId'],
          'pin':data['pin'],
          'cl':data['cl'],
          'lv':data['lv'],
          'isT':true,
          'isSt':false,
          'isAd':false,
          'isP':false
        });
      }}catch(e){

    }}

  void getOnlineTeacherCampus(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('schoolTutors').doc(doc['schId']).collection('tutors').doc(doc['id']).set({
      'ol':DateTime.now().toString(),
      'off':'',
      'onl':true,

    },SetOptions(merge: true));
  }


  void getOnlineTeacherHighSchool(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('teachers')
        .doc(doc['schId']).collection('schoolTeachers').doc(doc['id'])
        .get().then((value) {
      value.reference.set({
      'ol':DateTime.now().toString(),
      'off':'',
      'onl':true,
        'olc':value.data()!['olc'] + 1
    },SetOptions(merge: true));
  });

}}
