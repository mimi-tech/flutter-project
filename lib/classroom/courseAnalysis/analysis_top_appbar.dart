import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/profilepicture.dart';
import 'package:sparks/classroom/courseAdmin/course_admin_constants.dart';
import 'package:sparks/classroom/courseAnalysis/analysis_constants.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class AnalysisAppBar extends StatefulWidget implements PreferredSizeWidget {
  AnalysisAppBar({this.search});
  final Function? search;
  @override
  _AnalysisAppBarState createState() => _AnalysisAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _AnalysisAppBarState extends State<AnalysisAppBar> {
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
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AnalysisConstants.companyName == null ||
                        AnalysisConstants.companyName == ''
                    ? 'Sparks Universe'.toUpperCase()
                    : AnalysisConstants.companyName!.toUpperCase(),
                style: GoogleFonts.rajdhani(
                  fontSize: 22.sp,
                  color: kMaincolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ProfilePicture(),
            ]));
  }
}

class ViewAppbar extends StatefulWidget implements PreferredSizeWidget {
  ViewAppbar({required this.title});
  final String title;
  @override
  _ViewAppbarState createState() => _ViewAppbarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kSpreferredSize);
}

class _ViewAppbarState extends State<ViewAppbar> {
  bool checkSearch = true;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kplaylistappbar,
      title: checkSearch
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: 22.sp,
                    color: kMaincolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: kWhitecolor,
                    ),
                    onPressed: () {
                      setState(() {
                        checkSearch = false;
                      });
                    })
              ],
            )
          : Row(
              children: [
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
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: kWhitecolor,
                    ),
                    onPressed: () {
                      setState(() {
                        checkSearch = true;
                      });
                    })
              ],
            ),
    );
  }
}
