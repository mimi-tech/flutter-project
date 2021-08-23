import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

import 'package:sparks/social/socialCourse/search_stream.dart';
class SocialSearchAppBar extends StatefulWidget implements PreferredSizeWidget{

  @override
  _SocialSearchAppBarState createState() => _SocialSearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SocialSearchAppBarState extends State<SocialSearchAppBar> {
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(

      automaticallyImplyLeading: false,
      expandedHeight: 50,
      collapsedHeight: 80,
      title: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStream()));

            },
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,

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
          //ShowAllSilverAppBar(),
        ],
      ),
      backgroundColor: kBlackcolor,
      floating: true,
      pinned: true,
    );



  }
}


class SeeAllSearchAppBar extends StatefulWidget implements PreferredSizeWidget{

  @override
  _SeeAllSearchAppBarState createState() => _SeeAllSearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}

class _SeeAllSearchAppBarState extends State<SeeAllSearchAppBar> {
  @override
  Widget build(BuildContext context) {

    return SliverAppBar(

      automaticallyImplyLeading: false,
      //expandedHeight: 60,
      collapsedHeight: 80,
      title: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SearchStream()));

            },
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                IconButton(icon: (Icon(Icons.search,color: kBlackcolor,)), onPressed: (){}, color: kHintColor),
                Text(kSearchBar,
                  style: GoogleFonts.rajdhani(
                      fontSize: kFontSize14.sp,
                      fontWeight: FontWeight.w500,
                      color: kBlackcolor

                  ),)
              ],
            ),
          ),

        ],
      ),
      backgroundColor: kWhitecolor,
      floating: true,
      snap: true,
      pinned: false,
    );



  }
}



class TabsSearch extends StatefulWidget implements PreferredSizeWidget{
  TabsSearch({required this.title,required this.tapFunction});
  final String title;
  final Function tapFunction;

  @override
  _TabsSearchState createState() => _TabsSearchState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);

}


class _TabsSearchState extends State<TabsSearch> {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor:kBlackcolor,
      automaticallyImplyLeading: false,
      expandedHeight: 60,
      collapsedHeight: 80,

      title: GestureDetector(
        onTap:widget.tapFunction as void Function(),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            IconButton(icon: (Icon(Icons.search,color: kHintColor,)), onPressed: (){}, color: kHintColor),
            Text(widget.title,
              style: GoogleFonts.rajdhani(
                  fontSize: kFontSize14.sp,
                  fontWeight: FontWeight.w500,
                  color: kHintColor

              ),)
          ],
        ),
      ),
      floating: true,
      snap: true,
      pinned: false,
    );
  }
}


