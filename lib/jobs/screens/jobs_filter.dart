import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobFilterPage extends StatefulWidget {
  JobFilterPage({
    Key? key,
    this.filteredJobStream,
  });

  final Stream? filteredJobStream;

  @override
  _JobFilterPageState createState() => _JobFilterPageState();
}

class _JobFilterPageState extends State<JobFilterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          automaticallyImplyLeading: true,
          backgroundColor: kLight_orange,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
              'Jobs Filter Result',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(18.0),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: widget.filteredJobStream as Stream<QuerySnapshot<Object>>?,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // final singleJobs = snapshot.data.docs;

                    List<Map<String, dynamic>?> singleJobs =
                        snapshot.data!.docs.map((DocumentSnapshot doc) {
                      return doc.data as Map<String, dynamic>?;
                    }).toList();
                    if (singleJobs.isEmpty) {
                      return NoResult(
                        message: "No Result",
                      );
                    } else {
                      List<Widget> cardWidgets = [];
                      for (var singleJob in singleJobs) {
                        //Todo: get  datetime from database
                        DateTime date = DateTime.parse(singleJob!['jtm']);

                        String displayDay = timeago.format(date);

                        // for min and max salary
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
            ],
          ),
        ),
      ),
    );
  }
}
