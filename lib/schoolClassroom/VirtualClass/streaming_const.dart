
  import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

/// Define App ID and Token
   const APP_ID = '533fa1b861ce4270bccc83376cec04c9';
   const Token = '006533fa1b861ce4270bccc83376cec04c9IADR00JHtZfKH/IZi8upQehf2yk4GKKH32adQDkP7s/I/7GATF4AAAAAEAC4541ocKztYAEAAQBvrO1g';
   const channelName = 'sparks';
   Color stColor = kStatusbar;
  late String videoId;

  List<dynamic> raisedHands = <dynamic>[];
  bool isTeacher = false;
  ClientRole role = ClientRole.Broadcaster;
  var attendantCount = 0;
  dynamic joinedName = '';
  late String getClassPeriodTaken;

