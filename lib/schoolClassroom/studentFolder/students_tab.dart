import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/CampusSchool/faculty_screen.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/All_studies.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/create_dept.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/school_announcement.dart';

import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/chat/chat_screen.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/campusPosts.dart';
import 'package:sparks/schoolClassroom/schoolPost/classmatePost/classMatePost.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/schoolPost/schoolProfile.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/TeachersNewsTab.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_announcement.dart';
import 'package:sparks/schoolClassroom/studentFolder/stdent_announcement.dart';
import 'package:sparks/schoolClassroom/utils/profilPix.dart';
import 'file:///C:/Users/Home/AndroidStudioProjects/sparks_universe/lib/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/utils/schoolPostConst.dart';

class StudentsTab extends StatefulWidget {
  @override
  _StudentsTabState createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSappbarbacground,
          bottom: TabBar(
            /*tabs: [
              Tab( text: "Studies"),
              Tab( text: "Social"),
              Tab( text: "Chat"),
              Tab( text: "Records"),
              Tab( text: "Live"),

            ],*/
           indicatorColor: kWhitecolor,
            indicatorWeight: 4.0,

            labelStyle: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kStabcolor1,
                fontSize:kFontsize.sp,
              ),),
            unselectedLabelColor: kTextColor,

            tabs: [
              Tab( text: "Activities"),
              Tab( text: "E-class"),
              Tab( text: "Newsboard"),


            ],
          ),
          title: RichText(
            text: TextSpan(
                text:
                    '${SchClassConstant.schDoc['sN'].toString().toUpperCase()} \n',
                style: GoogleFonts.rajdhani(
fontSize:16.sp,fontWeight: FontWeight.w700,
                  color: kWhitecolor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,
                      fontWeight: FontWeight.normal,
                      color: kStabcolor1,
                    ),
                  ),
                  SchClassConstant.isUniStudent?
                  TextSpan(text: ': ${SchClassConstant.schDoc['lv']} \n ${SchClassConstant.schDoc['fac']} ${SchClassConstant.schDoc['dept']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,
                      fontWeight: FontWeight.normal,
                      color: kMaincolor,
                    ),

                  )
                      : TextSpan(text: ': ${SchClassConstant.schDoc['lv']} ${SchClassConstant.schDoc['cl']}',
                    style: GoogleFonts.rajdhani(
                      fontSize:16.sp,

                      fontWeight: FontWeight.normal,
                      color: kMaincolor,
                    ),
                  ),
                ]),
          ),
        ),
        body: TabBarView(

          children: [
           /* StudentLessons(),
            StudentSocial(),
            ChatScreen(),
            StudentAnnouncement(),
            StudentsEClasses()*/
            CampusPostScreen(),
            StudentsEClasses(),

            ChatScreen(),


          ],
        ),
      ),
    );
  }
}



class StuAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _StuAppBarState createState() => _StuAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _StuAppBarState extends State<StuAppBar> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: kplaylistappbar,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SchClassConstant.isTeacher?

      Flexible(
      child: RichText(
      text: TextSpan(
      text:'${SchClassConstant.schDoc['name'].toString().toUpperCase()} \n',
        style: GoogleFonts.rajdhani(
          fontSize:16.sp,
          fontWeight: FontWeight.w700,
          color: kWhitecolor,
        ),

        children: <TextSpan>[
          TextSpan(text: '${SchClassConstant.schDoc['tc']}'.toUpperCase(),
            style: GoogleFonts.rajdhani(
              fontSize:16.sp,
              fontWeight: FontWeight.normal,
              color: kStabcolor1,
            ),

          ),


        ]
    ),
    ),
    )
              :Flexible(
            child: RichText(
              text: TextSpan(
                  text:SchClassConstant.isProprietor?'${SchClassConstant.schDoc['name'].toString().toUpperCase()}\n':'${SchClassConstant.schDoc['sN'].toString().toUpperCase()} \n',
                  style: GoogleFonts.rajdhani(
  fontSize:16.sp,fontWeight: FontWeight.w700,
                    color: kWhitecolor,
                  ),

                  children: <TextSpan>[
                    TextSpan(text: '${SchClassConstant.schDoc['str']}'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        fontSize:16.sp,
                        fontWeight: FontWeight.normal,
                        color: kStabcolor1,
                      ),

                    ),


                  ]
              ),
            ),
          ),

          GestureDetector(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolProfile()));

              },
              child: ProfilePix(pix: SchClassConstant.schDoc['logo']))
        ],
      ),

    );
  }
}



class ActivityAppBer extends StatefulWidget with PreferredSizeWidget{
  ActivityAppBer({
    required this.activitiesColor,
    required this.classColor,
    required this.newsColor,

  });
  final Color activitiesColor;
  final Color classColor;
  final Color newsColor;

  @override
  _ActivityAppBerState createState() => _ActivityAppBerState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _ActivityAppBerState extends State<ActivityAppBer> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: kSappbarbacground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusPostScreen()));

          },
          child: Text('Activities',
          style: GoogleFonts.rajdhani(
            fontSize:kFontsize.sp,
            fontWeight: FontWeight.bold,
            color: widget.activitiesColor,
          ),),
        ),

          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentsEClasses()));

            },
            child: Text('E-class',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.classColor,
              ),),
          ),
          GestureDetector(
            onTap: (){
              if(SchClassConstant.isTeacher){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TeachersAnnouncement()));

              }else{

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StudentAnnouncement()));

            }},
            child: Text('Newsboard',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.newsColor,
              ),),
          )


        ],
      ),
    );
  }
}





class ProprietorActivityAppBar extends StatefulWidget with PreferredSizeWidget{
  ProprietorActivityAppBar({
    required this.activitiesColor,
    required this.classColor,
    required this.newsColor,
    required this.studiesColor,

  });
  final Color activitiesColor;
  final Color classColor;
  final Color newsColor;
  final Color studiesColor;

  @override
  _ProprietorActivityAppBarState createState() => _ProprietorActivityAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _ProprietorActivityAppBarState extends State<ProprietorActivityAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(

      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: kSappbarbacground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusPostScreen()));

            },
            child: Text('Activities',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.activitiesColor,
              ),),
          ),

          GestureDetector(
            onTap: (){
              if(SchClassConstant.isCampusProprietor){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: FacultyScreen()));

            }else{
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateDepartment()));

              }

              },
            child: Text(SchClassConstant.isCampusProprietor?'Admin':'Sections',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.classColor,
              ),),
          ),
          GestureDetector(
            onTap: (){

                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SchoolAnnouncement()));

           },
            child: Text('Newsboard',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.newsColor,
              ),),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AdminStudies()));

              },
            child: Text('Studies',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: widget.studiesColor,
              ),),
          )
        ],
      ),
    );
  }
}
