import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/sliverAppbarCampus.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_result.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';

class SchoolResult extends StatefulWidget {
  @override
  _SchoolResultState createState() => _SchoolResultState();
}

class _SchoolResultState extends State<SchoolResult> {
  var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title =  TextEditingController();
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;
  String? title;
  File? imageNote;
  String get fileImagePaths => 'studentsResult/${DateTime.now()}';
  bool _publishModal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAllStudents();

    getSchoolDetails();
  }

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }
  List<dynamic> schoolLevels = <dynamic>[];
  List<dynamic> schoolClasses = <dynamic>[];
  String students = '';
String levels = SchClassConstant.schDoc['camp'] == true?'Select department':'Select level';
String classes = SchClassConstant.schDoc['camp'] == true?'Select Faculty':'Select class';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: StuAppBar(),

      body:ModalProgressHUD(
        inAsyncCall: _publishModal,
        child: CustomScrollView(slivers: <Widget>[
          ProprietorActivityAppBar(
          activitiesColor: kTextColor,
          classColor: kTextColor,
          newsColor: kTextColor,
          studiesColor: kStabcolor1,
        ),
        CampusSliverAppBarStudies(
          campusBgColor: Colors.transparent,
          campusColor: klistnmber,
          deptBgColor: Colors.transparent,
          deptColor: klistnmber,
          recordsBgColor: klistnmber,
          recordsColor: kWhitecolor,
          eClassBgColor: Colors.transparent,
          eClassColor: klistnmber,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      RaisedButton(onPressed:(){getClasses();},
                        color: kWhitecolor,

                        child: Text(classes,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kLightGreen,
                              fontSize: kFontsize.sp,
                            ),
                          ),

                        ),
                      ),

                      RaisedButton(onPressed:(){getLevels();},
                        color: kExpertColor,
                        child: Text(levels,
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),

                        ),
                      ),


                      RaisedButton(onPressed:(){ getAllStudents();},
                        color: kLightGreen,

                        child: Text('Select student',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhitecolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),

                        ),
                      )

                    ],
                  ),

                  space(),

                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _title,
                        maxLines: null,
                        maxLength: 50,
                        cursorColor: (kMaincolor),
                        textCapitalization: TextCapitalization.sentences,
                        style: UploadVariables.uploadfontsize,
                        decoration: Constants.kResultDecoration,
                        onSaved: (String? value) {
                          title = value;
                        },
                        validator: Validator.validateSchUn,

                      ),
                    ),
                  ),
                  space(),

                  Text(kSchoolStudentAssignmentNote,

                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: klistnmber,
                        fontSize: kFontSize14.sp,
                      ),
                    ),
                  ),
                  space(),
                  itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                  itemsData.length == 0 && progress == true ? Text('No student found. Select level and class, tap on the students',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: klistnmber,
                        fontSize: kFontsize.sp,
                      ),
                    ),

                  ):
                  space(),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _documents.length,
                      itemBuilder: (context, int index) {


                        return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),

                            child: Column(

                                children: <Widget>[
                                  Card(
                                    elevation:5,
                                    child: ListTile(
                                        onTap: (){seeResult(index);},
                                        leading:  CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: FadeInImage.assetNetwork(
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                              image: ('${itemsData[index]['logo']}'.toString()),
                                              placeholder: 'images/classroom/user.png',),
                                          ),

                                        ),
                                        title:  Text(itemsData[index]['fn'],
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBlackcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),

                                        subtitle: Text(itemsData[index]['ln'],
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBlackcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),

                                        ),

                                        trailing:Stack(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(left: 40),
                                                  child: IconButton(icon:SchClassConstant.countUpload.contains(index)?

                                                  Icon(Icons.check,color: kLightGreen,)
                                                      : Icon(Icons.upload_outlined), onPressed: (){_pickFileUpload(index);},color: kLightGreen,)
                                              ),

                                              SchClassConstant.count.contains(index)? Container(
                                                  margin: EdgeInsets.only(right: 30),
                                                  child:  IconButton(icon: Icon(Icons.radio_button_on), onPressed: (){_uploadResult(index);},color: kMaincolor,))

                                                  : Container(
                                                  margin: EdgeInsets.only(right: 30),
                                                  child: IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: (){_uploadResult(index);},color: kMaincolor,)),
                                              //IconButton(icon: Icon(Icons.upload_outlined), onPressed: (){},color: kLightGreen,)


                                            ])
                                    ),
                                  )


                                ]
                            ));
                      }

                  ),

                  progress == true || _loadMoreProgress == true
                      || _documents.length < SchClassConstant.streamCount
                      ?Text(''):
                  moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                      onTap: (){loadMore();},
                      child: SvgPicture.asset('images/classroom/load_more.svg',))

                ]),

          ),
        ]),
      ),
    ));
  }

  Future<void> getAllStudents() async {
    _documents.clear();
    itemsData.clear();
    print(classes);
    print(levels);
    //check if its for campus
    if(SchClassConstant.schDoc['camp'] == true) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection("uniStudents").doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('cl', isEqualTo: levels)
          .where('fac', isEqualTo: classes)
          .where('ass', isEqualTo: true)
          .orderBy('ts',descending: true)
          .limit(SchClassConstant.streamCount)
          .get();

      final List <DocumentSnapshot> documents = result.docs;
      if(documents.length == 0){
        print('kkkkk');
        setState(() {
          progress = true;
        });

      }else {
        print('tttttttt');
        for (DocumentSnapshot document in documents) {
          _lastDocument = documents.last;
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());


          });



        }
      }
    }else{

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("classroomStudents").doc(SchClassConstant.schDoc['schId']).collection('students')
        .where('cl', isEqualTo: classes)
        .where('lv', isEqualTo: levels)
        .where('ass', isEqualTo: true)
        .orderBy('ts',descending: true)
        .limit(SchClassConstant.streamCount)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());


        });



      }
    }
  }}

  Future<void> loadMore() async {

    if(SchClassConstant.schDoc['camp'] == true){
      final QuerySnapshot result = await FirebaseFirestore.instance.collection("uniStudents").doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
        .where('cl', isEqualTo: classes)
        .where('dept', isEqualTo: levels)
        .where('ass', isEqualTo: true)
        .orderBy('ts',descending: true).

      startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount)

          .get();
      final List <DocumentSnapshot> documents = result.docs;
      if(documents.length == 0){
        setState(() {
          _loadMoreProgress = true;
        });

      }else {
        for (DocumentSnapshot document in documents) {
          _lastDocument = documents.last;

          setState(() {
            moreData = true;
            _documents.add(document);
            itemsData.add(document.data());

            moreData = false;


          });
        }
      }
    }else{

    final QuerySnapshot result = await FirebaseFirestore.instance.
    collection("classroomStudents").doc(SchClassConstant.schDoc['schId']).collection('students')
        .where('cl', isEqualTo: classes)
        .where('lv', isEqualTo: levels)
        .where('ass', isEqualTo: true)

        .orderBy('ts',descending: true).

    startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;


        });
      }
    }
  }}

  Future<void> _uploadResult(int index) async {
    //pick file
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      // File file = await FilePicker.getFile(
      //   type: FileType.custom,
      //   allowedExtensions: ['pdf'],
      // );

      FilePickerResult result = await (FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      ) as Future<FilePickerResult>);

      File file = File(result.files.single.path!);

      int fileSize = file.lengthSync();
      if (fileSize <= kSFileSize) {
        setState(() {
          imageNote = file;
        });
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            msg: 'Result picked',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kLightGreen);
      } else {
        Fluttertoast.showToast(
            msg: kSCourseError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackcolor,
            textColor: kFbColor);
      }
    }
  }

  Future<void> _pickFileUpload(int index) async {
    if (imageNote != null) {
      if (SchClassConstant.count.contains(index)) {
      } else {
        setState(() {
          SchClassConstant.count.add(index);
        });
      }
      setState(() {
        _publishModal = true;
      });
      //upload the file first
      try {
        Reference ref = FirebaseStorage.instance.ref().child(fileImagePaths);
        Constants.courseThumbnail = ref.putFile(
          imageNote!,
          SettableMetadata(
            contentType: 'images.pdf',
          ),
        );

        final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
        String url = await downloadUrl.ref.getDownloadURL();

        //push it database
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('studentResult')
            .doc(SchClassConstant.schDoc['schId'])
            .collection('results')
            .doc();
        docRef.set({
          'id': docRef.id,
          'stId': itemsData[index]['id'],
          'stun': itemsData[index]['un'],
          'stpin': itemsData[index]['pin'],
          'schId': SchClassConstant.schDoc['schId'],
          'stfn': itemsData[index]['fn'],
          'stln': itemsData[index]['ln'],
          'stlv': itemsData[index]['lv'],
          'stcl': itemsData[index]['cl'],
          're': url,
          'title': _title.text,
          'ts': DateTime.now().toString(),
          'tc':
          '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}'
        });
        setState(() {
          _publishModal = false;
          imageNote = null;
        });
        if (SchClassConstant.countUpload.contains(index)) {
        } else {
          setState(() {
            SchClassConstant.countUpload.add(index);
          });
        }
        SchClassConstant.displayBotToastCorrect(title: 'Posted');
      } catch (e) {
        print(e);
        setState(() {
          _publishModal = false;
        });
        SchClassConstant.displayBotToastError(title: kError);
      }
    } else {
      SchClassConstant.displayBotToastError(title: 'Please pick result');
    }
  }

  void seeResult(int index) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentsResult(doc: _documents[index]);
        });
  }

  void getLevels() {
//display a dialog to show list of all levels in this school

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            title: Text(
              'Registered levels',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kFbColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
            children: <Widget>[
              Column(children: <Widget>[
                ListView.builder(
                    itemCount: schoolLevels.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            levels = schoolLevels[index];
                          });
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.circle,
                          color: kFbColor,
                        ),
                        title: Text(
                          schoolLevels[index],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      );
                    })
              ])
            ]));
  }

  void getClasses() {
//display a dialog to show list of all levels in this school

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            title: Text(
              'Registered classes',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kFbColor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),
            children: <Widget>[
              Column(children: <Widget>[
                ListView.builder(
                    itemCount: schoolClasses.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            classes = schoolClasses[index];
                          });
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.circle,
                          color: kFbColor,
                        ),
                        title: Text(
                          schoolClasses[index],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kBlackcolor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      );
                    })
              ])
            ]));
  }

  void getDept() {
//display a dialog to show list of all levels in this school
    SchClassConstant.showLevelDialog(
        title: 'Registered Department(s)',
        context: context,
        count: ListView.builder(
            itemCount: schoolLevels.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, int index) {
              return ShowLevels(
                title: schoolLevels[index],
                click: () {
                  setState(() {
                    classes = schoolLevels[index];
                  });
                  Navigator.pop(context);
                },
              );
            }));
  }

  void getFaculty() {
//display a dialog to show list of all levels in this school
    SchClassConstant.showLevelDialog(
        title: 'Registered Faculty',
        context: context,
        count: ListView.builder(
            itemCount: schoolClasses.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, int index) {
              return ShowLevels(
                title: schoolClasses[index],
                click: () {
                  setState(() {
                    levels = schoolClasses[index];
                  });
                  Navigator.pop(context);
                },
              );
            }));
  }

  Future<void> getSchoolDetails() async {
    //check if its for campus
    if (SchClassConstant.schDoc['camp'] == true) {
      //campus
      List<dynamic> f = <dynamic>[];
      List<dynamic> d = <dynamic>[];

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('department')
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .orderBy('ts', descending: true)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          setState(() {
            f.add(data!['fa']);
            d.add(data['dept']);
          });
        }

        setState(() {
          schoolLevels.addAll(d.toList().toSet());
          schoolClasses.addAll(f.toList().toSet());
        });
      }
    } else {
      //not campus

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('levelClasses')
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .orderBy('ts', descending: true)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          setState(() {
            schoolLevels.add(data!['lv']);
            schoolClasses.add(data['class']);
          });
        }
      }
    }
  }
}



