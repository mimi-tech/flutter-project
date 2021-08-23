import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/company/admin/entry.dart';
import 'package:sparks/jobs/subScreens/company/companyAccessPage.dart';
import 'package:sparks/jobs/subScreens/company/createJobs/screenOne.dart';

class ManageCompanies extends StatefulWidget {
  @override
  _ManageCompaniesState createState() => _ManageCompaniesState();
}

class _ManageCompaniesState extends State<ManageCompanies> {
  bool showSpinner = false;

  String correctPin = "";
  String correctEmail = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  //TODO: List of scrollable content for company page.
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => CompanyAccessPage());
                              },
                              color: Colors.black,
                              textColor: Colors.white,
                              child: Text("Manage Another Company Account"),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('managedCompanyAccounts')
                              .doc(UserStorage.loggedInUser.uid)
                              .collection('companyAccounts')
                              .orderBy('ts', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // QuerySnapshot querySnapshot = snapshot.data;
                              // List<QueryDocumentSnapshot> companies =
                              //     querySnapshot.docs;

                              List<Map<String, dynamic>?> companies = snapshot
                                  .data!.docs
                                  .map((DocumentSnapshot doc) {
                                return doc.data as Map<String, dynamic>?;
                              }).toList();
                              if (companies.isEmpty) {
                                return NoResult(
                                  message: "No Company Found",
                                );
                              } else {
                                List<Widget> cardWidgets = [];
                                for (Map<String, dynamic>? singleCompany
                                    in companies) {
                                  final companyEmail = singleCompany!['em'];
                                  final companyUniqueId =
                                      singleCompany['comp_id'];
                                  final companyLocation = singleCompany['city'];
                                  final companyName = singleCompany['name'];
                                  final companyPin = singleCompany['cpin'];
                                  final userCompanyId = singleCompany['ugc'];
                                  final companyId = singleCompany['comp_id'];
                                  final createdTime = singleCompany['date'];
                                  final companyLogo = singleCompany['logo'];

                                  final cardWidget = Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Card(
                                      elevation: 10,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 20.0, 0.0, 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: ScreenUtil()
                                                      .setHeight(50.0),
                                                  width:
                                                      ScreenUtil().setWidth(50),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 32,
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: companyLogo,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        fit: BoxFit.cover,
                                                        width: 40.0,
                                                        height: 40.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    companyName,
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(25.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kNavBg),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.date_range,
                                                        color: Colors.lightBlue,
                                                        size: 25.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          createdTime,
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            textStyle: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            15.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.add_location,
                                                        color: Colors.red,
                                                        size: 25.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          companyLocation,
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            textStyle: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            16.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 20.0, 0.0, 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                RaisedButton(
                                                  onPressed: () {
                                                    PostJobFormStorage
                                                            .mainCompanyId =
                                                        userCompanyId;
                                                    PostJobFormStorage
                                                            .companyId =
                                                        companyUniqueId;
                                                    PostJobFormStorage
                                                            .companyName =
                                                        companyName;
                                                    PostJobFormStorage.logoUrl =
                                                        companyLogo;
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                CreateJobsScreenOne()));
                                                  },
                                                  color: Colors.black,
                                                  textColor: Colors.white,
                                                  child: Text('Post Job'),
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    // this is the general company id
                                                    CompanyStorage.companyId =
                                                        userCompanyId;

                                                    //this is the individual company id
                                                    CompanyStorage.pageId =
                                                        companyUniqueId;

                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child: PageOne()));
                                                  },
                                                  color: Colors.black,
                                                  textColor: Colors.white,
                                                  child: Text('Admin'),
                                                ),
                                              ],
                                            ),
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
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
