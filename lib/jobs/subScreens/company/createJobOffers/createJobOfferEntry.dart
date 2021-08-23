import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/market/utilities/market_const.dart';
import 'package:sparks/school_reg/screens/school_constance.dart';

class CreateJobOfferEntry extends StatefulWidget {
  @override
  _CreateJobOfferEntryState createState() => _CreateJobOfferEntryState();
}

class _CreateJobOfferEntryState extends State<CreateJobOfferEntry> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobOfferDescriptionController =
      TextEditingController();
  final TextEditingController _jobSalaryController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobOfferMessage = TextEditingController();

  bool showSpinner = false;

  void validateAndSaveData() {
    if (_companyNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobLocationController.text == '') {
      Fluttertoast.showToast(
          msg: "Location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobTitleController.text == '') {
      Fluttertoast.showToast(
          msg: "Write Job Title",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobOfferDescriptionController.text == '') {
      Fluttertoast.showToast(
          msg: "Write Full Job Offer Description",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_jobSalaryController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter Salary",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      setState(() {
        showSpinner = true;
      });

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('jobOfferRequest')
          .doc(UserStorage.loggedInUser.uid)
          .collection('companyJobOfferPages')
          .doc(CompanyStorage.pageId)
          .collection('companyJobOfferDetails')
          .doc();
      documentReference.set({
        'cid': CompanyStorage.pageId,
        'cnm': _companyNameController.text,
        'jdt': _jobOfferDescriptionController.text,
        'jof': _jobOfferMessage.text,
        'jtl': _jobTitleController.text,
        'jlt': _jobLocationController.text,
        'jtm': DateTime.now().toString(),
        'lur': JobOfferFormStorage.logoUrl,
        'srx': _jobSalaryController.text,
        'user': UserStorage.loggedInUser.email,
        'mainId': UserStorage.loggedInUser.uid,
        'id': documentReference.id,
        'time': DateTime.now()
      });
      Fluttertoast.showToast(
          msg: "Job Offer Created Successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white);

      setState(() {
        showSpinner = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _companyNameController.text = JobOfferFormStorage.companyName!;
    _jobLocationController.text = JobOfferFormStorage.jobLocation!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _companyNameController.dispose();
    _jobLocationController.dispose();
    _jobSalaryController.dispose();
    _jobOfferMessage.dispose();
    _jobTitleController.dispose();
    _jobOfferDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.7,
            automaticallyImplyLeading: true,
            backgroundColor: kLight_orange,
            centerTitle: true,
            title: Text(
              'Create Job Offer Form',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(16.0),
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
              child: Container(
//                  height: screenData.height * 0.78,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EditHintText(
                          hintText: "Company Name",
                        ),
                      ),
                      ResumeInput(
                        controller: _companyNameController,
                        labelText: "Enter Company Name",
                        hintText: "Rex Tech Global",
                        action: (value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                        child: EditHintText(
                          hintText: "Job Location",
                        ),
                      ),
                      ResumeInput(
                        controller: _jobLocationController,
                        labelText: "Enter Job Location",
                        hintText: "Germany",
                        action: (value) {},
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "Job Title",
                        ),
                      ),
                      ResumeInput(
                        controller: _jobTitleController,
                        labelText: "Enter Job Title",
                        hintText: "Software Engineer",
                        action: (value) {},
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "Job Offer Description",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Container(
                                height: ScreenUtil().setHeight(180.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  maxLines: 10,
                                  autofocus: true,
                                  controller: _jobOfferDescriptionController,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLight_orange, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "Job Offer Summary",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 10,
                              color: Colors.white,
                              child: Container(
                                height: ScreenUtil().setHeight(180.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextField(
                                  maxLines: 10,
                                  autofocus: true,
                                  controller: _jobOfferMessage,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kLight_orange, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                        child: EditHintText(
                          hintText: "Job Salary",
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(126),
                        child: TextField(
                          controller: _jobSalaryController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: kMSearchDrawerTextStyle,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kMarketPrimaryColor),
                            ),
                            hintText: '\$40,00',
                            hintStyle: kMSearchDrawerTextStyle,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: RaisedButton(
                              color: Colors.black,
                              onPressed: () {
                                validateAndSaveData();
                              },
                              child: new Text(
                                "Create",
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
