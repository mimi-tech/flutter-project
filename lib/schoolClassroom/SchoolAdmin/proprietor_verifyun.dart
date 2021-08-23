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
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';

class ProprietorVerifyUn extends StatefulWidget {
  @override
  _ProprietorVerifyUnState createState() => _ProprietorVerifyUnState();
}

class _ProprietorVerifyUnState extends State<ProprietorVerifyUn> {
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
        padding: const EdgeInsets.all(12.0),

        child: Text('School Admin Verification'.toUpperCase(),

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
      FadeHeading(title: kSchoolUn,),

        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            controller: _un,
            maxLength: 100,
            maxLines: null,
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
        verifyUn();
      },
        color: kFbColor,
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
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').doc(GlobalVariables.loggedInUserObject.id).collection('schoolUsers')
        .where('id', isEqualTo: GlobalVariables.loggedInUserObject.id)
        .where('un', isEqualTo: _un.text.trim())
        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 1) {
    for( doc in documents){
      Map<String, dynamic> data = doc!.data() as Map<String, dynamic>;

      //Add the user to identity collection for easy entry
      createIdentity(doc!);

      setState(() {
        progress = false;
        SchClassConstant.schDoc = doc!;
      });
      Navigator.pop(context);
      //check if user school is campus or not
      if(data['camp'] == true){
        //it is  a campus

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));


      }else {
        //move the proprietor to school admin page
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CampusPostScreen()));

      }



    }

    }else{
      setState(() {
        progress = false;
      });

      SchClassConstant.displayToastError(title: kSchoolUnDenied);
    }

  }catch(e){
      setState(() {
        progress = false;
      });
      print(e);
      SchClassConstant.displayToastError(title: kSchoolUnDenied);

    }
    }
  }

  Future<void> createIdentity(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//check if the school ahs been added before
    try{
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('schoolIdentity')
          .where('schId', isEqualTo: data['schId'])
          .where('schId', isEqualTo: data['un'])
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
      'un':data['un'],
      'cl':'',
      'lv':'',
      'isT':false,
      'isSt':false,
      'isAd':false,
      'isP':true



    });
  }}catch(e){

    }
}}
