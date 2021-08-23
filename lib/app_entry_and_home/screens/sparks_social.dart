import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/social_card.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SparksSocial extends StatelessWidget {
  static String id = kSPARKS_SOCIAL;

  List<SocialCard> socialCard = [];

  Future<List<Map<String, dynamic>>> _socials() async {
    return DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .usersWithPersonalAccount();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kWhitecolor,
          appBar: AppBar(
            backgroundColor: kLight_orange,
            title: Text("Social"),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _socials(),
            builder: (context, snapshot) {
              if ((snapshot.connectionState == ConnectionState.waiting) &&
                  (snapshot.hasData)) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              if ((snapshot.connectionState == ConnectionState.done) &&
                  (snapshot.hasData)) {
                List<Map<String, dynamic>?> infoList = []; // profile info
                List<String?> statusList = [];

                for (Map<String, dynamic> qust in snapshot.data!) {
                  QuerySnapshot qu = qust["profileQuerySnapshot"];
                  List<DocumentSnapshot> dst = qu.docs;

                  Map<String, dynamic>? info =
                      dst[0].data() as Map<String, dynamic>?;
                  infoList.add(info);
                  statusList.add(qust["currentProfileStatus"]);
                }

                //TODO: Creating a list of social cards
                socialCard =
                    CustomFunctions.createSocialCard(infoList, statusList);
              }

              return GridView.count(
                controller: AutoScrollController(),
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.5),
                children: socialCard,
              );
            },
          )),
    );
  }
}
