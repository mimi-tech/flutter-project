import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/AcardConstruct.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/noText.dart';
import 'package:sparks/schoolClassroom/utils/social_constants.dart';

class YearlyTeachersAnalysis extends StatefulWidget {
  YearlyTeachersAnalysis({required this.doc});
  final DocumentSnapshot doc;
  @override
  _YearlyTeachersAnalysisState createState() => _YearlyTeachersAnalysisState();
}

class _YearlyTeachersAnalysisState extends State<YearlyTeachersAnalysis> {
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
    getDailyAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
    workingDocuments.length == 0 && progress == true ? NoTextComment(title: kNothing,):SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              itemCount: workingDocuments.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return ACardConstruct(
                  text6: '${workingDocuments[index]['ts']}'.toString(),
                  text1: workingDocuments[index]['lc'] == null?'0':workingDocuments[index]['lc'],
                  text2: workingDocuments[index]['uc'] == null?'0':workingDocuments[index]['uc'],
                  text3: workingDocuments[index]['ec'] == null?'0':workingDocuments[index]['ec'],
                  text4: workingDocuments[index]['rc'] == null?'0':workingDocuments[index]['rc'],
                  text5: workingDocuments[index]['ac'] == null?'0':workingDocuments[index]['ac'],
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
    );


  }

  void getDailyAnalysis() {
    try{
      FirebaseFirestore.instance.collectionGroup('yearlyTeachersAnalysis')
          .where('schId',isEqualTo: widget.doc['schId'])
          .where('tId',isEqualTo: widget.doc['id'])
          .orderBy('ts', descending: true)
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
    FirebaseFirestore.instance.collectionGroup('yearlyTeachersAnalysis')
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
