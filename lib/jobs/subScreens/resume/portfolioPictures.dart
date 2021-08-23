import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/portfolioComponents.dart';
import 'package:sparks/jobs/subScreens/resume/singlePortfolio.dart';
import 'package:sparks/jobs/subScreens/resume/uploadPortfolioImages.dart';

class PortfolioImages extends StatefulWidget {
  @override
  _PortfolioImagesState createState() => _PortfolioImagesState();
}

class _PortfolioImagesState extends State<PortfolioImages> {
  Color selectionColor = Colors.black;
  bool onClick = false;
  String? clickedId = "1234566";
  Stream? categoryDisplay;

  void fetchAndSetDefaultCategory() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('PortfolioImagesCategory')
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
                          .collection('PortfolioImagesCategory')
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
                                              UploadPortfolioImages());
                                    }
                                  },
                                  child: Text(
                                    'No Category',
                                  ),
                                  textColor: Colors.white,
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
                                  child: FirstImageShow(
                                    imageUrl: category['fImg'],
                                    description:
                                        "${ReusableFunctions.smallSentence(26, 26, category['cgt'])}"
                                        " (${category['clt']})",
                                    colour: clickedId == category['id']
                                        ? Colors.orangeAccent
                                        : Colors.white38,
                                  ),
                                );
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
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            UploadPortfolioImages());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                      Text(
                                        'Photos',
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
                              .collection('PortfolioImagesView')
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
                                      backgroundColor: Colors.red,
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
                                      'No Pictures',
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              DocumentSnapshot images = snapshot.data!.docs[0];

                              Map<String, dynamic> data =
                                  images.data() as Map<String, dynamic>;
                              ProfessionalStorage.portfolioImageUrls =
                                  data["fImg"];
                              ProfessionalStorage.portfolioImageSingleCategory =
                                  data["cgt"];
                              ProfessionalStorage.portfolioImageLike =
                                  data["likes"];
                              return Column(
                                children: [
                                  Container(
                                    child: Text(
                                      ReusableFunctions.smallSentence(
                                          30, 30, data["cgt"]),
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(18),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: screenData.height * 0.88,
                                    child: GridView.count(
                                      scrollDirection: Axis.vertical,
                                      crossAxisCount: 3,
                                      children: List.generate(
                                          data["fImg"].length, (index) {
                                        return Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              ProfessionalStorage
                                                  .portfolioImageIndex = index;
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          SinglePortfolio()));
                                            },
                                            child: SecondImageShow(
                                              imageUrl: data["fImg"][index],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
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
