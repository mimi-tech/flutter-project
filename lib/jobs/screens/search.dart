import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/strings/jobs_Strings.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobSearch extends SearchDelegate<String?> {
  final recent = ["devops", "web developer", "app developer"];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.red,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      color: Colors.red,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("search", arrayContains: query.toLowerCase())
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
                message: kSearchResult,
              );
            } else {
              List<Widget> cardWidgets = [];
              for (var singleJob in jobs) {
                //Todo: get  datetime from database
                DateTime date = DateTime.parse(singleJob!['jtm']);

                String displayDay = timeago.format(date);
                int max = int.parse(singleJob['srx']);
                int min = int.parse(singleJob['srn']);

                final cardWidget = JobCard(
                    companyLogo: singleJob['lur'],
                    jobTitle: singleJob['jtl'],
                    companyName: singleJob['cnm'],
                    jobLocation: singleJob['jlt'],
                    minSalary: min,
                    maxSalary: max,
                    displayMin: singleJob['srn'],
                    displayMax: singleJob['srx'],
                    jobSummary: singleJob['sum'],
                    jobBenefit: singleJob['jbt'],
                    jobQualification: singleJob['jqt'],
                    responsibility: singleJob['jrSt'],
                    skills: singleJob['skl'],
                    status: singleJob['status'],
                    jobType: singleJob['jtp'],
                    jobCategory: singleJob['jcg'],
                    jobTime: displayDay,
                    jobId: singleJob['id'],
                    companyId: singleJob['cid'],
                    mainId: singleJob['mainId']);
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return NoResult(
              message: "Oops Something Went Wrong",
            );
          } else {
            return NoResult(
              message: "No Jobs Available",
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("search", arrayContains: query.toLowerCase())
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
                message: kSearchResult,
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? singleJob in jobs) {
                //Todo: get  datetime from database
                DateTime date = DateTime.parse(singleJob!['jtm']);

                String displayDay = timeago.format(date);
                int max = int.parse(singleJob['srx']);
                int min = int.parse(singleJob['srn']);

                final cardWidget = JobCard(
                    companyLogo: singleJob['lur'],
                    jobTitle: singleJob['jtl'],
                    companyName: singleJob['cnm'],
                    jobLocation: singleJob['jlt'],
                    minSalary: min,
                    maxSalary: max,
                    displayMin: singleJob['srn'],
                    displayMax: singleJob['srx'],
                    jobSummary: singleJob['sum'],
                    jobBenefit: singleJob['jbt'],
                    jobQualification: singleJob['jqt'],
                    responsibility: singleJob['jrSt'],
                    skills: singleJob['skl'],
                    status: singleJob['status'],
                    jobType: singleJob['jtp'],
                    jobCategory: singleJob['jcg'],
                    jobTime: displayDay,
                    jobId: singleJob['id'],
                    companyId: singleJob['cid'],
                    mainId: singleJob['mainId']);
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return NoResult(
              message: "Oops Something Went Wrong",
            );
          } else {
            return NoResult(
              message: "No Jobs Available",
            );
          }
        },
      ),
    );
  }
}

class ProfessionalSearch extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.red,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      color: Colors.red,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professionals')
            .where("search", arrayContains: query.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final professionals = snapshot.data.docs;

            List<Map<String, dynamic>?> professionals =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (professionals.isEmpty) {
              return NoResult(
                message: "No Result",
              );
            } else {
              List<Widget> cardWidgets = [];

              for (Map<String, dynamic>? professional in professionals) {
                int max = int.parse(professional!['srx']);
                int min = int.parse(professional['srn']);
                final professionalName =
                    ReusableFunctions.capitalizeWords(professional['name']);
                final professionalProfile = professional['imageUrl'];
                final professionalLocation =
                    ReusableFunctions.capitalizeWords(professional['location']);
                final date = professional['date'];
                final jobTitle =
                    ReusableFunctions.capitalizeWords(professional['pTitle']);
                final jobType =
                    ReusableFunctions.capitalizeWords(professional['ajt']);
                final professionalId = professional['userId'];
                final jobCategory =
                    ReusableFunctions.capitalizeWords(professional['ajc']);
                final status =
                    ReusableFunctions.capitalizeWords(professional['status']);
                final minSalary = min;
                final maxSalary = max;
                final starRating = professional['avgRt'];

                final cardWidget = ProfessionalCard(
                  professionalProfile: professionalProfile,
                  professionalName: professionalName,
                  jobTitle: jobTitle,
                  professionalLocation: professionalLocation,
                  jobCategory: jobCategory,
                  jobType: jobType,
                  professionalId: professionalId,
                  date: date,
                  status: status,
                  minSalary: minSalary,
                  maxSalary: maxSalary,
                  starRating: starRating,
                );
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professionals')
            .where("search", arrayContains: query.toLowerCase())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final professionals = snapshot.data.docs;

            List<Map<String, dynamic>?> professionals =
                snapshot.data!.docs.map((DocumentSnapshot doc) {
              return doc.data as Map<String, dynamic>?;
            }).toList();
            if (professionals.isEmpty) {
              return NoResult(
                message: "No Result",
              );
            } else {
              List<Widget> cardWidgets = [];
              for (Map<String, dynamic>? professional in professionals) {
                int max = int.parse(professional!['srx']);
                int min = int.parse(professional['srn']);
                final professionalName =
                    ReusableFunctions.capitalizeWords(professional['name']);
                final professionalProfile = professional['imageUrl'];
                final professionalLocation =
                    ReusableFunctions.capitalizeWords(professional['location']);
                final date = professional['date'];
                final jobTitle =
                    ReusableFunctions.capitalizeWords(professional['pTitle']);
                final jobType =
                    ReusableFunctions.capitalizeWords(professional['ajt']);
                final professionalId = professional['userId'];
                final jobCategory =
                    ReusableFunctions.capitalizeWords(professional['ajc']);
                final status =
                    ReusableFunctions.capitalizeWords(professional['status']);
                final minSalary = min;
                final maxSalary = max;
                final starRating = professional['avgRt'];

                final cardWidget = ProfessionalCard(
                  professionalProfile: professionalProfile,
                  professionalName: professionalName,
                  jobTitle: jobTitle,
                  professionalLocation: professionalLocation,
                  jobCategory: jobCategory,
                  jobType: jobType,
                  professionalId: professionalId,
                  date: date,
                  status: status,
                  minSalary: minSalary,
                  maxSalary: maxSalary,
                  starRating: starRating,
                );
                cardWidgets.add(cardWidget);
              }
              return Column(
                children: cardWidgets,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
