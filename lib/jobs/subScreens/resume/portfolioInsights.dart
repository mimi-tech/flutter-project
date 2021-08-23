import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/portfolioComponents.dart';
import 'package:sparks/jobs/subScreens/resume/uploadPortfolioInsight.dart';
import 'package:sparks/jobs/subScreens/resume/viewInsight.dart';

class PortfolioInsight extends StatefulWidget {
  @override
  _PortfolioInsightState createState() => _PortfolioInsightState();
}

class _PortfolioInsightState extends State<PortfolioInsight> {
  Color selectionColor = Colors.black;
  bool onClick = false;
  String? clickedId = "1234566";
  Stream? categoryDisplay;

  void fetchAndSetDefaultCategory() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('PortfolioInsightCategory')
        .where("userId", isEqualTo: ProfessionalStorage.id)
        .orderBy('time', descending: true)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    setState(() {
      clickedId = documents[0]['id'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndSetDefaultCategory();
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    return Container(
      child: Column(children: <Widget>[
        Expanded(
          child: Container(
            height: screenData.height * 0.81,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: screenData.width * 0.32,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('PortfolioInsightCategory')
                          .where("userId", isEqualTo: ProfessionalStorage.id)
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.data!.docs.length == 0) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  color: kLight_orange,
                                  onPressed: () {
                                    if (UserStorage.loggedInUser.uid ==
                                        ProfessionalStorage.id) {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              UploadPortfolioInsight());
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'No Insight',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot tempDoc =
                                    snapshot.data!.docs[index];

                                Map<String, dynamic> category =
                                tempDoc.data() as Map<String, dynamic>;
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        clickedId = category['id'];
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 0.0, 0.0),
                                      child: Column(
                                        children: <Widget>[
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: clickedId ==
                                                          category['id']
                                                      ? Colors.orangeAccent
                                                      : Colors.white38,
                                                  width: 4),
                                              //borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                height: ScreenUtil()
                                                    .setHeight(120.0),
                                                width: ScreenUtil()
                                                    .setWidth(190.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: category['tImg'],
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 10.0),
                                            child: UserStorage
                                                        .loggedInUser.uid ==
                                                    ProfessionalStorage.id
                                                ? GestureDetector(
                                                    onTap: () {
//                                              ProfileStorage.insightId = category.data['id'];
//
//                                              Navigator.push(
//                                                  context,
//                                                  PageTransition(
//                                                      type: PageTransitionType.rightToLeft,
//                                                      child: EditInsight()));
                                                    },
                                                    child: Text(
                                                      "(${category['inLt']})",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(15),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                : Text(''),
                                          ),
                                        ],
                                      ),
                                    ));
                              });
                        }
                      }),
                ),
                SizedBox(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    height: screenData.height * 0.88,
                    width: screenData.width * 0.02,
                    color: vd,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  width: screenData.width * 0.60,
                  child: ListView(
                    children: <Widget>[
                      UserStorage.loggedInUser.uid == ProfessionalStorage.id
                          ? Row(
                              children: [
                                Container(
                                    child: RaisedButton(
                                  color: kLight_orange,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: UploadPortfolioInsight()));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                      Text(
                                        'create new insight',
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            )
                          : Container(),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('PortfolioInsightContent')
                              .where("userId",
                                  isEqualTo: ProfessionalStorage.id)
                              .where("id", isEqualTo: clickedId)
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            ProfessionalStorage.portfolioImageClickedId =
                                clickedId;
                            if (!snapshot.hasData) {
                              return Container(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.data!.docs.length == 0) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Insight Available',
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              DocumentSnapshot insights = snapshot.data!.docs[0];

                              Map<String, dynamic> data =
                                  insights.data() as Map<String, dynamic>;

                              var insightsList = data['insight'];

                              return Column(
                                children: [
                                  for (var i = 0; i < insightsList.length; i++)
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            ProfileStorage.insightContent =
                                                insightsList.elementAt(i);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: ViewInsight()));
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      25.0, 0.0, 0.0, 10.0),
                                                  child: Text(
                                                    insightsList.elementAt(
                                                        i)['insightTitle'],
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: SecondImageShow(
                                                  imageUrl: insightsList
                                                      .elementAt(i)['image'],
                                                  colour: Colors.orangeAccent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              15.0, 0.0, 95.0, 0.0),
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
