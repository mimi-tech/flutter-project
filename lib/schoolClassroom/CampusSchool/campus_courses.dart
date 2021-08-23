import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class CampusCourses extends StatefulWidget {
  CampusCourses({required this.doc,required this.name});
  final List<dynamic> doc;
  final String name;
  @override
  _CampusCoursesState createState() => _CampusCoursesState();
}

class _CampusCoursesState extends State<CampusCourses> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level =  TextEditingController();
  TextEditingController _level2 =  TextEditingController();
  TextEditingController _tutors =  TextEditingController();
  TextEditingController _course =  TextEditingController();
  static  List<int> teachersPin = <int>[];

   String? level;
  String? level2;
  String ?tutors;
  String ?course;
  var pin;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get the count of friends
    FirebaseFirestore.instance.collection('schoolHod')
        .where('dept',isEqualTo: widget.name)
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('facId',isEqualTo: widget.doc[0]['id'])

        .get().then((value){
      setState(() {
        _level.text = value.docs[0]['hod'];

      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

        appBar:CampusDeptAppbar(name: widget.name,),
        body:ModalProgressHUD(
          inAsyncCall: progress,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Column(
                children: [
                  space(),

                  Text('Departmental course Registration',
                    style: GoogleFonts.rajdhani(
                      decoration: TextDecoration.underline,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kBlackcolor,
                        fontSize: 20.sp,
                      ),
                    ),

                  ) ,
                  space(),
                  space(),

                  Form(
    key: _formKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
    children: [
      FadeHeading(title: 'Head of department name',),

      TextFormField(
    controller: _level,
    maxLines: null,
    textCapitalization: TextCapitalization.sentences,
    autocorrect: true,
    cursorColor: (kMaincolor),
    style: UploadVariables.uploadfontsize,
    decoration: Constants.kTopicDecoration,
    onSaved: (String? value) {
    level = value;
    },

    ),
    space(),


      FadeHeading(title: 'Enter Level',),

      TextFormField(
        controller: _level2,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        cursorColor: (kMaincolor),
        style: UploadVariables.uploadfontsize,
        decoration: Constants.kTopicDecoration,
        onSaved: (String? value) {
          level2 = value;
        },

      ),
      space(),

      FadeHeading(title: 'Enter course name',),

      TextFormField(
              controller: _course,
              maxLines: null,
        textCapitalization: TextCapitalization.sentences,

        autocorrect: true,
              cursorColor: (kMaincolor),
              style: UploadVariables.uploadfontsize,
              decoration: Constants.kTopicDecoration,
              onSaved: (String? value) {
                course = value;
              },

      ),
      space(),

      ///Enter teachers for the class
      space(),
      FadeHeading(title: 'Add tutor(s) for this course',),
      TargetItemsList(),

      TextFormField(
              controller: _tutors,
              autocorrect: true,
              maxLength: 15,
        textCapitalization: TextCapitalization.sentences,

        cursorColor: (kMaincolor),
              style: UploadVariables.uploadfontsize,
              decoration: InputDecoration(
                  suffixIcon:  IconButton(icon: Icon(Icons.add,size: 30,), onPressed: (){_addTeachers();}),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(kPlaylistborder)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kMaincolor))
              ),
              onSaved: (String? value) {
                tutors = value;
              },

      ),

    ],
              )
    ),
                  space(),
                  RaisedButton(
                    color: kStabcolor,
                    onPressed: (){_saveLevel();},
                    child: Text('Save'.toUpperCase(),
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


                ]),
            ),
          ),
        )
    ));
  }

  void _addTeachers() {
    if(_tutors.text.isNotEmpty ){
      setState(() {
        TargetedStudents.items.add(_tutors.text.trim());
        _tutors.clear();

      });
    }else{
      SchClassConstant.displayToastError(title:'Enter tutor(s) name(s)');
    }
  }

  void _saveLevel() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (_level.text.isEmpty) {
        SchClassConstant.displayToastError(title: 'Enter name');
      }else if (_level2.text.isEmpty) {
        SchClassConstant.displayToastError(title: 'Enter level');
      } else if (_course.text.isEmpty) {
        SchClassConstant.displayToastError(title: 'Add course name');
      } else if (TargetedStudents.items.length == 0) {
        SchClassConstant.displayToastError(
            title: 'Add tutors(s) for this course');
      } else {
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
        setState(() {
          progress = true;
        });
        try {
          //save departmental head name
          DocumentReference doc = FirebaseFirestore.instance.collection('schoolHod').doc();

          doc.set({
            'dept':widget.name,
            'hod':_level.text.trim(),
            'id':doc.id,
            'schId':SchClassConstant.schDoc['schId'],
            'facId':widget.doc[0]['id']
          });


//push to database
          DocumentReference docRef =  FirebaseFirestore.instance.collection('schoolDepartments').doc(SchClassConstant.schDoc['schId']).collection('department').doc();


          docRef.set({
            'hod':_level.text.trim(),
            'lv':_level2.text.trim(),
            'cur':TargetedStudents.items,
            'pin':teachersPin,
            'schId':SchClassConstant.schDoc['schId'],
            'id':docRef.id,
            'ts':DateTime.now().toString(),
            'name':SchClassConstant.schDoc['name'],
            'logo':SchClassConstant.schDoc['logo'],
            'dept':widget.name,
            'fa':widget.doc[0]['lv'],
            'curs':_course.text,

            'crt':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}'

          }, SetOptions(merge: true));

          //create teachers collection
          for (var i = 0; i < TargetedStudents.items.length; i++) {
            DocumentReference docRefs =  FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc();


            docRefs.set({
              'hod':_level.text.trim(),
              'dept':widget.name,
              'cl':widget.name,//optional not sure
              'fa':widget.doc[0]['lv'],
              'lv':_level2.text.trim(),
              'curs':_course.text,
              'tc':TargetedStudents.items[i],
              'pin':teachersPin[i],
              'schId':SchClassConstant.schDoc['schId'],
              'id':docRefs.id,
              'ts':DateTime.now().toString(),
              'name':SchClassConstant.schDoc['name'],
              'logo':SchClassConstant.schDoc['logo'],
              'facId':widget.doc[0]['id'],
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

            //add the tutors count in the school collection

            FirebaseFirestore.instance.collection('users')
                .doc(SchClassConstant.isAdmin?SchClassConstant.schDoc['oid']:GlobalVariables.loggedInUserObject.id)
                .collection('schoolUsers').doc(SchClassConstant.schDoc['schId']).get().then((value) {

              value.reference.set({
                'stc': value.data()!['stc'] == null?0:value.data()!['stc'] + 1,
              },SetOptions(merge: true));

            });
            //clear all input


             setState(() {
     TargetedStudents.items.clear();
     teachersPin.clear();
     _course.clear();
   });
          }

          setState(() {
            progress = false;
          });
          SchClassConstant.displayBotToastCorrect(title:'${_course.text.trim()} saved successfully');


        } catch (e) {
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: kError);
        }
      }
    }
  }}
