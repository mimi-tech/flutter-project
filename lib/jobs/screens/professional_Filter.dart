import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/cardComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfFilterPage extends StatefulWidget {
  ProfFilterPage({
    Key? key,
    this.filteredProfStream,
  });

  final Stream? filteredProfStream;

  @override
  _ProfFilterPageState createState() => _ProfFilterPageState();
}

class _ProfFilterPageState extends State<ProfFilterPage> {
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
              'Professional Filter Result',
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
                stream: widget.filteredProfStream as Stream<QuerySnapshot<Object>>?,
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
                      for (var professional in professionals) {
                        //Todo: get  datetime from database

                        // for min and max salary
                        int max = int.parse(professional!['srx']);
                        int min = int.parse(professional['srn']);
                        final cardWidget = ProfessionalCard(
                          professionalProfile: professional['imageUrl'],
                          professionalName: ReusableFunctions.capitalizeWords(
                              professional['name']),
                          jobTitle: ReusableFunctions.capitalizeWords(
                              professional['pTitle']),
                          professionalLocation:
                              ReusableFunctions.capitalizeWords(
                                  professional['location']),
                          jobCategory: ReusableFunctions.capitalizeWords(
                              professional['ajc']),
                          jobType: ReusableFunctions.capitalizeWords(
                              professional['ajt']),
                          professionalId: professional['userId'],
                          date: professional['date'],
                          status: ReusableFunctions.capitalizeWords(
                              professional['status']),
                          minSalary: min,
                          maxSalary: max,
                          starRating: professional['avgRt'],
                        );
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
