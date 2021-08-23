
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/newsBoardAppbar.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_bottombar.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';


class TeachersAnnouncement extends StatefulWidget {
  @override
  _TeachersAnnouncementState createState() => _TeachersAnnouncementState();
}

class _TeachersAnnouncementState extends State<TeachersAnnouncement> {
  var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];


  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;
  String? title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnnouncement();
  }

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      appBar: StuAppBar(),
      body:CustomScrollView(slivers: <Widget>[
        ActivityAppBer(
          activitiesColor: kTextColor,
          classColor: kTextColor,
          newsColor: kStabcolor1,
        ),
        NewsBoardAppBar(
          extraLessonsBgColor: Colors.transparent,
          extraLessonsColor: klistnmber,
          chatBgColor: Colors.transparent,
          chatColor: klistnmber,
          newsBgColor: klistnmber,
          newsColor: kWhitecolor,

          reportBgColor: Colors.transparent,
          reportColor: klistnmber,
        ),
        SliverList(
            delegate: SliverChildListDelegate([


                  itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                  itemsData.length == 0 && progress == true ?
                  Center(
                    child: Text('No announcement'.toUpperCase(),

                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: klistnmber,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  )
                      :
                  space(),

                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _documents.length,
                      itemBuilder: (context, int index) {


                        return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width:MediaQuery.of(context).size.width,
                            child: Card(
                                elevation:5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text('Message',

                                        style: GoogleFonts.rajdhani(
                                          decoration: TextDecoration.underline,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: klistnmber,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width,
                                            minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),),

                                          child: ReadMoreText(itemsData[index]['msg'],
                                            //doc.data['desc'],
                                            trimLines: 2,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' .. ^',
                                            trimExpandedText: ' ^',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kFbColor,
                                                fontSize: kFontsize.sp,
                                              ),

                                            ),
                                          ),
                                        ),),
                                      Text('Date',

                                        style: GoogleFonts.rajdhani(
                                          decoration: TextDecoration.underline,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: klistnmber,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),
                                      Text(DateFormat().format(DateTime.parse(itemsData[index]['ts'])),

                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: klistnmber,
                                            fontSize: kFontSize14.sp,
                                          ),
                                        ),
                                      ),
                                      Text('By',

                                        style: GoogleFonts.rajdhani(
                                          decoration: TextDecoration.underline,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: klistnmber,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),

                                      Text('${itemsData[index]['fn']} ${itemsData[index]['ln']}',

                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kExpertColor,
                                            fontSize: kFontsize.sp,
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                )
                            ));
                      }

                  ),

                  progress == true || _loadMoreProgress == true
                      || _documents.length < SchClassConstant.streamCount
                      ?Text(''):
                  moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                      onTap: (){loadMore();},
                      child: SvgPicture.asset('images/classroom/load_more.svg',))

                ]),

          ),
        ])
    ));
  }

  Future<void> getAnnouncement() async {
    _documents.clear();
    itemsData.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("schoolAnnouncement").doc(SchClassConstant.schDoc['schId']).collection('announcement')

        .orderBy('ts',descending: true)
        .limit(SchClassConstant.streamCount)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());


        });



      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("schoolAnnouncement").doc(SchClassConstant.schDoc['schId']).collection('announcement')

        .orderBy('ts',descending: true).

    startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;


        });
      }
    }
  }


}
