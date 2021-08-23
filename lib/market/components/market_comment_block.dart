// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sparks/market/utilities/market_const.dart';
//
// class MarketCommentBlock extends StatefulWidget {
//   final List<QueryDocumentSnapshot> docSnap;
//
//   MarketCommentBlock({required this.docSnap});
//
//   @override
//   _MarketCommentBlockState createState() => _MarketCommentBlockState();
// }
//
// class _MarketCommentBlockState extends State<MarketCommentBlock> {
//   Stream<DocumentSnapshot> streamB;
//
//   @override
//   void initState() {
//     super.initState();
//
//     for (int i = 0; i < widget.docSnap.length; i++) {
//       streamB = FirebaseFirestore.instance
//           .collection("users")
//           .doc(widget.docSnap[i].data()["id"])
//           .collection("Market")
//           .doc("marketInfo")
//           .snapshots();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.docSnap.length,
//         itemBuilder: (BuildContext context, int index) {
//           return StreamBuilder<DocumentSnapshot>(
//               stream: streamB,
//               builder: (context, picSnapshot) {
//                 String imgUrl;
//                 if (picSnapshot.hasData &&
//                     picSnapshot.connectionState == ConnectionState.active) {
//                   imgUrl = picSnapshot.data.data()["pimg"];
//                   print(imgUrl);
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.only(
//                       top: 8.0, left: 16.0, right: 16.0, bottom: 24.0),
//                   child: Row(
//                     children: <Widget>[
//                       imgUrl != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(100.0),
//                               child: CachedNetworkImage(
//                                 progressIndicatorBuilder:
//                                     (context, url, progress) => Center(
//                                   child: CircularProgressIndicator(
//                                     backgroundColor: kMarketPrimaryColor,
//                                     value: progress.progress,
//                                   ),
//                                 ),
//                                 imageUrl: imgUrl,
//                                 width: ScreenUtil().setWidth(64),
//                                 height: ScreenUtil().setHeight(64),
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : CircleAvatar(
//                               backgroundColor: kMarketPrimaryColor,
//                               radius: 32.0,
//                             ),
//                       SizedBox(
//                         width: ScreenUtil().setWidth(8),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               widget.docSnap[index].data()["un"],
//                               style: kMarketNameTextStyle,
//                             ),
//                             SizedBox(
//                               height: ScreenUtil().setHeight(8),
//                             ),
//                             Text(
//                               widget.docSnap[index].data()["cmt"],
//                               style: kMarketComment,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               });
//         });
//   }
// }
