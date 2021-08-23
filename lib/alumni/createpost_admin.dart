import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'color/colors.dart';
import 'components/badge_counter.dart';
import 'constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import 'strings.dart';

class CreatePostAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePostAdminState();
  }
}

_changeText() {}

class _CreatePostAdminState extends State<CreatePostAdmin> {
  List<String> uche = [
    KAppBarMembers,
    KAppBarMySet,
    KAppBarChapter,
    KAppBarAdmin
  ];

  int _value = 0;
  var selectedValue = 0;
  var isLargeScreen = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          actions: <Widget>[],
          title: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(0.1),
                    child: Container(
                      margin: EdgeInsets.only(left: 0.1, right: 0.1, top: 4.0),
                      alignment: Alignment.center,
                      height: 41,
                      width: 70,
                      child: SvgPicture.asset("images/alumni/searchbutton.svg"),
                    )),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 1.0, right: 18.0, top: 5.0),
                        width: 30.03,
                        height: 28.09,
                        child: Image.asset("images/alumni/messages.png"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      BadgeCounter(
                        iconData: Icons.notifications,
                        batchText: '9',
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(left: 18.0, bottom: 2.0, top: 10.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/alumni/profile1.png'),
                      backgroundColor: kAWhite,
                    ),
                  ),
                ),
              ])),
          bottom: PreferredSize(
            preferredSize: Size(60, 60),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            kAppBarSchools,
                            style: new TextStyle(
                              color: kAWhite,
                              fontSize: 20.0,
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        kAppBarActivities,
                        style: new TextStyle(
                          color: kAWhite,
                          fontSize: 20.0,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        kAppBarNewsBoard,
                        style: new TextStyle(
                          color: kAWhite,
                          fontSize: 20.0,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: kAWhite,
                  height: 60.0,
                  child: Container(
                      color: kAWhite,
                      height: 45.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: uche.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: <Widget>[
                                  ChoiceChip(
                                    label: Text(uche[index]),
                                    labelStyle: _value == index
                                        ? kActiveChipTextStyle
                                        : kChipTextStyle,
                                    selected: _value == index,
                                    selectedColor: kChipActiveBgColor,
                                    backgroundColor: kChipInactiveBgColor,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _value = selected ? index : _value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                ],
                              );
                            }),
                      ))),
              Column(children: <Widget>[
                Container(
                  color: kAOffWhite,
                  height: 7.0,
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    elevation: 20.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0,
                            8,
                            0,
                            5,
                          ),
                          child: Text(
                            kAppBarCreatePost,
                            style: TextStyle(
                                fontFamily: "Rajdhani",
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    onPressed: _changeText,
                    color: kAWhite,
                    textColor: kABlack,
                    padding: EdgeInsets.fromLTRB(45, 3, 45, 3),
                    splashColor: kAGrey,
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 15.0,
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                              child: Container(
                                  child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/Alumn_imagesi/pic8.png'),
                              ))),
                          Container(
                            margin: EdgeInsets.fromLTRB(6, 20, 7, 20),
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
                          Container(
                            margin: EdgeInsets.fromLTRB(7, 0, 110, 25),
                            height: 20,
                            width: 17,
                            child: Image.asset('images/alumni/Group 78.png'),
                          ),
                          Padding(
                              padding: EdgeInsets.all(17.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(Icons.more_vert),
                              )),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 186,
                              width: 334,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Icon(Icons.save,
                                        size: 20, color: kAWhite),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('images/alumni/testing.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
                                      height: 20.76,
                                      width: 23.58,
                                      child: Image.asset(
                                          'images/alumni/love20.png'),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                      child: Text('247'),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
                                      child: Image.asset(
                                          'images/alumni/chat15.png'),
                                      height: 20.91,
                                      width: 21.38,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                      child: Text('57'),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
                                      child: Image.asset(
                                          'images/alumni/share19.png'),
                                      height: 20.91,
                                      width: 21.38,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
                                      child: Text('33'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(20, 10, 5, 5),
                                          child: Text(
                                            KAppBarFromCaliforniaUsa,
                                            style: TextStyle(
                                                fontFamily: 'Rajdhani',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 5, 5),
                                          child: Text(
                                            kAppBarHarvardUniversity,
                                            style: TextStyle(
                                                fontFamily: 'Rajdhani',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
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
