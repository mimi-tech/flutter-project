import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:sparks/alumni/strings.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'color/colors.dart';
import 'package:sparks/market/utilities/market_brain.dart';

class MySet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySetState();
  }
}

_changeText() {}

class _MySetState extends State<MySet> {
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
              kAppBarSave,
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Share Post",
              style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Text(
              "Copy Link",
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
  }

  @override
  Widget build(BuildContext context) {
    Widget images_carousel = Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage("images/alumni/friends.jpg"),
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

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        Column(children: <Widget>[
          Container(
            color: kAOffWhite,
            height: 7.0,
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 9.0),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kAGrey.withOpacity(0.8),
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: "search",
                      hintStyle: TextStyle(
                        color: kPrimaryColorDark.withOpacity(0.5),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "images/alumni/searchbutton.svg",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 6.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset('images/alumni/edit.png'),
                    height: 16.75,
                    width: 16.84,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      5,
                      7,
                      0,
                      5,
                    ),
                    child: Text(
                      kAppBarCreatePost,
                      style: TextStyle(
                          fontFamily: "Rajdhani",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              onPressed: _changeText,
              color: kAWhite,
              textColor: kABlack,
              padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
              splashColor: kAGrey,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5.0,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      kAppBarAlumni,
                      style: TextStyle(
                          color: kABlack,
                          fontFamily: "Rajdhani",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: SvgPicture.asset("images/alumni/television.svg"),
                  ),
                ],
              ),
              onPressed: _changeText,
              color: kAWhite,
              textColor: kAWhite,
              padding: EdgeInsets.fromLTRB(45, 3, 45, 3),
              splashColor: kAGrey,
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.all(5.0),
            child: Card(
              elevation: 15.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Card(
                        elevation: 10.0,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 7, 5),
                                    child: Container(
                                        child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/alumni/pic8.png'),
                                    ))),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 7, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        kAppBarAndreLyon,
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        kAppBarFromChicago,
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: kADeepOrange,
                                        ),
                                        Text(
                                          "${MarketBrain.numberFormatter(398888)}",
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 112,
                              width: 242,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      "images/alumni/iconlive1.svg",
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("images/alumni/testing.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                kAppBarCinematography,
                                                style: TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: kADeepOrange,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  height: 32.0,
                                                  child: Text(
                                                    kAppBarJoin,
                                                    style: TextStyle(
                                                        color: kAWhite,
                                                        fontFamily: "Rajdhani",
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: kADeepOrange,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  height: 32.0,
                                                  child: Text(
                                                    kAppBarProfile,
                                                    style: TextStyle(
                                                        color: kAWhite,
                                                        fontFamily: "Rajdhani",
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                    Card(
                        elevation: 10.0,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.fromLTRB(5, 5, 7, 5),
                                    child: Container(
                                        child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/alumni/pic8.png'),
                                    ))),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 7, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        kAppBarAndreLyon,
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        kAppBarFromChicago,
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: kADeepOrange,
                                        ),
                                        Text(
                                          "${MarketBrain.numberFormatter(398888)}",
                                          style: TextStyle(
                                              fontFamily: "Rajdhani",
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 112,
                              width: 242,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      "images/alumni/iconlive1.svg",
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("images/alumni/testing.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                kAppBarCinematography,
                                                style: TextStyle(
                                                    fontFamily: "Rajdhani",
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: kADeepOrange,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  height: 32.0,
                                                  child: Text(
                                                    kAppBarJoin,
                                                    style: TextStyle(
                                                        color: kAWhite,
                                                        fontFamily: "Rajdhani",
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: kADeepOrange,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  height: 32.0,
                                                  child: Text(
                                                    kAppBarProfile,
                                                    style: TextStyle(
                                                        color: kAWhite,
                                                        fontFamily: "Rajdhani",
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )),
        Container(
            margin: EdgeInsets.all(2.0),
            child: Card(
              elevation: 15.0,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                        child: Container(
                            child: CircleAvatar(
                          backgroundImage: AssetImage('images/alumni/pic8.png'),
                        ))),
                    Container(
                      margin: EdgeInsets.fromLTRB(6, 10, 7, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            kAppBarMichealBruno,
                            style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            kAppBarTravelerLifeLove,
                            style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            kAppBar19MinAgo,
                            style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.347,
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: images_carousel,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
                                height: 20.76,
                                width: 23.58,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      likeBtnPressed == false
                                          ? likeBtnPressed = true
                                          : likeBtnPressed = false;
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
                                margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                child: Text(
                                  "${MarketBrain.numberFormatter(300)}",
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
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
                                margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                child: Text(
                                  "${MarketBrain.numberFormatter(300)}",
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
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
                                margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                child: Text(
                                  "${MarketBrain.numberFormatter(300)}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 5, 5),
                                child: Text(
                                  KAppBarFromCaliforniaUsa,
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontFamily: 'Rajdhani',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
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
                                      margin: EdgeInsets.fromLTRB(5, 10, 20, 5),
                                      child: Text(
                                        kAppBarHarvardUniversity,
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            color: kAOrangeRed,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
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
      ]),
    ));
  }
}
