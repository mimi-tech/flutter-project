import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'color/colors.dart';
import 'strings.dart';

class AlumniSchoolsCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlumniSchoolsCreateState();
  }
}

_changeText() {}

class _AlumniSchoolsCreateState extends State<AlumniSchoolsCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kAWhite,
          leading: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.arrow_back,
              color: kABlack,
            ),
          ),
          title: Column(
            children: <Widget>[
              Center(
                child: Text(
                  kAppBarCreateResumeOrPost,
                  style: TextStyle(
                    color: kABlack,
                    fontFamily: "Rajdhani",
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                  child: Text(
                kAppBarDestinationOfPost,
                style: TextStyle(
                  color: kASkyBlue,
                  fontFamily: "Rajdhani",
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
              width: 36.28,
              child: SvgPicture.asset("images/Alumni/arrow sparks.svg"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 50.0, 0, 0),
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/Alumni/profile1.png'),
                backgroundColor: kAWhite,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                kAppBarAndreLyon,
                style: TextStyle(
                    color: kABlack,
                    fontFamily: 'Rajdhani',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                RaisedButton(
                  elevation: 7.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset('images/Alumni/edit.png'),
                        height: 19.75,
                        width: 19.84,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          10,
                          8,
                          5,
                          5,
                        ),
                        child: Text(
                          kAppBarCreateResume,
                          style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  onPressed: _changeText,
                  color: kADeepOrange,
                  textColor: kABlack,
                  padding: EdgeInsets.fromLTRB(45, 3, 45, 3),
                  splashColor: kAGrey,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  elevation: 7.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset('images/Alumni/edit.png'),
                        height: 19.75,
                        width: 19.84,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          10,
                          8,
                          5,
                          5,
                        ),
                        child: Text(
                          kAppBarCreateYourPost,
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
                  padding: EdgeInsets.fromLTRB(45, 3, 45, 3),
                  splashColor: kAGrey,
                ),
              ],
            )
          ]),
        ));
  }
}
