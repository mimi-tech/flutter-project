import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AddCampusNewStudents extends StatefulWidget {
  @override
  _AddCampusNewStudentsState createState() => _AddCampusNewStudentsState();
}

class _AddCampusNewStudentsState extends State<AddCampusNewStudents> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool progress = false;
  TextEditingController _level = TextEditingController();
  TextEditingController _classes = TextEditingController();
  TextEditingController _faculty = TextEditingController();
  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  TextEditingController _otherName = TextEditingController();
  List<dynamic> schoolLevels = <dynamic>[];
  List<dynamic> schoolClasses = <dynamic>[];
  List<dynamic> schoolDept = <dynamic>[];
  List<dynamic> workingDocuments = <dynamic>[];

  String? level;
  String? classes;
  String? faculty;
  String? fName;
  String? lName;
  String? otherName;
  int? selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = klistnmber;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }


  int ?selectedRadioGender;
  Color radioColorGender1 = kBlackcolor;
  Color radioColorGender2 = klistnmber;

  setSelectedRadioGender(int val) {
    setState(() {
      selectedRadioGender = val;
    });
  }

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 1;

    getSchoolDetails();
  }
bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CampusDeptAppbar(name: '${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}',),
        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
              child: StickyHeader(
                  header:  SchoolHeader(title: 'Add A student',),


                  content: workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                  workingDocuments.length == 0 && progress == true ? Center(child: NoContentCreated(
                    title: 'You have not registered your school departments',)):SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Column(children: <Widget>[

                        space(),
                        ExpertTitle(
                          title: kSchoolStudent1,
                        ),
                        Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(children: [
                              ///fName

                              TextFormField(
                                controller: _fName,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String ?value) {
                                  fName = value;
                                },
                                validator: Validator.validateStudent1,
                              ),

                              ///lName
                              space(),
                              ExpertTitle(
                                title: kSchoolStudent2,
                              ),
                              TextFormField(
                                controller: _lName,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String ?value) {
                                  lName = value;
                                },
                                validator: Validator.validateStudent2,

                              ),


                              ///other
                              space(),
                              ExpertTitle(
                                title: kSchoolStudent22,
                              ),
                              TextFormField(
                                controller: _otherName,
                                maxLines: null,
                                autocorrect: true,
                                cursorColor: (kMaincolor),
                                style: UploadVariables.uploadfontsize,
                                decoration: Constants.kTopicDecoration,
                                onSaved: (String ?value) {
                                  otherName = value;
                                },
                                validator: Validator.validateStudent2,

                              ),
                              space(),

                              ///select gender
                              ExpertTitle(
                                title: kSchoolStudent11,
                              ),
                              ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedRadioGender,
                                          activeColor: kBlackcolor,
                                          onChanged: ( dynamic val) {
                                            setSelectedRadio( val);

                                            setState(() {
                                              radioColorGender1 = kBlackcolor;
                                              radioColorGender2 = klistnmber;
                                            });
                                          },
                                        ),
                                        Text('Female',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: radioColorGender1,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    Row(
                                        children: <Widget>[
                                          Radio(
                                            value: 2,
                                            groupValue: selectedRadioGender,
                                            activeColor: kBlackcolor,
                                            onChanged: (dynamic val) {
                                              setSelectedRadio(val);

                                              setState(() {
                                                radioColorGender2 = kBlackcolor;
                                                radioColorGender1 = klistnmber;
                                              });

                                            },
                                          ),
                                          Text('Male',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: radioColorGender2,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ])]),
                              space(),

                              ///level
                              ExpertTitle(
                                title: kSchoolStudent3,
                              ),
                              GestureDetector(
                                onTap: (){
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  getLevels();
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _level,
                                    maxLines: null,
                                    autocorrect: true,
                                    cursorColor: (kMaincolor),
                                    style: UploadVariables.uploadfontsize,
                                    decoration: Constants.kTopicDecoration,
                                    onSaved: (String? value) {
                                      level = value;
                                    },
                                    validator: Validator.validateStudent5,

                                  ),
                                ),
                              ),


                              space(),
                              ///class
                              ExpertTitle(
                                title: kSchoolStudent15,
                              ),
                              GestureDetector(
                                onTap: (){
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  getDept();
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _classes,
                                    maxLines: null,
                                    autocorrect: true,
                                    cursorColor: (kMaincolor),
                                    style: UploadVariables.uploadfontsize,
                                    decoration: Constants.kTopicDecoration,
                                    onSaved: (String? value) {
                                      classes = value;
                                    },
                                    validator: Validator.validateStudent5,

                                  ),
                                ),
                              ),


                              space(),
                              ///faculty
                              ExpertTitle(
                                title: kSchoolStudent16,
                              ),
                              GestureDetector(
                                onTap: (){
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  getFaculty();
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _faculty,
                                    maxLines: null,
                                    autocorrect: true,
                                    cursorColor: (kMaincolor),
                                    style: UploadVariables.uploadfontsize,
                                    decoration: Constants.kTopicDecoration,
                                    onSaved: (String? value) {
                                      faculty = value;
                                    },
                                    validator: Validator.validateStudent5,

                                  ),
                                ),
                              ),


                              space(),

                              ExpertTitle(
                                title: kSchoolStudent5,
                              ),
                              ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedRadio,
                                          activeColor: kBlackcolor,
                                          onChanged: (dynamic val) {
                                            setSelectedRadio(val);

                                            setState(() {
                                              radioColor1 = kBlackcolor;
                                              radioColor2 = klistnmber;
                                            });
                                          },
                                        ),
                                        Text('Yes',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: radioColor1,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                    Row(
                                        children: <Widget>[
                                          Radio(
                                            value: 2,
                                            groupValue: selectedRadio,
                                            activeColor: kBlackcolor,
                                            onChanged: (dynamic val) {
                                              setSelectedRadio(val);

                                              setState(() {
                                                radioColor2 = kBlackcolor;
                                                radioColor1 = klistnmber;
                                              });

                                            },
                                          ),
                                          Text('No',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: radioColor2,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ])]),



                             RaisedButton(onPressed: (){
                                _saveStudent();
                              },
                                color: kFbColor,
                                child: Text('Save',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kWhitecolor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),

                                ),
                              ),

                            ]))
                      ]),
                    ),
                  ))),
        ),
      ),
    );
  }

  void _saveStudent()  {

    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _publishModal = true;
      });
      final random = Random();
      var userName =  faker.internet.userName();
      var pin = random.nextInt(1000000);
      var capitalizedValue = _fName.text.substring(0, 1).toUpperCase();
      try{

        DocumentReference docRef = FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents').doc();
        docRef.set({
          'fn':_fName.text.trim(),
          'ln':_lName.text.trim(),
          'oth':_otherName.text.trim(),
          'lv':_level.text.trim(),
          'dept':_classes.text.trim(),
          'cl':_classes.text.trim(),
          'fac':_faculty.text.trim(),
          'sk': capitalizedValue,
          'ass':selectedRadio == 1?true:false,
          'sex':selectedRadioGender == 1?'Female':'Male',
          'ts':DateTime.now().toString(),
          'schId':SchClassConstant.schDoc['schId'],
          'did':docRef.id,
          'id':docRef.id,
          'sN':SchClassConstant.schDoc['name'],
          'logo':SchClassConstant.schDoc['logo'],
          'st':SchClassConstant.schDoc['st'],
          'cty':SchClassConstant.schDoc['cty'],
          'str':SchClassConstant.schDoc['str'],
          'un':userName,
          'pin':pin,
          'ol':'',
          'off':DateTime.now().toString(),
          'onl':false,
          'by':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}',

        });

        //add the student count in the school collection

        FirebaseFirestore.instance.collection('users')
            .doc(SchClassConstant.isAdmin?SchClassConstant.schDoc['oid']:GlobalVariables.loggedInUserObject.id)
            .collection('schoolUsers').doc(SchClassConstant.schDoc['schId']).get().then((value) {

          value.reference.set({
            'ssc': value.data()!['ssc'] == null?0:value.data()!['ssc'] + 1,
          },SetOptions(merge: true));
        });

        setState(() {
          _publishModal = false;
        });


        SchClassConstant.displayBotToastCorrect(title: 'Saved successfully');
      }catch(e){
        setState(() {
          _publishModal = false;
        });
        SchClassConstant.displayBotToastError(title: kError);
      }}
  }

  void getLevels() {
//display a dialog to show list of all levels in this school
    SchClassConstant.showLevelDialog(title: 'Registered levels', context: context, count:
    ListView.builder(
        itemCount: schoolLevels.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return  ShowLevels(
            title: schoolLevels[index],
            click:  (){
            setState(() {
            _level.text = schoolLevels[index];
          });
              Navigator.pop(context);

        },);
        }
    )

    );



  }


  void getDept() {
//display a dialog to show list of all levels in this school
    SchClassConstant.showLevelDialog(title: 'Registered Department(s)', context: context, count:
    ListView.builder(
        itemCount: schoolDept.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return  ShowLevels(
            title: schoolDept[index],
            click:  (){
              setState(() {
                _classes.text = schoolDept[index];
              });
              Navigator.pop(context);

            },);
        }
    )

    );


  }


  void getFaculty() {
//display a dialog to show list of all levels in this school
    SchClassConstant.showLevelDialog(title: 'Registered Faculty', context: context, count:
    ListView.builder(
        itemCount: schoolClasses.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return  ShowLevels(
            title: schoolClasses[index],
            click:  (){
              setState(() {
                _faculty.text = schoolClasses[index];
              });
              Navigator.pop(context);

            },);
        }
    )

    );


  }


  Future<void> getSchoolDetails() async {
    List<dynamic> l = <dynamic>[];
    List<dynamic> f = <dynamic>[];
    List<dynamic> d = <dynamic>[];

    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('department').
    where('schId',isEqualTo:  SchClassConstant.schDoc['schId']).orderBy('ts',descending: true)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          workingDocuments.add(document.data());
          l.add(data['lv']);
          f.add(data['fa']);
          d.add(data["dept"]);


        });


      }

      setState(() {
        schoolLevels.addAll(l.toList().toSet());
        schoolClasses.addAll(f.toList().toSet());
        schoolDept.addAll(d.toList().toSet());
      });
    }
  }
}
