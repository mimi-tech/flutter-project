import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/components/job_shimmer.dart';

class Professional extends StatefulWidget {
  @override
  _ProfessionalState createState() => _ProfessionalState();
}

class _ProfessionalState extends State<Professional>
    with AutomaticKeepAliveClientMixin {
  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _professionals = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((professionalChange) {
      if (professionalChange.type == DocumentChangeType.removed) {
        _professionals.removeWhere((professional) {
          return professionalChange.doc.id == professional.id;
        });
        isChange = true;
      } else {
        if (professionalChange.type == DocumentChangeType.modified) {
          int indexWhere = _professionals.indexWhere((professional) {
            return professionalChange.doc.id == professional.id;
          });

          if (indexWhere >= 0) {
            _professionals[indexWhere] = professionalChange.doc;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      _streamController.add(_professionals);
    }
  }

  String defaultProfileUrl =
      "https://firebasestorage.googleapis.com/v0/b/sparks-44la.appspot.com/o/pimg%2F3VbJ6Oy86oXCo1CtNezUTigVOjw2%2Fimage_cropper_1599848645507.jpg?alt=media&token=1dccd5cd-6498-44a2-a192-2e097b230677";

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('professionals')
        .orderBy('time', descending: true)
        .snapshots()
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
                          return JobShimmer();
                        } else {
                          return Column(
                              children: snapshot.data!.map((professional) {
                            Map<String, dynamic> data =
                                professional.data() as Map<String, dynamic>;

                            /// Ellis to Austin = I replaced as the "professional.data()" with "data"
                            // for min and max salary
                            int max = int.parse(data['srx']);
                            int min = int.parse(data['srn']);
                            return Column(children: <Widget>[
                              ProfessionalCard(
                                professionalProfile: data['imageUrl'],
                                professionalName:
                                    ReusableFunctions.capitalizeWords(
                                        data['name']),
                                jobTitle: ReusableFunctions.capitalizeWords(
                                    data['pTitle']),
                                professionalLocation:
                                    ReusableFunctions.capitalizeWords(
                                        data['location']),
                                jobCategory: ReusableFunctions.capitalizeWords(
                                    data['ajc']),
                                jobType: ReusableFunctions.capitalizeWords(
                                    data['ajt']),
                                professionalId: data['userId'],
                                date: data['date'],
                                status: ReusableFunctions.capitalizeWords(
                                    data['status']),
                                minSalary: min,
                                maxSalary: max,
                                starRating: data['avgRt'],
                              )
                            ]);
                          }).toList());
                        }
                      }),
                  _isFinish == false
                      ? isLoading == true
                          ? CircularProgressIndicator()
                          : Text('')
                      : Text('')
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

      if (_professionals.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('professionals')
            .orderBy('time', descending: true)
            .limit(4)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });
        querySnapshot = await FirebaseFirestore.instance
            .collection('professionals')
            .orderBy('time', descending: true)
            .startAfterDocument(_professionals[_professionals.length - 1])
            .limit(4)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _professionals.length;

        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          /// Ellis to Austin = I replaced "documentSnapshot.data()" with "data"
          if (data["userId"] != UserStorage.loggedInUser.uid) {
            _professionals.add(documentSnapshot);
          }
        }

        //_professionals.addAll(querySnapshot.docs);
        int newSize = _professionals.length;
        if (oldSize != newSize) {
          _streamController.add(_professionals);
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
