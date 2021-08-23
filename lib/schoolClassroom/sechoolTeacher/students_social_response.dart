
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StudentSocialResponse extends StatefulWidget {
  StudentSocialResponse({required this.doc,required this.title});
  final DocumentSnapshot doc;
  final String title;
  @override
  _StudentSocialResponseState createState() => _StudentSocialResponseState();
}

class _StudentSocialResponseState extends State<StudentSocialResponse> {
  bool progress = false;

  List<dynamic> workingDocuments = <dynamic>[];
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
                    header:  SchoolHeader(title: widget.title),


                    content: workingDocuments.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                    workingDocuments.length == 0 && progress == true ? Center(child: NoContentCreated(
                      title: 'Nothing has happened',)):SingleChildScrollView(
                      child: Column(
                        children: [
                          space(),

                          ListView.builder(
                              itemCount: workingDocuments.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: <Widget>[

                                      Card(
                                        elevation:5,
                                        child: ListTile(

                                          title: Text('${workingDocuments[index]['fn']} ${workingDocuments[index]['ln']}',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kLightGreen,
                                                fontSize:kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                          leading:Icon(Icons.ac_unit,color: kFbColor,),
                                          subtitle: Text(Variables.dateFormat.format(DateTime.parse(workingDocuments[index]['ts'])),
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: klistnmber,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),

                                        ),
                                      ),


                                      space(),

                                    ]);
                              }),
                        ],
                      ),
                    )))));
  }



  Future<void> getSchoolDetails() async {
    //check if its like
    workingDocuments.clear();
    if(SchClassConstant.isLiked == true){
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentsLikedSocial').doc(widget.doc['schId']).collection('likedSocialClass')
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
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);

          });


        }
      }
    }else if(SchClassConstant.isView == true){
      //check if it is view
print(widget.doc['schId']);

      final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentsViewedSocial').doc(widget.doc['schId']).collection('viewedSocialClass')
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
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);

          });


        }
      }
    }else if(SchClassConstant.isDownload == true){
      //check if it is download video


      final QuerySnapshot result = await FirebaseFirestore.instance.collection('studentsDownloadedSocial').doc(widget.doc['schId']).collection('downloadedSocialClass')
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
          setState(() {
            workingDocuments.add(document.data());
            _documents.add(document);

          });


        }
      }
    }


  }


}
