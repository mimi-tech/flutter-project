import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class HomePostDynamicScreen extends StatefulWidget {
  static String id = kHome_dynamic_link;

  final String? authorID;
  final String? postID;

  HomePostDynamicScreen({
    this.authorID,
    this.postID,
  });

  @override
  _HomePostDynamicScreenState createState() => _HomePostDynamicScreenState();
}

class _HomePostDynamicScreenState extends State<HomePostDynamicScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.authorID);
    print(widget.postID);
    return Container();
  }
}
