
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teacher_reply_ques.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/ask_my_ques.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StudentsQuestions extends StatefulWidget {
  StudentsQuestions({required this.doc});
  final DocumentSnapshot doc;
  @override
  _StudentsQuestionsState createState() => _StudentsQuestionsState();
}

class _StudentsQuestionsState extends State<StudentsQuestions> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
  var _documents = <DocumentSnapshot>[];

  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;


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
                    header:  QuestionHeader(title: 'Lesson Questions ', askQues: (){_askQuestions();},),


                    content: workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                    workingDocuments.length == 0 && progress == true ? Center(child: NoContentCreated(
                      title: 'No student have asked any question',)):SingleChildScrollView(
                      child: Column(
                        children: [
                          space(),
                          space(),
                          space(),
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
                                                    color: klistnmber,
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

                                              Visibility(
                                                visible: workingDocuments[index]['re'],
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Divider(),

                                                    Text('Answer'.toUpperCase(),

                                                      style: GoogleFonts.rajdhani(
                                                        decoration: TextDecoration.underline,
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: kFbColor,
                                                          fontSize:kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:12.0),
                                                      child: ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(context).size.width,
                                                            minHeight: ScreenUtil().setHeight(15),
                                                          ),
                                                          child: ReadMoreText(workingDocuments[index]['ans'],

                                                            trimLines: 2,
                                                            colorClickableText:kStabcolor,
                                                            trimMode: TrimMode.Line,
                                                            trimCollapsedText: ' ...',
                                                            trimExpandedText: ' show less',
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: kSappbarbacground,
                                                                fontSize:kFontsize.sp,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Divider(),


                                              IntrinsicHeight(
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(workingDocuments[index]['se'] == false?'Unseen':'Seen',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: workingDocuments[index]['se'] == false?kFbColor:kExpertColor,
                                                              fontSize: kFontSize14.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        VerticalDivider(),

                                                        GestureDetector(
                                                          onTap: (){
                                                            if(SchClassConstant.isTeacher == true){
                                                              _replyQuestion(index);
                                                            }else{
                                                              print('sdfd');
                                                            }
                                                          },
                                                          child: Text(workingDocuments[index]['re'] == false?'No-reply':'Replied',
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: workingDocuments[index]['re']  == false?kFbColor:kExpertColor,
                                                                fontSize: kFontSize14.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        )

                                                      ]
                                                  )
                                              )

                                            ],




                                          ),
                                        ),
                                      ),


                                      space(),

                                    ]);
                                  }),

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
    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('questions')
    .where('schId',isEqualTo:  widget.doc['schId'])
    .where('id',isEqualTo:  widget.doc['id'])
        .orderBy('ts',descending: true)
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
           _documents.add(document);

        });


      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('questions')
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
          workingDocuments.add(document.data());
          _documents.add(document);
          moreData = false;


        });
      }
    }
  }

  void _askQuestions() {
    //the student will post question here
    Navigator.pop(context);
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return StudentAskMyQuestion(doc:widget.doc);
        });
  }

  void _replyQuestion( int index) {
    //reply the students question here
    Navigator.pop(context);
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),
        builder: (context) {
          return TeacherReplyQuestions(doc:_documents[index]);
        });
  }
}
