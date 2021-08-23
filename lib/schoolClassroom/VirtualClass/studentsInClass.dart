import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StudentsInClass extends StatefulWidget {
  @override
  _StudentsInClassState createState() => _StudentsInClassState();
}

class _StudentsInClassState extends State<StudentsInClass> {


  bool progress = false;

  late StreamSubscription stream;
  var _documents = <DocumentSnapshot>[];
  bool moreData = false;
  List<dynamic> studentsInClass = <dynamic>[];
  bool prog = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getComment();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream.cancel();
  }
  void getComment() {
    stream = FirebaseFirestore.instance.collection("classAttendant").doc(videoId).collection('classList').snapshots()
        .listen((result) {


      final List <DocumentSnapshot> documents = result.docs;

      if(documents.length == 0){
        setState(() {
          prog = true;
        });

      }else {
        studentsInClass.clear();
        _documents.clear();
        for (DocumentSnapshot document in documents) {
          setState(() {

            studentsInClass.add(document.data());
            _documents.add(document);
            prog = false;
          });
        }}});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                color: kBlackcolor.withOpacity(0.5),
                child: studentsInClass.length == 0 && prog == false ?PlatformCircularProgressIndicator():
                studentsInClass.length == 0 && prog == true ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('No student is in the class yet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(

                        fontWeight: FontWeight.bold,
                        color: kMaincolor,
                        fontSize:kFontsize.sp,
                      ),
                    ),
                  ),
                ):StickyHeader(
                  header: SchoolHeader(title: 'These students are present in this class now',),
                  content: ListView.builder(
                      itemCount: studentsInClass.length,
                      shrinkWrap: true,
                      reverse: true,

                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        return Column(
                            children: [
                              ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child:  CachedNetworkImage(
                                        imageUrl: studentsInClass[index]['pimg'],
                                        imageBuilder: (context, imageProvider) => Container(
                                          width: kImageWidth.w,
                                          height: kImageHeight.h,
                                          decoration: BoxDecoration(

                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>  Image.asset('images/classroom/user.png'),
                                      )),

                                  title: Text(studentsInClass[index]['fn'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(

                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        fontSize:kFontsize.sp,
                                      ),
                                    ),
                                  ),

                                  subtitle: Text(studentsInClass[index]['ln'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(

                                        fontWeight: FontWeight.bold,
                                        color: Colors.tealAccent,
                                        fontSize:kFontsize.sp,
                                      ),
                                    ),
                                  ),

                                  trailing: Text('${timeago.format(DateTime.parse(studentsInClass[index]['ol']), locale: 'en_short')}',

                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: klistnmber,
                                        fontSize:14.sp,
                                      ),
                                    ),
                                  )
                              )
                            ]);
                      }),

                ))));
  }


}
