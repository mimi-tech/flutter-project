import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sparks/alumni/components/alumni_persistent_header.dart';
import 'package:sparks/alumni/views/tab_views/alumni_members.dart';
import 'package:sparks/alumni/views/tab_views/alumni_my_set.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class MembersMySetChapter extends StatefulWidget {
  const MembersMySetChapter({Key? key}) : super(key: key);

  @override
  _MembersMySetChapterState createState() => _MembersMySetChapterState();
}

class _MembersMySetChapterState extends State<MembersMySetChapter>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            // pinned: true,
            delegate: AlumniPersistentHeader(
              isCard: true,
              cardBottomLeftRadius: 10.0,
              cardBottomRightRadius: 10.0,
              widget: TabBar(
                controller: _tabController,
                labelColor: kWhiteColor,
                unselectedLabelColor: kBlackColor,
                // indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: kTextStyleFont15Bold,
                unselectedLabelStyle: kTextStyleFont15Bold,
                indicator: BubbleTabIndicator(
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color(0xff434343),
                  indicatorHeight: 36.0,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      "Members",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "My Set",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Chapter",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          AlumniMembers(
            parentController: _scrollController,
          ),
          AlumniMySet(),
          Container(
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
}
