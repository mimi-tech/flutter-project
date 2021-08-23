import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sparks/Alumni/apply-jobs.dart';
import 'package:sparks/Alumni/jobsdetails.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'color/colors.dart';
import 'strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Jobs extends StatefulWidget {
  @override
  JobsState createState() => JobsState();
}

class JobsState extends State<Jobs> {
  TextEditingController schoolSearchController = TextEditingController();

  List<String> uche = [
    kAppBarSchoolEvents,
    kAppBarJobs,
    kAppBarPromotions,
    kAppBarScholarship,
    kAppBarInternship,
    kAppBarCareerService,
    kAppBarAlumniProject
  ];
  void checkJobsStatus(status, schoolAccountId) {
    FirebaseFirestore.instance
        .collection('jobsApplied')
        .where('status', isEqualTo: status)
        .where('schAccId', isEqualTo: schoolAccountId)
        .get()
        .then((myDocuments) {
      print("${myDocuments.docs.length}");
    });
  }

  int _value = 0;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final sparksUser = Provider.of<User>(context, listen: false) ?? null;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 9.0),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: kAGrey.withOpacity(0.8),
                        )
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: "search",
                            hintStyle: TextStyle(
                              color: kPrimaryColorDark.withOpacity(0.5),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset(
                          "images/alumni/searchbutton.svg",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AlumniJobs')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // final jobsApplieds = snapshot.data.docs;

                      List<Map<String, dynamic>?> jobsApplieds =
                          snapshot.data!.docs.map((DocumentSnapshot doc) {
                        return doc.data as Map<String, dynamic>?;
                      }).toList();
                      if (jobsApplieds.isEmpty) {
                        return Center(
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8))),
                              child: Text(
                                "No Jobs Available",
                                style: TextStyle(
                                  fontFamily: "Rajdhani",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: kAWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        List<Widget> cardWidgets = [];
                        for (var jobsApplied in jobsApplieds) {
                          final cardWidget =
                              JobsCards(jobsApplied: jobsApplied);
                          cardWidgets.add(cardWidget);
                        }
                        return Column(
                          children: cardWidgets,
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      print('waiting');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
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
                              backgroundColor: Colors.lightBlueAccent,
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
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ]),
          ],
        ),
      ),
    );
  }
}

class JobsCards extends StatelessWidget {
  const JobsCards({
    Key? key,
    required this.jobsApplied,
  }) : super(key: key);

  // final DocumentSnapshot jobsApplied;
  final Map<String, dynamic>? jobsApplied;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 15.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.21,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: kADarkGrey,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            jobsApplied!['jbTitle'] ?? "jobs",
                            style: new TextStyle(
                                color: kAWhite,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              jobsApplied!['slrMnm'] ?? "jobs",
                              style: new TextStyle(
                                  color: kAWhite,
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                          Text(
                            "-",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              jobsApplied!['slrMxm'] ?? "jobs",
                              style: new TextStyle(
                                  color: kAWhite,
                                  fontFamily: 'Rajdhani',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ),
                          Text(
                            "salary",
                            style: TextStyle(
                                color: kAWhite,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          SizedBox(
                            width: 23.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  width: 45.0,
                                  height: 45.0,
                                  child: CachedNetworkImage(
                                    imageUrl: jobsApplied!['sl'] ??
                                        "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.0,
                                        left: 0.1,
                                        right: 4.1,
                                      ),
                                      child: Image.asset(
                                          'images/alumni/building.png'),
                                      height: 10.91,
                                      width: 8.89,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: 5.0, top: 14.0),
                                      child: Image.asset(
                                          'images/alumni/maplocation.png'),
                                      height: 11.0,
                                      width: 7.7,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10.0, left: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                jobsApplied!['compNme'] ??
                                                    "jobs",
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11.0),
                                              ),
                                              SizedBox(
                                                height: 14.0,
                                              ),
                                              Text(
                                                jobsApplied!['location'] ??
                                                    "jobs",
                                                style: TextStyle(
                                                    fontFamily: 'Rajdhani',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    kAppBarSkills,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Rajdhani',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4.0),
                                  child: Text("  :"),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8.0, top: 5.0),
                                  child: Text(
                                    jobsApplied!['skills'] ?? "jobs",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Rajdhani',
                                        fontSize: 12.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 2.0, top: 6.0),
                                        child: Image.asset(
                                            'images/alumni/work.png'),
                                        height: 11,
                                        width: 8.36,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 0.0, top: 5.0),
                                        child: Text(
                                          jobsApplied!['jbCaty'] ?? "jobs",
                                          style: TextStyle(
                                              fontFamily: 'Rajdhani',
                                              fontSize: 13.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: JobsDetails()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        right: 0.0,
                                        left: 0.0,
                                      ),
                                      alignment: Alignment.center,
                                      color: kALemonBlue,
                                      height: 21,
                                      width: 54,
                                      child: Text(
                                        kAppBarDetails,
                                        style: TextStyle(
                                          fontFamily: 'Rajdhani',
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: Apply()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 0.0,
                                        right: 5.0,
                                      ),
                                      alignment: Alignment.center,
                                      color: kADeepOrange,
                                      height: 21,
                                      width: 54,
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                          fontFamily: 'Rajdhani',
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: kADarkGrey,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                jobsApplied!['prfSn1'] ?? "jobs",
                                style: new TextStyle(
                                    color: kASkyPink,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              color: kAOffPink,
                              height: 17.0,
                              width: 50.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.008,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                jobsApplied!['prfSn2'] ?? "jobs",
                                style: new TextStyle(
                                    color: kASkyPink,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              color: kAOffPink,
                              height: 17.0,
                              width: 50.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 12.03,
                              child: Image.asset(
                                  'images/alumni/Date_and_time.png'),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2.0),
                              child: Text(
                                jobsApplied!['jbTleF'] ?? "jobs",
                                style: new TextStyle(
                                    color: kABlack,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2.0),
                              child: Text(
                                '  -  ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 12.03,
                              child: Image.asset('images/alumni/Group.png'),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.008,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2.0),
                              child: Text(
                                jobsApplied!['jbTleT'] ?? "jobs",
                                style: new TextStyle(
                                    color: kABlack,
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
