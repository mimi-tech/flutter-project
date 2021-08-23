import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/alumni/components/alumni_post_card.dart';
import 'package:sparks/alumni/components/alumni_search_create_post_chat.dart';
import 'package:sparks/alumni/components/alumni_text_photo_card.dart';
import 'package:sparks/alumni/components/alumni_tv_reel_card.dart';
import 'package:sparks/alumni/components/label_icon_elevated_button.dart';
import 'package:sparks/alumni/components/post_render.dart';
import 'package:sparks/alumni/models/alumni_post.dart';
import 'package:sparks/alumni/services/alumni_db.dart';
import 'package:sparks/alumni/utilities/alumni_db_const.dart';
import 'package:sparks/alumni/utilities/alumni_utils.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class AlumniMembers extends StatefulWidget {
  const AlumniMembers({Key? key, required this.parentController})
      : super(key: key);

  final ScrollController parentController;

  @override
  _AlumniMembersState createState() => _AlumniMembersState();
}

class _AlumniMembersState extends State<AlumniMembers>
    with AutomaticKeepAliveClientMixin {
  AlumniDB _alumniDB = AlumniDB();

  TextEditingController? _minYearTextController;
  TextEditingController? _maxYearTextController;

  late double _maxRange;
  double _minRange = 1950;

  late RangeValues _postYearRange;

  StreamController<List<AlumniPost>> _streamController =
      StreamController<List<AlumniPost>>();

  List<AlumniPost> _alumniPostCache = [];

  List<DocumentSnapshot>? _lastDocumentSnapshot = [];

  void getCurrentYearAsDouble() {
    DateTime dateTime = DateTime.now();
    int currentYear = dateTime.year;

    _maxRange = currentYear.toDouble();

    _postYearRange = RangeValues(_minRange, _maxRange);

    _minYearTextController =
        TextEditingController(text: _minRange.toInt().toString());
    _maxYearTextController =
        TextEditingController(text: _maxRange.toInt().toString());
  }

  void minTextInputToRangeSliderStartHandler(String newMinValue) {
    double minYearValue;

    if (newMinValue.isNotEmpty) {
      if (double.parse(newMinValue) <= _maxRange &&
          double.parse(newMinValue) >= _minRange &&
          double.parse(newMinValue) <= _postYearRange.end) {
        setState(() {
          minYearValue = double.parse(newMinValue);
          RangeValues newRangeValues =
              RangeValues(minYearValue, _postYearRange.end);
          _postYearRange = newRangeValues;
        });
      } else {
        setState(() {
          _postYearRange = RangeValues(_minRange, _maxRange);
        });
      }
    }
  }

  void maxTextInputToRangeSliderEndHandler(String newMaxValue) {
    double maxYearValue;

    if (newMaxValue.isNotEmpty) {
      if (double.parse(newMaxValue) <= _maxRange &&
          double.parse(newMaxValue) >= _minRange &&
          double.parse(newMaxValue) >= _postYearRange.start) {
        setState(() {
          maxYearValue = double.parse(newMaxValue);
          RangeValues newRangeValues =
              RangeValues(_postYearRange.start, maxYearValue);
          _postYearRange = newRangeValues;
        });
      } else {
        setState(() {
          _postYearRange = RangeValues(_minRange, _maxRange);
        });
      }
    }
  }

  void _getFirstSetOfPosts() async {
    /// TODO: Add listener function here

    _alumniDB.getAlumniPosts().then((mapStringDynamicData) {
      List<AlumniPost> listOfAlumniPost =
          mapStringDynamicData[kListOfAlumniPost];

      _lastDocumentSnapshot = mapStringDynamicData[kLastDocumentSnapshot];

      if (listOfAlumniPost.isNotEmpty) {
        print("LENGTHY: ${listOfAlumniPost.length}");
        _alumniPostCache = listOfAlumniPost;
      }

      if (mounted) {
        setState(() => _streamController.add(_alumniPostCache));
      }
    }).catchError((onError) {
      /// TODO: Use onError to give feedback
      print("_getFirstSetOfPosts: From alumni_members = $onError");
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentYearAsDouble();

    _getFirstSetOfPosts();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// TODO: Change SingleChildScrollView to NestedScrollView if controlling multiple
    return SingleChildScrollView(
      controller: widget.parentController,
      child: Column(
        children: [
          /// RangeSlider Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 40.0,
                child: TextField(
                  controller: _minYearTextController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: kTextStyleFont15Bold,
                  decoration: InputDecoration(
                    hintText: "Min",
                    isDense: true,
                  ),
                  onChanged: (String value) {
                    minTextInputToRangeSliderStartHandler(value.trim());
                  },
                ),
              ),
              RangeSlider(
                activeColor: kPrimaryColor,
                inactiveColor: Color(0xffFEE7E2),
                values: _postYearRange,
                min: _minRange,
                max: _maxRange,
                onChanged: (RangeValues values) {
                  print("Range value: $values");
                  setState(() {
                    _postYearRange = values;

                    _minYearTextController!.text =
                        values.start.toInt().toString();
                    _maxYearTextController!.text = values.end.toInt().toString();
                  });
                },
              ),
              SizedBox(
                width: 40.0,
                child: TextField(
                  controller: _maxYearTextController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: kTextStyleFont15Bold,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Max",
                  ),
                  onChanged: (String value) {
                    maxTextInputToRangeSliderEndHandler(value.trim());
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),

          /// Search, Create Post & Sparks Chat Widget
          AlumniSearchCreatePostChat(),
          SizedBox(
            height: 24.0,
          ),

          /// Sparks TV Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: LabelIconElevatedButton(
                  onPressed: () {}, label: "all alumni"),
            ),
          ),
          Divider(),

          /// Sparks TV Reels
          Container(
            height: 296.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: kBlurColor,
                  offset: Offset(0, 3),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                AlumniTVReelCard(),
                AlumniTVReelCard(),
                AlumniTVReelCard(),
                AlumniTVReelCard(),
              ],
            ),
          ),

          /// Alumni posts
          StreamBuilder<List<AlumniPost>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              } else if (snapshot.hasError) {
                return Text("An error has occurred");
              } else {
                List<AlumniPost> posts = snapshot.data!.toList();

                if (posts == null || posts.isEmpty) {
                  return Text("No data found");
                } else {
                  List<Widget> testingOne = [];

                  for (AlumniPost post in posts) {
                    Widget something = AlumniTextPhotoCard(
                      alumniPost: post,
                    );
                    testingOne.add(something);
                  }
                  return Column(
                    children: [...testingOne],
                  );
                  // return ListView.builder(
                  //   itemCount: posts.length,
                  //   itemBuilder: ((BuildContext context, int index) {
                  //     AlumniPost post = posts[index];
                  //     return AlumniTextPhotoCard(alumniPost: post);
                  //   }),
                  // );
                }
              }
            },
          ),

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 10,
          //     itemBuilder: ((BuildContext context, int index) {
          //       return Text("Hello world");
          //     }),
          //   ),
          // ),

          // AlumniPostCard(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
