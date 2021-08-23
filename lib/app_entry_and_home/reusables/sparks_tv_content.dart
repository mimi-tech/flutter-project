import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SparksTVContent extends StatefulWidget {
  final ImageProvider banner;
  final ImageProvider profileImage;
  final Map<String, String> fullname;
  final String? username;

  SparksTVContent({
    required this.banner,
    required this.profileImage,
    required this.fullname,
    required this.username,
});

  @override
  _SparksTVContentState createState() => _SparksTVContentState();
}

class _SparksTVContentState extends State<SparksTVContent> {

  List<Color> _profileImageBorderColour = [
    kProfileBorder3,
    kProfileBorder2,
    kProfileBorder1,
    kDisplayStoryBorderColour,
    kLeaveGreen,
    kActiveTab,
  ];

  //This function generates a random number that is equal to the index number
  //of a colour inside "_profileImageBorderColour"
  int? _getColourIndex() {
    int? colourIndex;

    dynamic rng = new Random();
    colourIndex = rng.nextInt(6);

    return colourIndex;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.02,
        left: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.02,
      ),
      width: MediaQuery.of(context).size.width * 0.55,
      height: MediaQuery.of(context).size.height * 0.28,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                0.55,
            height: MediaQuery.of(context).size.height *
                0.20,
            decoration: BoxDecoration(
              color: kLight_orange,
              borderRadius: BorderRadius.circular(
                k20,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width *
                0.55,
            height: MediaQuery.of(context).size.height *
                0.08,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 50.0,
                    child: Container(
                      width: 40.0,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                        widget.profileImage,
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: kWhiteColour,
                          width: 4.0,
                        ),
                      ),
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: _profileImageBorderColour[_getColourIndex()!],
                        width: 4.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prince John",
                        style: Theme.of(context).textTheme.headline6!.apply(
                          fontSizeFactor: 0.9,
                          fontSizeDelta: 0.2,
                          color:  kBlackColour,
                        ),
                      ),
                      Text(
                        "Username",
                        style: Theme.of(context).textTheme.headline6!.apply(
                          fontSizeFactor: 0.7,
                          fontSizeDelta: 0.2,
                          color:  kHintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
