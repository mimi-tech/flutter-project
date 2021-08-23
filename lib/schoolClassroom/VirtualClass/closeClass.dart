import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/sparksCompanies/yesNo.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class CloseClass extends StatefulWidget {
  @override
  _CloseClassState createState() => _CloseClassState();
}

class _CloseClassState extends State<CloseClass> {
  List<dynamic> attendantList = <dynamic>[];

  List<dynamic> classList = <dynamic>[];

  List<dynamic> missedClassList = <dynamic>[];

  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: Duration(milliseconds: 400),
    curve: Curves.decelerate,
    child: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Do wish to end this class?',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kBlackcolor,
                  fontSize: kFontsize.sp,
                ),
              ),

            ),
          ),
          progress?CircularProgressIndicator(backgroundColor: kFbColor,):YesNoBtn(no: (){Navigator.pop(context);}, yes: (){
            if(SchClassConstant.isTeacher){

            setState(() {
              progress = true;
            });
         //get the list of students that missed the class

              ///get the list of students that attended the class

       FirebaseFirestore.instance.collection('classAttendant').doc(videoId).collection('classList').get().then((value) {
         final List < DocumentSnapshot > documents = value.docs;
        
         for(DocumentSnapshot doc in documents){
           Map<String, dynamic> data =
           doc.data() as Map<String, dynamic>;
           attendantList.add(data['uid']);
         }
       });

       ///get the list of student for this class
         FirebaseFirestore.instance.collection('classroomStudents').doc(
        SchClassConstant.schDoc['schId']).collection('students')
        .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv', isEqualTo:SchClassConstant.schDoc['lv'])
        .orderBy('ts', descending: true).get().then((value){

           final List < DocumentSnapshot > documents = value.docs;

           for(DocumentSnapshot doc in documents){
             Map<String, dynamic> data =
             doc.data() as Map<String, dynamic>;
             if(!attendantList.contains(data['id'])){
               classList.add(data['id']);
               missedClassList.add(data);
             }


           }

         });

         ///push missed classes

    for(int i = 0; i < missedClassList.length; i++){
      FirebaseFirestore.instance.collection('missedClass').doc(videoId).collection('missedClassList').add({
       'fn':missedClassList[i]['fn'],
        'ln':missedClassList[i]['ln'],
        'lv':missedClassList[i]['lv'],
        'cl':missedClassList[i]['cl'],
        'stId':missedClassList[i]['id'],
        'schId':missedClassList[i]['schId'],
        'ts':DateTime.now().toString(),
        'tp':SchoolPostConst.liveVideoDoc['tp'],
        'cn':SchoolPostConst.liveVideoDoc['cn'],
        'vido':'',
        'tcId':SchoolPostConst.liveVideoDoc['tcId'],
        'tsn':SchoolPostConst.liveVideoDoc['tsn'],
      });
    }

       DocumentReference  docRef = FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses').doc(videoId);
       docRef.set({
         'act':true,
         'close':true,
         'tm':getClassPeriodTaken,
         'mis':missedClassList.length,
         'att':attendantList.length
       },SetOptions(merge: true));


       ///update teachers live false
    //tell the management that this teacher is live
            teacherIsLive();




    setState(() {
              progress = false;
            });
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentsEClasses(),),);




          }else{


              //This collection is to get the students attendant live class analysis
              setState(() {
                progress = true;
              });

    /*FirebaseFirestore.instance.collection('studentActivity')
        .doc(SchClassConstant.schDoc['schId']).collection('sActivity')
        .where('id',isEqualTo: videoId)
        .where('stId',isEqualTo: SchClassConstant.schDoc['id']).get()
        .then((value){

    final List <DocumentSnapshot> documents = value.docs;

    if (documents.length == 0) {
              FirebaseFirestore.instance.collection('studentActivity').doc(SchClassConstant.schDoc['schId']).collection('sActivity').doc()
                  .set({
                'ts':DateTime.now().toString(),
                'live':true,
                'stId':SchClassConstant.schDoc['id'],
                'schId':SchClassConstant.schDoc['schId'],
                'fn': SchClassConstant.schDoc['fn'],
                'ln':SchClassConstant.schDoc['ln'],
                'cl':SchClassConstant.schDoc['cl'],
                'lv':SchClassConstant.schDoc['lv'],
                'tp':SchoolPostConst.liveVideoDoc['tp'],
                'cn':SchoolPostConst.liveVideoDoc['cn'],
                'tcId':SchoolPostConst.liveVideoDoc['tcId'],
                'tsn':SchoolPostConst.liveVideoDoc['tsn'],
                 'id':videoId
              });}});
*/
              DocumentReference docRef = FirebaseFirestore.instance.collection('classAttendant').doc(videoId).collection('classList').doc(SchClassConstant.schDoc['did']);

              docRef.set({
                'off':DateTime.now().toString()

              },SetOptions(merge: true));
              //this collection stores the name of the student that joined the class
              FirebaseFirestore.instance.collection('joinedClassName').doc(videoId).set({
                'fn':'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                'join':'left'
              });
              setState(() {
                progress = false;
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentsEClasses(),),);
            }
          }
          ),
          progress?Text(''): BtnWhiteTextColor(next: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentsEClasses(),),);

          }, title: "ll be right back" , bgColor: kAGreen),
          SizedBox(height: 20,)
        ],
      ),
    )
    ));
  }


  void teacherIsLive() {
    dynamic lc;
    dynamic ld;
    dynamic lw;
    dynamic lm;
    dynamic ly;
    //tell the management that this teacher is live
    if(SchClassConstant.isLecturer){
      ///if this is a campus teacher

      FirebaseFirestore.instance.collection('schoolTutors')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('tutors')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {


        lc = value.data()!['lc'] == null?0:value.data()!['lc'];
        ld = value.data()!['ld'] == null?0:value.data()!['ld'];
        lw = value.data()!['lw'] == null?0:value.data()!['lw'];
        lm = value.data()!['lm'] == null?0:value.data()!['lm'];
        ly = value.data()!['ly'] == null?0:value.data()!['ly'];


        FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
          'lc':lc + 1,
          'ld': value.data()!['day'] == DateTime.now().day?ld + 1:1,
          'lw':value.data()!['wky'] == Jiffy().week?lw + 1:1,
          'lm':value.data()!['mth'] == DateTime.now().month?lm + 1:1,
          'ly':value.data()!['yr'] == DateTime.now().year?ly + 1:1,
          'lId':videoId,
          'lot':DateTime.now().toString(),
          'lyr':DateTime.now().year,
          'lmth':DateTime.now().month,
          'lday':DateTime.now().day,
          'lwky':Jiffy().week,
          'live': false,
          'loft':DateTime.now().toString()

        },SetOptions(merge:  true));


        campusTeacherAnalysis();


      });




    }else{
      ///if this is a high school teacher

      FirebaseFirestore.instance.collection('teachers')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('schoolTeachers')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        lc = value.data()!['lc'] == null?0:value.data()!['lc'];
        ld = value.data()!['ld'] == null?0:value.data()!['ld'];
        lw = value.data()!['lw'] == null?0:value.data()!['lw'];
        lm = value.data()!['lm'] == null?0:value.data()!['lm'];
        ly = value.data()!['ly'] == null?0:value.data()!['ly'];


        FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
          'lc':lc + 1,

          'lot':DateTime.now().toString(),
          'lId':videoId,
          'ld': value.data()!['day'] == DateTime.now().day?ld + 1:1,
          'lw':value.data()!['wky'] == Jiffy().week?lw + 1:1,
          'lm':value.data()!['mth'] == DateTime.now().month?lm + 1:1,
          'ly':value.data()!['yr'] == DateTime.now().year?ly + 1:1,
          'lyr':DateTime.now().year,
          'lmth':DateTime.now().month,
          'lday':DateTime.now().day,
          'lwky':Jiffy().week,
          'live': false,
          'loft':DateTime.now().toString()
        },SetOptions(merge:  true));

        campusTeacherAnalysis();
      });


    }

  }

  Future<void> campusTeacherAnalysis() async {
    ///Daily Analysis
    final snapShot = await FirebaseFirestore.instance.collection('campusAnalysisDaily')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('daily').doc('${DateTime.now().day}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();



   /* final snapShot = await FirebaseFirestore.instance.collection('campusAnalysisDaily')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('periods')
        .doc(SchClassConstant.schDoc['id'])
        .collection('daily').doc('${DateTime.now().year}')
        .collection('schoolAnalysis').doc('${DateTime.now().month}')
        .collection('dailyTeachersAnalysis').doc('${DateTime.now().day}').get();*/



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
        'lc':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId']
      });


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
          'lc': resultData.data()!['lc']==null?1:resultData.data()!['lc'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId']
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
          .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .set({

        'wk':Jiffy().week,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'lc':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId']
      });


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
          'lc': resultData.data()!['lc']==null?1:resultData.data()!['lc'] + 1,
          'ts':DateTime.now().toString(),
          'yr':DateTime.now().year,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId']
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
        .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();

    if (snapShotMonthly == null || !snapShotMonthly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisMonthly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('monthly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .set({

        'mth':DateTime.now().month,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'lc':1
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
          'lc': resultData.data()!['lc']==null?1:resultData.data()!['lc'] + 1,
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

        'yr':DateTime.now().year,
        'ts':DateTime.now().toString(),
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'lc':1
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
          'lc': resultData.data()!['lc']==null?1:resultData.data()!['lc'] + 1,

          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }



  }


}
