import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SchoolPostLikes extends StatefulWidget {
  SchoolPostLikes({required this.doc, required this.cid});
  final Map<String, dynamic?>? doc;
  final String? cid;

  @override
  _SchoolPostLikesState createState() => _SchoolPostLikesState();
}

class _SchoolPostLikesState extends State<SchoolPostLikes> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('schoolPostLikes')
                          .where('cid', isEqualTo: widget.doc!['id'])

                      //.orderBy('ts', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: ProgressIndicatorState(),
                          );
                        } else {
                          final List<Map<String, dynamic>> workingDocuments =
                          snapshot.data!.docs as List<Map<String, dynamic>>;
                          print(workingDocuments.length);
                          return StickyHeader(
                            header: SchoolHeader(
                              title: 'Likes ${workingDocuments.length}',
                            ),
                            content: ListView.builder(
                                itemCount: workingDocuments.length,
                                shrinkWrap: true,
                                reverse: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, int index) {
                                  return Column(children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 32,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            '${workingDocuments[index]['pimg']}',
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                Icon(Icons.error),
                                            fit: BoxFit.cover,
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        '${workingDocuments[index]['fn']}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kBlackcolor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${workingDocuments[index]['ln']}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kBlackcolor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),
                                      trailing: Text(
                                        '${timeago.format(DateTime.parse(workingDocuments[index]['ts']), locale: 'en_short')}',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: klistnmber,
                                            fontSize: kFontSize14.sp,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]);
                                }),
                          );
                        }
                      })
                ]))));
  }
}
