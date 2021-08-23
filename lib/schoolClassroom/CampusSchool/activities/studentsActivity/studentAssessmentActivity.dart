import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';

class StudentAssessmentActivities extends StatefulWidget {
  StudentAssessmentActivities({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentAssessmentActivitiesState createState() => _StudentAssessmentActivitiesState();
}

class _StudentAssessmentActivitiesState extends State<StudentAssessmentActivities> {
  List<dynamic> workingDocuments = <dynamic>[];
  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  var _documents = <DocumentSnapshot>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }
  @override
  Widget build(BuildContext context) {
    return workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
    workingDocuments.length == 0 && progress == true ? NoTextComment(title: kNothing,):SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('This student did the following assessment given by the teacher'.toUpperCase(),
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


          ListView.builder(
              itemCount: workingDocuments.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return Card(
                    elevation: 10,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(workingDocuments[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(workingDocuments[index]['ts']))}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    decoration: TextDecoration.underline,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),

                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(

                                    child: PDF.network(workingDocuments[index]['turl'],
                                      placeHolder: Center(child: CircularProgressIndicator()),
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      width:MediaQuery.of(context).size.width * 0.3,

                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().setWidth(180),
                                            minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                          ),
                                          child: ReadMoreText(workingDocuments[index]['title'],
                                            //doc.data['desc'],
                                            trimLines: 1,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' .. ^',
                                            trimExpandedText: ' ^',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kFbColor,
                                                fontSize:12.sp,
                                              ),

                                            ),
                                          ),
                                        ),),
                                      Text(workingDocuments[index]['tc'],
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kExpertColor,
                                            fontSize: kFontSize14.sp,
                                          ),
                                        ),

                                      ),

                                     Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: ScreenUtil().setWidth(200),
                                            minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                          ),
                                          child: ReadMoreText(workingDocuments[index]['curs'],
                                            //doc.data['desc'],
                                            trimLines: 1,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' .. ^',
                                            trimExpandedText: ' ^',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kLightGreen,
                                                fontSize: kFontsize.sp,
                                              ),

                                            ),
                                          ),
                                        ),),
                                      Text(Variables.dateFormat.format(DateTime.parse(workingDocuments[index]['ts'])),
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: klistnmber,
                                            fontSize: kFontSize14.sp,
                                          ),
                                        ),

                                      ),
                                    ],
                                  ),


                                ],
                              ),




                            ]
                        )
                    )
                );
              }),

          prog == true || _loadMoreProgress == true
              || _documents.length < SocialConstant.streamLength
              ?Text(''):
          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
              onTap: (){loadMore();},
              child: SvgPicture.asset('assets/classroom/load_more.svg',))
        ],
      ),
    );}


  void getResult() {


    try{

      if(SchClassConstant.isTeacher){


       /* FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
            .collection('sActivity')
            .where('stId',isEqualTo:  widget.doc['id'])
            .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
            .where('ac',isEqualTo:  true)
            .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
            .snapshots().listen((result) {
          final List < DocumentSnapshot > documents = result.docs;

          if (documents.length != 0) {
            workingDocuments.clear();
            for (DocumentSnapshot document in documents) {

              _lastDocument = documents.last;
              setState(() {
                workingDocuments.add(document.data());
                _documents.add(document);

              });
            }
          }else{

            setState(() {
              progress = true;
            });
          }
        });
*/

        workingDocuments = SchClassConstant.studentsActivityItems.where(
                (element) => element['stId'] == widget.doc['id']
                && element['tcId'] == SchClassConstant.schDoc['id']
                && element['ac'] == true
        ).toList();
        if(workingDocuments.length == 0){
          setState(() {
            progress = true;
          });}
      }else{

      FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
          .collection('sActivity')
          .where('stId',isEqualTo:  widget.doc['id'])
          .where('ac',isEqualTo:  true)
          .orderBy('ts',descending: true).limit(SocialConstant.streamLength)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          workingDocuments.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              workingDocuments.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });}


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {



    FirebaseFirestore.instance.collection('studentActivity').doc(widget.doc['schId'])
        .collection('sActivity')
        .where('stId',isEqualTo:  widget.doc['id'])
        .where('ac',isEqualTo: true)
        .orderBy('ts',descending: true)
        .startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

        .snapshots().listen((event) {
      final List <DocumentSnapshot> documents = event.docs;
      if (documents.length == 0) {
        setState(() {
          _loadMoreProgress = true;
        });
      } else {
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
  }}



