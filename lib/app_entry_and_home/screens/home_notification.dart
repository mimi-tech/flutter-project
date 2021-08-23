import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/models/home_notification.dart';
import 'package:sparks/app_entry_and_home/models/notification_card_model.dart';
import 'package:sparks/app_entry_and_home/reusables/cards/notification_card.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class HomeNotificationsScreen extends StatefulWidget {
  static const String id = kHome_notifications;

  final bool actSrn;

  HomeNotificationsScreen({
    required this.actSrn,
  });

  @override
  _HomeNotificationsScreenState createState() =>
      _HomeNotificationsScreenState();
}

class _HomeNotificationsScreenState extends State<HomeNotificationsScreen> {
  Widget? notificationStreamBuilder;
  AutoScrollController notificationScrollController = AutoScrollController();
  StreamController<List<DocumentSnapshot>> _notificationStreamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _notificationDocumentList = [];
  int check = 0;
  bool shouldCheck = false;
  bool shouldRunCheck = true;

  bool shouldRunFirstTen = true;

  //TODO: Fetch the first fifteen notifications
  Future getFirstFifteenNotifications() async {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(GlobalVariables.loggedInUserObject.id)
        .collection("homePLCNotifications")
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    _notificationDocumentList = (await FirebaseFirestore.instance
            .collection("posts")
            .doc(GlobalVariables.loggedInUserObject.id)
            .collection("homePLCNotifications")
            .orderBy("cts", descending: true)
            .limit(15)
            .get())
        .docs;

    _notificationDocumentList.sort((b, a) => a['notID'].compareTo(b['notID']));

    _notificationDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_notificationDocumentList)
            .toList();

    if (mounted) {
      setState(() {
        _notificationStreamController.add(_notificationDocumentList);
      });
    }
  }

  //TODO: Fetch the next fifteen notifications
  fetchNextFifteenNotifications() async {
    if (shouldCheck) {
      shouldRunCheck = false;
      shouldCheck = false;

      check++;

      List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
              .collection("posts")
              .doc(GlobalVariables.loggedInUserObject.id)
              .collection("homePLCNotifications")
              .orderBy("cts", descending: true)
              .startAfterDocument(_notificationDocumentList[
                  _notificationDocumentList.length - 1])
              .limit(15)
              .get())
          .docs;

      _notificationDocumentList.addAll(newDocumentList);

      sortAndRemoveDuplicates();

      setState(() {
        _notificationStreamController.add(_notificationDocumentList);
      });
    }
  }

  //TODO: Tracking document changes inside notification collection
  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;

    documentChanges.forEach((change) {
      if (change.type == DocumentChangeType.removed) {
        _notificationDocumentList.removeWhere((notification) {
          return change.doc.id == notification.id;
        });

        isChange = true;
      } else if (change.type == DocumentChangeType.modified) {
        int indexWhere = _notificationDocumentList.indexWhere((notification) {
          return change.doc.id == notification.id;
        });

        if (indexWhere >= 0) {
          _notificationDocumentList[indexWhere] = change.doc;
        }

        isChange = true;
      } else if (change.type == DocumentChangeType.added) {
        int indexWhere = _notificationDocumentList.indexWhere((notification) {
          return change.doc.id == notification.id;
        });

        if (indexWhere >= 0) {
          //_commentDocumentList.removeAt(indexWhere);
        }

        _notificationDocumentList.add(change.doc);

        isChange = true;
      }
    });

    if (isChange) {
      sortAndRemoveDuplicates();

      if (mounted) {
        setState(() {
          _notificationStreamController.add(_notificationDocumentList);
        });
      }
    }
  }

  //TODO: Takes a list of notifications, sorts through it and remove duplicates
  void sortAndRemoveDuplicates() {
    _notificationDocumentList.sort((b, a) => a['notID'].compareTo(b['notID']));

    _notificationDocumentList =
        LinkedHashSet<DocumentSnapshot>.from(_notificationDocumentList)
            .toList();

    for (int i = 0; i < _notificationDocumentList.length; i++) {
      if (i == 0 && _notificationDocumentList.length > 1) {
        if (_notificationDocumentList[i]['notID'] ==
            _notificationDocumentList[i + 1]['notID']) {
          _notificationDocumentList.removeAt(i);
        }
      }
      if (i == _notificationDocumentList.length - 1 &&
          _notificationDocumentList.length > 1) {
        if (_notificationDocumentList[i]['notID'] ==
            _notificationDocumentList[i - 1]['notID']) {
          _notificationDocumentList.removeAt(i);
        }
      }
      if (i != 0 && i != _notificationDocumentList.length - 1) {
        if (_notificationDocumentList[i]['notID'] ==
            _notificationDocumentList[i + 1]['notID']) {
          _notificationDocumentList.removeAt(i);
        }
      }
    }
  }

  //TODO: Initialize notificationStreamBuilder variable
  _notificationInit() {
    notificationStreamBuilder = StreamBuilder(
      stream: _notificationStreamController.stream,
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.active) &&
            (!snapshot.hasData)) {
          return Center(
            child: Text(
              kNo_notification,
            ),
          );
        }
        if ((snapshot.connectionState == ConnectionState.active) &&
            (snapshot.hasData)) {}
        return ListView.builder(
          controller: notificationScrollController,
          itemCount: _notificationDocumentList.length,
          itemBuilder: (context, index) {
            DocumentSnapshot currentDocument = _notificationDocumentList[index];
            NotificationCardModel notificationModel =
                NotificationCardModel.fromJson(currentDocument.data() as Map<String, dynamic>);
            return Container(
              key: Key('${currentDocument['notID']}'),
              child: CustomFunctions.createNotificationCard(notificationModel),
            );
          },
        );
      },
    );
  }

  //TODO: Making the notification screen active
  _makeNotificationScreenActive() async {
    await DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .notificationActiveScreen(
      true,
    );
  }

  //TODO: Making the notification screen inactive
  _makeNotificationScreenInactive() async {
    await DatabaseService(loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .resetNotificationScreen(false, 0);
  }

  @override
  void initState() {
    notificationScrollController.addListener(() {
      double maxScroll = notificationScrollController.position.maxScrollExtent;
      double currentScroll = notificationScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      if (maxScroll - currentScroll <= delta) {
        shouldCheck = true;

        if (shouldRunCheck) {
          fetchNextFifteenNotifications();
        }
      } else {
        shouldRunCheck = true;
      }
    });

    _notificationInit();

    Timer(Duration(seconds: 2), () {
      getFirstFifteenNotifications();
    });

    // Update the notification tracker: set 'actSrn' to true and notification counter to zero
    _makeNotificationScreenActive();
    super.initState();
  }

  @override
  void dispose() {
    // Reset the notification tracker to false and notification counter to zero
    _makeNotificationScreenInactive();
    notificationScrollController.dispose();
    _notificationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLight_orange,
          title: Text(
            kNotification_title,
            style: Theme.of(context).textTheme.headline6!.apply(
              color: kWhitecolor,
            ),
          ),
        ),
        body: notificationStreamBuilder,
      ),
    );
  }
}
