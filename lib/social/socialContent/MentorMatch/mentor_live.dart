import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';


import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/social/socialConstants/SocialSlivers/mentors_appbar.dart';

import 'package:sparks/social/socialConstants/SocialSlivers/tutors_appbar.dart';
import 'package:sparks/social/socialConstants/searchAppbar.dart';
import 'package:sparks/social/socialConstants/second_appbar.dart';

import 'package:sparks/social/socialConstants/topAppbar.dart';

import 'package:sparks/social/users_match.dart';


class SocialMentorMatchLive extends StatefulWidget {
  @override
  _SocialMentorMatchLiveState createState() => _SocialMentorMatchLiveState();
}

class _SocialMentorMatchLiveState extends State<SocialMentorMatchLive> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusColor();
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });
  }
  void getStatusColor(){
    setState(() {
      //changing the status bar color
      stColor = kBlackcolor;
    });
  }

  double radius = 0.0;
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.03,
    );
  }


  String? filter;


  @override
  Widget build(BuildContext context) {


    return SafeArea(child: Scaffold(
        backgroundColor: kBlackcolor,

        body:CustomScrollView(slivers: <Widget>[
          SocialTopAppBar(search: (){},),
          SocialSilverAppBar(
            matches: kMaincolor,
            friends: kFbColor,
            classroom: kMaincolor,
            content: kMaincolor,


          ),
          SocialSearchAppBar(),
          NewUsersMatch(),

          SocialMentorSilverAppBar(
            all: klistnmber,
            matches: klistnmber,
            friends: klistnmber,
            classroom: klistnmber,
            content: kFbColor,
          ),


          SliverList(
              delegate: SliverChildListDelegate([


                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: kWhitecolor,
                    //borderRadius:  BorderRadius.only(topRight: Radius.circular(15.0),topLeft: Radius.circular(radius),

                  ),
                )

              ])

          )
        ])
    )
    );
  }


}


