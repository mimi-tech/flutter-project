import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/job_shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class MainJobs extends StatefulWidget {
  @override
  _MainJobsState createState() => _MainJobsState();
}

class _MainJobsState extends State<MainJobs>
    with AutomaticKeepAliveClientMixin {
  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  List<DocumentSnapshot> _jobs = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((jobChange) {
      if (jobChange.type == DocumentChangeType.removed) {
        _jobs.removeWhere((job) {
          return jobChange.doc.id == job.id;
        });
        isChange = true;
      } else {
        if (jobChange.type == DocumentChangeType.modified) {
          int indexWhere = _jobs.indexWhere((job) {
            return jobChange.doc.id == job.id;
          });

          if (indexWhere >= 0) {
            _jobs[indexWhere] = jobChange.doc;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      _streamController.add(_jobs);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collectionGroup('companyJobs')
        .orderBy('time', descending: true)
        .snapshots()
        .asBroadcastStream()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<List<DocumentSnapshot>>(
                      stream: _streamController.stream,
                      builder: (context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.data == null) {
                          return JobShimmer();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return JobShimmer();
                        } else if (snapshot.hasError) {
                          return NoResult(
                            message: "Oops Something Went Wrong",
                          );
                        } else {
                          return Column(
                              children: snapshot.data!.map((singleJob) {
                            //Todo: get  datetime from database
                            Map<String, dynamic> data =
                                singleJob.data() as Map<String, dynamic>;
                            DateTime date = DateTime.parse(data['jtm']);

                            /// Ellis to Austin = I replaced all "singleJob.data()" with [data]
                            // DateTime date =
                            //     DateTime.parse(singleJob.data()['jtm']);

                            String displayDay = timeago.format(date);

                            // for min and max salary
                            int max = int.parse(data['srx']);
                            int min = int.parse(data['srn']);

                            return Column(children: <Widget>[
                              JobCard(
                                  companyLogo: data['lur'],
                                  jobTitle: data['jtl'],
                                  companyName: data['cnm'],
                                  jobLocation: data['jlt'],
                                  minSalary: min,
                                  maxSalary: max,
                                  displayMin: data['srn'],
                                  displayMax: data['srx'],
                                  jobSummary: data['sum'],
                                  jobBenefit: data['jbt'],
                                  jobQualification: data['jqt'],
                                  responsibility: data['jrSt'],
                                  skills: data['skl'],
                                  status: data['status'],
                                  jobType: data['jtp'],
                                  jobCategory: data['jcg'],
                                  jobTime: displayDay,
                                  jobId: data['id'],
                                  companyId: data['cid'],
                                  mainId: data['mainId'])
                            ]);
                          }).toList());
                        }
                      }),
                  _isFinish == false
                      ? isLoading == true
                          ? CircularProgressIndicator()
                          : Text('')
                      : Text(''),
                ],
              ),
            ),
          ),
        ));
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_jobs.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .orderBy('time', descending: true)
            .limit(4)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .orderBy('time', descending: true)
            .startAfterDocument(_jobs[_jobs.length - 1])
            .limit(4)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _jobs.length;
        _jobs.addAll(querySnapshot.docs);
        int newSize = _jobs.length;
        if (oldSize != newSize) {
          _streamController.add(_jobs);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
