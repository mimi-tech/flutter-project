import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import 'package:sparks/classroom/courseAnalysis/analysis_second_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_top_appbar.dart';
import 'package:sparks/classroom/courseAnalysis/no_staff.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

class ViewAllCourses extends StatefulWidget {
  @override
  _ViewAllCoursesState createState() => _ViewAllCoursesState();
}

class _ViewAllCoursesState extends State<ViewAllCourses> {
  var itemsData = [];
  var _documents = [];
  bool progress = false;
  String? filter;
  bool _loadMoreProgress = false;
  bool moreData = false;
  late var _lastDocument;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourses();
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
  }

  Widget bodyList(int index) {
    return Column(children: <Widget>[
      Card(
        elevation: 20,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 32,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: itemsData[index]['pix'],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: kPixWidth,
                      height: kPixHeight,
                    ),
                  ),
                ),
                Text(
                  itemsData[index]['fn'].toString().toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Company: ',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kFbColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  itemsData[index]['comN'],
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Topic: ',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kFbColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ScreenUtil().setWidth(constrainedReadMore),
                    minHeight:
                        ScreenUtil().setHeight(constrainedReadMoreHeight),
                  ),
                  child: ReadMoreText(
                    itemsData[index]['cname'],
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' ...',
                    trimExpandedText: ' less',
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      color: kBlackcolor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Date: ',
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kFbColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            )
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ViewAppbar(
              title: 'View Courses',
            ),
            body: CustomScrollView(slivers: <Widget>[
              AnalysisSilverAppBar(
                matches: kStabcolor1,
                friends: kSappbarcolor,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    itemsData.length == 0 && progress == false
                        ? Center(child: PlatformCircularProgressIndicator())
                        : itemsData.length == 0 && progress == true
                            ? Text(
                                'Sorry no course have been uploaded',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  color: kBlackcolor,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _documents.length,
                                itemBuilder: (context, int index) {
                                  return filter == null || filter == ""
                                      ? bodyList(index)
                                      : '${itemsData[index]['biz']}'
                                              .toLowerCase()
                                              .contains(filter!.toLowerCase())
                                          ? bodyList(index)
                                          : Container();
                                }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    progress == true ||
                            _loadMoreProgress == true ||
                            _documents.length < UploadVariables.limit
                        ? Text('')
                        : moreData == true
                            ? PlatformCircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  loadMore();
                                },
                                child: SvgPicture.asset(
                                  'assets/imagesFolder/load_more.svg',
                                ))
                  ],
                )
              ]))
            ])));
  }

  Future<void> getCourses() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collectionGroup('inspectedCourses')
          .orderBy('time', descending: true)
          .limit(UploadVariables.limit)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());

            // PageConstants.getCompanies.clear();
          });
        }
      }
    } catch (e) {
      // return CircularProgressIndicator();
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collectionGroup('inspectedCourses')
        .orderBy('time', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(UploadVariables.limit)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

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
          itemsData.add(document.data);

          moreData = false;
        });
      }
    }
  }
}
