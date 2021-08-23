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
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_result.dart';

class TeachersUploadResult extends StatefulWidget {
  @override
  _TeachersUploadResultState createState() => _TeachersUploadResultState();
}

class _TeachersUploadResultState extends State<TeachersUploadResult> {
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
  bool isSwitched = false;
  late int i;
  String imagePath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudents();
  }

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

        body:  itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        itemsData.length == 0 && progress == true ? Text('No student found'):ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
               children: [
                 Align(
                   alignment: Alignment.topRight,
                   child: Container(
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: kAGreen,
                     ),
                     child: IconButton(icon: Icon(Icons.upload_rounded,color: kWhitecolor,), onPressed: (){ _pickFileUpload(i);}),
                   ),
                 ),


                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(kAllStudentsRes,

                    textAlign: TextAlign.center,
                     style: GoogleFonts.rajdhani(

                       textStyle: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: kBlackcolor,
                         fontSize: kFontsize.sp,
                       ),
                     ),
                   ),
                 ),




          space(),

                 i  != null  && isSwitched == false?Text(''):Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _title,
                maxLines: null,
                autofocus: true,
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

                 Text(imagePath,

                   style: GoogleFonts.rajdhani(
                     textStyle: TextStyle(
                       fontWeight: FontWeight.w500,
                       color: kExpertColor,
                       fontSize: kFontsize.sp,
                     ),
                   ),
                 ),
                 space(),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(kAllStudents,

            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Switch(
              value: isSwitched,
              onChanged: (value){
                setState(() {
                  isSwitched=value;
                });
                   if(isSwitched){
                getTheResult();
              }},
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ),
        ],
      ),




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
        color: SchClassConstant.count.contains(index)?kLightmaincolor:kWhitecolor,
          elevation:5,
          child: ListTile(
            onTap: (){seeResult(index);
            },
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
                        : Icon(Icons.upload_outlined), onPressed: (){},color: kLightGreen,)
                ),


                isSwitched?Container(
                    margin: EdgeInsets.only(right: 30),
                    child:  IconButton(icon: Icon(Icons.radio_button_on,color: kFbColor,), onPressed: (){},color: kMaincolor,)):

                SchClassConstant.countUpload.contains(index)? Container(
                    margin: EdgeInsets.only(right: 30),
                    child:  IconButton(icon: Icon(Icons.radio_button_on), onPressed: (){

                    },color: kMaincolor,))

            : Container(
                    margin: EdgeInsets.only(right: 30),
                    child: IconButton(icon: Icon(Icons.radio_button_unchecked), onPressed: (){

                      i = index;
                      getTheResult();
                    },color: kMaincolor,)),
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
        ),
        ));
  }

  Future<void> getAllStudents() async {
if(SchClassConstant.isLecturer){
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection("uniStudents").doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
      .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
      .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
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


}else{

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("classroomStudents").doc(SchClassConstant.schDoc['schId']).collection('students')
        .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
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
    if(SchClassConstant.isLecturer){
      final QuerySnapshot result = await FirebaseFirestore.instance.
      collection("uniStudents").doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
          .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
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
        .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
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




  void getTheResult() async {
    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

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



  Future<void> _pickFileUpload(index) async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

    }
    if(imageNote != null){
    if(SchClassConstant.count.contains(index)){
      setState(() {
        SchClassConstant.count.removeAt(index);
      });
    }else{
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
      DocumentReference docRef = FirebaseFirestore.instance.collection('studentResult').doc(SchClassConstant.schDoc['schId']).collection('results').doc();
      docRef.set({
        'id': docRef.id,
        'stId': isSwitched?'':itemsData[index]['id'],
        'stun': isSwitched?'':itemsData[index]['un'],
        'stpin': isSwitched?'':itemsData[index]['pin'],
        'schId': SchClassConstant.schDoc['schId'],
        'stfn': isSwitched?'':itemsData[index]['fn'],
        'stln': isSwitched?'':itemsData[index]['ln'],
        'stlv': isSwitched?SchClassConstant.schDoc['lv']:itemsData[index]['lv'],
        'stcl': isSwitched?SchClassConstant.schDoc['cl']:itemsData[index]['cl'],
        're': url,
        'gen':isSwitched?true:false,
        'title': _title.text,
        'ts': DateTime.now().toString(),
        'tc': SchClassConstant.schDoc['tc'],
        'tcId':SchClassConstant.schDoc['tId'],
      });

      //Take the result upload analysis
      teacherIsUploadingLesson(SchClassConstant.schDoc);
      campusTeacherAnalysis(SchClassConstant.schDoc);


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
      SchClassConstant.displayBotToastCorrect(title: 'Result Posted successfully');




  }catch(e){
      setState(() {
        _publishModal = false;
      });
      SchClassConstant.displayBotToastError(title: kError);

    }
    }else{
      SchClassConstant.displayBotToastError(title: 'Please pick result');

    }
  }

  void seeResult(index) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {return StudentsResult(doc:_documents[index]);
        });
  }


  void teacherIsUploadingLesson(DocumentSnapshot doc) {

    //tell the management that this teacher has uploaded a lesson
    if(SchClassConstant.isLecturer){
      ///if this is a campus teacher

      FirebaseFirestore.instance.collection('schoolTutors')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('tutors')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic rc = value.data()!['rc'] == null?0:value.data()!['rc'];
        dynamic rd = value.data()!['rd'] == null?0:value.data()!['rd'];
        dynamic rw = value.data()!['rw'] == null?0:value.data()!['rw'];
        dynamic  rm = value.data()!['rm'] == null?0:value.data()!['rm'];
        dynamic ry = value.data()!['ry'] == null?0:value.data()!['ry'];


        FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
          'uc':rc + 1,
          'ud': value.data()!['day'] == DateTime.now().day?rd + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?rw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?rm + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?ry + 1:1,
          'lot':DateTime.now().toString(),
          'ryr':DateTime.now().year,
          'rmth':DateTime.now().month,
          'rday':DateTime.now().day,
          'rwky':Jiffy().week,


        },SetOptions(merge:  true));


        campusTeacherAnalysis(doc);


      });




    }else{
      ///if this is a high school teacher

      FirebaseFirestore.instance.collection('teachers')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('schoolTeachers')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic rc = value.data()!['rc'] == null?0:value.data()!['rc'];
        dynamic rd = value.data()!['rd'] == null?0:value.data()!['rd'];
        dynamic rw = value.data()!['rw'] == null?0:value.data()!['rw'];
        dynamic  rm = value.data()!['rm'] == null?0:value.data()!['rm'];
        dynamic ry = value.data()!['ry'] == null?0:value.data()!['ry'];


        FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
          'uc':rc + 1,
          'ud': value.data()!['day'] == DateTime.now().day?rd + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?rw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?rm + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?ry + 1:1,
          'ryr':DateTime.now().year,
          'rmth':DateTime.now().month,
          'rday':DateTime.now().day,
          'rwky':Jiffy().week,
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
        'rc':1,
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
          'rc': resultData.data()!['rc'] == null?1:resultData.data()!['rc'] + 1,
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
        'rc':1,
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
          'rc': resultData.data()!['rc'] == null?1:resultData.data()!['rc'] + 1,
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
        'rc':1,
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
          'rc': resultData.data()!['rc'] == null?1:resultData.data()!['rc'] + 1,
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
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'rc':1
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
          'rc': resultData.data()!['rc'] == null?1:resultData.data()!['rc'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }



  }



  }

