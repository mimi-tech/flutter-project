import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/indexpage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/liveAttendant.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/utils/searchservice.dart';

class SearchEClass extends StatefulWidget {
  @override
  _SearchEClassState createState() => _SearchEClassState();
}

class _SearchEClassState extends State<SearchEClass> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot>[];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot>[];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  bool isPlaying = false;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByStudentsEClass(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {
      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['tp'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kStatusbar,
              title: Text(
                'Search for a class',
                style: GoogleFonts.rajdhani(
                  fontSize: kFontsize.sp,
                  color: kWhitecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: kWhitecolor,
                automaticallyImplyLeading: false,
                //expandedHeight: 100,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (val) {
                      initiateSearch(val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.search),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by topic',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    tempSearchStore.length == 0
                        ? Text('')
                        : ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          Map<String, dynamic> data = tempSearchStore[index]
                              .data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _moveMe(tempSearchStore[index]);
                                },
                                child: Card(
                                  elevation: 10,
                                  color: kCardFillColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Icon(Icons.tv_off),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                      color: klistnmber),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['cn'],
                                                      style: GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: kBlackcolor,
                                                          fontSize: kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxWidth: ScreenUtil()
                                                              .setWidth(150),
                                                          minHeight: ScreenUtil()
                                                              .setHeight(
                                                              constrainedReadMoreHeight),
                                                        ),
                                                        child: ReadMoreText(
                                                          data['tp'],
                                                          trimLines: 1,
                                                          colorClickableText:
                                                          Colors.pink,
                                                          trimMode: TrimMode.Line,
                                                          trimCollapsedText: ' ...',
                                                          trimExpandedText:
                                                          'show less',
                                                          style:
                                                          GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: kBlackcolor,
                                                              fontSize:
                                                              kFontsize.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    Material(
                                                      color: kRed,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'images/classroom/uploadvideo.svg',
                                                            width: klistIcon
                                                                .roundToDouble(),
                                                            height: klistIcon
                                                                .roundToDouble(),
                                                          ),
                                                          Text(
                                                            data['act'] == true
                                                                ? 'Live'
                                                                : 'Scheduled',
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: kWhitecolor,
                                                                fontSize:
                                                                kFontsize.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      data['close'] == true
                                                          ? data['tm']
                                                          : '00:00:00',
                                                      style: GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: klistnmber,
                                                          fontSize: kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Divider(),
                                        Text(
                                          data['tsn'],
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: kBlackcolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Posted on ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(data['ts']))}',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kMaincolor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Class date ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(data['dd']))}',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: kBlackcolor,
                                                  fontSize: kFontsize.sp,
                                                ),
                                              ),
                                            ),
                                            isTeacher && data['close'] == true
                                                ? IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _getAttendants(
                                                          tempSearchStore[
                                                          index]);
                                                    },
                                                    child: Text(
                                                      'Attendant',
                                                      style: GoogleFonts
                                                          .rajdhani(
                                                        textStyle:
                                                        TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          color:
                                                          kExpertColor,
                                                          fontSize:
                                                          kFontsize
                                                              .sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _getAttendants(
                                                          tempSearchStore[
                                                          index]);
                                                    },
                                                    child: Text(
                                                      data['ass'] == true
                                                          ? 'Access'
                                                          : 'Denied',
                                                      style: GoogleFonts
                                                          .rajdhani(
                                                        textStyle:
                                                        TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          color: data['ass'] ==
                                                              true
                                                              ? kExpertColor
                                                              : kRed,
                                                          fontSize:
                                                          kFontsize
                                                              .sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _deleteDoc(
                                                          tempSearchStore[
                                                          index]);
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: GoogleFonts
                                                          .rajdhani(
                                                        textStyle:
                                                        TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          color:
                                                          kExpertColor,
                                                          fontSize:
                                                          kFontsize
                                                              .sp,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                                : Text(''),
                                            Text(
                                              data['items'] == ""
                                                  ? 'Note: No Item required to attend this class.'
                                                  : 'Note: ${data['items']}',
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: kBlackcolor,
                                                  fontSize: kFontsize.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ]))
            ])));
  }

  void _moveMe(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //check if time has expired
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    /*final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
*/
    final dateToCheck = DateTime.parse(data['dd']);
    final aDate =
    DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    DateTime classDate = DateTime.parse(data['dd']);

    bool checkDate = classDate.isBefore(now);
    bool checkDateAfter = classDate.isAfter(now);

    if ((aDate == today) && (data['close'] == false)) {
      videoId = data['id'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                channelName: channelName,
                role: role,
                id: data['id'],
                topic: data['tp'],
                items: data['items'],
                courseName: data['cn'],
              )));
      if (!SchClassConstant.isTeacher) {
        getStudentsCount(doc);
      }
    } else if (data['close'] == true) {
      //take the students to screen where they will watch the live video
      print('I will take you there');
    } else {
//check if time has passed

      if (checkDate) {
        SchClassConstant.displayToastError(title: 'Not yet time');
      } else {
        SchClassConstant.displayToastError(
            title: 'Time for this class has expired');
      }
    }
  }

  Future<void> getStudentsCount(DocumentSnapshot doc) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('attendant')
        .where('id', isEqualTo: videoId)
        .where('uid', isEqualTo: SchClassConstant.schDoc['did'])
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      //update the number of student that attended this class
      FirebaseFirestore.instance
          .collection('attendant')
          .doc(videoId)
          .get()
          .then((value) {
        var count = value.data()!['att'] + 1;
        attendantCount = count;
        value.reference.set({
          'att': count,
        }, SetOptions(merge: true));
      });
    }

    //get the students name that attended the class

    final QuerySnapshot res = await FirebaseFirestore.instance
        .collection('classAttendant')
        .doc(videoId)
        .collection('classList')
        .where('id', isEqualTo: videoId)
        .where('uid', isEqualTo: SchClassConstant.schDoc['did'])
        .get();

    final List<DocumentSnapshot> doc = res.docs;

    if (doc.length == 0) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('classAttendant')
          .doc(videoId)
          .collection('classList')
          .doc(SchClassConstant.schDoc['did']);

      docRef.set({
        'id': videoId,
        'uid': SchClassConstant.schDoc['did'],
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ol': DateTime.now().toString(),
        'did': docRef.id,
        'pimg': SchClassConstant.isUniStudent || isTeacher
            ? GlobalVariables.loggedInUserObject.pimg
            : null,
      });

      //this collection stores the name of the student that joined the class
      FirebaseFirestore.instance
          .collection('joinedClassName')
          .doc(videoId)
          .set({
        'fn':
        '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
        'join': 'joined'
      });
    }
  }

  void _getAttendants(DocumentSnapshot doc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => LiveAttendant(
          doc: doc,
        ));
  }

  void _checkDenied(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    FirebaseFirestore.instance
        .collection('savedClasses')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('savedOnlineClasses')
        .doc(data['id'])
        .set({
      'ass': data['ass'] == true ? false : true,
    }, SetOptions(merge: true));
  }

  void _deleteDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    FirebaseFirestore.instance
        .collection('savedClasses')
        .doc(SchClassConstant.schDoc['schId'])
        .collection('savedOnlineClasses')
        .doc(data['id'])
        .delete();
  }
}
