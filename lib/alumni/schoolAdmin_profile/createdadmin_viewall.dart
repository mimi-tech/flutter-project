import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/alumni/color/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminViewAll extends StatefulWidget {
  @override
  AdminViewAllState createState() => AdminViewAllState();
}

class AdminViewAllState extends State<AdminViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onLongPress: () {},
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        title: Center(child: Text('Created admin')),
        backgroundColor: kADarkRed,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sentSchoolRequest')
                  //.where('schUid', isEqualTo: loggedInUser.uid)
                  .where('status', isEqualTo: "Admin")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final schoolRequests = snapshot.data.docs;
                  List<Map<String, dynamic>> schoolRequests =
                      snapshot.data!.docs.map((doc) {
                    return doc.data as Map<String, dynamic>;
                  }).toList();
                  if (schoolRequests.isEmpty) {
                    return Column(children: [
                      Container(
                        child: RaisedButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8))),
                          child: Text(
                            "No Admin Available",
                            style: TextStyle(
                              fontFamily: "Rajdhani",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kAWhite,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    List<Widget> cardWidgets = [];
                    for (var schoolRequest in schoolRequests) {
                      final cardWidget =
                          AdminCards(schoolRequest: schoolRequest);
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
                          backgroundColor: Colors.green,
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
                          backgroundColor: Colors.deepOrangeAccent,
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
    );
  }
}

class AdminCards extends StatelessWidget {
  const AdminCards({
    Key? key,
    required this.schoolRequest,
  }) : super(key: key);

  // final DocumentSnapshot schoolRequest;
  final Map<String, dynamic> schoolRequest;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        child: Container(
          color: kAWhite,
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 13, 0, 0),
                            child: CachedNetworkImage(
                              imageUrl: schoolRequest['logo'] ??
                                  "https://image.freepik.com/free-vector/head-man_1308-33466.jpg",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: kADeepOrange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0))),
                            alignment: Alignment.center,
                            height: 20,
                            width: 40,
                            child: Text(
                              "Profile",
                              style: new TextStyle(
                                color: kAWhite,
                                fontSize: 12.0,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
              Flexible(
                flex: 38,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5.0, left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                schoolRequest['name'] ?? "school",
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21.0),
                              ),
                              Text(
                                schoolRequest['grade'] ?? "school",
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                schoolRequest['schName'] ?? "school",
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        schoolRequest["stYr"] ?? "school",
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(" - "),
                                    Container(
                                      child: Text(
                                        schoolRequest["edYr"] ?? "school",
                                        style: TextStyle(
                                            fontFamily: 'Rajdhani',
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 40, 5, 0),
                    width: 30.03,
                    height: 28.09,
                    child: Image.asset("images/alumni/messages.png"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
