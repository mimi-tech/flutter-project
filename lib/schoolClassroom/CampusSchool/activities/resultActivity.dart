import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/social/socialConstants/social_constants.dart';
class ResultActivities extends StatefulWidget {
  ResultActivities({required this.doc});
  final DocumentSnapshot doc;
  @override
  _ResultActivitiesState createState() => _ResultActivitiesState();
}

class _ResultActivitiesState extends State<ResultActivities> {
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
              return Column(
                  children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(

                          child: PDF.network(workingDocuments[index]['re'],
                            placeHolder: Center(child: CircularProgressIndicator()),
                            height: MediaQuery.of(context).size.height * 0.15,
                            width:MediaQuery.of(context).size.width * 0.3,

                          ),
                        ),



                        SizedBox(width: 5,),


                    Column(
                      children: [
                        Text(workingDocuments[index]['stfn'],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: klistnmber,
                              fontSize: kFontSize14.sp,
                            ),
                          ),


                        ),
                        Text(workingDocuments[index]['stln'],
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: klistnmber,
                              fontSize: kFontSize14.sp,
                            ),
                          ),),

                        Text('Date: ${Variables.dateFormat.format(DateTime.parse(workingDocuments[index]['ts']))}',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: klistnmber,
                              fontSize: kFontSize14.sp,
                            ),
                          ),),




                          ],
                    )],
                    ),

                    Divider(),

                    ShowRichText(color:kExpertColor,title: 'Student level: ',titleText: workingDocuments[index]['stlv']),
                    ShowRichText(color:kExpertColor,title: 'Student class: ',titleText: workingDocuments[index]['stcl']),
                    ShowRichText(color:kExpertColor,title: 'Result Briefing: ',titleText: workingDocuments[index]['title']),

                  ],
                ),
              )

                  ]
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
      FirebaseFirestore.instance.collection('studentResult').doc(SchClassConstant.schDoc['schId']).collection('results')
          .where('schId',isEqualTo: widget.doc['schId'])
          .where('tId',isEqualTo: widget.doc['id'])
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
    FirebaseFirestore.instance.collection('studentResult').doc(SchClassConstant.schDoc['schId']).collection('results')
        .where('schId',isEqualTo: widget.doc['schId'])
        .where('tId',isEqualTo: widget.doc['id'])
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
}
