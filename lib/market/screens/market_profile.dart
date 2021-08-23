import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarketProfile extends StatefulWidget {
  static String id = "market_profile";

  final String? userId;

  MarketProfile({this.userId});

  @override
  _MarketProfileState createState() => _MarketProfileState();
}

class _MarketProfileState extends State<MarketProfile> {
  Future<DocumentSnapshot?> getUserProfileDetail() async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("Market")
          .doc("marketInfo")
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DocumentSnapshot?>? userProfileDetail;

  @override
  void initState() {
    super.initState();

    userProfileDetail = getUserProfileDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<DocumentSnapshot?>(
            future: userProfileDetail,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("An error has occurred"),
                );
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> userDetail = snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userDetail["em"],
                      ),
                      Text(userDetail["un"]),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text("Loading..."),
                );
              }
            }),
      ),
    );
  }
}
