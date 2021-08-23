import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:sparks/alumni/components/generalComponent.dart';
import 'color/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'components/badge_counter.dart';
import 'constant.dart';
import 'strings.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class AlumniViewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlumniViewPostState();
  }
}

_changeText() {}

class _AlumniViewPostState extends State<AlumniViewPost> {
  final ScrollController _scrollController = ScrollController();
  bool? likeBtnPressed;
  List<String> uche = [
    KAppBarMembers,
    KAppBarMySet,
    KAppBarChapter,
    KAppBarAdmin
  ];

  Widget _selectPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Delete",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Edit Post",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              "Expired Post",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        initialValue: 0,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        offset: Offset(0, 100),
        icon: Icon(Icons.more_vert),
      );
  Widget _choosePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Leave Chapter",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        initialValue: 0,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
        },
        offset: Offset(0, 100),
        icon: Icon(Icons.more_vert),
      );

  int _value = 0;
  void initState() {
    likeBtnPressed = false;
    super.initState();
    print(ChapterStorage.Id);
  }

  @override
  Widget build(BuildContext context) {
    Widget images_carousel = Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage("images/alumni/unsplash1.png"),
          AssetImage("images/alumni/testing.png"),
          AssetImage("images/alumni/friends2.jpg"),
          AssetImage("images/alumni/friends3.jpg"),
        ],
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 100),
        dotSize: 2.0,
        dotIncreasedColor: kADeepOrange,
        dotSpacing: 8.0,
        indicatorBgPadding: 3.0,
      ),
    );

    // final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return SafeArea(
        child: Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "images/alumni/friends3.jpg b",
                  fit: BoxFit.cover,
                ),
                title: Text("Chapter name"),
                centerTitle: true,
              ),
              actions: [
                Container(
                  child: Image.asset(
                    'images/alumni/edit.png',
                    color: Colors.white,
                  ),
                  height: 16.75,
                  width: 16.84,
                ),
                SizedBox(
                  width: 10.0,
                ),
                _choosePopup(),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 5, 5, 10),
                                            child: Container(
                                                child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'images/alumni/pic8.png'),
                                            ))),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(6, 10, 7, 13),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                kAppBarMichealBruno,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                kAppBarTravelerLifeLove,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                kAppBar19MinAgo,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.347,
                                        ),
                                        Container(
                                          child: _selectPopup(),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "hello this is an information with the school.",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: images_carousel,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.76,
                                                    width: 23.58,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          likeBtnPressed ==
                                                                  false
                                                              ? likeBtnPressed =
                                                                  true
                                                              : likeBtnPressed =
                                                                  false;
                                                        });
                                                      },
                                                      child: likeBtnPressed!
                                                          ? SvgPicture.asset(
                                                              "images/alumni/lov1.svg",
                                                              color: kARed,
                                                            )
                                                          : SvgPicture.asset(
                                                              "images/alumni/lov1.svg",
                                                            ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('247'),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.91,
                                                    width: 21.38,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                            "images/alumni/chat21.svg")),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('47'),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.91,
                                                    width: 21.38,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                            "images/alumni/sharebutton.svg")),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('33'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 10, 5, 5),
                                                    child: Text(
                                                      KAppBarFromCaliforniaUsa,
                                                      style: TextStyle(
                                                          color: Colors.purple,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 18,
                                                          width: 17,
                                                          child: Image.asset(
                                                              'images/alumni/Group 78.png'),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 10, 20, 5),
                                                          child: Text(
                                                            kAppBarHarvardUniversity,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Rajdhani',
                                                                color:
                                                                    kAOrangeRed,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ]),
                            )),
                        Container(
                            margin: EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 5, 5, 10),
                                            child: Container(
                                                child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'images/alumni/pic8.png'),
                                            ))),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(6, 10, 7, 13),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                kAppBarMichealBruno,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                kAppBarTravelerLifeLove,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                kAppBar19MinAgo,
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.347,
                                        ),
                                        Container(
                                          child: _selectPopup(),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "hello this is an information with the school.",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: images_carousel,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.76,
                                                    width: 23.58,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          likeBtnPressed ==
                                                                  false
                                                              ? likeBtnPressed =
                                                                  true
                                                              : likeBtnPressed =
                                                                  false;
                                                        });
                                                      },
                                                      child: likeBtnPressed!
                                                          ? SvgPicture.asset(
                                                              "images/alumni/lov1.svg",
                                                              color: kARed,
                                                            )
                                                          : SvgPicture.asset(
                                                              "images/alumni/lov1.svg",
                                                            ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('247'),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.91,
                                                    width: 21.38,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                            "images/alumni/chat21.svg")),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('47'),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 20, 5, 5),
                                                    height: 20.91,
                                                    width: 21.38,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                            "images/alumni/sharebutton.svg")),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 20, 5, 5),
                                                    child: Text('33'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        20, 10, 5, 5),
                                                    child: Text(
                                                      KAppBarFromCaliforniaUsa,
                                                      style: TextStyle(
                                                          color: Colors.purple,
                                                          fontFamily:
                                                              'Rajdhani',
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 18,
                                                          width: 17,
                                                          child: Image.asset(
                                                              'images/alumni/Group 78.png'),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 10, 20, 5),
                                                          child: Text(
                                                            kAppBarHarvardUniversity,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Rajdhani',
                                                                color:
                                                                    kAOrangeRed,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ]),
                            ))
                      ],
                    ),
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    ));
  }
}
