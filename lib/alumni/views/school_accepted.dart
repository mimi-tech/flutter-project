// import 'dart:collection';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'package:sparks/alumni/color/colors.dart';
// import 'package:sparks/Alumni/components/alumni_card_not_joined.dart';
// import 'package:sparks/jobs/components/generalComponent.dart';
// import 'package:sparks/market/utilities/market_const.dart';
//
// class SchoolAccepted extends StatefulWidget {
//   @override
//   _SchoolAcceptedState createState() => _SchoolAcceptedState();
// }
//
// class _SchoolAcceptedState extends State<SchoolAccepted>
//     with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
//   ScrollController _scrollController;
//
//   AnimationController _animationController;
//
//   /// Variable holding the list of accepted schools of a given user
//   List<DocumentSnapshot> _schoolAcceptedList = [];
//
//   /// Variable to check if a fresh set of DocumentSnapshot is being fetched
//   /// NOTE: This variable is solely utilized when initial data is loaded
//   bool _loadingAcceptedSchools = false;
//
//   /// This boolean variable is used to check whether the scroll position is close
//   /// to the bottom of the scrollable widget. If "true" then fetch next set of
//   /// document data
//   bool _shouldCheck = false;
//
//   /// This boolean variable is used to check whether the method
//   /// [fetchNextSetOfAcceptedSchools] to fetch new set of document data is already
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
//   /// user has accepted request for
//   void _getFirstSetOfAcceptedSchools() async {
//     setState(() => _loadingAcceptedSchools = true);
//
//     _schoolAcceptedList?.clear();
//
//     try {
//       /// Initializing a listener on the "acceptedUsers" collection group
//       FirebaseFirestore.instance
//           .collectionGroup("acceptedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .snapshots()
//           .listen((event) => onAcceptedUserEventChange(event.docChanges));
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("acceptedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .orderBy("ts", descending: true)
//           .limit(10)
//           .get();
//
//       List<DocumentSnapshot> acceptedSchChunk = querySnapshot.docs;
//
//       List<DocumentSnapshot> removeDuplicateDocs =
//           LinkedHashSet<DocumentSnapshot>.from(acceptedSchChunk).toList();
//
//       if (removeDuplicateDocs.length == 0 || removeDuplicateDocs.isEmpty) {
//         _noMoreDocuments = true;
//         setState(() {
//           _showCircularProgress = false;
//           _loadingAcceptedSchools = false;
//         });
//
//         return;
//       }
//
//       if (removeDuplicateDocs.length < 10) _noMoreDocuments = true;
//
//       _schoolAcceptedList = removeDuplicateDocs;
//     } catch (e) {
//       print("_getFirstSetOfAcceptedSchools: $e");
//     }
//
//     if (mounted) {
//       setState(() => _loadingAcceptedSchools = false);
//     }
//   }
//
//   /// Method responsible for reacting/effecting changes listened/gotten from the
//   /// "acceptedUsers" collection group
//   void onAcceptedUserEventChange(List<DocumentChange> documentChange) async {
//     for (DocumentChange change in documentChange) {
//       if (change.type == DocumentChangeType.added) {
//         if (change.doc.exists) {
//           if (mounted)
//             setState(() => _schoolAcceptedList.insert(0, change.doc));
//         }
//       }
//
//       if (change.type == DocumentChangeType.removed) {
//         List<DocumentSnapshot> currentAcceptedSchools = [];
//
//         currentAcceptedSchools = _schoolAcceptedList;
//
//         if (currentAcceptedSchools.length == 0 ||
//             currentAcceptedSchools.isEmpty) return;
//
//         int indexWhere = currentAcceptedSchools.indexWhere((sch) {
//           return change.doc.id == sch.data()["id"];
//         });
//
//         if (mounted) {
//           _schoolAcceptedList.removeAt(indexWhere);
//           setState(() {});
//         }
//       }
//     }
//   }
//
//   /// Method responsible for fetching the next set of data if any from the
//   /// "acceptedUsers" collection group
//   void fetchNextSetOfAcceptedSchools() async {
//     if (_shouldCheck && !_noMoreDocuments) {
//       _shouldRunCheck = false;
//       _shouldCheck = false;
//
//       _hasGottenNextDocData = false;
//
//       List<DocumentSnapshot> prevDocSnapshot = _schoolAcceptedList;
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("acceptedUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .orderBy("ts", descending: true)
//           .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
//           .limit(10)
//           .get();
//
//       List<DocumentSnapshot> nextAcceptedSchools = querySnapshot.docs;
//
//       if (nextAcceptedSchools.length == 0 || nextAcceptedSchools.isEmpty) {
//         /// ie. No more Document Snapshot available in the database
//         _noMoreDocuments = true;
//
//         setState(() => _showCircularProgress = false);
//
//         return;
//       }
//
//       if (nextAcceptedSchools.length < 10) _noMoreDocuments = true;
//
//       setState(() {
//         _showCircularProgress = false;
//         _schoolAcceptedList.addAll(nextAcceptedSchools);
//       });
//
//       _hasGottenNextDocData = true;
//
//       _shouldRunCheck = true;
//     }
//   }
//
//   /// Widget method responsible for handling/displaying accepted school cards
//   Widget _schoolAcceptedWidgets() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: _schoolAcceptedList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return SchCardComponent(
//                 onPressed: () {},
//                 schoolName: _schoolAcceptedList[index]["schN"],
//                 schoolLocation: _schoolAcceptedList[index]["loc"],
//                 schoolState: _schoolAcceptedList[index]["st"],
//               );
//             },
//           ),
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
//           /// TODO: Restore function call
//           // fetchNextSetOfAcceptedSchools();
//         }
//       }
//     });
//
//     _getFirstSetOfAcceptedSchools();
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
//     // final sparksUser = Provider.of<User>(context, listen: false) ?? null;
//
//     return _loadingAcceptedSchools
//         ? Center(
//             child: CircularProgressIndicator(
//               backgroundColor: kADeepOrange,
//             ),
//           )
//         : _schoolAcceptedList.length == 0
//             ? Center(
//                 child: Text("No Pending Schools"),
//               )
//             : _schoolAcceptedWidgets();
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }
