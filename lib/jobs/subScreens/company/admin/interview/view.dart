import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/experienceComponents.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class ViewInterviewRequest extends StatefulWidget {
  @override
  _ViewInterviewRequestState createState() => _ViewInterviewRequestState();
}

class _ViewInterviewRequestState extends State<ViewInterviewRequest> {
  final TextEditingController _userEmailController = TextEditingController();

  Stream? _stream;

  bool showSpinner = false;

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('interviewRequest')
        .doc(InterviewFormStorage.companyId)
        .collection('companyInterviewsPages')
        .doc(InterviewFormStorage.mainCompanyId)
        .collection('companyInterviewDetails')
        .doc(InterviewFormStorage.interviewId)
        .snapshots();

    _userEmailController.text = ProfessionalStorage.email!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    InterviewFormStorage.mainCompanyId = null;
    InterviewFormStorage.interviewId = null;
    InterviewFormStorage.companyId = null;
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
                            'Send Interview Request',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(18.0),
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
                                          fontSize: ScreenUtil().setSp(25.0),
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
                                        fontSize: ScreenUtil().setSp(18.0),
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
                                        fontSize: ScreenUtil().setSp(14.0),
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
                                            fontSize: ScreenUtil().setSp(18.0),
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
                                            fontSize: ScreenUtil().setSp(18.0),
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

                              ResumeInput(
                                controller: _userEmailController,
                                labelText: "Enter User Email",
                                hintText: "user@gmail.com",
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      onPressed: () async {
                                        String incomingEmail =
                                            _userEmailController.text.trim();

                                        if (_userEmailController.text == '') {
                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  "please a profile email is required",
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: kLight_orange,
                                              textColor: Colors.white);
                                        } else {
                                          setState(() {
                                            showSpinner = true;
                                          });

                                          // check if the user has a spark job profile
                                          final QuerySnapshot userResult =
                                              await FirebaseFirestore.instance
                                                  .collection('professionals')
                                                  .where('email',
                                                      isEqualTo: incomingEmail)
                                                  .get();
                                          final List<DocumentSnapshot>
                                              userDocuments = userResult.docs;

                                          if (userDocuments.isEmpty) {
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    "$incomingEmail don't have a sparks profile",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: kLight_orange,
                                                textColor: Colors.white);
                                          } else {
                                            final QuerySnapshot result =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'sentInterviewRequests')
                                                    .doc(InterviewFormStorage
                                                        .companyId)
                                                    .collection(
                                                        'sentCompanyPage')
                                                    .doc(InterviewFormStorage
                                                        .mainCompanyId)
                                                    .collection(
                                                        'sentInterviewDetails')
                                                    .where('uEmail',
                                                        isEqualTo:
                                                            _userEmailController
                                                                .text)
                                                    .where('irId',
                                                        isEqualTo:
                                                            InterviewFormStorage
                                                                .interviewId)
                                                    .get();
                                            final List<DocumentSnapshot>
                                                documents = result.docs;

                                            if (documents.length >= 1) {
                                              setState(() {
                                                showSpinner = false;
                                              });

                                              Fluttertoast.showToast(
                                                  timeInSecForIosWeb: 45,
                                                  msg:
                                                      " sorry this interview request has already been sent to $incomingEmail",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor:
                                                      kLight_orange,
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
                                                            'sentInterviewRequests')
                                                        .doc(InterviewFormStorage
                                                            .companyId)
                                                        .collection(
                                                            'sentCompanyPage')
                                                        .doc(
                                                            InterviewFormStorage
                                                                .mainCompanyId)
                                                        .collection(
                                                            'sentInterviewDetails')
                                                        .doc();

                                                documentReference.set({
                                                  'cid': InterviewFormStorage
                                                      .companyId,
                                                  'mCid': InterviewFormStorage
                                                      .mainCompanyId,
                                                  'cnm':
                                                      singleInterviewDocument[
                                                          "cnm"],
                                                  'jbt':
                                                      singleInterviewDocument[
                                                          "jbt"],
                                                  'ims':
                                                      singleInterviewDocument[
                                                          "ims"],
                                                  'jdt':
                                                      singleInterviewDocument[
                                                          "jdt"],
                                                  'jtl':
                                                      singleInterviewDocument[
                                                          "jtl"],
                                                  'cpd':
                                                      singleInterviewDocument[
                                                          "cpd"],
                                                  'jlt':
                                                      singleInterviewDocument[
                                                          "jlt"],
                                                  'jrm':
                                                      singleInterviewDocument[
                                                          "jrm"],
                                                  'ivn':
                                                      singleInterviewDocument[
                                                          "ivn"],
                                                  'jtm':
                                                      DateTime.now().toString(),
                                                  'lur':
                                                      singleInterviewDocument[
                                                          "lur"],
                                                  'srn':
                                                      singleInterviewDocument[
                                                          "srn"],
                                                  'srx':
                                                      singleInterviewDocument[
                                                          "srx"],
                                                  'irId': InterviewFormStorage
                                                      .interviewId,
                                                  'suId': documentReference.id,
                                                  'uEmail': incomingEmail,
                                                  'time': DateTime.now()
                                                });
                                                setState(() {
                                                  showSpinner = false;
                                                });
                                                Fluttertoast.showToast(
                                                    timeInSecForIosWeb: 45,
                                                    msg:
                                                        "An Interview Request Has Been Sent to $incomingEmail",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white);
                                              } catch (err) {
                                                print(err);
                                                print('....');
                                                print(
                                                    _userEmailController.text);
                                              }
                                            }
                                          }
                                        }
                                      },
                                      color: kComp,
                                      textColor: Colors.black,
                                      child: Text("Send"),
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
