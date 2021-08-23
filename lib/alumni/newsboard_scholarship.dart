import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'dart:ui';
import 'color/colors.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'strings.dart';

class NewsBoardScholarship extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsBoardScholarshipState();
  }
}

_changeText() {}

class _NewsBoardScholarshipState extends State<NewsBoardScholarship> {
  List<String> uche = [
    kAppBarSchoolEvents,
    kAppBarJobs,
    kAppBarPromotions,
    kAppBarScholarship,
    kAppBarInternship,
    kAppBarCareerService,
    kAppBarAlumniProject,
  ];
  Widget _selectPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Save",
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

  bool? likeBtnPressed;

  int _value = 0;
  var selectedValue = 0;
  var isLargeScreen = false;
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
          AssetImage("images/alumni/testing.png"),
          AssetImage("images/alumni/friends.jpg"),
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
      child: Column(
        children: <Widget>[
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
          Container(
              margin: EdgeInsets.all(2.0),
              child: Card(
                elevation: 15.0,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                          child: Container(
                              child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/alumni/pic8.png'),
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
                                  child: Text('247'),
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
                                  child: Text('47'),
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
                                  child: Text('33'),
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
                                        margin:
                                            EdgeInsets.fromLTRB(5, 10, 20, 5),
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
        ],
      ),
    ));
  }
}
