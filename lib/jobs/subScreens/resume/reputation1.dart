import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class Reputation1 extends StatefulWidget {
  @override
  _Reputation1State createState() => _Reputation1State();
}

class _Reputation1State extends State<Reputation1> {
  int starCount = 5;
  double? ratingCount;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    ratingCount = 1.0;

    ProfessionalStorage.resume = FirebaseFirestore.instance
        .collection('professionals')
        .doc(ProfessionalStorage.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: ProfessionalStorage.resume,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          Map<String, dynamic> resumeDetails =
              snapshot.data as Map<String, dynamic>;

          return Container(
            child: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: kBackgroundColor,
                    ),
                    height: screenData.height * 0.70,
                    width: screenData.width * 0.97,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                            child: Text(
                              'REPUTATION',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(25.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: kNavBg,
                                  ),
                                  // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                  height: ScreenUtil().setHeight(30.0),
                                  width: ScreenUtil().setWidth(60.0),
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      Text(
                                        ProfessionalStorage.isLoggedInUser(
                                                UserStorage.loggedInUser.uid,
                                                ProfessionalStorage.id)
                                            ? resumeDetails['avgRt'].toString()
                                            : ratingCount.toString(),
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(18.0),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (ProfessionalStorage.isLoggedInUser(
                                        UserStorage.loggedInUser.uid,
                                        ProfessionalStorage.id) ==
                                    false)
                                  RatingBar.builder(
                                    initialRating: 1,
                                    minRating: 1,
                                    unratedColor: Colors.white,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: starCount,
                                    itemSize: 25,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        ratingCount = rating;
                                      });
                                    },
                                  )
                              ],
                            ),
                          ),
                          if (ProfessionalStorage.isLoggedInUser(
                                  UserStorage.loggedInUser.uid,
                                  ProfessionalStorage.id) ==
                              false)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    //checking if this user has rated before
                                    final QuerySnapshot result =
                                        await FirebaseFirestore
                                            .instance
                                            .collection('professionals')
                                            .doc(ProfessionalStorage.id)
                                            .collection("professionalRatings")
                                            .where(
                                                'rId',
                                                isEqualTo: UserStorage
                                                    .loggedInUser.uid)
                                            .where('reMl',
                                                isEqualTo: UserStorage
                                                    .loggedInUser.email)
                                            .get();
                                    final List<DocumentSnapshot> documents =
                                        result.docs;

                                    //if yes update
                                    if (documents.length >= 1) {
                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection('professionals')
                                              .doc(ProfessionalStorage.id)
                                              .collection("professionalRatings")
                                              .doc(
                                                  UserStorage.loggedInUser.uid);
                                      documentReference.update({
                                        "rt": ratingCount,
                                        "date": DateTime.now()
                                      });

                                      setState(() {
                                        showSpinner = false;
                                      });

                                      ReusableFunctions.showToastMessage2(
                                          "submitted successfully",
                                          Colors.white,
                                          Colors.green);
                                    }

                                    // if no rate
                                    else {
                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection('professionals')
                                              .doc(ProfessionalStorage.id)
                                              .collection("professionalRatings")
                                              .doc(
                                                  UserStorage.loggedInUser.uid);
                                      documentReference.set({
                                        "rId": UserStorage.loggedInUser.uid,
                                        "userId": ProfessionalStorage.id,
                                        "rt": ratingCount,
                                        "reMl": UserStorage.loggedInUser.email,
                                        "un": GlobalVariables
                                            .loggedInUserObject.un,
                                        "date": DateTime.now()
                                      });

                                      setState(() {
                                        showSpinner = false;
                                      });

                                      ReusableFunctions.showToastMessage2(
                                          "submitted successfully",
                                          Colors.white,
                                          Colors.green);
                                    }
                                  },
                                  child: Text("submit")),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                              child: Column(
                                children: <Widget>[
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().setWidth(380.0),
                                      minHeight: ScreenUtil().setHeight(380.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.white,
                                      ),
                                      width: ScreenUtil().setWidth(380.0),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0.0, 25.0, 0.0, 0.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 52,
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: resumeDetails[
                                                        'imageUrl'],
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: ScreenUtil()
                                                        .setHeight(500.0),
                                                    width: ScreenUtil()
                                                        .setWidth(500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              ReusableFunctions.capitalizeWords(
                                                  resumeDetails['name'])!,
                                              style: GoogleFonts.rajdhani(
                                                textStyle: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(18.0),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 0.0, 10.0, 5.0),
                                              child: ReadMoreText(
                                                resumeDetails["abtMe"],
                                                trimLines: 6,
                                                colorClickableText: kMore,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText:
                                                    ' ...Show more',
                                                trimExpandedText:
                                                    ' ...Show less',
                                                textAlign: TextAlign.center,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          );
        });
  }
}
