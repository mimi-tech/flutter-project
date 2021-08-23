import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class ViewJobOfferRequest extends StatefulWidget {
  @override
  _ViewJobOfferRequestState createState() => _ViewJobOfferRequestState();
}

class _ViewJobOfferRequestState extends State<ViewJobOfferRequest> {
  final TextEditingController _userEmailController = TextEditingController();
  Stream? _stream;

  bool showSpinner = false;

  var date = new DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('jobOfferRequest')
        .doc(CompanyStorage.companyId)
        .collection('companyJobOfferPages')
        .doc(CompanyStorage.pageId)
        .collection('companyJobOfferDetails')
        .doc(JobOfferFormStorage.jobId)
        .snapshots();

    _userEmailController.text = ProfessionalStorage.email!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    JobOfferFormStorage.mainCompanyId = null;
    JobOfferFormStorage.interviewId = null;
    JobOfferFormStorage.companyId = null;
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
                                    singleJobOfferDocument['cnm'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(18.0),
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
                                        fontSize: ScreenUtil().setSp(16.0),
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
                                        fontSize: 15.sp,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ResumeInput(
                                  controller: _userEmailController,
                                  labelText: "Enter User Email",
                                  hintText: "user@gmail.com",
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    String incomingEmail =
                                        _userEmailController.text;
                                    if (incomingEmail == '') {
                                      Fluttertoast.showToast(
                                          timeInSecForIosWeb: 45,
                                          msg:
                                              "Please a profile email is required",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
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
                                                    'sentJobOfferRequests')
                                                .doc(JobOfferFormStorage
                                                    .companyId)
                                                .collection(
                                                    'sentJobOfferCompanyPage')
                                                .doc(JobOfferFormStorage
                                                    .mainCompanyId)
                                                .collection(
                                                    'sentJobOfferDetails')
                                                .where('uEmail',
                                                    isEqualTo:
                                                        _userEmailController
                                                            .text)
                                                .where('joId',
                                                    isEqualTo:
                                                        JobOfferFormStorage
                                                            .jobId)
                                                .get();
                                        final List<DocumentSnapshot> documents =
                                            result.docs;

                                        if (documents.length >= 1) {
                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              timeInSecForIosWeb: 45,
                                              msg:
                                                  " sorry this job offer has already been sent to ${_userEmailController.text}",
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
                                                        'sentJobOfferRequests')
                                                    .doc(JobOfferFormStorage
                                                        .companyId)
                                                    .collection(
                                                        'sentJobOfferCompanyPage')
                                                    .doc(JobOfferFormStorage
                                                        .mainCompanyId)
                                                    .collection(
                                                        'sentJobOfferDetails')
                                                    .doc();

                                            documentReference.set({
                                              'cid':
                                                  JobOfferFormStorage.companyId,
                                              'mCid': JobOfferFormStorage
                                                  .mainCompanyId,
                                              'cnm':
                                                  singleJobOfferDocument["cnm"],
                                              'jdt':
                                                  singleJobOfferDocument["jdt"],
                                              'jtl':
                                                  singleJobOfferDocument["jtl"],
                                              'jlt':
                                                  singleJobOfferDocument["jlt"],
                                              'jof':
                                                  singleJobOfferDocument["jof"],
                                              'jtm': date,
                                              'lur':
                                                  singleJobOfferDocument["lur"],
                                              'srx':
                                                  singleJobOfferDocument["srx"],
                                              'joId': JobOfferFormStorage.jobId,
                                              'suId': documentReference.id,
                                              'uEmail':
                                                  _userEmailController.text,
                                              'time': DateTime.now()
                                            });
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                timeInSecForIosWeb: 45,
                                                msg:
                                                    "A Job Offer Request Has Been Sent to ${_userEmailController.text}",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white);
                                          } catch (err) {
                                            print(err);
                                            print('....');
                                            print(_userEmailController.text);
                                          }
                                        }
                                      }
                                    }
                                  },
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  child: Text("Send"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))));
        });
  }
}
