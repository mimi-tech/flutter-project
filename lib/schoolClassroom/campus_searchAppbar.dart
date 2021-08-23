import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_student_search.dart';
import 'package:sparks/schoolClassroom/CampusSchool/campus_tutors_search.dart';

class CampusSearchAppBar extends StatefulWidget implements PreferredSizeWidget{
  CampusSearchAppBar({required this.filter});
  final Widget filter;
  @override
  _CampusSearchAppBarState createState() => _CampusSearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _CampusSearchAppBarState extends State<CampusSearchAppBar> {
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
         floating:true,
           pinned:false,
      automaticallyImplyLeading: false,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusTutorSearchStream()));

            },
            child: Row(

              children: <Widget>[
                IconButton(icon: (Icon(Icons.search)), onPressed: (){}, color: kHintColor),
                Text(kSearchBar,
                  style: GoogleFonts.rajdhani(
                      fontSize: kFontSize14.sp,
                      fontWeight: FontWeight.w500,
                      color: kHintColor

                  ),),

              ],
            ),
          ),



            PopupMenuButton(

              child: Icon(Icons.more_vert,color: kHintColor,),
              //ToDo:getting the popMenuButton items
              itemBuilder: (
                  context) =>
              [
              //ToDo:Edit details
              PopupMenuItem(
            child:widget.filter,
            ),
            ])


          //ShowAllSilverAppBar(),
        ],
      ),
      backgroundColor: kWhitecolor,

    );



  }
}




class CampusStudentSearchAppBar extends StatefulWidget implements PreferredSizeWidget{
  CampusStudentSearchAppBar({required this.filter,required this.click});
  final Widget filter;
  final Function click;
  @override
  _CampusStudentSearchAppBarState createState() => _CampusStudentSearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _CampusStudentSearchAppBarState extends State<CampusStudentSearchAppBar> {
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(

      automaticallyImplyLeading: false,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(

              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kExpertColor,width: 2.0)
              ),

              child: IconButton(icon: Icon(Icons.add,color: kExpertColor,size: 20,), onPressed:widget.click as void Function()?)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CampusStudentSearchStream()));

            },
            child: Row(

              children: <Widget>[
                Icon(Icons.search,color: kHintColor,),
                Text(kSearchBar,
                  style: GoogleFonts.rajdhani(
                      fontSize: kFontSize14.sp,
                      fontWeight: FontWeight.w500,
                      color: kHintColor

                  ),),

              ],
            ),
          ),



          PopupMenuButton(

              child: Icon(Icons.more_vert,color: kHintColor,),
              //ToDo:getting the popMenuButton items
              itemBuilder: (
                  context) =>
              [
                //ToDo:Edit details
                PopupMenuItem(
                  child:widget.filter,
                ),
              ])


          //ShowAllSilverAppBar(),
        ],
      ),
      backgroundColor: kWhitecolor,
      floating: true,
      pinned: false,
    );



  }
}

class SearchNonCampusStudents extends StatefulWidget implements PreferredSizeWidget{
  SearchNonCampusStudents({required this.filter,required this.click,required this.clickSearch});
  final String filter;
  final Function click;
  final Function clickSearch;
  @override
  _SearchNonCampusStudentsState createState() => _SearchNonCampusStudentsState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SearchNonCampusStudentsState extends State<SearchNonCampusStudents> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: kWhitecolor,
        floating: true,
        pinned: false,
        automaticallyImplyLeading: false,

        title: GestureDetector(
          onTap: widget.clickSearch as void Function()?,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: <Widget>[
                    IconButton(icon: (Icon(Icons.search)), onPressed: (){}, color: kHintColor),
                    Text(widget.filter,
                      style: GoogleFonts.rajdhani(
                          fontSize: kFontSize14.sp,
                          fontWeight: FontWeight.w500,
                          color: kHintColor

                      ),),

                  ],
                ),


                Container(

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kExpertColor,width: 2.0)

                    ),
                    child: IconButton(icon: Icon(Icons.add,color: kExpertColor,size: 20,), onPressed:widget.click as void Function()?)),


              ]),
        )
    );
  }
}




class SearchNonCampusTutors extends StatefulWidget implements PreferredSizeWidget{
  SearchNonCampusTutors({required this.filter,required this.clickSearch});
  final String filter;
  final Function clickSearch;
  @override
  _SearchNonCampusTutorsState createState() => _SearchNonCampusTutorsState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SearchNonCampusTutorsState extends State<SearchNonCampusTutors> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: kWhitecolor,
        floating: true,
        pinned: false,
        automaticallyImplyLeading: false,

        title: GestureDetector(
          onTap: widget.clickSearch as void Function()?,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(icon: (Icon(Icons.search)), onPressed: (){}, color: kHintColor),
                Text(widget.filter,
                  style: GoogleFonts.rajdhani(
                      fontSize: kFontSize14.sp,
                      fontWeight: FontWeight.w500,
                      color: kHintColor

                  ),),



              ]),
        )
    );
  }
}

