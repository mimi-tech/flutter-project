import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class BookmarkScreen extends StatefulWidget {
  static const String id = kBookmark_screen;

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<dynamic>? incomingBookmark = [];
  List<Widget?> bookmarkWidget = [];
  DocumentSnapshot? _lastDocument;
  Future<dynamic>? loadBookmark;
  ScrollController _bookmarkScrollController = ScrollController();
  bool _gettingMoreBookmarkFeeds = false;
  bool _moreAvailableBookmarkFeeds = true;

  //TODO: Load the first set of bookmark feed into the bookmark feed list.
  _loadBookmark() async {
    List<DocumentSnapshot> bkSnapshot = await DatabaseService(
            loggedInUserID: GlobalVariables.loggedInUserObject.id)
        .fetchFirstTenBookmarkedPost();
    _lastDocument = bkSnapshot[bkSnapshot.length - 1];

    return bkSnapshot;
  }

  //TODO: Get the next set of bookmark feeds
  _getIncomingBookmarkFeeds(DocumentSnapshot? lastD) async {
    try {
      if (_moreAvailableBookmarkFeeds == false) {
        return;
      }

      if (_gettingMoreBookmarkFeeds == true) {
        return;
      }

      _gettingMoreBookmarkFeeds = true;

      List<DocumentSnapshot> nextBkSnapshot = await DatabaseService(
              loggedInUserID: GlobalVariables.loggedInUserObject.id)
          .fetchNextTenBookmarkedPost(lastD!);

      //TODO: Check if there are more feeds to load
      if (nextBkSnapshot.length < 10) {
        _moreAvailableBookmarkFeeds = false;
      }
      _lastDocument =
          nextBkSnapshot[nextBkSnapshot.length - 1]; //get the last document.

      incomingBookmark!.addAll(nextBkSnapshot);

      _gettingMoreBookmarkFeeds = false;
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    //TODO: Add a listener to the _bookmarkScrollController
    _bookmarkScrollController.addListener(() {
      double maxScroll = _bookmarkScrollController.position.maxScrollExtent;
      double currentScroll = _bookmarkScrollController.position.pixels;
      double percentageScrollReached =
          MediaQuery.of(context).size.height * 0.15;

      if (maxScroll - currentScroll <= percentageScrollReached) {
        _getIncomingBookmarkFeeds(_lastDocument);
      }
    });

    loadBookmark = _loadBookmark();

    super.initState();
  }

  @override
  void dispose() {
    _bookmarkScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLight_orange,
          title: Text(
            kBookmark,
            style: Theme.of(context).textTheme.headline6!.apply(
                  color: kWhiteColour,
                ),
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: loadBookmark,
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.waiting) &&
                (!snapshot.hasData)) {
              return Center(
                child: Text(
                  kFetchingBookmark,
                ),
              );
            }

            if ((snapshot.connectionState == ConnectionState.done) &&
                (!snapshot.hasData)) {
              return Container(
                child: Center(
                  child: Text(
                    kProcessingBookmark,
                  ),
                ),
              );
            }

            if ((snapshot.connectionState == ConnectionState.done) &&
                (snapshot.hasData)) {
              incomingBookmark = snapshot.data;
              for (DocumentSnapshot qdocSnapshot
                  in incomingBookmark as List<DocumentSnapshot>) {
                Map<String, dynamic> data =
                    qdocSnapshot.data() as Map<String, dynamic>;
                bookmarkWidget.add(CustomFunctions.feedWidget(context, data));
              }
            }

            return ListView.builder(
              controller: _bookmarkScrollController,
              itemCount: bookmarkWidget.length,
              physics: BouncingScrollPhysics(
                parent: ScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                return bookmarkWidget[index]!;
              },
            );
          },
        ),
      ),
    );
  }
}
