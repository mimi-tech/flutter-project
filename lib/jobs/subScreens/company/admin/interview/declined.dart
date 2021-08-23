import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/resume/resume.dart';

class AdminInterviewDeclined extends StatefulWidget {
  @override
  _AdminInterviewDeclinedState createState() => _AdminInterviewDeclinedState();
}

class _AdminInterviewDeclinedState extends State<AdminInterviewDeclined> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('DeclinedInterviewRequests')
                .doc(CompanyStorage.companyId)
                .collection('DeclinedCompanyPage')
                .doc(CompanyStorage.pageId)
                .collection('DeclinedInterviewDetails')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // final declinedInterviewRequests = snapshot.data.docs;

                List<Map<String, dynamic>?> declinedInterviewRequests =
                    snapshot.data!.docs.map((DocumentSnapshot doc) {
                  return doc.data as Map<String, dynamic>?;
                }).toList();
                if (declinedInterviewRequests.isEmpty) {
                  return NoResult(
                    message: "No Declined Interview Request",
                  );
                } else {
                  List<Widget> cardWidgets = [];
                  for (Map<String, dynamic>? declinedInterviewRequest
                      in declinedInterviewRequests) {
                    final cardWidget = Card(
                      elevation: 6,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            minHeight: ScreenUtil().setSp(150)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 32,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            declinedInterviewRequest!['usImg'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    declinedInterviewRequest['cnm'],
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        declinedInterviewRequest['jtl'],
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(15),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'INTERVIEW INVITATION',
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${declinedInterviewRequest['uEmail']} Declined your interview Request',
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      ProfessionalStorage.id =
                                          declinedInterviewRequest['uId'];
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: Resume()));
                                    },
                                    color: kLight_orange,
                                    textColor: Colors.white,
                                    child: Text("Profile"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    cardWidgets.add(cardWidget);
                  }
                  return Column(
                    children: cardWidgets,
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                print('has error');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                );
              } else {
                print('nothing');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    ));
  }
}
