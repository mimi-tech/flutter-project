import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/schoolClassroom/utils/add_screen.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
            length: 3,
            child: Scaffold(
            appBar: AppBar(
            backgroundColor: kSappbarbacground,

            bottom: TabBar(
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Creates border
                  color: kSelectbtncolor),
              labelStyle: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kWhitecolor,
                  fontSize:kFontsize.sp,
                ),),
              unselectedLabelColor: kWhitecolor,
              tabs: [
                   Tab( text: "Schools".toUpperCase()),
                   Tab( text: "Alumni".toUpperCase()),
                   Tab( text: "Admin".toUpperCase()),


                       ],
                   ),
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 32,
          child: ClipOval(
            child: CachedNetworkImage(

              imageUrl: GlobalVariables.loggedInUserObject.pimg.toString(),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: 40.0,
              height: 40.0,

            ),
          ),
        ),

            SvgPicture.asset('images/classroom/search.svg'),

            SvgPicture.asset("images/jobs/bell.svg",),

            SvgPicture.asset("images/classroom/messenger_icon.svg")
          ],
        )


        ),
        body: TabBarView(
        children: [
          AddSchoolScreen(),
          AddSchoolScreen(),
          AddSchoolScreen(),
          ]

            ))),
      ),
    );



  }
}
