import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
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
import 'package:sparks/schoolClassroom/studentFolder/searchE-class.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchLessons.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/schoolPost/e-class-secondAppbar.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class StudentsEClasses extends StatefulWidget {
  @override
  _StudentsEClassesState createState() => _StudentsEClassesState();
}

class _StudentsEClassesState extends State<StudentsEClasses> {
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

    if(SchClassConstant.isTeacher){
      FirebaseFirestore.instance.collection('savedClasses').doc(
          SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
          .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
          .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
          .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
          .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
          .where('close',isEqualTo: false)
          .orderBy('ts', descending: true)
          .snapshots()
          .listen((data) => onChangeData(data.docChanges));

      requestNextPage();
    }else {
      FirebaseFirestore.instance.collection('savedClasses').doc(
          SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
          .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
          .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
          .where('schId', isEqualTo: SchClassConstant.schDoc['schId'])
          .where('close', isEqualTo: false)
          .orderBy('ts', descending: true)
          .snapshots()
          .listen((data) => onChangeData(data.docChanges));

      requestNextPage();
    }
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
          liveBgColor: klistnmber,
          liveColor: kWhitecolor,
          missedClassBgColor: Colors.transparent,
          missedClassColor: klistnmber,
          recordsBgColor: Colors.transparent,
          recordsColor: klistnmber,
          assessmentBgColor: Colors.transparent,
          assessmentColor: klistnmber,

        ),
        EClassSliverAppBarSearch(
          scheduleColor: klistnmber,
          scheduledClassColor: kIconColor2,
          attendedColor: klistnmber,
          searchTap: (){
            if(SchClassConstant.isStudent){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchEClass()));

            }else{
              //isTeacher
            }

          },
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 20,),
            StreamBuilder<List<DocumentSnapshot>>(
            stream: _streamController.stream,

            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if(snapshot.data == null){
            return Center(child: Text(SchClassConstant.isStudent?'Loading...':'Schedule a live class',
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
                               child:   Text('Live',
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
                                  color: kMaincolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),

                            Text('Class date ${DateFormat('EE d, MMM yyyy: hh:mma').format(DateTime.parse(data['dd']))}',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kAGreen,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            ),


                               Divider(),
                            Text(data['items'] == ""?'Note: No Item required to attend this class.':'Note: ${data['items']}',
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: kBlackcolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),

                            ),
                            Divider(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [



                                isTeacher?IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [

                                      GestureDetector(
                                        onTap:(){_checkDenied(doc);},
                                        child: Text(data['ass'] == true?'Access':'Denied',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: data['ass'] == true? kExpertColor:kRed,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(),
                                      GestureDetector(
                                        onTap:(){_deleteDoc(doc);},
                                        child: Text('Delete',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: kExpertColor,
                                              fontSize: kFontsize.sp,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ):Text(''),


                              ],
                            ),


                          ],
                    ),
                      ),
                    ),
                  ),
                  _isFinish == false ?
                  isLoading == true ? Center(
                      child: PlatformCircularProgressIndicator()) : Text('')

                      : Text(''),
                ],
              );
            }).toList());
            }})]))]))));
  }

    void requestNextPage() async {

    if(SchClassConstant.isTeacher){
      if (!_isRequesting && !_isFinish) {
        QuerySnapshot querySnapshot;
        _isRequesting = true;


        if (_products.isEmpty) {

          querySnapshot = await   FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
              .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
              .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
              .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
              .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
              .where('close',isEqualTo: false)
              .orderBy('ts',descending: true)
              .limit(SchClassConstant.streamCount)
              .get();
        } else {
          setState(() {
            isLoading = true;
          });
          querySnapshot = await   FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
              .where('tcId',isEqualTo: SchClassConstant.schDoc['id'])
              .where('cl', isEqualTo: SchClassConstant.schDoc['cl'])
              .where('lv', isEqualTo: SchClassConstant.schDoc['lv'])
              .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
              .where('close',isEqualTo: false)
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


    }else{

    if (!_isRequesting && !_isFinish) {
    QuerySnapshot querySnapshot;
    _isRequesting = true;


    if (_products.isEmpty) {

    querySnapshot = await   FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('close',isEqualTo: false)
        .orderBy('ts',descending: true)
        .limit(SchClassConstant.streamCount)
        .get();
    } else {
    setState(() {
    isLoading = true;
    });
    querySnapshot = await   FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses')
        .where('cl',isEqualTo: SchClassConstant.schDoc['cl'])
        .where('lv',isEqualTo: SchClassConstant.schDoc['lv'])
        .where('schId',isEqualTo: SchClassConstant.schDoc['schId'])
        .where('close',isEqualTo: false)
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
    }}

  void _moveMe(DocumentSnapshot doc) {
    //check if time has expired
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    /*final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
*/
    final dateToCheck = DateTime.parse(data['dd']);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    DateTime classDate = DateTime.parse(data['dd']);

    bool checkDate = classDate.isBefore(now);
    bool checkDateAfter = classDate.isAfter(now);

    if((aDate == today) && (data['close'] == false) && (checkDateAfter == false)) {
      videoId = data['id'];
      Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(
        channelName: data['id'],
        role: role,
        id:data['id'],
        topic:data['tp'],
        items:data['items'],
        courseName: data['cn'],
      )));
if(!SchClassConstant.isTeacher){
  getStudentsCount(doc);
}else{

  if(SchClassConstant.isLecturer){
    ///if this is a campus teacher

    FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
      'live': false,
      'loft':DateTime.now().toString(),
      'lId':videoId,
      'litp':data['tp'],
      'licn':data['cn']

    },SetOptions(merge:  true));
  }else{
    ///if this is a high school teacher

    FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
      'live': false,
      'loft':DateTime.now().toString(),
      'lId':videoId,
      'litp':data['tp'],
      'licn':data['cn']
    },SetOptions(merge:  true));

  }

}
    }else if(data['close'] == true){
        //take the students to screen where they will watch the live video
      print('I will take you there');
      }else {
//check if time has passed

      if(checkDate){

        SchClassConstant.displayToastError(title: 'Time for this class has expired');

      }else {

        SchClassConstant.displayToastError(title: 'Not yet time');

    }


    }


  }

  Future<void> getStudentsCount(DocumentSnapshot doc) async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('attendant')
        .where('id', isEqualTo: videoId)
        .where('uid', isEqualTo: SchClassConstant.schDoc['did'])

        .get();

    final List < DocumentSnapshot > documents = result.docs;

    if (documents.length == 0) {
      //update the number of student that attended this class
      FirebaseFirestore.instance.collection('attendant').doc(videoId).get().then((value) {
        value.reference.set({
          'att': 1,
        }, SetOptions(merge: true));

      });
  }else{
      //update the number of student that attended this class
      FirebaseFirestore.instance.collection('attendant').doc(videoId).get().then((value) {

        var count = value.data()!['att'] + 1;
        attendantCount = count;
        value.reference.set({
          'att': count,
        }, SetOptions(merge: true));

      });
    }


    //get the students name that attended the class

    final QuerySnapshot res = await FirebaseFirestore.instance.collection('classAttendant').doc(videoId).collection('classList')
        .where('id', isEqualTo: videoId)
        .where('uid', isEqualTo: SchClassConstant.schDoc['did'])

        .get();

    final List < DocumentSnapshot > doc = res.docs;

    if (doc.length == 0) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('classAttendant').doc(videoId).collection('classList').doc(SchClassConstant.schDoc['did']);

      docRef.set({
         'id':videoId,
         'uid':SchClassConstant.schDoc['did'],
        'fn':SchClassConstant.schDoc['fn'],
        'ln':SchClassConstant.schDoc['ln'],
        'ol':DateTime.now().toString(),
        'did':docRef.id,
        'pimg':SchClassConstant.isUniStudent || isTeacher?GlobalVariables.loggedInUserObject.pimg:null,
        'lv':SchClassConstant.schDoc['lv'],
        'cl':SchClassConstant.schDoc['cl'],
        'stId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'tp':SchoolPostConst.liveVideoDoc['tp'],
        'cn':SchoolPostConst.liveVideoDoc['cn'],
        'tcId':SchoolPostConst.liveVideoDoc['tcId'],
        'tsn':SchoolPostConst.liveVideoDoc['tsn'],
        'sk':SchoolPostConst.liveVideoDoc['cn'].substring(0,1).toUpperCase(),
        'ts':DateTime.now().toString(),
        'vido':''
      });

      //this collection stores the name of the student that joined the class
      FirebaseFirestore.instance.collection('joinedClassName').doc(videoId).set({
        'fn':'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
        'join':'joined'
      });
    }



    }



  void _checkDenied(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses').doc(data['id']).set({
      'ass':data['ass'] == true?false:true,

    },SetOptions(merge: true));
  }

  void _deleteDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses').doc(data['id']).delete();

  }

  void _getAbsent(DocumentSnapshot doc) {

  }




}
