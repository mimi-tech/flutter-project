import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/studentsActivity/studentsActivitiesTab.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/studentPostProfile.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchStudents.dart';
import 'package:sparks/schoolClassroom/studentFolder/studentsPost.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';
import 'package:sparks/schoolClassroom/utils/showReadMore.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';

class ListOfClassmate extends StatefulWidget {
  @override
  _ListOfClassmateState createState() => _ListOfClassmateState();
}

class _ListOfClassmateState extends State<ListOfClassmate> {
  bool progress = false;

  List<dynamic> schoolDocuments = <dynamic>[];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClassmate();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: kSappbarbacground,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(kClassMateList,
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
              ),
            ),
            SchClassConstant.isUniStudent? GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStudent()));

                },
                child: SvgPicture.asset('images/classroom/search.svg',color: kWhitecolor,)):Text(''),


          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

        workingDocuments.length == 0 && progress == false ?Center(child: CircularProgressIndicator(backgroundColor: kFbColor,)):
        workingDocuments.length == 0 && progress == true ?Center(
        child: Text(kNoSchoolPost,
        style: GoogleFonts.rajdhani(
          fontSize:kFontsize.sp,
          fontWeight: FontWeight.bold,
          color: kBlackcolor,
        ),
    ),
    ):
    ListView.builder(
    itemCount: workingDocuments.length,
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, int index) {

    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfilePix(pix: workingDocuments[index]['logo']),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(workingDocuments[index]['fn'],
                    style: GoogleFonts.rajdhani(
                      fontSize:kFontsize.sp,
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                    ),
                  ),
                  Text(workingDocuments[index]['ln'],
                    style: GoogleFonts.rajdhani(
                      fontSize:kFontsize.sp,
                      fontWeight: FontWeight.bold,
                      color: kIconColor,
                    ),
                  ),            ],
              ),

              Spacer(),
              Icon(Icons.circle,color:workingDocuments[index]['onl'] == true?kAGreen:kRed ,size: 15,)

            ],
          ),
         space(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowReadMoreText(title: SchClassConstant.isUniStudent ||SchClassConstant.isCampusProprietor || SchClassConstant.isLecturer?'${workingDocuments[index]['cl']} department':workingDocuments[index]['cl'], titleColor: klistnmber),


                  Text(workingDocuments[index]['lv'],

                    style: GoogleFonts.rajdhani(
                      fontSize:kFontsize.sp,
                      fontWeight: FontWeight.bold,
                      color: kBlackcolor,
                    ),
                  ),
                ],
              ),

              Spacer(),
               BtnSecond(next: (){

              }, title: workingDocuments[index]['ass'] == true?'Access':kDenied,
                   bgColor: workingDocuments[index]['ass'] == true?kAGreen:kRed)
            ],
          ),
          Divider(),
             space(),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap:(){
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsPostScreen(doc:_documents[index])));

                  },
                  child: Text( SchClassConstant.isUniStudent ||SchClassConstant.isCampusProprietor || SchClassConstant.isLecturer?'See post':'',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kExpertColor,
                        fontSize: kFontsize.sp,
                      ),
                    ),

                  ),
                ),

                VerticalDivider(),
                GestureDetector(
                  onTap:(){
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentActivitiesTab(doc:_documents[index])));
                  },
                  child: Text('Activities',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kExpertColor,
                        fontSize: kFontsize.sp,
                      ),
                    ),

                  ),
                ),

              ],
            ),
          )

        ],
        ),
    );}),


            prog == true || _loadMoreProgress == true
                || _documents.length < SocialConstant.streamLength
                ?Text(''):
            moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                onTap: (){loadMore();},
                child: SvgPicture.asset('assets/classroom/load_more.svg',))
          ],
        ),
      ),
    ));
  }

  void getClassmate() {
    if((SchClassConstant.isUniStudent) || (SchClassConstant.isLecturer)){
      FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('dept',isEqualTo: SchClassConstant.schDoc['dept'])
          .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);
              workingDocuments.shuffle();
            });

          }
        }else{
          setState(() {
            progress = true;
          });
        }
      });

    }else if(SchClassConstant.isCampusProprietor){
      FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);
              workingDocuments.shuffle();
            });

          }
        }else{
          setState(() {
            progress = true;
          });
        }
      });
    }else if(SchClassConstant.isHighSchProprietor) {
      FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);
              workingDocuments.shuffle();
            });
          }
        }else{
          setState(() {
            progress = true;
          });
        }
      });

    }else{
      FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
          .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);
              workingDocuments.shuffle();
            });
          }
        }else{
          setState(() {
            progress = true;
          });
        }
      });

    }
  }

  Future<void> loadMore() async {
    if((SchClassConstant.isUniStudent) || (SchClassConstant.isLecturer)){
      FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .where('dept',isEqualTo: SchClassConstant.schDoc['dept'])
          .orderBy('ts',descending: true).
    startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
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
            workingDocuments.add(document.data());

            moreData = false;


          });
        }
      }

    });


  }else if(SchClassConstant.isCampusProprietor){
      FirebaseFirestore.instance.collection('uniStudents').doc(SchClassConstant.schDoc['schId']).collection('campusStudents')
          .orderBy('ts',descending: true).
      startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
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
              workingDocuments.add(document.data());

              moreData = false;


            });
          }
        }

      });
    }else if(SchClassConstant.isHighSchProprietor) {

      FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
          .orderBy('ts',descending: true).
      startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
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
              workingDocuments.add(document.data());

              moreData = false;


            });
          }
        }

      });

    }else{
      FirebaseFirestore.instance.collection('classroomStudents').doc(SchClassConstant.schDoc['schId']).collection('students')
          .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
          .orderBy('ts',descending: true).
      startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
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
              workingDocuments.add(document.data());

              moreData = false;


            });
          }
        }

      });


    }
  }

}
