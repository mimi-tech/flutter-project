import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/alumni/color/colors.dart';

class AlumniSearchButton extends StatefulWidget {
  static String id = 'alumni_search';

  @override
  _AlumniSearchButtonState createState() => _AlumniSearchButtonState();
}

class _AlumniSearchButtonState extends State<AlumniSearchButton> {
  final _searchController = TextEditingController();

  bool isSearching = false;

  List<String> _searchPersistentNav = ['big head'];
  void _handleSearchFilterNav(String searchPersistentFilter) {
    if (_searchPersistentNav.contains(searchPersistentFilter)) {
      setState(() {
        _searchPersistentNav
            .retainWhere((e) => e.contains(searchPersistentFilter));
      });

      print(_searchPersistentNav);
    } else {
      setState(() {
        _searchPersistentNav.clear();
        _searchPersistentNav.add(searchPersistentFilter);
      });

      print(_searchPersistentNav);
    }
  }

  // The Widget displayed when the search TextField is empty
  Widget emptySearch() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 10.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'RECENTLY VIEWED',
              ),
              Text(
                'CLEAR',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 10.0),
          child: Container(
            height: ScreenUtil().setHeight(88),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8.0,
                  color: kAWhite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image(
                            image:
                                AssetImage('images/market_images/img_02.jpg'),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'The big head guy',
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Text(
                              '49.99',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image(
                            image:
                                AssetImage('images/market_images/img_02.jpg'),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'The big head guy',
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Text(
                              '49.99',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image(
                            image:
                                AssetImage('images/market_images/img_02.jpg'),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'The big head guy',
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Text(
                              '49.99',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image(
                            image:
                                AssetImage('images/market_images/img_02.jpg'),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'The big head guy',
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            Text(
                              '49.99',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'RECOMMENDED',
              ),
              Text(
                'REFRESH',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              children: <Widget>[
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'Denim Jeans',
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // The Widget displayed when the user starts typing in the search TextField
  Widget searching() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeader(
            widget: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav('big head');
                        },
                        child: Text('big head'),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav('big head');
                        },
                        child: Text(
                          'big head',
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav('big head');
                        },
                        child: Text(
                          'big head',
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                      InkWell(
                        onTap: () {
                          _handleSearchFilterNav('big head');
                        },
                        child: Text(
                          'big head',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF3F4F6),
        appBar: AppBar(
          backgroundColor: Color(0xFFA60F00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          title: Container(
            height: 40.0,
            decoration: BoxDecoration(
              color: Color(0xffF5F6F8),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: "Rajdhani",
                    fontSize: 17.0),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          actions: <Widget>[
            SvgPicture.asset(
              'images/m_filter_icon.svg',
              width: 20.0,
              height: 20.0,
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget? widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      color: Colors.white,
      child: widget,
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
