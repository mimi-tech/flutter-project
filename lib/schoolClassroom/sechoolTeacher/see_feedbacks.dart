
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/ask_my_ques.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TeachersFeedback extends StatefulWidget {
  TeachersFeedback({required this.doc});
  final DocumentSnapshot doc;
  @override
  _TeachersFeedbackState createState() => _TeachersFeedbackState();
}

class _TeachersFeedbackState extends State<TeachersFeedback> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];

  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  var _documents = <DocumentSnapshot>[];


  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSchoolDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
                color: kWhitecolor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(kmodalborderRadius),
                  topLeft: Radius.circular(kmodalborderRadius),
                )),
            child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 400),
                curve: Curves.decelerate,
                child:

                StickyHeader(
                    header:  SchoolHeader(title: '${widget.doc['title']} feedBacks'.toUpperCase(),),


                    content: workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                    workingDocuments.length == 0 && progress == true ? Center(child: NoContentCreated(
                      title: 'No student have given a feedBack on this lesson [${widget.doc['title']}]',)):SingleChildScrollView(
                      child: Column(
                        children: [

                          space(),
                          ListView.builder(
                              itemCount: workingDocuments.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return Column(children: <Widget>[

                                  Card(
                                    elevation: 5,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']} ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kLightGreen,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),
                                          Text(Variables.dateFormat.format(DateTime.parse(workingDocuments[index]['ts'])),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: kFbColor,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),
                                          Divider(),

                                          ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width,
                                                minHeight: ScreenUtil().setHeight(15),
                                              ),
                                              child: ReadMoreText(workingDocuments[index]['msg'],

                                                trimLines: 3,
                                                colorClickableText:kStabcolor,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' ...',
                                                trimExpandedText: ' show less',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: kBlackcolor,
                                                    fontSize:kFontsize.sp,
                                                  ),
                                                ),
                                              )),




                                        ],




                                      ),
                                    ),
                                  ),


                                  space(),

                                ]);
                              }),
                          space(),

                          progress == true || _loadMoreProgress == true
                              || _documents.length < SchClassConstant.streamCount
                              ?Text(''):
                          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                              onTap: (){loadMore();},
                              child: SvgPicture.asset('images/classroom/load_more.svg',))

                        ],
                      ),
                    )))));
  }



  Future<void> getSchoolDetails() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('lessonFeedback').doc(widget.doc['schId']).collection('feedback')
        .where('schId',isEqualTo:  widget.doc['schId'])
        .where('id',isEqualTo:  widget.doc['id'])
        .orderBy('ts',descending: true).limit(SchClassConstant.streamCount)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          workingDocuments.add(document.data());


        });


      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('lessonFeedback').doc(widget.doc['schId']).collection('feedback')
        .where('schId',isEqualTo:  widget.doc['schId'])
        .where('id',isEqualTo:  widget.doc['id'])
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
          workingDocuments.add(document.data());

          moreData = false;


        });
      }
    }
  }
}
