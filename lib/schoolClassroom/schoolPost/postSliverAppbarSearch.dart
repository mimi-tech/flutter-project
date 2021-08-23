import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/VirtualClass/attendedClasses.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/VirtualClass/indexpage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/teachersAttendedClass.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/createSchPost.dart';
import 'package:sparks/schoolClassroom/schoolPost/searchStudentsPost.dart';

class PostSliverAppBarSearch extends StatefulWidget with PreferredSizeWidget{


  @override
  _PostSliverAppBarSearchState createState() => _PostSliverAppBarSearchState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _PostSliverAppBarSearchState extends State<PostSliverAppBarSearch> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kWhitecolor,
      automaticallyImplyLeading: false,
      snap: true,
      floating: true,
      pinned: false,
      forceElevated: false,
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         GestureDetector(
             onTap: (){
               Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStudentsPost()));

             },
             child: SvgPicture.asset('images/classroom/search.svg',color: kBlackcolor,)),


          SchClassConstant.isUniStudent?  TextButton.icon(
            icon: SvgPicture.asset('images/classroom/edit_add.svg'),
            label: Text('Create post',
              style: GoogleFonts.rajdhani(
                fontSize:kFontsize.sp,
                fontWeight: FontWeight.bold,
                color: klistnmber,
              ),

            ),
            onPressed: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateSchoolPost()));
            },
          ):Text(''),

          SvgPicture.asset('images/classroom/messenger_icon.svg'),

        ],
      ),
    );
  }
}



class EClassSliverAppBarSearch extends StatefulWidget with PreferredSizeWidget{
  EClassSliverAppBarSearch({
    required this.searchTap,
    required this.scheduledClassColor,
    required this.attendedColor,
    required this.scheduleColor,

  });
  final Function searchTap;
  final Color scheduledClassColor;
  final Color attendedColor;
  final Color scheduleColor;

  @override
  _EClassSliverAppBarSearchState createState() => _EClassSliverAppBarSearchState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _EClassSliverAppBarSearchState extends State<EClassSliverAppBarSearch> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kWhitecolor,
      automaticallyImplyLeading: false,

      //floating: true,
      pinned: true,
      forceElevated: false,
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          IconButton(icon: (Icon(Icons.school_outlined,color: widget.scheduledClassColor,size: 25,)), onPressed: (){
            Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: StudentsEClasses()));

          }),
          IconButton(icon: (Icon(Icons.book_online,color: widget.attendedColor,size: 25,)), onPressed: (){

            if(SchClassConstant.isStudent){
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: AttendedEClass()));

            }else{
              Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: TeachersAttendedEClass()));
            }

          }),
          IconButton(icon: (Icon(Icons.schedule,color: widget.scheduleColor,size: 25,)), onPressed: (){
            Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: IndexPage()));

          }),

          GestureDetector(
              onTap: widget.searchTap as void Function()?,
              child: SvgPicture.asset('images/classroom/search.svg',color: kBlackcolor,)),



          /* SchClassConstant.isStudent?Text(''):TextButton.icon(onPressed: (){
            Navigator.push (context, PageTransition (type: PageTransitionType.fade, child: IndexPage()));
          }, icon:  Icon(Icons.schedule), label:
          Text('Schedule A Class',
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
                fontSize: kFontsize.sp,
              ),
            ),

          ),

          ),*/

          SvgPicture.asset('images/classroom/messenger_icon.svg'),

        ],
      ),
    );
  }
}



class EClassSliverAppBarSearchSecond extends StatefulWidget with PreferredSizeWidget{
  EClassSliverAppBarSearchSecond({required this.searchTap});
  final Function searchTap;

  @override
  _EClassSliverAppBarSearchSecondState createState() => _EClassSliverAppBarSearchSecondState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _EClassSliverAppBarSearchSecondState extends State<EClassSliverAppBarSearchSecond> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kWhitecolor,
      automaticallyImplyLeading: false,

      floating: true,
      pinned: false,
      forceElevated: false,
      shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
          )
      ),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: widget.searchTap as void Function()?,
              child: SvgPicture.asset('images/classroom/search.svg',color: kBlackcolor,)),


          SvgPicture.asset('images/classroom/messenger_icon.svg'),

        ],
      ),
    );
  }
}
