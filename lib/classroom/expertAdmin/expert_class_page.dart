import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'package:readmore/readmore.dart';

import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_appbar.dart';

class ExpertPage extends StatefulWidget {
  @override
  _ExpertPageState createState() => _ExpertPageState();
}

class _ExpertPageState extends State<ExpertPage> {
  var itemsData = [];
  var _documents = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses();
  }

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    );
  }

  Widget spaceWidth() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAdminAppBar(),
            body: _documents.length == 0
                ? ProgressIndicatorState()
                : Column(
                    children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _documents.length,
                          itemBuilder: (context, int index) {
                            return Column(
                              children: <Widget>[
                                Card(
                                  elevation: 20.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 32,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: itemsData[index]
                                                    ['pix'],
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
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                itemsData[index]['fn'],
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontsize.sp,
                                                  color: kFbColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                itemsData[index]['ln'],
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontsize.sp,
                                                  color: kFbColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          spaceWidth(),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(10)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: ScreenUtil()
                                                      .setWidth(
                                                          constrainedReadMore),
                                                  minHeight: ScreenUtil().setHeight(
                                                      constrainedReadMoreHeight),
                                                ),
                                                child: ReadMoreText(
                                                  itemsData[index]['tp'],
                                                  trimLines: 2,
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: ' ...',
                                                  trimExpandedText: 'show less',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kBlackcolor,
                                                      fontSize: kFontsize.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(10)),
                                              Text(
                                                itemsData[index]['date'],
                                                style: GoogleFonts.rajdhani(
                                                  fontSize: kFontsize.sp,
                                                  color: kPreviewcolor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: kAshthumbnailcolor,
                                        thickness: kThickness,
                                      ),
                                      Center(
                                        child: Text(
                                          'Staff Uploaded class details'
                                              .toUpperCase(),
                                          style: GoogleFonts.rajdhani(
                                            fontWeight: FontWeight.bold,
                                            fontSize: kFontsize.sp,
                                            color: kExpertColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'FirstName:',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: klistnmber,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            spaceWidth(),
                                            Text(
                                              itemsData[index]['sfn'],
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kBlackcolor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'LastName:',
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: klistnmber,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            spaceWidth(),
                                            Text(
                                              itemsData[index]['sln'],
                                              style: GoogleFonts.rajdhani(
                                                fontSize: kFontsize.sp,
                                                color: kBlackcolor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      space(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })
                    ],
                  )));
  }

  void getClasses() {
    FirebaseFirestore.instance
        .collectionGroup('details')
        .where('id', isEqualTo: ExpertAdminConstants.userData[0]['id'])
        .orderBy('date')
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          itemsData.clear();
          _documents.clear();
          _documents.add(result);
          itemsData.add(result.data());
          print(_documents);
        });
      });
    });
  }
}
