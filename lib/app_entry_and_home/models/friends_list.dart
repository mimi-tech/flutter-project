import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FriendsList {
  final bool friendshipAccepted;
  final String friendUID;
  final String? friendType;
  final Timestamp? myFriendSince;

  FriendsList({
    required this.friendshipAccepted,
    required this.friendUID,
    this.friendType,
    this.myFriendSince,
  });
}
