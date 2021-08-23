// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sparks/alumni/color/colors.dart';
// import 'package:sparks/alumni/components/alumni_card_not_joined.dart';
// import 'package:sparks/alumni/models/alumni_user.dart';
// import 'package:sparks/alumni/services/alumni_db.dart';
// import 'package:sparks/alumni/utilities/show_toast_alumni.dart';
// import 'package:sparks/jobs/components/generalComponent.dart';
//
// /// TODO: Delete this class if not in use
// class SchoolCardNew extends StatelessWidget {
//   final DocumentSnapshot school;
//
//   const SchoolCardNew({
//     Key key,
//     required this.school,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("users")
//           .doc(school.data()["id"])
//           .collection("School")
//           .doc(school.id)
//           .collection("schoolUsers")
//           .doc(UserStorage.loggedInUser.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.data == null &&
//             snapshot.connectionState == ConnectionState.waiting) {
//           /// TODO: Implement Shimmer here to indicate loading card
//           return Text("waiting...");
//         } else {
//           DocumentSnapshot docSnap = snapshot.data;
//
//           if (snapshot.data.exists) {
//             return SizedBox.shrink();
//           } else {
//             return SchCardComponent(
//               onPressed: () async {
//                 /// Assigning the values to the model fields.
//                 ///
//                 /// NOTE: This model will be used to set the data into the
//                 /// schoolPending collection
//                 JoinSchool joinSchool = JoinSchool(
//                   id: UserStorage.loggedInUser.uid,
//                   accId: school.data()["id"],
//                   schId: school.id,
//                   st: school.data()["st"],
//                   ts: DateTime.now().millisecondsSinceEpoch,
//                 );
//
//                 try {
//                   DocumentSnapshot docSnap = await AlumniDB()
//                       .checkIfPendingUser(
//                           schMasterId: school.data()["id"],
//                           schId: school.id,
//                           userId: UserStorage.loggedInUser.uid);
//
//                   if (docSnap.exists) {
//                     /// TODO: Show toast here
//                     ShowToastAlumni.showToastMessage(
//                       toastMessage: "You have a pending request",
//                       gravity: ToastGravity.CENTER,
//                       textColor: Colors.white,
//                       bgColor: kADeepOrange,
//                     );
//                   } else {
//                     /// If the document doesn't exist, the [joinSchool] data is
//                     /// then written into the "pendingUser" Collection and a
//                     /// corresponding toast shown to the user
//                     AlumniDB()
//                         .joinSchoolAddPendingUser(
//                       schMasterId: school.data()["id"],
//                       schId: school.id,
//                       userId: UserStorage.loggedInUser.uid,
//                       joinSchoolData: joinSchool,
//                     )
//                         .then((noValue) {
//                       ShowToastAlumni.showToastMessage(
//                         toastMessage: "Request sent!",
//                         gravity: ToastGravity.CENTER,
//                         textColor: Colors.white,
//                         bgColor: kADeepOrange,
//                       );
//                     }).catchError((onError) {
//                       print("SchoolCardNew: $onError");
//                       ShowToastAlumni.showToastMessage(
//                         toastMessage: "Something went wrong\nTry again",
//                         gravity: ToastGravity.CENTER,
//                         textColor: Colors.white,
//                         bgColor: kADeepOrange,
//                       );
//                     });
//                   }
//                 } catch (e) {
//                   print(e);
//                   ShowToastAlumni.showToastMessage(
//                     toastMessage: "Something went wrong\nTry again",
//                     gravity: ToastGravity.CENTER,
//                     textColor: Colors.white,
//                     bgColor: kADeepOrange,
//                   );
//                 }
//               },
//               schoolName: school.data()["schN"],
//               schoolCity: school.data()["loc"],
//               schoolState: school.data()["st"],
//             );
//           }
//         }
//       },
//     );
//   }
// }
