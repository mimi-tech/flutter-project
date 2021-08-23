import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';

class UserViewInterviewRequest extends StatefulWidget {
  @override
  _UserViewInterviewRequestState createState() =>
      _UserViewInterviewRequestState();
}

class _UserViewInterviewRequestState extends State<UserViewInterviewRequest> {
  Stream? _stream;

  bool showSpinner = false;

  var date = new DateFormat().toString();

  @override
  void initState() {
    super.initState();
    print(UserStorage.sentInterviewRequestID);
    _stream = FirebaseFirestore.instance
        .collection('interviewRequest')
        .doc(UserStorage.companyID)
        .collection('companyInterviewsPages')
        .doc(UserStorage.mainCompanyID)
        .collection('companyInterviewDetails')
        .doc(UserStorage.sentInterviewRequestID)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    UserStorage.sentInterviewRequestID = null;
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text("Loading..."),
                ));
          }
          Map<String, dynamic> singleInterviewDocument =
              snapshot.data as Map<String, dynamic>;
          print(singleInterviewDocument);
          return WillPopScope(
              onWillPop: () => Future.value(true),
              child: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        elevation: 0.7,
                        automaticallyImplyLeading: true,
                        backgroundColor: kLight_orange,
                        centerTitle: true,
                        title: Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Interview Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(20.0),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      body: ModalProgressHUD(
                        inAsyncCall: showSpinner,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    singleInterviewDocument['cnm'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(20.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: ScreenUtil().setHeight(60.0),
                                      width: ScreenUtil().setWidth(80),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 72,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                singleInterviewDocument["lur"],
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit.cover,
                                            width: 70.0,
                                            height: 70.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  singleInterviewDocument["jtl"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(18.0),
                                        fontWeight: FontWeight.bold,
                                        color: kNavBg),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                child: Text(
                                  singleInterviewDocument["jlt"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(16.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                child: Text(
                                  singleInterviewDocument["jdt"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(14.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                child: Text(
                                  "Salary \$${singleInterviewDocument["srn"]} - \$${singleInterviewDocument["srx"]}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(16.0),
                                        fontWeight: FontWeight.bold,
                                        color: kNavBg),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                child: Text(
                                  singleInterviewDocument["ims"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(16.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),

                              //for requirement
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Requirements",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(20.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                                child: Column(
                                  children: <Widget>[
                                    for (var item
                                        in singleInterviewDocument["jrm"])
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              "images/jobs/bullet.svg",
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item,
                                                  softWrap: true,
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14.0),
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
                                  ],
                                ),
                              ),

                              //for benefits
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Benefits",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(20.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                                child: Column(
                                  children: <Widget>[
                                    for (var item
                                        in singleInterviewDocument["jbt"])
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              "images/jobs/bullet.svg",
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item,
                                                  softWrap: true,
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(14.0),
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
                                  ],
                                ),
                              ),

                              Container(
                                  margin:
                                      EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      for (var i = 0;
                                          i <
                                              singleInterviewDocument["cpd"]
                                                  .length;
                                          i++)
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  15.0, 30.0, 0.0, 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color: kLight_orange,
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Contact Person ${i + 1}",
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(18.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ExContent(
                                              dString: "images/jobs/dm.png",
                                              text1:
                                                  singleInterviewDocument["cpd"]
                                                      .elementAt(i)['name'],
                                              text2:
                                                  singleInterviewDocument["cpd"]
                                                      .elementAt(i)['role'],
                                              text3:
                                                  singleInterviewDocument["cpd"]
                                                      .elementAt(i)['phone'],
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                    ],
                                  )),

                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(
                                      color: Colors.black,
                                      onPressed: () async {
                                        print(UserStorage.loggedInUser.email);

                                        setState(() {
                                          showSpinner = true;
                                        });
                                        final QuerySnapshot result =
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'AcceptedInterviewRequests')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'AcceptedCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'AcceptedInterviewDetails')
                                                .where('uEmail',
                                                    isEqualTo: UserStorage
                                                        .loggedInUser.email)
                                                .where('irId',
                                                    isEqualTo: UserStorage
                                                        .sentInterviewRequestID)
                                                .get();
                                        final List<DocumentSnapshot>
                                            acceptedDocuments1 = result.docs;

                                        final QuerySnapshot declinedResult =
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'DeclinedInterviewRequests')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'DeclinedCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'DeclinedInterviewDetails')
                                                .where('uEmail',
                                                    isEqualTo: UserStorage
                                                        .loggedInUser.email)
                                                .where('irId',
                                                    isEqualTo: UserStorage
                                                        .sentInterviewRequestID)
                                                .get();
                                        final List<DocumentSnapshot>
                                            declinedDocuments1 =
                                            declinedResult.docs;

                                        if (acceptedDocuments1.length >= 1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you have accepted this interview invitation",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: kLight_orange,
                                              textColor: Colors.white);
                                        } else if (declinedDocuments1.length >=
                                            1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you have declined this interview invitation",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: kLight_orange,
                                              textColor: Colors.white);
                                        } else {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          try {
                                            DocumentReference
                                                documentReference =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'AcceptedInterviewRequests')
                                                    .doc(UserStorage.companyID)
                                                    .collection(
                                                        'AcceptedCompanyPage')
                                                    .doc(UserStorage
                                                        .mainCompanyID)
                                                    .collection(
                                                        'AcceptedInterviewDetails')
                                                    .doc();

                                            documentReference.set({
                                              'cid': UserStorage.companyID,
                                              'mCid': UserStorage.mainCompanyID,
                                              'jtl': singleInterviewDocument[
                                                  "jtl"],
                                              'cnm': singleInterviewDocument[
                                                  "cnm"],
                                              'jtm': date,
                                              'irId': UserStorage
                                                  .sentInterviewRequestID,
                                              'Id': documentReference.id,
                                              'uEmail': UserStorage
                                                  .loggedInUser.email,
                                              'uId':
                                                  UserStorage.loggedInUser.uid,
                                              'usImg':
                                                  "${GlobalVariables.loggedInUserObject.pimg}",
                                              'time': DateTime.now()
                                            });
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    "Interview Request Accepted",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white);
                                          } catch (err) {
                                            print(err);
                                            print('....');
                                          }
                                        }
                                      },
                                      child: new Text(
                                        "Accept",
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: kLight_orange,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierColor: Colors.black54,
                                          builder: (context) => SimpleDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 8,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Are you sure?",
                                                    style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(18),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  RaisedButton(
                                                    color: kLight_orange,
                                                    onPressed: () async {
                                                      setState(() {
                                                        showSpinner = true;
                                                      });
                                                      final QuerySnapshot
                                                          acceptedResultForDeclineButton =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'AcceptedInterviewRequests')
                                                              .doc(UserStorage
                                                                  .companyID)
                                                              .collection(
                                                                  'AcceptedCompanyPage')
                                                              .doc(UserStorage
                                                                  .mainCompanyID)
                                                              .collection(
                                                                  'AcceptedInterviewDetails')
                                                              .where('uEmail',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .loggedInUser
                                                                          .email)
                                                              .where('irId',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .sentInterviewRequestID)
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          acceptedResultForDeclineButtonDocuments =
                                                          acceptedResultForDeclineButton
                                                              .docs;

                                                      final QuerySnapshot
                                                          declineResultForDeclineButton =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'DeclinedInterviewRequests')
                                                              .doc(UserStorage
                                                                  .companyID)
                                                              .collection(
                                                                  'DeclinedCompanyPage')
                                                              .doc(UserStorage
                                                                  .mainCompanyID)
                                                              .collection(
                                                                  'DeclinedInterviewDetails')
                                                              .where('uEmail',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .loggedInUser
                                                                          .email)
                                                              .where('irId',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .sentInterviewRequestID)
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          declineResultForDeclineDocuments =
                                                          declineResultForDeclineButton
                                                              .docs;

                                                      if (declineResultForDeclineDocuments
                                                              .length >=
                                                          1) {
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                        Navigator.pop(context);

                                                        Fluttertoast.showToast(
                                                            timeInSecForIosWeb:
                                                                45,
                                                            msg:
                                                                "Sorry you have Declined this interview invitation",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                kLight_orange,
                                                            textColor:
                                                                Colors.white);
                                                      } else if (acceptedResultForDeclineButtonDocuments
                                                              .length >=
                                                          1) {
                                                        setState(() {
                                                          showSpinner = false;
                                                        });
                                                        Navigator.pop(context);
                                                        Fluttertoast.showToast(
                                                            timeInSecForIosWeb:
                                                                45,
                                                            msg:
                                                                "Sorry you have accepted this interview invitation",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                kLight_orange,
                                                            textColor:
                                                                Colors.white);
                                                      } else {
                                                        setState(() {
                                                          showSpinner = true;
                                                        });
                                                        try {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'DeclinedInterviewRequests')
                                                                  .doc(UserStorage
                                                                      .companyID)
                                                                  .collection(
                                                                      'DeclinedCompanyPage')
                                                                  .doc(UserStorage
                                                                      .mainCompanyID)
                                                                  .collection(
                                                                      'DeclinedInterviewDetails')
                                                                  .doc();

                                                          documentReference
                                                              .set({
                                                            'cid': UserStorage
                                                                .companyID,
                                                            'mCid': UserStorage
                                                                .mainCompanyID,
                                                            'jtl':
                                                                singleInterviewDocument[
                                                                    "jtl"],
                                                            'cnm':
                                                                singleInterviewDocument[
                                                                    "cnm"],
                                                            'jtm': date,
                                                            'irId': UserStorage
                                                                .sentInterviewRequestID,
                                                            'Id':
                                                                documentReference
                                                                    .id,
                                                            'uEmail': UserStorage
                                                                .loggedInUser
                                                                .email,
                                                            'uId': UserStorage
                                                                .loggedInUser
                                                                .uid,
                                                            'usImg':
                                                                "${GlobalVariables.loggedInUserObject.pimg}",
                                                            'time':
                                                                DateTime.now()
                                                          });
                                                          setState(() {
                                                            showSpinner = false;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              timeInSecForIosWeb:
                                                                  45,
                                                              msg:
                                                                  "Interview Request Declined",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              backgroundColor:
                                                                  Colors.black,
                                                              textColor:
                                                                  Colors.white);
                                                        } catch (err) {
                                                          print(err);
                                                          print('....');
                                                        }
                                                      }
                                                    },
                                                    child: new Text(
                                                      "Decline",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    color: kLight_orange,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: new Text(
                                                      "Cancel",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(18),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: new Text(
                                        "Decline",
                                        style: GoogleFonts.rajdhani(
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))));
        });
  }
}
