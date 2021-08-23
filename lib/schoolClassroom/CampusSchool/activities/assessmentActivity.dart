import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/post_assignment.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/replied_assignments.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/studentFolder/view_assessments.dart';
class AssessmentActivities extends StatefulWidget {
  AssessmentActivities({required this.doc});
  final DocumentSnapshot doc;
  @override
  _AssessmentActivitiesState createState() => _AssessmentActivitiesState();
}

class _AssessmentActivitiesState extends State<AssessmentActivities> {
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
        child:Column(
      children: [
    ListView.builder(
    itemCount: workingDocuments.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewAssessment(note:workingDocuments[index]['url'],doc:_documents[index])));

            },
            child: Card(
              elevation: 5,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(

                          child: PDF.network(workingDocuments[index]['url'],
                            placeHolder: Center(child: CircularProgressIndicator()),
                            height: MediaQuery.of(context).size.height * 0.15,
                            width:MediaQuery.of(context).size.width * 0.3,

                          ),
                        ),

                        SizedBox(width: 5,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: ScreenUtil().setWidth(200),
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
                                      fontSize: kFontsize.sp,
                                    ),

                                  ),
                                ),
                              ),),

                            SchClassConstant.isUniStudent?Container(
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
                              ),):Text(''),

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
                  ),
                  Divider(),

                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){


                          },
                          child: Text(workingDocuments[index]['ass'] == true?"Block":'Unblock',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: (workingDocuments[index]['ass'] == true?kExpertColor:kRed),
                                fontSize: kFontsize.sp,
                              ),
                            ),

                          ),
                        ),
                        VerticalDivider(),

                        GestureDetector(
                          onTap: (){
                            _repliedAssignment(_documents[index]);},
                          child: Text('Replied ${workingDocuments[index]['rec']}',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kExpertColor,
                                fontSize: kFontsize.sp,
                              ),
                            ),

                          ),
                        ),





                      ],
                    ),
                  ),





                ],
              ),
            ),
          );}),

        
        
        prog == true || _loadMoreProgress == true
            || _documents.length < SocialConstant.streamLength
            ?Text(''):
        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
            onTap: (){loadMore();},
            child: SvgPicture.asset('assets/classroom/load_more.svg',))
      ],
    ));
  }

  void getResult() {
    try{
      FirebaseFirestore.instance.collection('teachersAssessment')
          .doc(widget.doc['schId']).collection('assessments')
          .where('tcId',isEqualTo: widget.doc['id'])
          .orderBy('ts', descending: true).limit(SocialConstant.streamLength)
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


    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }


  Future<void> loadMore() async {
    FirebaseFirestore.instance.collection('teachersAssessment')
        .doc(widget.doc['schId']).collection('assessments')
        .where('tcId',isEqualTo: widget.doc['id'])
        .orderBy('ts', descending: true).
    startAfterDocument(_lastDocument).limit(SocialConstant.streamLength)

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
  }
  void _repliedAssignment(DocumentSnapshot doc) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {return StudentsRepliedAssessment(doc:doc);
        });
  }
}
