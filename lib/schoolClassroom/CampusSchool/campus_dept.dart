import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/teachersActivitiesTab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_dept_levels.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_tutors.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/schoolTeachersAnalysis.dart';

import 'package:sparks/schoolClassroom/SchoolAdmin/add_new_students.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/schoolClassroom/campus_appbar.dart';
import 'package:sparks/schoolClassroom/campus_searchAppbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/analysisText.dart';

class CampusLecturersScreen extends StatefulWidget {
  CampusLecturersScreen({required this.doc,required this.name});
  final List<dynamic> doc;
  final String name;
  @override
  _CampusLecturersScreenState createState() => _CampusLecturersScreenState();
}

class _CampusLecturersScreenState extends State<CampusLecturersScreen> {
  Widget space(){
    return SizedBox(height:  MediaQuery.of(context).size.height * 0.02,);
  }


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

    FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
        .where('facId',isEqualTo: widget.doc[0]['id'])
        .where('dept',isEqualTo: widget.name)
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
  Widget ?f;

  List<dynamic> levelCount = <dynamic>[];
  List<dynamic> levelSorted = <dynamic>[];
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SafeArea(
            child: Scaffold(
                appBar:CampusDeptAppbar(name: widget.name,),

                body: CustomScrollView(slivers: <Widget>[
                  CampusSearchAppBar(filter:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getLevel(),
                  ),),
                  SliverList(
                    delegate: SliverChildListDelegate([

                      Container(
                          child: Column(
                              children: [
                                space(),

                                space(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('List of departmental courses & tutors'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlackcolor,
                                        fontSize:kFontsize.sp
                                      ),
                                    ),

                                  ),
                                ),
                                space(),

                                StreamBuilder<List<DocumentSnapshot>>(
                                    stream: _streamController.stream,

                                    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                      if(snapshot.data == null){
                                        return Center(child: CircularProgressIndicator());
                                      } else if(snapshot.data!.isEmpty){
                                        return NoContentCreated(title: kNothing);
                                      }else{
                                        return Column(
                                            children: snapshot.data!.map((doc) {
                                              Map<String, dynamic> data =
                                              doc.data() as Map<String, dynamic>;
                                              addLevels(doc);

                                              return Card(
                                                  elevation: 10,
                                                  child:Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Tutor's name",
                                                          style: GoogleFonts.rajdhani(
                                                            decoration: TextDecoration.underline,
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kExpertColor,
                                                              fontSize:kFontsize.sp
                                                            ),
                                                          ),

                                                        ),

                                                        Text(data['tc'].toString(),
                                                          style: GoogleFonts.rajdhani(
                                                            textStyle: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: kBlackcolor,
                                                              fontSize:kFontsize.sp
                                                            ),
                                                          ),

                                                        ),


                                                        data['ass'] == true?
                                                        BtnThird(next: (){_removeTeacher(doc);}, title: 'Denial', bgColor: kAGreen)

                                                            :BtnThird(next: (){_acceptTeacher(doc);}, title: 'Accept', bgColor: kFbColor),


                                                        Divider(),


                                                        space(),
                                                        ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: data['pin'].toString()),


                                                        space(),

                                                        ShowRichText(color:kExpertColor,title: 'Tutor Level: ',titleText: data['lv']),


                                                        space(),
                                                        ShowRichText(color:kExpertColor,title: 'Tutor course: ',titleText: data['curs']),

                                                        space(),
                                                        ShowRichText(color:kIconColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(data['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(data['ts']))}'),



                                                        space(),
                                                        ShowRichText(color:kIconColor,title: 'By: ',titleText: data['by']),

                                                        space(),
                                                        Divider(),

                                                        IntrinsicHeight(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,

                                                                children: [
                                                                  Text(data['onl']==true?'Online':'Offline',
                                                                      style: GoogleFonts.rajdhani(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: data['onl']==true?kAGreen:kRed,
                                                                          fontSize:kFontSize14.sp
                                                                        ),
                                                                      )),

                                                                  Text(data['onl']==true?'${timeago.format(DateTime.parse(data['ol']), locale: 'en_short')} ago':'${timeago.format(DateTime.parse(data['off']), locale: 'en_short')} ago',
                                                                      style: GoogleFonts.rajdhani(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: kIconColor,
                                                                          fontSize:kFontSize14.sp
                                                                        ),
                                                                      )),

                                                                  Text('online count: ${data['olc'].toString()}',
                                                                      style: GoogleFonts.rajdhani(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: kIconColor,
                                                                          fontSize:kFontSize14.sp
                                                                        ),
                                                                      )),


                                                                ],
                                                              ) ,

                                                              VerticalDivider(),
                                                              Column(
                                                                children: [
                                                                  Text(data['live']==true?'Live':'Not live',
                                                                      style: GoogleFonts.rajdhani(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: data['live']==true?kAGreen:kRed,
                                                                          fontSize:kFontSize14.sp
                                                                        ),
                                                                      )),

                                                                  BtnSecond(next: (){
                                                                    if(data['live']==true){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(
                                                                        channelName: data['id'],
                                                                        role: role,
                                                                        id:data['id'],
                                                                        topic:data['litp'],
                                                                        items:'',
                                                                        courseName: data['licn'],
                                                                      )));

                                                                      //this collection stores the name of the student that joined the class
                                                                      FirebaseFirestore.instance.collection('joinedClassName').doc(videoId).set({
                                                                        'fn':'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                                                                        'join':'joined'
                                                                      });
                                                                    }else{
                                                                      SchClassConstant.displayToastError(title: 'Invalid');
                                                                    }

                                                                  }, title: data['live']==true?'Join':'Invalid', bgColor: data['live']==true?kAGreen:Colors.orange),


                                                                ],
                                                              ) ,
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(),



                                                        space(),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            AnalysisTextSchool(title: kTeachersAnalysis,),

                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersActivities(doc:doc)));

                                                              },
                                                              child: Text('See Activities',
                                                                  style: GoogleFonts.rajdhani(
                                                                    textStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kExpertColor,
                                                                      fontSize:kFontSize14.sp
                                                                    ),
                                                                  )),
                                                            ),

                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersAnalysis(doc:doc)));

                                                              },
                                                              child: Text('See details',
                                                                  style: GoogleFonts.rajdhani(
                                                                    textStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kExpertColor,
                                                                      fontSize:kFontSize14.sp
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                        space(),

                                                        AnalysisTableSchool(
                                                          text1: kEclassCount,
                                                          text2: data['lday']==DateTime.now().day && data['lmth']==DateTime.now().month && data['lyr']==DateTime.now().year ?data['ld'].toString():'0',
                                                          text3: data['lwky']==Jiffy().week && data['lyr'] == DateTime.now().year?data['lw'].toString():'0',
                                                          text4: data['lmth']==DateTime.now().month && data['lyr']==DateTime.now().year ?data['lm'].toString():'0',
                                                          text5: data['lyr']==DateTime.now().year ?data['ly'].toString():'0',

                                                          text6: kRecordedCount,
                                                          text7: data['uday']==DateTime.now().day && data['umth']==DateTime.now().month && data['uyr']==DateTime.now().year?data['ud'].toString():'0',
                                                          text8: data['uwky']==Jiffy().week && data['uyr'] == DateTime.now().year?data['uw'].toString():'0',
                                                          text9: data['umth']==DateTime.now().month && data['uyr']==DateTime.now().year ?data['um'].toString():'0',
                                                          text10: data['uyr']==DateTime.now().year?data['uy'].toString():'0',

                                                          text11: kExtraCount,
                                                          text12: data['eday']==DateTime.now().day && data['emth']==DateTime.now().month && data['eyr']==DateTime.now().year ?data['ed'].toString():'0',
                                                          text13: data['ewky']==Jiffy().week && data['eyr'] == DateTime.now().year?data['ew'].toString():'0',
                                                          text14: data['emth']==DateTime.now().month && data['eyr']==DateTime.now().year ?data['em'].toString():'0',
                                                          text15: data['eyr']==DateTime.now().year?data['ey'].toString():'0',

                                                          text16: kResultCount,
                                                          text17: data['rday']==DateTime.now().day && data['rmth']==DateTime.now().month && data['ryr']==DateTime.now().year ?data['rd'].toString():'0',
                                                          text18:  data['rwky']==Jiffy().week && data['ryr'] == DateTime.now().year?data['rw'].toString():'0',
                                                          text19: data['rmth']==DateTime.now().month && data['ryr']==DateTime.now().year?data['rm'].toString():'0',
                                                          text20: data['ryr']==DateTime.now().year?data['ry'].toString():'0',

                                                          text21: kAssessmentCount,
                                                          text22: data['aday']==DateTime.now().day && data['amth']==DateTime.now().month && data['ayr']==DateTime.now().year ?data['ad'].toString():'0',
                                                          text23: data['awky']==Jiffy().week && data['ayr'] == DateTime.now().year?data['aw'].toString():'0',
                                                          text24: data['amth']==DateTime.now().month && data['ayr']==DateTime.now().year?data['am'].toString():'0',
                                                          text25: data['ayr']==DateTime.now().year?data['ay'].toString():'0',
                                                        ),








                                                        Divider(),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                            BtnThird(next: (){ _deleteTeacher(doc);}, title: 'Remove', bgColor: kRed),

                                                            RaisedButton(onPressed: (){
                                                              _editTeacher(doc);
                                                            },
                                                              color: kWhitecolor,
                                                              child: Text('Edit',
                                                                style: GoogleFonts.rajdhani(
                                                                  textStyle: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: kFbColor,
                                                                    fontSize:kFontsize.sp
                                                                  ),
                                                                ),

                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              );
                                            }).toList()

                                        );

                                      }
                                    }),
                                _isFinish == false ?
                                isLoading == true ? Center(
                                    child: PlatformCircularProgressIndicator()) : Text('')

                                    : Text(''),
                              ])
                      ),
                    ]),
                  ),
                ])
            )));
  }


  void _deleteTeacher(DocumentSnapshot doc) {
    //remove Admin
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])
          .update({
        'ass':false,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _acceptTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(data['schId']).collection('tutors').doc(data['id'])
          .update({
        'ass':true,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _editTeacher(DocumentSnapshot doc) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: EditCampusTutors(doc:doc)));
//edit students profile here



  }

  void requestNextPage() async {

    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;


      if (_products.isEmpty) {

        querySnapshot = await FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
            .where('facId',isEqualTo: widget.doc[0]['id'])
            .where('dept',isEqualTo: widget.name)
            .orderBy('ts',descending: true)

            .limit(SchClassConstant.streamCount)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors')
            .where('facId',isEqualTo: widget.doc[0]['id'])
            .where('dept',isEqualTo: widget.name)
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

  void addLevels(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    for(int i = 0; i < data.length; i++){
      levelCount.add(data['lv']);
    }


  }
  List<Widget> getLevel(){
    levelSorted.clear();
    levelSorted.addAll(levelCount.toList().toSet());

    List<Widget> list =  <Widget>[];
    for(var i = 0; i < levelSorted.length; i++){
      Widget w =  Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusLecturersLevel(name: widget.name,doc: widget.doc,level:levelSorted[i])));
          },
          child: Text(levelSorted[i].toString(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize: kFontSize14.sp,
              ),
            ),

          ),
        ),
      );
      list.add(w);
    }
    return list;
  }
}
