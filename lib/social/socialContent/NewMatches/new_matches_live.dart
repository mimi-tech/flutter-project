import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';


import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';

import 'package:sparks/social/socialConstants/searchAppbar.dart';
import 'package:sparks/social/socialConstants/second_appbar.dart';

import 'package:sparks/social/socialConstants/SocialSlivers/new_appbar.dart';
import 'package:sparks/social/socialConstants/topAppbar.dart';

import 'package:sparks/social/users_match.dart';


class SocialNewMatchesLive extends StatefulWidget {
  static String id = "MentorsHub";
  @override
  _SocialNewMatchesLiveState createState() => _SocialNewMatchesLiveState();
}

class _SocialNewMatchesLiveState extends State<SocialNewMatchesLive> {


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
      height: MediaQuery.of(context).size.height * kSocialWidgetHeight,
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
              matches: kFbColor,
              friends: kMaincolor,
              classroom: kMaincolor,
              content: kMaincolor),

          SocialSearchAppBar(),
          NewUsersMatch(),
          SocialThirdSilverAppBar(
            all:klistnmber,
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


