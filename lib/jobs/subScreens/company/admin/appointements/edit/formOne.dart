import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/components/generalComponent.dart';
import 'package:sparks/jobs/subScreens/company/createAppointmentLetter/sample.dart';

class EditFormOne extends StatefulWidget {
  const EditFormOne({
    Key? key,
    this.tabController,
  });

  final TabController? tabController;

  @override
  _EditFormOneState createState() => _EditFormOneState();
}

class _EditFormOneState extends State<EditFormOne> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyCityController = TextEditingController();
  final TextEditingController _companyStateController = TextEditingController();
  final TextEditingController _companyZipCodeController =
      TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _recipientAddressController =
      TextEditingController();
  final TextEditingController _recipientCityController =
      TextEditingController();
  final TextEditingController _recipientStateController =
      TextEditingController();
  final TextEditingController _recipientZipCodeController =
      TextEditingController();

  bool showSpinner = false;

  void validateAndSaveData() {
    if (_companyNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Name field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyAddressController.text == '') {
      Fluttertoast.showToast(
          msg: "Location field cannot be blank",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyStateController.text == '') {
      Fluttertoast.showToast(
          msg: "Write Job Title",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_companyZipCodeController.text == '') {
      Fluttertoast.showToast(
          msg: "Write Job Description",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_recipientCityController.text == '') {
      Fluttertoast.showToast(
          msg: "Write The Appointment Letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_recipientNameController.text == '' &&
        _recipientAddressController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter Salary Range",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (_recipientStateController.text == '' &&
        _recipientZipCodeController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter Salary Range",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      AppointmentStorage.companyName = _companyNameController.text;
      AppointmentStorage.companyAddress = _companyAddressController.text;
      AppointmentStorage.companyCity = _companyCityController.text;
      AppointmentStorage.companyState = _companyStateController.text;
      AppointmentStorage.companyZipCode = _companyZipCodeController.text;
      AppointmentStorage.recipientName = _recipientNameController.text;
      AppointmentStorage.recipientAddress = _recipientAddressController.text;
      AppointmentStorage.recipientCity = _recipientCityController.text;
      AppointmentStorage.recipientState = _recipientStateController.text;
      AppointmentStorage.recipientZipCode = _recipientZipCodeController.text;

      widget.tabController!.animateTo(1);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _companyNameController.text = AppointmentStorage.companyName!;
    _companyAddressController.text = AppointmentStorage.companyAddress!;
    _companyCityController.text = AppointmentStorage.companyCity!;
    _companyStateController.text = AppointmentStorage.companyState!;
    _companyZipCodeController.text = AppointmentStorage.companyZipCode!;
    _recipientNameController.text = AppointmentStorage.recipientName!;
    _recipientAddressController.text = AppointmentStorage.recipientAddress!;
    _recipientCityController.text = AppointmentStorage.recipientCity!;
    _recipientStateController.text = AppointmentStorage.recipientState!;
    _recipientZipCodeController.text = AppointmentStorage.recipientZipCode!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AppointmentStorage.companyLogo = null;
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyCityController.dispose();
    _companyStateController.dispose();
    _companyZipCodeController.dispose();
    _recipientNameController.dispose();
    _recipientAddressController.dispose();
    _recipientCityController.dispose();
    _recipientStateController.dispose();
    _recipientZipCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: SafeArea(
        child: Scaffold(
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
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: RaisedButton(
                          color: kComp,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Container(
                                      padding: EdgeInsets.only(top: 32.0),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: AppointmentSample(),
                                    ));
                          },
                          child: new Text(
                            "See Sample",
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      ResumeInput(
                        controller: _companyNameController,
                        labelText: "Enter Company Name",
                        hintText: "Rex Tech Global",
                      ),
                      ResumeInput(
                        controller: _companyAddressController,
                        labelText: "Enter Company Address",
                        hintText: "1234 texas grace street",
                      ),
                      ResumeInput(
                        controller: _companyCityController,
                        labelText: "Enter Company City Name",
                        hintText: "Rex tech estate Owerri",
                      ),
                      ResumeInput(
                        controller: _companyStateController,
                        labelText: "Enter State",
                        hintText: "Lagos State",
                      ),
                      ResumeInput(
                        controller: _companyZipCodeController,
                        labelText: "Enter Zip Code",
                        hintText: "57957403",
                      ),
                      ResumeInput(
                        controller: _recipientNameController,
                        labelText: "Enter Recipient Name",
                        hintText: "Amadi Austin Chukwuemeka",
                      ),
                      ResumeInput(
                        controller: _recipientAddressController,
                        labelText: "Enter Recipient Address",
                        hintText: "No 24 Rex street",
                      ),
                      ResumeInput(
                        controller: _recipientCityController,
                        labelText: "Enter Recipient City Name",
                        hintText: "Austin Texas",
                      ),
                      ResumeInput(
                        controller: _recipientStateController,
                        labelText: "Enter Recipient State",
                        hintText: "Abuja",
                      ),
                      ResumeInput(
                        controller: _recipientZipCodeController,
                        labelText: "Enter Recipient Zip Code",
                        hintText: "803850058",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //widget.tabController.animateTo(0);
                            },
                            color: kLight_orange,
                            textColor: Colors.white,
                            child: Text("Back To Home"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: RaisedButton(
                              color: Colors.black,
                              onPressed: () {
                                validateAndSaveData();
                              },
                              child: new Text(
                                "Next",
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
