import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class UserViewJobOfferRequest extends StatefulWidget {
  @override
  _UserViewJobOfferRequestState createState() =>
      _UserViewJobOfferRequestState();
}

class _UserViewJobOfferRequestState extends State<UserViewJobOfferRequest> {
  Stream? _stream;

  bool showSpinner = false;

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  void acceptInterviewRequest() {}

  @override
  void initState() {
    super.initState();
    print(UserStorage.companyID);
    print(UserStorage.mainCompanyID);
    print(UserStorage.jobOfferRequestID);
    _stream = FirebaseFirestore.instance
        .collection('jobOfferRequest')
        .doc(UserStorage.companyID)
        .collection('companyJobOfferPages')
        .doc(UserStorage.mainCompanyID)
        .collection('companyJobOfferDetails')
        .doc(UserStorage.jobOfferRequestID)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    UserStorage.jobOfferRequestID = null;
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          Map<String, dynamic> singleJobOfferDocument =
              snapshot.data as Map<String, dynamic>;
          ;
          print(singleJobOfferDocument);
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
                            '${singleJobOfferDocument['cnm']} Job Offer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
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
                                    singleJobOfferDocument['cnm'],
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
                                                singleJobOfferDocument["lur"],
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
                                  singleJobOfferDocument["jtl"],
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
                                  singleJobOfferDocument["jlt"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(16.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EditHintText(
                                  hintText: "Job Offer Description",
                                ),
                              ),
                              Container(
                                child: Text(
                                  singleJobOfferDocument["jdt"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(14.0),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EditHintText(hintText: "Salary"),
                              ),
                              Container(
                                child: Text(
                                  " \$${singleJobOfferDocument["srx"]}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(18.0),
                                        fontWeight: FontWeight.bold,
                                        color: kNavBg),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EditHintText(
                                  hintText: "Job Offer Summary",
                                ),
                              ),
                              Container(
                                child: Text(
                                  singleJobOfferDocument["jof"],
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
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(
                                      color: Colors.black,
                                      onPressed: () async {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        final QuerySnapshot result =
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'AcceptedJobOfferRequests')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'AcceptedJobOfferCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'AcceptedJobOfferDetails')
                                                .where('uEmail',
                                                    isEqualTo: UserStorage
                                                        .loggedInUser.email)
                                                .where('irId',
                                                    isEqualTo: UserStorage
                                                        .jobOfferRequestID)
                                                .get();
                                        final List<DocumentSnapshot>
                                            acceptedDocuments = result.docs;

                                        final QuerySnapshot declinedResult =
                                            await FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'DeclinedJobOfferRequests')
                                                .doc(UserStorage.companyID)
                                                .collection(
                                                    'DeclinedJobOfferRequestsCompanyPage')
                                                .doc(UserStorage.mainCompanyID)
                                                .collection(
                                                    'DeclinedJobOfferRequestsDetails')
                                                .where('uEmail',
                                                    isEqualTo: UserStorage
                                                        .loggedInUser.email)
                                                .where('irId',
                                                    isEqualTo: UserStorage
                                                        .jobOfferRequestID)
                                                .get();
                                        final List<DocumentSnapshot>
                                            declinedDocuments =
                                            declinedResult.docs;

                                        if (acceptedDocuments.length >= 1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you have accepted this job Offer",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white);
                                        } else if (declinedDocuments.length >=
                                            1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "Sorry you have declined this jobOffer",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: Colors.red,
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
                                                        'AcceptedJobOfferRequests')
                                                    .doc(UserStorage.companyID)
                                                    .collection(
                                                        'AcceptedJobOfferCompanyPage')
                                                    .doc(UserStorage
                                                        .mainCompanyID)
                                                    .collection(
                                                        'AcceptedJobOfferDetails')
                                                    .doc();

                                            documentReference.set({
                                              'cid': UserStorage.companyID,
                                              'mCid': UserStorage.mainCompanyID,
                                              'jtl':
                                                  singleJobOfferDocument["jtl"],
                                              'cnm':
                                                  singleJobOfferDocument["cnm"],
                                              'jtm': date,
                                              'irId':
                                                  UserStorage.jobOfferRequestID,
                                              'Id': documentReference.id,
                                              'uEmail': UserStorage
                                                  .loggedInUser.email,
                                              'uId':
                                                  UserStorage.loggedInUser.uid,
                                              'usImg':
                                                  "https://i.pinimg.com/originals/35/9f/ae/359fae7e8ad479e55d0dcbd4c7e7733c.jpg",
                                              'time': DateTime.now()
                                            });
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    "Congrats! You Have Accepted This Job Offer",
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
                                          builder: (context) => SimpleDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 8,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () async {
                                                      setState(() {
                                                        showSpinner = true;
                                                      });
                                                      final QuerySnapshot
                                                          acceptedResult =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'AcceptedJobOfferRequests')
                                                              .doc(UserStorage
                                                                  .companyID)
                                                              .collection(
                                                                  'AcceptedJobOfferCompanyPage')
                                                              .doc(UserStorage
                                                                  .mainCompanyID)
                                                              .collection(
                                                                  'AcceptedJobOfferDetails')
                                                              .where('uEmail',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .loggedInUser
                                                                          .email)
                                                              .where('irId',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .jobOfferRequestID)
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          acceptedDocuments =
                                                          acceptedResult.docs;
                                                      final QuerySnapshot
                                                          declinedResult =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'DeclinedJobOfferRequests')
                                                              .doc(UserStorage
                                                                  .companyID)
                                                              .collection(
                                                                  'DeclinedJobOfferRequestsCompanyPage')
                                                              .doc(UserStorage
                                                                  .mainCompanyID)
                                                              .collection(
                                                                  'DeclinedJobOfferRequestsDetails')
                                                              .where('uEmail',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .loggedInUser
                                                                          .email)
                                                              .where('irId',
                                                                  isEqualTo:
                                                                      UserStorage
                                                                          .jobOfferRequestID)
                                                              .get();
                                                      final List<
                                                              DocumentSnapshot>
                                                          declinedDocuments =
                                                          declinedResult.docs;

                                                      if (declinedDocuments
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
                                                                "Sorry You Have Declined This Job Offer",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white);
                                                      } else if (acceptedDocuments
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
                                                                "Job Offer Already Accepted",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            backgroundColor:
                                                                Colors.black,
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
                                                                      'DeclinedJobOfferRequests')
                                                                  .doc(UserStorage
                                                                      .companyID)
                                                                  .collection(
                                                                      'DeclinedJobOfferRequestsCompanyPage')
                                                                  .doc(UserStorage
                                                                      .mainCompanyID)
                                                                  .collection(
                                                                      'DeclinedJobOfferRequestsDetails')
                                                                  .doc();

                                                          documentReference
                                                              .set({
                                                            'cid': UserStorage
                                                                .companyID,
                                                            'mCid': UserStorage
                                                                .mainCompanyID,
                                                            'jtl':
                                                                singleJobOfferDocument[
                                                                    "jtl"],
                                                            'cnm':
                                                                singleJobOfferDocument[
                                                                    "cnm"],
                                                            'jtm': date,
                                                            'irId': UserStorage
                                                                .jobOfferRequestID,
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
                                                                "https://i.pinimg.com/originals/35/9f/ae/359fae7e8ad479e55d0dcbd4c7e7733c.jpg",
                                                            'time':
                                                                DateTime.now()
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            showSpinner = false;
                                                          });

                                                          Fluttertoast.showToast(
                                                              timeInSecForIosWeb:
                                                                  45,
                                                              msg:
                                                                  "Job Offer Declined",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              backgroundColor:
                                                                  kLight_orange,
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
                                                    color: Colors.red,
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
