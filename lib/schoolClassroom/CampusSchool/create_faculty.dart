import 'package:flutter/material.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
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
import 'package:sparks/schoolClassroom/SchoolAdmin/view_department.dart';
import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class CreateFaculty extends StatefulWidget {
  @override
  _CreateFacultyState createState() => _CreateFacultyState();
}

class _CreateFacultyState extends State<CreateFaculty> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level =  TextEditingController();
  TextEditingController _subjects =  TextEditingController();
  static  List<int> teachersPin = <int>[];

  String? level;
  String? subjects;
var pin;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: CampusAppbar2(),
      body: ModalProgressHUD(
      inAsyncCall: progress,
      child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(
              children: [


                space(),

                Text(kSchoolUnDept2.toString(),
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
                FadeHeading(title: 'Enter faculty name',),

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


                      ///Adding the department
                      space(),
                      FadeHeading(title: 'Add the departments under this faculty',),
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


                space(),
                RaisedButton(
                  color: kStabcolor,
                  onPressed: (){_saveLevel();},
                  child: Text('Save Faculty'.toUpperCase(),
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

    ))));
  }
  void _addSubject() {
    //Adding the subject to a list


    if(_subjects.text.isNotEmpty ){
      setState(() {
        Objective.items.add(_subjects.text.trim());
        _subjects.clear();

      });
    }else{
      SchClassConstant.displayToastError(title:'Add department(s)');
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
        SchClassConstant.displayToastError(title:'Enter faculty name');

      }else if (Objective.items.isEmpty) {
        SchClassConstant.displayToastError(title:'Add department under this faculty');
      }else{

        //push level to dataBase
        setState(() {
          progress = true;
          teachersPin.clear();
        });
//generate pin for the teachers
        final random = Random();
           pin = (random.nextInt(1000000000));

        }
        try{


          DocumentReference docRef =  FirebaseFirestore.instance.collection('schoolFaculty').doc(SchClassConstant.schDoc['schId']).collection('faculty').doc();


          docRef.set({
            'lv':_level.text.trim(),
            'sub':Objective.items,
            'pin':pin,
            'schId':SchClassConstant.schDoc['schId'],
            'id':docRef.id,
            'ts':DateTime.now().toString(),
            'name':SchClassConstant.schDoc['name'],
            'logo':SchClassConstant.schDoc['logo'],

            'crt':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}'

          }, SetOptions(merge: true));
          //add the Admin count in the school collection

          FirebaseFirestore.instance.collection('users')
              .doc(SchClassConstant.isAdmin?SchClassConstant.schDoc['oid']:GlobalVariables.loggedInUserObject.id)
              .collection('schoolUsers').doc(SchClassConstant.schDoc['schId']).get().then((value) {

            value.reference.set({
              'sfc': value.data()!['sfc'] == null?0:value.data()!['sfc'] + 1,
            },SetOptions(merge: true));

          });

          //create department collection
          DocumentReference docRefs =  FirebaseFirestore.instance.collection('schoolDeptList').doc(SchClassConstant.schDoc['schId']).collection('deptList').doc();

          docRef.set({
            'id':docRefs,
            'dept':Objective.items,
            'schId':SchClassConstant.schDoc['schId'],
            'ts':DateTime.now().toString(),
          });

          //add the Admin count in the school collection

          FirebaseFirestore.instance.collection('users')
              .doc(SchClassConstant.isAdmin?SchClassConstant.schDoc['oid']:GlobalVariables.loggedInUserObject.id)
              .collection('schoolUsers').doc(SchClassConstant.schDoc['schId']).get().then((value) {

            value.reference.set({
              'sdc': value.data()!['sdc'] == null?0:value.data()!['sdc'] + 1,
            },SetOptions(merge: true));

          });
          setState(() {
            progress = false;
          });
          SchClassConstant.displayBotToastCorrect(title:'${_level.text.trim()} Faculty created successfully');
           setState(() {
     _level.clear();
     Objective.items.clear();
     teachersPin.clear();
   });


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

