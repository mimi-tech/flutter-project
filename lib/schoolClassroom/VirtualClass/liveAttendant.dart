import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sticky_headers/sticky_headers.dart';

class LiveAttendant extends StatefulWidget {
  LiveAttendant({required this.doc});
  final DocumentSnapshot doc;

  @override
  _LiveAttendantState createState() => _LiveAttendantState();
}

class _LiveAttendantState extends State<LiveAttendant> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('classAttendant').doc(widget.doc['id']).collection('classList')
                              //.orderBy('ol', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: ProgressIndicatorState(),
                              );
                            } else {
                              final List<Map<String, dynamic>> workingDocuments =
                              snapshot.data!.docs as List<Map<String, dynamic>>;                              return StickyHeader(
                                header: SchoolHeader(title: 'Class Attendant ${workingDocuments.length}',),
                                content: ListView.builder(
                                    itemCount: workingDocuments.length,
                                    shrinkWrap: true,
                                    reverse: true,

                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      return Column(

                                          children: [
                                            ListTile(

                                              leading:Container(
                                                  decoration:BoxDecoration(
                                          shape:BoxShape.circle,
                                        color: kMaincolor
                                      ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.person,color: kWhitecolor,),
                                                  )),
                                              title: Text('${workingDocuments[index]['fn']}',

                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kBlackcolor,
                                                   fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),


                                              subtitle: Text('${workingDocuments[index]['ln']}',

                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kBlackcolor,
                                                    fontSize:kFontsize.sp,
                                                  ),
                                                ),
                                              ),

                                              trailing: RaisedButton(
                                                onPressed: (){},
                                                color:kFbColor,
                                                child: Text('Joined: ${DateFormat('hh:mma').format(DateTime.parse(workingDocuments[index]['ol']))}\n Left: ${DateFormat('hh:mma').format(DateTime.parse(workingDocuments[index]['ol']))}',

                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kWhitecolor,
                                                      fontSize:kFontsize.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )

                                          ]);
                                    }),
                              );

                            }})


                    ]))));
  }
}
