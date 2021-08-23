import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sparks/schoolClassroom/CampusSchool/edit_tutors.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/CampusSchool/schoolAnalysis/schoolTeachersAnalysis.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/utils/analysisText.dart';


class CampusTutorSearchStream extends StatefulWidget {
  @override
  _CampusTutorSearchStreamState createState() => _CampusTutorSearchStreamState();
}

class _CampusTutorSearchStreamState extends State<CampusTutorSearchStream> {
  List<DocumentSnapshot> queryResultSet = <DocumentSnapshot> [];
  List<DocumentSnapshot> tempSearchStore = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  late List <dynamic> aoi;
  late List <dynamic> spec;
  late List <dynamic> hobby;
  late List <dynamic> lang;
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

      SchClassConstant().searchByTutorName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i]);
        }
      });
    } else {


      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['tc'].startsWith(capitalizedValue)) {

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
              fontSize: kFontsize.sp,
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
                        hintText: 'Search by name',
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


                          return  Card(
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


                                    tempSearchStore[index]['ass']== true?
                                    BtnThird(next: (){_removeTeacher(tempSearchStore[index]);}, title: 'Denied', bgColor: kAGreen)

                                        :BtnThird(next: (){_acceptTeacher(tempSearchStore[index]);}, title: 'Accept', bgColor: kFbColor),


                                    Divider(),


                                    space(),
                                    ShowRichText(color:kSwitchoffColors,title: 'Pin: ',titleText: tempSearchStore[index]['pin'].toString()),


                                    space(),

                                    ShowRichText(color:kIconColor,title: 'Tutor Level: ',titleText: tempSearchStore[index]['lv']),


                                    space(),
                                    ShowRichText(color:kIconColor,title: 'Tutor course: ',titleText: tempSearchStore[index]['curs']),

                                    space(),
                                    ShowRichText(color:kIconColor,title: 'Added: ',titleText: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(tempSearchStore[index]['ts']))} : ${DateFormat('h:m:a').format(DateTime.parse(tempSearchStore[index]['ts']))}'),



                                    space(),
                                    ShowRichText(color:kIconColor,title: 'By: ',titleText: tempSearchStore[index]['by']),

                                    space(),
                                    Divider(),



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
                                                    channelName:tempSearchStore[index]['id'],
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
                                    space(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnalysisTextSchool(title: kTeachersAnalysis,),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolTeachersAnalysis(doc:tempSearchStore[index])));

                                          },
                                          child: Text('View details',
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
                                      text2: tempSearchStore[index]['ld']==null?'0':tempSearchStore[index]['ld'].toString(),
                                      text3: tempSearchStore[index]['lw']==null?'0':tempSearchStore[index]['lw'].toString(),
                                      text4: tempSearchStore[index]['lm']==null?'0':tempSearchStore[index]['lm'].toString(),
                                      text5: tempSearchStore[index]['ly']==null?'0':tempSearchStore[index]['ly'].toString(),

                                      text6: kRecordedCount,
                                      text7: tempSearchStore[index]['ud']==null?'0':tempSearchStore[index]['ud'].toString(),
                                      text8: tempSearchStore[index]['uw']==null?'0':tempSearchStore[index]['uw'].toString(),
                                      text9: tempSearchStore[index]['um']==null?'0':tempSearchStore[index]['um'].toString(),
                                      text10: tempSearchStore[index]['uy']==null?'0':tempSearchStore[index]['uy'].toString(),

                                      text11: kExtraCount,
                                      text12: tempSearchStore[index]['ed']==null?'0':tempSearchStore[index]['ed'].toString(),
                                      text13: tempSearchStore[index]['ew']==null?'0':tempSearchStore[index]['ew'].toString(),
                                      text14: tempSearchStore[index]['em']==null?'0':tempSearchStore[index]['em'].toString(),
                                      text15: tempSearchStore[index]['ey']==null?'0':tempSearchStore[index]['ey'].toString(),

                                      text16: kResultCount,
                                      text17: tempSearchStore[index]['rd']==null?'0':tempSearchStore[index]['rd'].toString(),
                                      text18: tempSearchStore[index]['rw']==null?'0':tempSearchStore[index]['rw'].toString(),
                                      text19: tempSearchStore[index]['rm']==null?'0':tempSearchStore[index]['rm'].toString(),
                                      text20: tempSearchStore[index]['ry']==null?'0':tempSearchStore[index]['ry'].toString(),

                                      text21: kAssessmentCount,
                                      text22: tempSearchStore[index]['ad']==null?'0':tempSearchStore[index]['ad'].toString(),
                                      text23: tempSearchStore[index]['aw']==null?'0':tempSearchStore[index]['aw'].toString(),
                                      text24: tempSearchStore[index]['am']==null?'0':tempSearchStore[index]['am'].toString(),
                                      text25: tempSearchStore[index]['ay']==null?'0':tempSearchStore[index]['ay'].toString(),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        BtnThird(next: (){ _deleteTeacher(tempSearchStore[index]);}, title: 'Remove', bgColor: kRed),

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
    //remove Admin
    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(doc['schId']).collection('tutors').doc(doc['id'])

          .delete();

    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _removeTeacher(DocumentSnapshot doc) {
    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(doc['schId']).collection('tutors').doc(doc['id'])
          .update({
        'ass':false,
      });
    }catch(e){
      SchClassConstant.displayToastError(title: kError);
    }
  }

  void _acceptTeacher(DocumentSnapshot doc) {
    try{

      FirebaseFirestore.instance.collection('schoolTutors').doc(doc['schId']).collection('tutors').doc(doc['id'])
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

}

