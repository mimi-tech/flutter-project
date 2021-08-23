import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_onwer_company_analysis/owner_daily.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/expertAdmin/expert_admin_constants.dart';
import 'package:sparks/classroom/expertAdmin/expert_staff_analysis.dart';

class ExpertAdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  ExpertAdminAppBar({this.search});
  final Function? search;
  @override
  _ExpertAdminAppBarState createState() => _ExpertAdminAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _ExpertAdminAppBarState extends State<ExpertAdminAppBar> {
  //ToDo:Appbar title
  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle =
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
    GestureDetector(
      child: ProfilePicture(),
    ),
    GestureDetector(
        child: SvgPicture.asset(
      "images/friends_notification.svg",
    )),
    Text(
      ExpertAdminConstants.userData[0]['name'],
      style: GoogleFonts.rajdhani(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: KLightermaincolor,
          fontSize: kFontsize.sp,
        ),
      ),
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10.0,
      backgroundColor: kplaylistappbar,
      title: appBarTitle,
      actions: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = Icon(Icons.close);
                      this.appBarTitle = TextFormField(
                          onChanged: (String value) {
                            UploadVariables.searchText = value;
                          },
                          controller: UploadVariables.searchController,
                          cursorColor: kMaincolor,
                          autofocus: true,
                          style: TextStyle(color: kSearchTextcolor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: kWhitecolor),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kWhitecolor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kMaincolor),
                            ),
                          ));
                    } else {
                      this.actionIcon = Icon(Icons.search);
                      this.appBarTitle = Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: ProfilePicture(),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          OnwerCompanyDailyAnalysis()));
                                  /* if((ExpertAdminConstants.userData[0]['uid'] ) == ExpertAdminConstants.currentUser){
                                    AnalysisConstants.docId = ExpertAdminConstants.userData[0]['id'];

                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => OnwerCompanyDailyAnalysis()));
                                  }else {

                                     Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => ExpertStaffAnalysis()));

                                  }*/
                                },
                                child: SvgPicture.asset(
                                  "images/friends_notification.svg",
                                )),
                            Text(
                              ExpertAdminConstants.userData[0]['name'],
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: KLightermaincolor,
                                  fontSize: kFontsize.sp,
                                ),
                              ),
                            )
                          ]);
                    }
                  });
                }),
          ],
        ),
      ],
    );
  }
}
