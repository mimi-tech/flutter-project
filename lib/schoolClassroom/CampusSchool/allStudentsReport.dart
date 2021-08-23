import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'package:sparks/schoolClassroom/utils/showReadMore.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AllSchoolStudentReport extends StatefulWidget {

  @override
  _AllSchoolStudentReportState createState() => _AllSchoolStudentReportState();
}

class _AllSchoolStudentReportState extends State<AllSchoolStudentReport> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReport();
  }
  List<dynamic> workingDocuments = <dynamic>[];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  var _documents = <DocumentSnapshot>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StuAppBar(),
      body: CustomScrollView(slivers: <Widget>[
      ProprietorActivityAppBar(
        activitiesColor: kStabcolor1,
        classColor: kTextColor,
        newsColor: kTextColor,
        studiesColor: kTextColor,
      ),

        SchClassConstant.isUniStudent? PostSliverStudentAppBar(
          campusBgColor: Colors.transparent,
          campusColor: klistnmber,
          deptBgColor: Colors.transparent,
          deptColor: klistnmber,
          recordsBgColor: klistnmber,
          recordsColor: kWhitecolor,
          profileBgColor: Colors.transparent,
          profileColor: klistnmber,
        ):PostSliverAppBar(
          campusBgColor: Colors.transparent,
          campusColor: klistnmber,
          deptBgColor: Colors.transparent,
          deptColor: klistnmber,
          recordsBgColor: klistnmber,
          recordsColor: kWhitecolor,
        ),



    SliverList(
    delegate: SliverChildListDelegate([

      workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
      workingDocuments.length == 0 && progress == true ? NoTextComment(title: kNothing,):SingleChildScrollView(
        child:  Column(
          children: [



            ListView.builder(
                itemCount: workingDocuments.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int index) {
                  return Card(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reportee'.toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kFbColor,
                                    fontSize: 20.sp,
                                  ),
                                ),

                              ),

                              RaisedButton(
                                onPressed:(){_checkReport(index);},
                                color:kWhitecolor,
                                child: Text(workingDocuments[index]['op'] == true?'Open':'Close',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: workingDocuments[index]['op'] == true?kFbColor:kLightGreen,
                                      fontSize: 20.sp,
                                    ),
                                  ),

                                ),
                              ),
                            ],
                          ),
                          ///username
                          ShowRichText(color:kSwitchoffColors,title: 'Full name: ',titleText: '${workingDocuments[index]['sFn']} ${workingDocuments[index]['sLn']}'),



                          space(),
                          ShowRichText(color:kSwitchoffColors,title: 'Department: ',titleText: workingDocuments[index]['stD']),


                          space(),

                          ShowRichText(color:kExpertColor,title: 'Level: ',titleText: workingDocuments[index]['stLv']),
                          space(),

                          ShowRichText(color:kExpertColor,title: 'Report message: ',titleText: ''),
                          space(),
                          ShowReadMoreText(title: workingDocuments[index]['msg'],titleColor: kBlackcolor,),




                          Divider(),
                          Text('Reporter'.toUpperCase(),
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kFbColor,
                                fontSize: 20.sp,
                              ),
                            ),

                          ),
                          ///username
                          ShowRichText(color:kSwitchoffColors,title: 'Full name: ',titleText: '${workingDocuments[index]['rFn']} ${workingDocuments[index]['rLn']}'),



                          space(),
                          ShowRichText(color:kSwitchoffColors,title: 'Department: ',titleText: workingDocuments[index]['stD']),


                          space(),

                          ShowRichText(color:kExpertColor,title: 'Level: ',titleText: workingDocuments[index]['rLv']),




                        ]),
                  );
                }),
            progress == true || _loadMoreProgress == true
                || _documents.length < SchClassConstant.streamCount
                ?Text(''):
            moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                onTap: (){loadMore();},
                child: SvgPicture.asset('images/classroom/load_more.svg',))

          ],
        ),
      ),


    ]))]));



  }

  Future<void> getReport() async {
    try{
      FirebaseFirestore.instance.collection('studentsReport')
          .where('schId',isEqualTo:SchClassConstant.schDoc['schId'])
          .orderBy('ts',descending: true).limit(SchClassConstant.streamCount)
          .snapshots().listen((result) {

        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {

    FirebaseFirestore.instance.collection('studentsReport')
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId']).
    orderBy('ts',descending: true).limit(SchClassConstant.streamCount)
        .snapshots().listen((result) {
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
          workingDocuments.add(document.data());

          moreData = false;


        });
      }
    }});}


  void _checkReport(int index) {
    FirebaseFirestore.instance.collection('studentsReport').doc(workingDocuments[index]['id']).update({
      'op':workingDocuments[index]['op'] == true?false:true,
    });
  }
}
