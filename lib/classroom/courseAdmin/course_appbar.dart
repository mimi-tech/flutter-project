import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class CourseAdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  CourseAdminAppBar({this.search});
  final Function? search;
  @override
  _CourseAdminAppBarState createState() => _CourseAdminAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _CourseAdminAppBarState extends State<CourseAdminAppBar> {
  bool checkSearch = true;
  //ToDo:Appbar title
  Icon actionIcon = Icon(Icons.search);
  Widget appBarTitle =
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
    GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 32,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: CourseAdminConstants.adminData[0]['pimg'].toString(),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            width: 40.0,
            height: 40.0,
          ),
        ),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('images/classroom/hamburger.svg'),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 10.0,
      backgroundColor: kplaylistappbar,
      title: checkSearch
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  GestureDetector(
                    child: ProfilePicture(),
                  ),
                  GestureDetector(
                      child: SvgPicture.asset(
                    "images/friends_notification.svg",
                  )),
                  //ToDo:notifications
                  /* Text(CourseAdminConstants.showLoginTime,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: KLightermaincolor,
                  fontSize: kFontsize.sp,
                ),
              ),
            ),*/

                  GestureDetector(
                      onTap: () {
                        setState(() {
                          checkSearch = false;
                        });
                      },
                      child: Icon(Icons.search))
                ])
          : Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
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
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      checkSearch = true;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
