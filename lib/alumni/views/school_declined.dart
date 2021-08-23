// import 'dart:collection';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sparks/alumni/color/colors.dart';
// import 'package:sparks/alumni/components/alumni_card_not_joined.dart';
// import 'package:sparks/jobs/components/generalComponent.dart';
// import 'package:sparks/market/utilities/market_const.dart';
//
// class SchoolDeclined extends StatefulWidget {
//   @override
//   _SchoolDeclinedState createState() => _SchoolDeclinedState();
// }
//
// class _SchoolDeclinedState extends State<SchoolDeclined>
//     with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
//   ScrollController _scrollController;
//
//   AnimationController _animationController;
//
//   /// Variable holding the list of declined schools for a given user
//   List<DocumentSnapshot> _schoolDeclinedList = [];
//
//   /// Variable to check if a fresh set of DocumentSnapshot is being fetched
//   /// NOTE: This variable is solely utilized when initial data is loaded
//   bool _loadingPendingSchools = false;
//
//   /// This boolean variable is used to check whether the scroll position is close
//   /// to the bottom of the scrollable widget. If "true" then fetch next set of
//   /// document data
//   bool _shouldCheck = false;
//
//   /// This boolean variable is used to check whether the method
//   /// [fetchNextSetOfDeclinedSchools] to fetch new set of document data is already
//   /// running (pagination), if it is then the method is not called again
//   bool _shouldRunCheck = true;
//
//   /// This boolean variable is used to verify if there are still any documents
//   /// left in the database
//   bool _noMoreDocuments = false;
//
//   /// Boolean variable to verify if the next set of document snapshot has been
//   /// fetched
//   bool _hasGottenNextDocData = false;
//
//   /// Boolean variable that determines if a circular progress spinner should be
//   /// shown at the bottom of the scrollable widget to indicated data being fetched
//   bool _showCircularProgress = false;
//
//   /// Method responsible for fetching the first 10 data set of schools that a
//   /// user a declined request for
//   void _getFirstSetOfDeclinedSchools() async {
//     setState(() => _loadingPendingSchools = true);
//
//     _schoolDeclinedList?.clear();
//
//     try {
//       FirebaseFirestore.instance
//           .collectionGroup("declinedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .snapshots()
//           .listen((event) => onDeclinedUserEventChange(event.docChanges));
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("declinedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .orderBy("ts", descending: true)
//           .limit(10)
//           .get();
//
//       List<DocumentSnapshot> pendingSchChunk = querySnapshot.docs;
//
//       List<DocumentSnapshot> removeDuplicatePendingSch =
//           LinkedHashSet<DocumentSnapshot>.from(pendingSchChunk).toList();
//
//       /// If [_schoolDeclinedList] is empty, then the [_getFirstSetOfDeclinedSchools]
//       /// will be exited from
//       if (removeDuplicatePendingSch.length == 0 ||
//           removeDuplicatePendingSch.isEmpty) {
//         _noMoreDocuments = true;
//         setState(() => _showCircularProgress = false);
//
//         return;
//       }
//
//       if (removeDuplicatePendingSch.length < 10) _noMoreDocuments = true;
//
//       _schoolDeclinedList = removeDuplicatePendingSch;
//     } catch (e) {
//       print("_getFirstSetOfDeclinedSchools: $e");
//     }
//
//     if (mounted) {
//       setState(() => _loadingPendingSchools = false);
//     }
//   }
//
//   /// Method responsible for reacting/effecting changes listened/gotten from the
//   /// "declinedUsers" collection group
//   void onDeclinedUserEventChange(List<DocumentChange> documentChange) async {
//     for (DocumentChange change in documentChange) {
//       if (change.type == DocumentChangeType.removed) {
//         List<DocumentSnapshot> currentDeclinedSchools = [];
//         currentDeclinedSchools = _schoolDeclinedList;
//
//         if (currentDeclinedSchools.length == 0 ||
//             currentDeclinedSchools.isEmpty) return;
//
//         int indexWhere = currentDeclinedSchools.indexWhere((sch) {
//           return change.doc.id == sch.data()["id"];
//         });
//
//         if (mounted) {
//           _schoolDeclinedList.removeAt(indexWhere);
//           setState(() {});
//         }
//       }
//
//       if (change.type == DocumentChangeType.added) {
//         if (change.doc.exists) {
//           if (mounted) {
//             setState(() {
//               _schoolDeclinedList.insert(0, change.doc);
//             });
//           }
//         }
//       }
//     }
//   }
//
//   /// Method responsible for fetching the next set of data if any from the
//   /// "declinedUsers" collection group
//   void fetchNextSetOfDeclinedSchools() async {
//     if (_shouldCheck && !_noMoreDocuments) {
//       _shouldRunCheck = false;
//       _shouldCheck = false;
//
//       _hasGottenNextDocData = false;
//
//       List<DocumentSnapshot> prevDocSnapshot = _schoolDeclinedList;
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("declinedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .orderBy("ts", descending: true)
//           .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
//           .limit(10)
//           .get();
//
//       List<DocumentSnapshot> nextDeclinedSchools = querySnapshot.docs;
//
//       if (nextDeclinedSchools.length == 0 || nextDeclinedSchools.isEmpty) {
//         /// i.e. No more Document Snapshot available in the database
//         _noMoreDocuments = true;
//
//         setState(() => _showCircularProgress = false);
//
//         return;
//       }
//
//       if (nextDeclinedSchools.length < 10) _noMoreDocuments = true;
//
//       setState(() {
//         _showCircularProgress = false;
//         _schoolDeclinedList.addAll(nextDeclinedSchools);
//       });
//
//       _hasGottenNextDocData = true;
//
//       _shouldRunCheck = true;
//     }
//   }
//
//   /// Widget method responsible for handling/displaying declined school cards
//   Widget _schoolDeclinedWidgets() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _schoolDeclinedList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return SchCardComponent(
//                   schoolName: _schoolDeclinedList[index].data()["schN"],
//                   schoolCity: _schoolDeclinedList[index].data()["loc"],
//                   schoolState: _schoolDeclinedList[index].data()["st"],
//                   onPressed: () {
//                     print("Declined button pressed!");
//                   },
//                 );
//               }),
//         ),
//         _showCircularProgress
//             ? Center(
//                 child: SizedBox(
//                   width: 18.0,
//                   height: 18.0,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.0,
//                     valueColor: _animationController.drive(
//                       ColorTween(
//                           begin: kADeepOrange, end: kMarketSecondaryColor),
//                     ),
//                   ),
//                 ),
//               )
//             : SizedBox.shrink(),
//       ],
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _scrollController = ScrollController();
//
//     _scrollController.addListener(() {
//       double maxScroll = _scrollController.position.maxScrollExtent;
//       double currentScroll = _scrollController.position.pixels;
//       double delta = MediaQuery.of(context).size.height * 0.20;
//
//       /// Bottom of the screen
//       if (_scrollController.offset >=
//               _scrollController.position.maxScrollExtent &&
//           !_scrollController.position.outOfRange) {
//         if (!_hasGottenNextDocData && !_noMoreDocuments) {
//           setState(() => _showCircularProgress = true);
//         } else {
//           setState(() => _showCircularProgress = false);
//         }
//       }
//
//       if (maxScroll - currentScroll <= delta) {
//         _shouldCheck = true;
//
//         if (_shouldRunCheck) {
//           fetchNextSetOfDeclinedSchools();
//         }
//       }
//     });
//
//     _getFirstSetOfDeclinedSchools();
//
//     _animationController =
//         AnimationController(duration: new Duration(seconds: 1), vsync: this);
//     _animationController.repeat();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _animationController.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return _loadingPendingSchools
//         ? Center(
//             child: CircularProgressIndicator(
//               backgroundColor: kADeepOrange,
//             ),
//           )
//         : _schoolDeclinedList.length == 0
//             ? Center(
//                 child: Text("No Pending Schools"),
//               )
//             : _schoolDeclinedWidgets();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
