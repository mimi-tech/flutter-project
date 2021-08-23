import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/golive/bottomsheet_widget_first.dart';
import 'package:sparks/schoolClassroom/VirtualClass/getRaisedHands.dart';
import 'package:sparks/schoolClassroom/VirtualClass/liveComments.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:volume_control/volume_control.dart';

class CameraIcons extends StatefulWidget {
  /*CameraIcons({@required this.question,@required this.comment,@required this.volume,});
  final Function question;
  final  Function comment;
  final Function volume;*/

  @override
  _CameraIconsState createState() => _CameraIconsState();
}

class _CameraIconsState extends State<CameraIcons> {
  double _val = 0.5;
  Timer? timer;
  bool showHand = false;
  bool showVol = true;
  late StreamSubscription stream;
  int? commentCount = 0;
  int? handCount = 0;
  List<Widget> getNames() {
    List<Widget> list = [];
    for (var i = 0; i < raisedHands.length; i++) {
      Widget w = Column(
        children: [
          Text(
            '${raisedHands[i]['fn']} ${raisedHands[i]['ln']}'.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: kExpertColor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
        ],
      );
      list.add(w);
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    getRaisedHands();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
              color: kDarkColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              )),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _getHands();
                  },
                  child: Badge(
                    toAnimate: false,
                    padding: EdgeInsets.all(4.0),
                    badgeContent: Text(
                      handCount.toString(),
                      style: TextStyle(color: kBlackcolor),
                    ),
                    badgeColor: kAYellow,
                    position: BadgePosition.bottomEnd(bottom: -12, end: -14),
                    child: Icon(
                      Icons.pan_tool,
                      color: kMilkColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showComments();
                  },
                  child: Badge(
                      toAnimate: false,
                      padding: EdgeInsets.all(4.0),
                      badgeContent: Text(
                        commentCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      badgeColor: kExpertColor,
                      position: BadgePosition.bottomEnd(bottom: -12, end: -14),
                      child: Icon(
                        Icons.comment,
                        color: kMilkColor,
                      )),
                ),
                showVol
                    ? GestureDetector(
                    onTap: () {
                      settingVol();
                    },
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: kMilkColor,
                    ))
                    : GestureDetector(
                    onTap: () {
                      setState(() {
                        showVol = !showVol;
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: kMilkColor,
                    )),
              ],
            ),
          ),
        ),
        !showVol
            ? Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: RotatedBox(
              quarterTurns: 1,
              child: Slider(
                  value: _val,
                  min: 0,
                  max: 1,
                  divisions: 100,
                  onChanged: (val) {
                    _val = val;
                    setState(() {});
                    if (timer != null) {
                      timer!.cancel();
                    }

                    //use timer for the smoother sliding
                    timer = Timer(Duration(milliseconds: 200), () {
                      VolumeControl.setVolume(val);
                    });
                  })),
        )
            : Text(''),
        showHand && raisedHands.isNotEmpty
            ? Column(
          children: getNames(),
        )
            : Text(''),
      ],
    );
  }

  Future<void> settingVol() async {
    if (!mounted) return;

    //read the current volume
    _val = await VolumeControl.volume;
    setState(() {});

    setState(() {
      showVol = !showVol;
    });
  }

  void getComments() {
    stream = FirebaseFirestore.instance
        .collection("liveVideoCommentCount")
        .doc(videoId)
        .snapshots()
        .listen((result) {
      if (result.data()!['ct'] != null) {
        setState(() {
          commentCount = result.data()!['ct'];
        });
      }
    });
  }

  void _showComments() {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveMessageStream()));

    showBottomSheet(
        backgroundColor: kBlackcolor.withOpacity(0.5),
        context: context,
        //isScrollControlled: true,
        builder: (context) => LiveMessageStream());
  }

  void getRaisedHands() {
    stream = FirebaseFirestore.instance
        .collection("liveVideoHandsCount")
        .doc(videoId)
        .snapshots()
        .listen((result) {
      if (result.data()!['ha'] != null) {
        setState(() {
          handCount = result.data()!['ha'];
        });
      }
    });
  }

  void _getHands() {
    if (!isTeacher) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('liveVideoHands')
          .doc(videoId)
          .collection('raisedHands')
          .doc();
      docRef.set({
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ts': DateTime.now().toString(),
        'pimg': SchClassConstant.isUniStudent || isTeacher
            ? GlobalVariables.loggedInUserObject.pimg
            : null,
      });

      //get the hands count
      FirebaseFirestore.instance
          .collection("liveVideoHandsCount")
          .doc(videoId)
          .get()
          .then((value) {
        if (value.exists) {
          var res = value.data()!['ha'] + 1;
          value.reference.set({'ha': res}, SetOptions(merge: true));
        } else {
          FirebaseFirestore.instance
              .collection("liveVideoHandsCount")
              .doc(videoId)
              .set({'ha': 1});
        }
      });
    } else {
      /* FirebaseFirestore.instance.collection("liveVideoHands").doc(videoId).collection('raisedHands').doc()
          .get().then((value) {
        setState(() {
          raisedHands.clear();
          raisedHands.add(value.data());
        });
      });*/

      showBottomSheet(
          backgroundColor: kBlackcolor.withOpacity(0.5),
          context: context,
          //isScrollControlled: true,
          builder: (context) => GetHandsUp());
    }
  }
}
