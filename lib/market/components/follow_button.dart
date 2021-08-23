import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/market/market_services/market_database_service.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/market/utilities/market_global_variables.dart';

class FollowButton extends StatefulWidget {
  final String? storeId;
  final String? storeImgUrl;
  final String? storeName;

  const FollowButton(
      {Key? key,
      required this.storeId,
      required this.storeImgUrl,
      required this.storeName})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _following = false;

  late MarketDatabaseService _marketDatabaseService;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _marketDatabaseService =
        MarketDatabaseService(userId: MarketGlobalVariables.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _following = !_following;
        });
        String storeTopic = "store" + widget.storeId!;
        print("STORE TOPIC: $storeTopic");
        if (_following) {
          _marketDatabaseService
              .followStore(widget.storeId, widget.storeImgUrl, widget.storeName)
              .then((value) {
            _firebaseMessaging.subscribeToTopic(storeTopic);
            print("SUBSCRIBED");
          }).catchError((onError) {
            print("Failed to subscribe to topic $onError");
          });
        } else {
          _marketDatabaseService.unfollowStore(widget.storeId).then((value) {
            _firebaseMessaging.unsubscribeFromTopic(storeTopic);
            print("UNSUBSCRIBED");
          }).catchError((onError) {
            print("Failed to unsubscribe from topic");
          });
        }
      },
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("stores")
              .doc(widget.storeId)
              .collection("followers")
              .where("id", isEqualTo: MarketGlobalVariables.currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("An error has occurred");
            } else {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                List<QueryDocumentSnapshot> documentSnapshot =
                    snapshot.data!.docs;

                if (documentSnapshot.length >= 1 ||
                    documentSnapshot.isNotEmpty) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (!_following) {
                      setState(() {
                        _following = true;
                      });
                      print("Changing following $_following");
                    }
                  });
                } else {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (_following) {
                      setState(() {
                        _following = false;
                      });
                      print("Changing following from else $_following");
                    }
                  });
                }
              }
            }
            return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                constraints: BoxConstraints(
                  minWidth: ScreenUtil().setWidth(64),
                  maxWidth: ScreenUtil().setWidth(92),
                ),
                decoration: BoxDecoration(
                  color: _following ? Color(0xffFF502F) : Colors.white,
                  border: _following
                      ? null
                      : Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: AutoSizeText(
                  _following ? 'FOLLOWING' : 'FOLLOW',
                  style: _following
                      ? kFollowButtonActiveTextStyle
                      : kFollowButtonInactiveTextStyle,
                  maxLines: 1,
                ));
          }),
    );
  }
}
