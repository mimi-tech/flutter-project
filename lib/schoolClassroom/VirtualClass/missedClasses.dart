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
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/indexpage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/liveAttendant.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchE-class.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchLessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/e-class-secondAppbar.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class MissedEClass extends StatefulWidget {
  @override
  _MissedEClassState createState() => _MissedEClassState();
}

class _MissedEClassState extends State<MissedEClass> {
  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {

        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if(isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collectionGroup('missedClassList')
        .where('stId',isEqualTo: SchClassConstant.schDoc['id'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .orderBy('ts',descending: true)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child:SafeArea(child: Scaffold(
            appBar: StuAppBar(),
            body:CustomScrollView(slivers: <Widget>[
              ActivityAppBer(
                activitiesColor: kTextColor,
                classColor: kStabcolor1,
                newsColor: kTextColor,
              ),
              EClassSliverAppBar(
                liveBgColor: Colors.transparent,
                liveColor: klistnmber,
                missedClassBgColor: klistnmber,
                missedClassColor: kWhitecolor,
                recordsBgColor: Colors.transparent,
                recordsColor: klistnmber,
                assessmentBgColor: Colors.transparent,
                assessmentColor: klistnmber,

              ),
              EClassSliverAppBarSearch(
                scheduleColor: klistnmber,
                scheduledClassColor: klistnmber,
                attendedColor: klistnmber,
                searchTap: (){
                  //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchEClass()));

                },
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 20,),
                    StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController.stream,

                        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if(snapshot.data == null){
                            return Center(child: Text(SchClassConstant.isStudent?kNothing:'Missed classes',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: klistnmber,
                                  fontSize: kFontsize.sp,
                                ),
                              ),

                            ));
                          } else {
                            return Column(
                                children: snapshot.data!.map((doc) {
                                  Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          SchoolPostConst.liveVideoDoc = doc;
                                          _moveMe(doc);},
                                        child: Card(
                                          elevation: 10,
                                          color: kCardFillColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(child: Row(
                                                  children: [
                                                    Container(
                                                      height:50,
                                                      width: 50,
                                                      child: Icon(Icons.tv_off),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.circular(6.0),
                                                          color: klistnmber
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize:MainAxisSize.min,
                                                      children: [
                                                        Text('${data['cn']}',
                                                          overflow:TextOverflow.ellipsis,
                                                          softWrap:true,
                                                          maxLines:1,
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kBlackcolor,
                                                              fontSize: kFontSize14.sp,
                                                            ),
                                                          ),

                                                        ),
                                                        Container(
                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                              maxWidth: ScreenUtil().setWidth(150),
                                                              minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                                            ),
                                                            child: ReadMoreText(data['tp'],

                                                              trimLines: 1,
                                                              colorClickableText: Colors.pink,
                                                              trimMode: TrimMode.Line,
                                                              trimCollapsedText: ' ...',
                                                              trimExpandedText: 'show less',
                                                              style:GoogleFonts.rajdhani(
                                                                textStyle: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: kBlackcolor,
                                                                  fontSize:14.sp,
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
                                                          child:  Text('Live',
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: kWhitecolor,
                                                                fontSize: kFontsize.sp,
                                                              ),
                                                            ),
                                                          ),


                                                        ),


                                                        Text(data['close'] == true?data['tm']:'00:00:00',
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
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

                                                Text(data['tsn'],
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: kBlackcolor,
                                                      fontSize: kFontsize.sp,
                                                    ),
                                                  ),
                                                ),

                                                Text('Posted on ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(data['ts']))}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kFacebookcolor,
                                                      fontSize: kFontsize.sp,
                                                    ),
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  );
                                }).toList());
                          }}),

                    _isFinish == false ?
                    isLoading == true ? Center(
                        child: PlatformCircularProgressIndicator()) : Text('')

                        : Text(''),
                  ]))]))));
  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await    FirebaseFirestore.instance.collectionGroup('missedClassList')
            .where('stId',isEqualTo: SchClassConstant.schDoc['id'])
            .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
            .orderBy('ts',descending: true)
            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await   FirebaseFirestore.instance.collectionGroup('missedClassList')
            .where('stId',isEqualTo: SchClassConstant.schDoc['id'])
            .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
            .orderBy('ts',descending: true)

            .startAfterDocument(_products[_products.length - 1])
            .limit(SchClassConstant.streamCount)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }

  void _moveMe(DocumentSnapshot doc) {


  }







}
