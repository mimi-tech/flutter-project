import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/fab_enum.dart';
import 'package:sparks/app_entry_and_home/sparks_enums/sparks_bottom_munus_enums.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/jobEdit/editone.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListedJobs extends StatefulWidget {
  @override
  _ListedJobsState createState() => _ListedJobsState();
}

class _ListedJobsState extends State<ListedJobs> {
  SparksBottomMenu bottomMenuPressed = SparksBottomMenu.JOBS;
  FabActivity? fabCurrentState;
  bool? isPressed;
  bool showSpinner = false;

  void fetchEditDetails(mainId, jobId) async {
    setState(() {
      showSpinner = true;
    });
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(mainId)
        .collection('companyJobs')
        .where('id', isEqualTo: jobId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      EditJobFormStorage.jobId = data["id"];
      EditJobFormStorage.companyId = data["cid"];
      EditJobFormStorage.logoUrl = data["lur"];
      EditJobFormStorage.jobType = data["jtp"];
      EditJobFormStorage.jobTitle = data["jtl"];
      EditJobFormStorage.jobCategory = data["jcg"];
      EditJobFormStorage.jobSummary = data["sum"];
      EditJobFormStorage.jobBenefit = data["jbt"];
      EditJobFormStorage.jobQualification = data["jqt"];
      EditJobFormStorage.responsibility = data["jrSt"];
      EditJobFormStorage.skills = data["skl"];
      EditJobFormStorage.companyName = data["cnm"];
      EditJobFormStorage.jobLocation = data["jlt"];
      EditJobFormStorage.salaryRangeMin = data["srn"];
      EditJobFormStorage.salaryRangeMax = data["srx"];
      EditJobFormStorage.mainCompanyId = data["mainId"];
    });

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .doc(UserStorage.loggedInUser.uid)
            .collection('companyJobs')
            .where('cid', isEqualTo: CompanyStorage.pageId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final jobs = snapshot.data.docs;

            List<Map<String, dynamic>?> jobs =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (jobs.isEmpty) {
              return NoResult(
                message: "No Job Listed",
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? job in jobs) {
                DateTime date = DateTime.parse(job!['jtm']);

                String displayDay = timeago.format(date);

                // for min and max salary
                int max = int.parse(job['srx']);
                int min = int.parse(job['srn']);
                final cardWidget = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: double.infinity,
                          minHeight: ScreenUtil().setSp(150)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 32,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: job['lur'],
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                width: 40.0,
                                                height: 40.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ReusableFunctions.smallSentence(
                                              15, 15, job['cnm']),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(18.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        ReusableFunctions.smallSentence(
                                            19, 19, job['jtl']),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(16.0),
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_location,
                                            color: kNavBg,
                                            size: ScreenUtil().setSp(16.0),
                                          ),
                                          Text(
                                            ReusableFunctions.smallSentence(
                                                19, 19, job['jlt']),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(16.0),
                                                  fontWeight: FontWeight.bold,
                                                  color: kShade),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.orange,
                                            size: ScreenUtil().setSp(14.0),
                                          ),
                                        ),
                                        Text(
                                          displayDay,
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14.0),
                                                fontWeight: FontWeight.bold,
                                                color: kShade),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Job Type',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(18.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "${ReusableFunctions.capitalizeWords(job['jcg'])} - ${ReusableFunctions.capitalizeWords(job['jtp'])}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(13.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          '\$${ReusableFunctions.numberFormatter(min)} - \$${ReusableFunctions.numberFormatter(max)}',
                                          style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16.0),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        EditJobFormStorage.jobId = job["id"];
                                        EditJobFormStorage.companyId =
                                            job["cid"];
                                        EditJobFormStorage.logoUrl = job["lur"];
                                        EditJobFormStorage.jobType = job["jtp"];
                                        EditJobFormStorage.jobTitle =
                                            job["jtl"];
                                        EditJobFormStorage.jobCategory =
                                            job["jcg"];
                                        EditJobFormStorage.jobSummary =
                                            job["sum"];
                                        EditJobFormStorage.jobBenefit =
                                            job["jbt"];
                                        EditJobFormStorage.jobQualification =
                                            job["jqt"];
                                        EditJobFormStorage.responsibility =
                                            job["jrSt"];
                                        EditJobFormStorage.skills = job["skl"];
                                        EditJobFormStorage.companyName =
                                            job["cnm"];
                                        EditJobFormStorage.jobLocation =
                                            job["jlt"];
                                        EditJobFormStorage.salaryRangeMin =
                                            job["srn"];
                                        EditJobFormStorage.salaryRangeMax =
                                            job["srx"];
                                        EditJobFormStorage.mainCompanyId =
                                            job["mainId"];
                                        EditJobFormStorage.status =
                                            job["status"];
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: EditOne()));
                                      },
                                      child: Text("Edit"),
                                      color: kLight_orange,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
    );
  }
}
