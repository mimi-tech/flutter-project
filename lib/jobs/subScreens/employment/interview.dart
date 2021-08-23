import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/job_shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Interview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<Interview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('sentInterviewDetails')
            .where('uEmail', isEqualTo: UserStorage.loggedInUser.email)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final interviewRequests = snapshot.data.docs;

            List<Map<String, dynamic>?> interviewRequests =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (interviewRequests.isEmpty) {
              return NoResult(
                message: "No Interview Request Available",
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? interviewRequest in interviewRequests) {
                DateTime date = DateTime.parse(interviewRequest!['jtm']);

                String displayDay = timeago.format(date);
                final cardWidget = JobsInterviewCard(
                    interviewRequest: interviewRequest, displayDay: displayDay);
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return JobShimmer();
          } else if (snapshot.hasError) {
            print('has error');
            return JobShimmer();
          } else {
            print('nothing');
            return JobShimmer();
          }
        },
      ),
    );
  }
}
