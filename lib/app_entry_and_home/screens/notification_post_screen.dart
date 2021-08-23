import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class NotificationPostScreen extends StatefulWidget {
  final String? postAuthorId;
  final String? postId;

  NotificationPostScreen({
    required this.postAuthorId,
    required this.postId,
  });

  @override
  _NotificationPostScreenState createState() => _NotificationPostScreenState();
}

class _NotificationPostScreenState extends State<NotificationPostScreen> {
  Future<dynamic>? getThePost;
  Widget? customPost;

  //TODO: This function Initializes variable 'getThePost'
  _initGetThePost(String? postOwner, String? postId) async {
    return await CustomFunctions.getNotificationRelatedPost(postOwner, postId);
  }

  @override
  void initState() {
    //TODO: Initialize variable getThePost
    getThePost = _initGetThePost(widget.postAuthorId, widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhitecolor,
        appBar: AppBar(
          backgroundColor: kLight_orange,
          title: Text(
            kHome_posts,
            style: Theme.of(context).textTheme.headline6!.apply(
                  color: kWhitecolor,
                ),
          ),
        ),
        body: FutureBuilder(
          future: getThePost,
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.waiting) &&
                (snapshot.hasData)) {
              return Center(
                child: Text("Loading..."),
              );
            }

            if ((snapshot.connectionState == ConnectionState.done) &&
                (snapshot.hasData)) {
              Map<String, dynamic> documentSnapshot =
                  snapshot.data as Map<String, dynamic>;
              customPost =
                  CustomFunctions.feedWidget(context, documentSnapshot);
            }

            return customPost!;
          },
        ),
      ),
    );
  }
}
