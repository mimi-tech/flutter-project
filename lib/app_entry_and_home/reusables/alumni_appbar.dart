import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/alumni_tab.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AlumniAppBarWithCustomScrollView extends StatefulWidget {
  final Widget profileImageUrl;

  AlumniAppBarWithCustomScrollView({required this.profileImageUrl});

  @override
  _AlumniAppBarWithCustomScrollViewState createState() =>
      _AlumniAppBarWithCustomScrollViewState();
}

class _AlumniAppBarWithCustomScrollViewState
    extends State<AlumniAppBarWithCustomScrollView>
    with SingleTickerProviderStateMixin {
  TabController? alumniTabBar;
  int activeTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    alumniTabBar = TabController(vsync: this, length: 3);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    alumniTabBar!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        //TODO: Displays the appBar for alumni.
        SliverAppBar(
          backgroundColor: kLight_orange,
          bottom: TabBar(
            tabs: <Widget>[
              AlumniTabs(
                tabName: kAlumni_school_tab,
              ),
              AlumniTabs(
                tabName: kAlumni_activities_tab,
              ),
              AlumniTabs(
                tabName: kAlumni_newsBoard_tab,
              ),
            ],
            controller: alumniTabBar,
            indicatorWeight: 5.0,
            labelPadding: EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            labelColor: kActiveTab,
            unselectedLabelColor: kWhiteColour,
            indicatorColor: kTransparent,
            //TODO: Retrieves the index of the tab clicked.
            onTap: (value) async {
              setState(() {
                activeTab = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
