// import 'dart:collection';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sparks/Alumni/components/alumni_card_not_joined.dart';
// import 'package:sparks/alumni/color/colors.dart';
// import 'package:sparks/alumni/services/alumni_db.dart';
// import 'package:sparks/alumni/utilities/show_toast_alumni.dart';
// import 'package:sparks/jobs/components/generalComponent.dart';
// import 'package:sparks/market/utilities/market_const.dart';
//
// class SchoolPending extends StatefulWidget {
//   @override
//   _SchoolPendingState createState() => _SchoolPendingState();
// }
//
// class _SchoolPendingState extends State<SchoolPending>
//     with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
//   ScrollController _scrollController;
//
//   AnimationController _animationController;
//
//   /// Variable holding the list of pending schools a given user has pending request
//   List<DocumentSnapshot> _schoolPendingList = [];
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
//   /// [fetchNextSetOfPendingSchools] to fetch new set of document data is already
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
//   /// user has pending requests for
//   void _getFirstSetOfPendingSchools() async {
//     setState(() => _loadingPendingSchools = true);
//
//     _schoolPendingList?.clear();
//
//     try {
//       FirebaseFirestore.instance
//           .collectionGroup("pendingUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .snapshots()
//           .listen((event) => onPendingUserEventChange(event.docChanges));
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("pendingUsers")
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
//       /// If [_schoolPendingList] is empty, then the [_getFirstSetOfPendingSchools]
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
//       _schoolPendingList = removeDuplicatePendingSch;
//     } catch (e) {
//       print("_getFirstSetOfPendingSchools: $e");
//     }
//
//     if (mounted) {
//       setState(() => _loadingPendingSchools = false);
//     }
//   }
//
//   /// Method responsible for reacting/effecting changes listened/gotten from the
//   /// "pendingUsers" collection group
//   void onPendingUserEventChange(List<DocumentChange> documentChange) async {
//     for (DocumentChange change in documentChange) {
//       if (change.type == DocumentChangeType.removed) {
//         List<DocumentSnapshot> currentPendingSchools = [];
//         currentPendingSchools = _schoolPendingList;
//
//         if (currentPendingSchools.length == 0 || currentPendingSchools.isEmpty)
//           return;
//
//         int indexWhere = currentPendingSchools.indexWhere((sch) {
//           return change.doc.id == sch.data()["id"];
//         });
//
//         if (mounted) {
//           _schoolPendingList.removeAt(indexWhere);
//           setState(() {});
//         }
//       }
//
//       if (change.type == DocumentChangeType.added) {
//         if (change.doc.exists) {
//           if (mounted) {
//             setState(() {
//               _schoolPendingList.insert(0, change.doc);
//             });
//           }
//         }
//       }
//     }
//   }
//
//   /// Method responsible for fetching the next set of data if any from the
//   /// "pendingUsers" collection group
//   void fetchNextSetOfPendingSchools() async {
//     if (_shouldCheck && !_noMoreDocuments) {
//       _shouldRunCheck = false;
//       _shouldCheck = false;
//
//       _hasGottenNextDocData = false;
//
//       List<DocumentSnapshot> prevDocSnapshot = _schoolPendingList;
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collectionGroup("pendingUsers")
//           .where("id", isEqualTo: UserStorage.loggedInUser.uid)
//           .orderBy("ts", descending: true)
//           .startAfterDocument(prevDocSnapshot[prevDocSnapshot.length - 1])
//           .limit(10)
//           .get();
//
//       List<DocumentSnapshot> nextPendingSchools = querySnapshot.docs;
//
//       if (nextPendingSchools.length == 0 || nextPendingSchools.isEmpty) {
//         /// i.e. No more Document Snapshot available in the database
//         _noMoreDocuments = true;
//
//         setState(() => _showCircularProgress = false);
//
//         return;
//       }
//
//       if (nextPendingSchools.length < 10) _noMoreDocuments = true;
//
//       setState(() {
//         _showCircularProgress = false;
//         _schoolPendingList.addAll(nextPendingSchools);
//       });
//
//       _hasGottenNextDocData = true;
//
//       _shouldRunCheck = true;
//     }
//   }
//
//   /// Widget method responsible for handling/displaying pending school cards
//   Widget _schoolPendingWidgets() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _schoolPendingList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return SchCardComponent(
//                   schoolName: _schoolPendingList[index].data()["schN"],
//                   schoolLocation: _schoolPendingList[index].data()["loc"],
//                   schoolState: _schoolPendingList[index].data()["st"],
//                   onPressed: () {
//                     AlumniDB()
//                         .removePendingRequest(
//                       schMasterId: _schoolPendingList[index].data()["accId"],
//                       schId: _schoolPendingList[index].data()["schId"],
//                       userId: UserStorage.loggedInUser.uid,
//                     )
//                         .then((noValue) {
//                       ShowToastAlumni.showToastMessage(
//                         toastMessage: "Request removed",
//                         gravity: ToastGravity.CENTER,
//                         textColor: Colors.white,
//                         bgColor: kADeepOrange,
//                       );
//                     }).catchError((onError) {
//                       ShowToastAlumni.showToastMessage(
//                         toastMessage: "Something went wrong\nTry again",
//                         gravity: ToastGravity.CENTER,
//                         textColor: Colors.white,
//                         bgColor: kADeepOrange,
//                       );
//                     });
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
//           fetchNextSetOfPendingSchools();
//         }
//       }
//     });
//
//     _getFirstSetOfPendingSchools();
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
//     //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
//
//     return _loadingPendingSchools
//         ? Center(
//             child: CircularProgressIndicator(
//               backgroundColor: kADeepOrange,
//             ),
//           )
//         : _schoolPendingList.length == 0
//             ? Center(
//                 child: Text("No Pending Schools"),
//               )
//             : _schoolPendingWidgets();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
