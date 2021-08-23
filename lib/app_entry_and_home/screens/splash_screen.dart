import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/screens/sparks_landing_screen.dart';
import 'dart:async';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SplashScreen extends StatefulWidget {
  static String id = kSplash_screen;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(milliseconds: 5000),
      () {
        Navigator.pushNamed(context, SparksLandingScreen.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<SparksUser>(context, listen: false) ?? null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/app_entry_and_home/sparksbg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: SizedBox(
                    child: Image(
                      width: 200.0,
                      height: 100.0,
                      image: AssetImage(
                        'images/app_entry_and_home/brand.png',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.18,
                    left: MediaQuery.of(context).size.width * 0.3,
                    right: MediaQuery.of(context).size.width * 0.3,
                  ),
                  color: Colors.transparent,
                  height: 1.5,
                  child: LinearProgressIndicator(
                    backgroundColor: kLoadingProgressIndicatorColour,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.04,
                  ),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(
                    child: Text(
                      kFooterLabelText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
