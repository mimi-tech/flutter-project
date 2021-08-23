import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/schoolClassroom/CampusSchool/activities/teachersActivitiesTab.dart';
import 'package:sparks/schoolClassroom/CampusSchool/edit_campus_student.dart';
import 'package:sparks/schoolClassroom/CampusSchool/schoolAnalysis/schoolTeachersAnalysis.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/edit_students.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/edit_teachers.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/analysisText.dart';
import 'package:timeago/timeago.dart' as timeago;



class NonCampusTutorSearchStream extends StatefulWidget {
  @override
  _NonCampusTutorSearchStreamState createState() => _NonCampusTutorSearchStreamState();
}

class _NonCampusTutorSearchStreamState extends State<NonCampusTutorSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  List <dynamic>? aoi;
  List <dynamic>? spec;
  List <dynamic>? hobby;
  List <dynamic>? lang;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print(capitalizedValue);
    if (queryResultSet.length == 0 && value.length == 1) {

      SchClassConstant().searchByNonCampusTutorsName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['fn'].startsWith(capitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kStatusbar,
          title: Text('Search for a tutor',
            style: GoogleFonts.rajdhani(
              fontSize:kFontsize.sp,
              color: kWhitecolor,
              fontWeight: FontWeight.bold,

            ),),
        ),
        body: CustomScrollView(
            slivers: <Widget>[
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
                    onChanged: (dynamic val) {
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
                        hintText: 'Search by first name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([

                    tempSearchStore.length == 0?Text('empty'):
                    ListView.builder(
                        itemCount: tempSearchStore.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {


                          return Card(
                              elevation: 10,
                              child:Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Teacher's name",
                                      style: GoogleFonts.rajdhani(
                                        decoration: TextDecoration.underline,
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kExpertColor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),

                                    ),

                                    Text(tempSearchStore[index]['tc'].toString(),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: kBlackcolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      ),

                                    ),


                                    tempSearchStore[index]['ass'] == true?RaisedButton(onPressed: (){
                                      _removeTeacher(tempSearchStore[index]);
                                    },
                                      color: kFbColor,
                                      child: Text('Denied',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kWhitecolor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),

                                      ),
                                    ):RaisedButton(onPressed: (){
                                      _acceptTeacher(tempSearchStore[index]);
                                    },
                                      color: kFbColor,
                                      child: Text('Accept',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kWhitecolor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),

                                      ),
                                    ),
                                    Divider(),


                                    space(),
                                    ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: tempSearchStore[index]['pin'].toString()),


                                    space(),

                                    ShowRichText(color:kIconColor,title: 'Teacher Level: ',titleText: tempSearchStore[index]['lv']),


                                    space(),
                                    ShowRichText(color:kIconColor,title: 'Teacher class: ',titleText: tempSearchStore[index]['class']),





                                    space(),
                                    ShowRichText(color:kIconColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(tempSearchStore[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(tempSearchStore[index]['ts']))}'),



                                    space(),
                                    ShowRichText(color:kIconColor,title: 'By: ',titleText: tempSearchStore[index]['by']),

                                    space(),
                                    ShowRichText(color:kIconColor,title: 'By: ',titleText: tempSearchStore[index]['by']),

                                    space(),
                                    Divider(),

                                    AnalysisTextSchool(title: kAttendantCount,),

                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Text(tempSearchStore[index]['onl']==true?'Online':'Offline',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: tempSearchStore[index]['onl']==true?kAGreen:kRed,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  )),

                                              Text(tempSearchStore[index]['onl']==true?'${timeago.format(DateTime.parse(tempSearchStore[index]['ol']), locale: 'en_short')} ago':'${timeago.format(DateTime.parse(tempSearchStore[index]['off']), locale: 'en_short')} ago',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kIconColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  )),

                                              Text('online count: ${tempSearchStore[index]['olc'].toString()}',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kIconColor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  )),


                                            ],
                                          ) ,

                                          VerticalDivider(),
                                          Column(
                                            children: [
                                              Text(tempSearchStore[index]['live']==true?'Live':'Not live',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: tempSearchStore[index]['live']==true?kAGreen:kRed,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  )),

                                              BtnSecond(next: (){
                                                if(tempSearchStore[index]['live']==true){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(
                                                    channelName: tempSearchStore[index]['id'],
                                                    role: role,
                                                    id:tempSearchStore[index]['id'],
                                                    topic:tempSearchStore[index]['litp'],
                                                    items:'',
                                                    courseName: tempSearchStore[index]['licn'],
                                                  )));

                                                  //this collection stores the name of the student that joined the class
                                                  FirebaseFirestore.instance.collection('joinedClassName').doc(videoId).set({
                                                    'fn':'${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                                                    'join':'joined'
                                                  });
                                                }else{
                                                  SchClassConstant.displayToastError(title: 'Invalid');
                                                }

                                              }, title: tempSearchStore[index]['live']==true?'Join':'Invalid', bgColor: tempSearchStore[index]['live']==true?kAGreen:Colors.orange),


                                            ],
                                          ) ,
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnalysisTextSchool(title: kTeachersAnalysis,),

                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersActivities(doc:tempSearchStore[index])));

                                          },
                                          child: Text('See Activities',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kExpertColor,
                                                  fontSize: kFontSize14.sp,
                                                ),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersAnalysis(doc:tempSearchStore[index])));

                                          },
                                          child: Text('See details',
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kExpertColor,
                                                  fontSize: kFontSize14.sp,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                    space(),

                                    AnalysisTableSchool(
                                      text1: kEclassCount,
                                      text2: tempSearchStore[index]['lday']==DateTime.now().day && tempSearchStore[index]['lmth']==DateTime.now().month && tempSearchStore[index]['lyr']==DateTime.now().year ?tempSearchStore[index]['ld'].toString():'0',
                                      text3: tempSearchStore[index]['lwky']==Jiffy().week && tempSearchStore[index]['lyr'] == DateTime.now().year?tempSearchStore[index]['lw'].toString():'0',
                                      text4: tempSearchStore[index]['lmth']==DateTime.now().month && tempSearchStore[index]['lyr']==DateTime.now().year ?tempSearchStore[index]['lm'].toString():'0',
                                      text5: tempSearchStore[index]['lyr']==DateTime.now().year ?tempSearchStore[index]['ly'].toString():'0',

                                      text6: kRecordedCount,
                                      text7: tempSearchStore[index]['uday']==DateTime.now().day && tempSearchStore[index]['umth']==DateTime.now().month && tempSearchStore[index]['uyr']==DateTime.now().year?tempSearchStore[index]['ud'].toString():'0',
                                      text8: tempSearchStore[index]['uwky']==Jiffy().week && tempSearchStore[index]['uyr'] == DateTime.now().year?tempSearchStore[index]['uw'].toString():'0',
                                      text9: tempSearchStore[index]['umth']==DateTime.now().month && tempSearchStore[index]['uyr']==DateTime.now().year ?tempSearchStore[index]['um'].toString():'0',
                                      text10: tempSearchStore[index]['uyr']==DateTime.now().year?tempSearchStore[index]['uy'].toString():'0',

                                      text11: kExtraCount,
                                      text12: tempSearchStore[index]['eday']==DateTime.now().day && tempSearchStore[index]['emth']==DateTime.now().month && tempSearchStore[index]['eyr']==DateTime.now().year ?tempSearchStore[index]['ed'].toString():'0',
                                      text13: tempSearchStore[index]['ewky']==Jiffy().week && tempSearchStore[index]['eyr'] == DateTime.now().year?tempSearchStore[index]['ew'].toString():'0',
                                      text14: tempSearchStore[index]['emth']==DateTime.now().month && tempSearchStore[index]['eyr']==DateTime.now().year ?tempSearchStore[index]['em'].toString():'0',
                                      text15: tempSearchStore[index]['eyr']==DateTime.now().year?tempSearchStore[index]['ey'].toString():'0',

                                      text16: kResultCount,
                                      text17: tempSearchStore[index]['rday']==DateTime.now().day && tempSearchStore[index]['rmth']==DateTime.now().month && tempSearchStore[index]['ryr']==DateTime.now().year ?tempSearchStore[index]['rd'].toString():'0',
                                      text18:  tempSearchStore[index]['rwky']==Jiffy().week && tempSearchStore[index]['ryr'] == DateTime.now().year?tempSearchStore[index]['rw'].toString():'0',
                                      text19: tempSearchStore[index]['rmth']==DateTime.now().month && tempSearchStore[index]['ryr']==DateTime.now().year?tempSearchStore[index]['rm'].toString():'0',
                                      text20: tempSearchStore[index]['ryr']==DateTime.now().year?tempSearchStore[index]['ry'].toString():'0',

                                      text21: kAssessmentCount,
                                      text22: tempSearchStore[index]['aday']==DateTime.now().day && tempSearchStore[index]['amth']==DateTime.now().month && tempSearchStore[index]['ayr']==DateTime.now().year ?tempSearchStore[index]['ad'].toString():'0',
                                      text23: tempSearchStore[index]['awky']==Jiffy().week && tempSearchStore[index]['ayr'] == DateTime.now().year?tempSearchStore[index]['aw'].toString():'0',
                                      text24: tempSearchStore[index]['amth']==DateTime.now().month && tempSearchStore[index]['ayr']==DateTime.now().year?tempSearchStore[index]['am'].toString():'0',
                                      text25: tempSearchStore[index]['ayr']==DateTime.now().year?tempSearchStore[index]['ay'].toString():'0',
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RaisedButton(onPressed: (){
                                          _deleteTeacher(tempSearchStore[index]);
                                        },
                                          color: kRed,
                                          child: Text('Remove',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kWhitecolor,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),

                                          ),
                                        ),

                                        RaisedButton(onPressed: (){
                                          _editTeacher(tempSearchStore[index]);
                                        },
                                          color: kWhitecolor,
                                          child: Text('Edit',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kFbColor,
                                                fontSize: kFontsize.sp,
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

                        })])
              )])
    ));
  }


  void _deleteTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //remove Admin
    try{

      FirebaseFirestore.instance.collection('teachers').doc(data['schId']).collection('schoolTeachers').doc(data['id'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeTeacher(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try{

      FirebaseFirestore.instance.collection('teachers').doc(data['schId']).collection('schoolTeachers').doc(data['id'])
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

      FirebaseFirestore.instance.collection('teachers').doc(data['schId']).collection('schoolTeachers').doc(data['id'])
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
            child: EditTeachers(doc:doc)));
//edit students profile here



  }
}

