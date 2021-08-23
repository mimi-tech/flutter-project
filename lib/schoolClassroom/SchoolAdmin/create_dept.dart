import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expert_class/expert_constants/requirement_list.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_bottomAppbar.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/view_department.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class CreateDepartment extends StatefulWidget {
  @override
  _CreateDepartmentState createState() => _CreateDepartmentState();
}

class _CreateDepartmentState extends State<CreateDepartment> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level =  TextEditingController();
  TextEditingController _classes =  TextEditingController();
  TextEditingController _subjects =  TextEditingController();
  TextEditingController _teacher =  TextEditingController();
  static  List<int> teachersPin = <int>[];

  String? level;
  String? classes;
  String? subjects;
  String? teacher;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: StuAppBar(),
          body: ModalProgressHUD(
            inAsyncCall: progress,
            child: CustomScrollView(slivers: <Widget>[
              ProprietorActivityAppBar(
              activitiesColor: kTextColor,
              classColor: kStabcolor1,
              newsColor: kTextColor,
              studiesColor: kTextColor,
            ),
              HighSchoolSliverAppBar(
              campusBgColor: klistnmber,
              campusColor: kWhitecolor,
              deptBgColor: Colors.transparent,
              deptColor: klistnmber,
              recordsBgColor: Colors.transparent,
              recordsColor: klistnmber,
                sectionBgColor: Colors.transparent,
                sectionColor: klistnmber,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: kMaincolor,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewSchoolDepartment()));

                          },
                          child: Text('View department'.toString().toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontSize14.sp,
                              ),
                            ),
                          ),
                        ),

                        RaisedButton(
                          color: kStabcolor,
                          onPressed: (){_saveLevel();},
                          child: Text('Save Level'.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                                fontSize: kFontSize14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    space(),

                    Text(kSchoolUnDept.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kBlackcolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                    space(),
                    FadeHeading(title: kSchoolUnDeptLevel,),

                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _level,
                            maxLines: null,
                            autocorrect: true,
                            cursorColor: (kMaincolor),
                            style: UploadVariables.uploadfontsize,
                            decoration: Constants.kTopicDecoration,
                            onSaved: (String? value) {
                              level = value;
                            },

                          ),
                          space(),

                          ///classes
                          FadeHeading(title: kSchoolUnDeptClasses,),
                          ClassRequirementList(),

                          TextFormField(
                            controller: _classes,
                            maxLines: null,
                            autocorrect: true,
                            cursorColor: (kMaincolor),
                            style: UploadVariables.uploadfontsize,
                            decoration: Constants.kTopicDecoration,

                            onSaved: (String? value) {
                              classes = value;
                            },

                          ),

                         ///Adding the subject
                          space(),
                          FadeHeading(title: kSchoolUnDeptSubjects,),
                          ObjectiveList(),

                          TextFormField(
                            controller: _subjects,
                            maxLines: null,
                            autocorrect: true,
                            cursorColor: (kMaincolor),
                            style: UploadVariables.uploadfontsize,
                            decoration: InputDecoration(
                                suffixIcon:  IconButton(icon: Icon(Icons.add,size: 30,), onPressed: (){_addSubject();}),
                                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(kPlaylistborder)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMaincolor))
                            ),
                            onSaved: (String? value) {
                              subjects = value;
                            },

                          ),

                  ///Enter teachers for the class
                          space(),
                          FadeHeading(title: kSchoolUnDeptTeacher,),
                          TargetItemsList(),

                          TextFormField(
                            controller: _teacher,
                            autocorrect: true,
                            maxLength: 15,
                            cursorColor: (kMaincolor),
                            style: UploadVariables.uploadfontsize,
                            decoration: InputDecoration(
                                suffixIcon:  IconButton(icon: Icon(Icons.add,size: 30,), onPressed: (){_addTeachers();}),
                                contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(kPlaylistborder)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMaincolor))
                            ),
                            onSaved: (String? value) {
                              teacher = value;
                            },

                          ),

                        ],
                      ),
                    ),
                space(),
                    Text(kSchoolUnDeptTeacherNote.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kBlackcolor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),

                    space(),
                    RaisedButton(
                      color: kStabcolor,
                      onPressed: (){_saveLevel();},
                      child: Text('Save Level'.toUpperCase(),
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhitecolor,
                            fontSize: kFontsize.sp,
                          ),
                        ),
                      ),
                    ),
                    space(),

                  ],
                ),
              )
            ]),
        ),
      ])),
          ),
    );
  }

  /*void _addClasses() {
    //Adding the classes to a list

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(_classes.text.isNotEmpty ){
      setState(() {
        ExpertConstants.requirementItems.add(_classes.text.trim());
        _classes.clear();

      });
    }else{
      SchClassConstant.displayToastError(title:'Enter class');
    }


  }*/

  void _addSubject() {
    //Adding the subject to a list

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(_subjects.text.isNotEmpty ){
      setState(() {
        Objective.items.add(_subjects.text.trim());
        _subjects.clear();

      });
    }else{
      SchClassConstant.displayToastError(title:'Enter subject');
    }

  }

  void _addTeachers() {
    //Adding the subject to a list

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(_teacher.text.isNotEmpty ){
      setState(() {
        TargetedStudents.items.add(_teacher.text.trim());
        _teacher.clear();

      });
    }else{
      SchClassConstant.displayToastError(title:'Enter Teacher(s) name(s)');
    }
  }

  Future<void> _saveLevel() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (_level.text.isEmpty){
        SchClassConstant.displayToastError(title:'Enter level name');

      }else if (_classes.text.isEmpty){


        SchClassConstant.displayToastError(title:'Add level class');

      }else if (Objective.items.isEmpty) {
        SchClassConstant.displayToastError(title:'Add subjects for this level');
      }else if (TargetedStudents.items.isEmpty) {
      SchClassConstant.displayToastError(title:'Add teacher(s) for this level');
    }else{

        //push level to dataBase
setState(() {
  progress = true;
  teachersPin.clear();
});
//generate pin for the teachers
        final random = Random();
        for (var i = 0; i < TargetedStudents.items.length; i++) {
          var r = (random.nextInt(1000000000));
          teachersPin.add(r);

        }
try{


 DocumentReference docRef =  FirebaseFirestore.instance.collection('schoolDepartment').doc(SchClassConstant.schDoc['schId']).collection('levelClasses').doc();


 docRef.set({
    'lv':_level.text.trim(),
    'class': _classes.text.trim(),
    'sub':Objective.items,
    'tc':TargetedStudents.items,
   'pin':teachersPin,
   'schId':SchClassConstant.schDoc['schId'],
   'id':docRef.id,
   'ts':DateTime.now().toString(),
   'name':SchClassConstant.schDoc['name'],
   'logo':SchClassConstant.schDoc['logo'],

   'crt':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}'

 }, SetOptions(merge: true));

 //create teachers collection
 for (var i = 0; i < TargetedStudents.items.length; i++) {
   var capitalizedValue = TargetedStudents.items[i]!.substring(0, 1).toUpperCase();

   DocumentReference docRefs =  FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc();


   docRefs.set({
     'lv':_level.text.trim(),
     'class': _classes.text.trim(),
     'cl': _classes.text.trim(),
     'tc':TargetedStudents.items[i],
     'pin':teachersPin[i],
     'sk':capitalizedValue,
     'schId':SchClassConstant.schDoc['schId'],
     'id':docRefs.id,
     'ts':DateTime.now().toString(),
     'ass':true,
     'name':SchClassConstant.schDoc['name'],
     'logo':SchClassConstant.schDoc['logo'],
     'str': SchClassConstant.schDoc['str'],
     'st': SchClassConstant.schDoc['st'],
     'cty': SchClassConstant.schDoc['cty'],
     'by':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}',
     'ol':'',
     'off':DateTime.now().toString(),
     'onl':false,
     'yr':DateTime.now().year,
     'mth':DateTime.now().month,
     'day':DateTime.now().day,
     'wky':Jiffy().week,
     'lc':0,
     'ld':0,
     'lw':0,
     'lm':0,
     'ly':0,

     'uc':0,
     'ud':0,
     'uw':0,
     'um':0,
     'uy':0,

     'ec':0,
     'ed':0,
     'ew':0,
     'em':0,
     'ey':0,

     'rc':0,
     'rd':0,
     'rw':0,
     'rm':0,
     'ry':0,

     'ac':0,
     'ad':0,
     'aw':0,
     'am':0,
     'ay':0,



   }, SetOptions(merge: true));

   //clear all input

  /* setState(() {
     _level.clear();
     Objective.items.clear();
     TargetedStudents.items.clear();
     ExpertConstants.requirementItems.clear();
     teachersPin.clear();
   });*/
 }

//add the teacher count in the school collection

  FirebaseFirestore.instance.collection('users')
      .doc(SchClassConstant.isAdmin?SchClassConstant.schDoc['oid']:GlobalVariables.loggedInUserObject.id)
      .collection('schoolUsers').doc(SchClassConstant.schDoc['schId']).get().then((value) {

    value.reference.set({
      'stc': value.data()!['stc'] == null?0:value.data()!['stc'] + 1,
    },SetOptions(merge: true));
  });
 setState(() {
   progress = false;
 });
 SchClassConstant.displayBotToastCorrect(title:'${_level.text.trim()} saved successfully');



}catch(e){
          print(e);
  setState(() {
    progress = false;
  });
  SchClassConstant.displayToastError(title:kError);

}

      }
  }
  }
}
