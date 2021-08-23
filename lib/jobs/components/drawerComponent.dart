import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/jobs/colors/colors.dart';
import 'package:sparks/jobs/screens/jobs_filter.dart';
import 'package:sparks/jobs/screens/professional_Filter.dart';
import 'package:sparks/market/screens/market_product_listing.dart';
import 'package:sparks/market/utilities/market_const.dart';

class JobHomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    /// Rebuild the section called manage account
    Widget managingUsersAccount() {
      Widget mA;

      mA = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.allMyAccountTypes, accountGateWay.id),
      );

      return mA;
    }

    /// Displays all the accounts and show the one that is active
    Widget settingActiveAcct() {
      Widget activeAcct = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.updatedAcct, accountGateWay.id),
      );

      return activeAcct;
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, MarketProductListing.id);
              },
              color: Colors.yellowAccent,
              child: Text('Become a professional'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  kManageAcc,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontSize: kFont_size.sp,
                      color: kLight_orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, PersonalReg.id);
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                  iconSize: 40.0,
                  padding: EdgeInsets.all(0.0),
                  color: kLight_orange,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //TODO: Display all the account a user has and show the account that is active.
            GlobalVariables.updatedAcct.isEmpty
                ? managingUsersAccount()
                : settingActiveAcct(),
          ],
        ),
      ),
    );
  }
}

class JobFilterDrawer extends StatefulWidget {
  @override
  _JobFilterDrawerState createState() => _JobFilterDrawerState();
}

class _JobFilterDrawerState extends State<JobFilterDrawer> {
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();

  /// FocusNodes for the 'min price' & 'max price' TextFields
  /// TODO: Remove focus nodes if not necessary
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  /// These are the RangeValues for the RangeSlider Widget
  late double _lowPriceRange;
  late double _highPriceRange;

  /// The minimum and maximum values allowed for the price input
  double minRangeSliderValue = 0.0;
  double maxRangeSliderValue = 1000000.0;

  /// Boolean validator for 'MIN' and 'MAX' price TextFields
  bool isMinValid = true;
  bool isMaxValid = true;

  /// Note: This function is called in the "initState"
  void setDefaultValuesOfSalary() {
    setState(() {
      if (_minSalaryController.text.trim() == null ||
          _minSalaryController.text.trim() == "") {
        _lowPriceRange = 0;
      } else {
        _lowPriceRange = double.parse(_minSalaryController.text.trim());
      }

      if (_maxSalaryController.text.trim() == null ||
          _maxSalaryController.text.trim() == "") {
        _highPriceRange = 1000000;
      } else {
        _highPriceRange = double.parse(_maxSalaryController.text.trim());
      }
    });
  }

  //TODO: Declare and initializing the filter variables
  /// string variable for setting the two radio buttons to true or false
  String jobTypeGroupValue = "In-Person";

  /// I am setting the In-Person button to true by default
  String jobType = "In-Person";

  ///  string variable for setting the three check buttons to true or false
  ///  and I am setting the fullTimeCheckboxValue to true by default
  bool? fullTimeCheckboxValue = true;
  bool? partTimeCheckboxValue = false;
  bool? contractCheckboxValue = false;
  bool disableFilter = false;

  /// string variable for storing filter values
  String fullTimeValue = "full time";
  String partTimeValue = "part time";
  String contractValue = "contract";
  String? jobLocation;
  String? mainMinSalary;
  String? minSalary;
  var _dateTime;
  bool hideFilter = false;
  StreamBuilder<QuerySnapshot>? filterDisplayCard;
  StreamBuilder<QuerySnapshot>? pFilterDisplayCard;
  Stream? filteredJobStream;

  //TODO:Declaring and initializing Job variables
  bool showFilterCard = false;
  bool enable = true;

  //TODO:Declaring and initializing Professional variables
  bool showProfessionalFilterCard = false;
  bool professionalEnable = true;
  bool filterColor = false;

  //TODO: Get values for the Job type details
  void changeJobTypeState(value) {
    if (value == "In-Person") {
      setState(() {
        jobTypeGroupValue = "In-Person";
        jobType = "in person";
      });
    } else if (value == "Remote") {
      setState(() {
        jobTypeGroupValue = "Remote";
        jobType = "remote";
      });
    }
    print(jobType);
  }

  //TODO: change the filter color once filter is active
  void changeFilterColor() {
    if (showProfessionalFilterCard == true) {
      setState(() {
        filterColor = true;
      });
    } else if (showFilterCard == true) {
      setState(() {
        filterColor = true;
      });
    }
  }

  //TODO: The filter function without location and Date
  void filterFunction() {
    //TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = _minSalaryController.text;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

//TODO: The filter function with location and Date
  void locationAndDateFilterFunction() {
    // TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = _minSalaryController.text;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

  //TODO: The filter function with location only
  void locationFilterFunction() {
    //TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = _minSalaryController.text;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jlt", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

  //TODO: The filter function with date only
  void dateFilterFunction() {
    // TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = _minSalaryController.text;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredJobStream = FirebaseFirestore.instance
            .collectionGroup('companyJobs')
            .where("jtp", isEqualTo: jobType)
            .where("jtm",
                isEqualTo:
                    DateFormat("yyyy-MM-dd").format(_dateTime).toString())
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("jcg", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaultValuesOfSalary();
    // _minSalaryController = TextEditingController(text: ProfessionalStorage.salaryRangeMin);
    // _maxSalaryController = TextEditingController(text: ProfessionalStorage.salaryRangeMax);
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _minSalaryController.dispose();
    _maxSalaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 20.0),
                  child: Text(
                    'FILTER BY',
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CLEAR FILTER',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Text(
              'Job Type',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: "In-Person",
                      groupValue: jobTypeGroupValue,
                      activeColor: Colors.red,
                      onChanged: (dynamic val) => changeJobTypeState(val),
                    ),
                    Text(
                      'In-Person',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 60.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: "Remote",
                      groupValue: jobTypeGroupValue,
                      activeColor: Colors.red,
                      onChanged: (dynamic val) => changeJobTypeState(val),
                    ),
                    Text(
                      'Remote',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Divider(
              color: kShade,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Text(
              'Location',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20, 0.0),
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    hintText: "Enter Job Location",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kShade,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
                onChanged: (value) {
                  setState(() {
                    jobLocation = value;
                  });
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Divider(
              color: kShade,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
            child: Text(
              'Enter Salary Range',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /// TextField for the 'MIN' price input field
                      Flexible(
                        child: Container(
                          width: ScreenUtil().setWidth(96),
                          child: TextField(
                            controller: _minSalaryController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: kMSearchDrawerTextStyle,
                            keyboardType: TextInputType.number,
                            focusNode: _minPriceFocusNode,
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
                              hintText: 'MIN',
                              hintStyle: kMSearchDrawerTextStyle,
                            ),
                            onSubmitted: (value) {
                              _minPriceFocusNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_maxPriceFocusNode);
                            },
                            onChanged: (value) {
                              if (value == null || value == '') {
                                setState(() {
                                  _lowPriceRange = minRangeSliderValue;
                                });
                              } else if (double.parse(value) <=
                                      maxRangeSliderValue &&
                                  double.parse(value) >= minRangeSliderValue &&
                                  double.parse(value) <= _highPriceRange) {
                                setState(() {
                                  _lowPriceRange = double.parse(value);
                                });
                              } else {
                                setState(() {
                                  _lowPriceRange = minRangeSliderValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(44),
                      ),

                      /// TextField for the 'MAX' price input field
                      Flexible(
                        child: Container(
                          width: ScreenUtil().setWidth(96),
                          child: TextField(
                            controller: _maxSalaryController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: kMSearchDrawerTextStyle,
                            keyboardType: TextInputType.number,
                            focusNode: _maxPriceFocusNode,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kMarketPrimaryColor),
                              ),
                              hintText: 'MAX',
                              hintStyle: kMSearchDrawerTextStyle,
                              errorText: isMaxValid ? null : 'Shit not working',
                            ),
                            onSubmitted: (value) {
                              _maxPriceFocusNode.unfocus();
                            },
                            onChanged: (value) {
                              if (value == null || value == '') {
                                setState(() {
                                  _highPriceRange = maxRangeSliderValue;
                                });
                              } else if (double.parse(value) <=
                                      maxRangeSliderValue &&
                                  double.parse(value) >= minRangeSliderValue &&
                                  double.parse(value) >= _lowPriceRange) {
                                setState(() {
                                  _highPriceRange = double.parse(value);
                                });
                              } else {
                                setState(() {
                                  _highPriceRange = maxRangeSliderValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// RangeSlider for the 'Price Range'
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RangeSlider(
                    activeColor: kMarketSecondaryColor,
                    inactiveColor: Color(0xffB9BEC5),
                    values: RangeValues(_lowPriceRange, _highPriceRange),
                    divisions: 50,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _lowPriceRange = values.start.roundToDouble();
                        _highPriceRange = values.end.roundToDouble();
                        _minSalaryController.text =
                            values.start.toInt().toString();
                        _maxSalaryController.text =
                            values.end.toInt().toString();
                      });
                    },
                    min: minRangeSliderValue,
                    max: maxRangeSliderValue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Divider(
              color: kShade,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Date',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    Text(
                      'Pick A Date?',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: RaisedButton(
                    child: Text(_dateTime == null
                        ? 'Click To Pick A Date'
                        : DateFormat("yyyy-MM-dd")
                            .format(_dateTime)
                            .toString()),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate:
                            _dateTime == null ? DateTime.now() : _dateTime,
                        firstDate: DateTime(2019),
                        lastDate: DateTime(2025),
                      ).then((date) {
                        setState(() {
                          _dateTime = date;
                        });
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
            child: Text(
              'Job Category',
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: fullTimeCheckboxValue,
                      activeColor: Colors.transparent,
                      checkColor: Colors.red,
                      onChanged: (bool? val) {
                        print(val);
                        setState(() {
                          fullTimeCheckboxValue = val;
                          disableFilter = false;
                        });
                      },
                    ),
                    Text(
                      'Full Time',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: partTimeCheckboxValue,
                      activeColor: Colors.transparent,
                      checkColor: Colors.red,
                      onChanged: (bool? val) {
                        print(val);
                        setState(() {
                          partTimeCheckboxValue = val;
                          disableFilter = false;
                        });
                      },
                    ),
                    Text(
                      'Part Time',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: contractCheckboxValue,
                  activeColor: Colors.transparent,
                  checkColor: Colors.red,
                  onChanged: (bool? val) {
                    print(val);
                    setState(() {
                      contractCheckboxValue = val;
                      disableFilter = false;
                    });
                  },
                ),
                Text(
                  'Contract',
                  style: new TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Divider(
              color: kShade,
            ),
          ),
          FlatButton(
            onPressed: () {
              //TODO: check if the filter values are empty
              //TODO: checking if the job category boxes were checked
              if (fullTimeCheckboxValue == false &&
                  partTimeCheckboxValue == false &&
                  contractCheckboxValue == false) {
                setState(() {
                  disableFilter = true;
                });
                Fluttertoast.showToast(
                    msg: "Job Category Field Was Not Checked",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                    textColor: Colors.white);
              } else {
                setState(() {
                  disableFilter = false;
                });
                //TODO: perform the filter
                print(jobLocation);

                /// performing filter when location value is not null
                if (jobLocation != null && _dateTime != null) {
                  locationAndDateFilterFunction();
                  print('location and date query');
                  setState(() {
                    jobLocation = null;
                    _dateTime = null;
                  });

                  /// performing filter when location value is not null but date value is null
                } else if (jobLocation != null && _dateTime == null) {
                  locationFilterFunction();
                  print('location query');
                  setState(() {
                    jobLocation = null;
                  });

                  /// performing filter when location value is null but date value is not null
                } else if (jobLocation == null && _dateTime != null) {
                  dateFilterFunction();
                  print('Date query');
                  setState(() {
                    _dateTime = null;
                  });
                }

                /// performing filter when location and date  values are not present
                else {
                  filterFunction();
                  print('normal query');
                }
                //TODO: remove the drawer context
                changeFilterColor();
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: JobFilterPage(
                            filteredJobStream: filteredJobStream)));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: disableFilter == true ? Colors.black : Colors.red,
              ),
              // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              height: ScreenUtil().setHeight(50.0),
              margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    disableFilter == true ? 'FILTER DISABLED' : 'APPLY FILTERS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("images/jobs/filter.png"),
                    )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfessionalDrawerFilter extends StatefulWidget {
  @override
  _ProfessionalDrawerFilterState createState() =>
      _ProfessionalDrawerFilterState();
}

class _ProfessionalDrawerFilterState extends State<ProfessionalDrawerFilter> {
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();

  /// FocusNodes for the 'min price' & 'max price' TextFields
  /// TODO: Remove focus nodes if not necessary
  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  /// These are the RangeValues for the RangeSlider Widget
  late double _lowPriceRange;
  late double _highPriceRange;

  /// The minimum and maximum values allowed for the price input
  double minRangeSliderValue = 0.0;
  double maxRangeSliderValue = 1000000.0;

  /// Boolean validator for 'MIN' and 'MAX' price TextFields
  bool isMinValid = true;
  bool isMaxValid = true;

  /// Note: This function is called in the "initState"
  void setDefaultValuesOfSalary() {
    setState(() {
      if (_minSalaryController.text.trim() == null ||
          _minSalaryController.text.trim() == "") {
        _lowPriceRange = 0;
      } else {
        _lowPriceRange = double.parse(_minSalaryController.text.trim());
      }

      if (_maxSalaryController.text.trim() == null ||
          _maxSalaryController.text.trim() == "") {
        _highPriceRange = 1000000;
      } else {
        _highPriceRange = double.parse(_maxSalaryController.text.trim());
      }
    });
  }

  //TODO: Declare and initializing the filter variables
  /// string variable for setting the two radio buttons to true or false
  String jobTypeGroupValue = "In-Person";

  /// I am setting the In-Person button to true by default
  String jobType = "In-Person";

  ///  string variable for setting the three check buttons to true or false
  ///  and I am setting the fullTimeCheckboxValue to true by default
  bool? fullTimeCheckboxValue = true;
  bool? partTimeCheckboxValue = false;
  bool? contractCheckboxValue = false;
  bool disableFilter = false;

  /// string variable for storing filter values
  String fullTimeValue = "full time";
  String partTimeValue = "part time";
  String contractValue = "contract";
  String? jobLocation;
  String? mainMinSalary;
  String? minSalary;
  var _dateTime;
  bool hideFilter = false;
  StreamBuilder<QuerySnapshot>? filterDisplayCard;
  StreamBuilder<QuerySnapshot>? pFilterDisplayCard;
  Stream? filteredProfStream;

  //TODO:Declaring and initializing Job variables
  bool showFilterCard = false;
  bool enable = true;

  //TODO:Declaring and initializing Professional variables
  bool showProfessionalFilterCard = false;
  bool professionalEnable = true;
  bool filterColor = false;

  //TODO: Get values for the Job type details
  void changeJobTypeState(value) {
    if (value == "In-Person") {
      setState(() {
        jobTypeGroupValue = "In-Person";
        jobType = "in person";
      });
    } else if (value == "Remote") {
      setState(() {
        jobTypeGroupValue = "Remote";
        jobType = "remote";
      });
    }
    print(jobType);
  }

  //TODO: change the filter color once filter is active
  void changeFilterColor() {
    if (showProfessionalFilterCard == true) {
      setState(() {
        filterColor = true;
      });
    } else if (showFilterCard == true) {
      setState(() {
        filterColor = true;
      });
    }
  }

  //TODO: professional location filter functionality
  void professionalLocationQuery() {
    //TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = _minSalaryController.text;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("location", isEqualTo: jobLocation)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

  //TODO: Normal professional filter functonality
  void normalProfessionalFilter() {
    //TODO: Run seven possible queries for the 3 checkboxes when the are set to true or checked
    //TODO: Set the query result to the filter display card and set other display card to false once condition returns true

    //TODO: setting minSalary to Default if null
    if (minSalary == null) {
      setState(() {
        mainMinSalary = "0";
      });
    } else {
      setState(() {
        mainMinSalary = minSalary;
      });
    }

    //TODO:
    if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == false) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue, partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [
          fullTimeValue,
          partTimeValue,
          contractValue
        ]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == false) {
      setState(() {
        print("fourth");
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [partTimeValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == true &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [partTimeValue, contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == false &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [contractValue]).snapshots();
      });
    } else if (fullTimeCheckboxValue == true &&
        partTimeCheckboxValue == false &&
        contractCheckboxValue == true) {
      setState(() {
        filteredProfStream = FirebaseFirestore.instance
            .collection('professionals')
            .where("ajt", isEqualTo: jobType)
            .where("srn", isGreaterThanOrEqualTo: mainMinSalary)
            .where("ajc", whereIn: [fullTimeValue, contractValue]).snapshots();
      });
    } else {
      print('why empty');
    }
    //TODO: Else show a flutter toast showing no value checked
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaultValuesOfSalary();
    // _minSalaryController = TextEditingController(text: ProfessionalStorage.salaryRangeMin);
    // _maxSalaryController = TextEditingController(text: ProfessionalStorage.salaryRangeMax);
  }

  @override
  void dispose() {
    /// Disposing the controllers (min & max controllers) before leaving the page to avoid memory leak
    _minSalaryController.dispose();
    _maxSalaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 148.0),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 20.0),
                    child: Text(
                      'FILTER BY',
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 20.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          filterColor = false;
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        'CLEAR FILTER',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(18.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
              child: Text(
                'Job Type',
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(18.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: "In-Person",
                        groupValue: jobTypeGroupValue,
                        activeColor: Colors.red,
                        onChanged: (dynamic val) => changeJobTypeState(val),
                      ),
                      Text(
                        'In-Person',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 60.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: "Remote",
                        groupValue: jobTypeGroupValue,
                        activeColor: Colors.red,
                        onChanged: (dynamic val) => changeJobTypeState(val),
                      ),
                      Text(
                        'Remote',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Divider(
                color: kShade,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Text(
                'Location',
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(18.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20, 0.0),
              child: Container(
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      hintText: "Enter Job Location",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kShade,
                          style: BorderStyle.solid,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  onChanged: (value) {
                    setState(() {
                      jobLocation = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Divider(
                color: kShade,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
              child: Text(
                'Enter Salary Range',
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(18.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /// TextField for the 'MIN' price input field
                        Flexible(
                          child: Container(
                            width: ScreenUtil().setWidth(96),
                            child: TextField(
                              controller: _minSalaryController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: kMSearchDrawerTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _minPriceFocusNode,
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
                                hintText: 'MIN',
                                hintStyle: kMSearchDrawerTextStyle,
                              ),
                              onSubmitted: (value) {
                                _minPriceFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_maxPriceFocusNode);
                              },
                              onChanged: (value) {
                                if (value == null || value == '') {
                                  setState(() {
                                    _lowPriceRange = minRangeSliderValue;
                                  });
                                } else if (double.parse(value) <=
                                        maxRangeSliderValue &&
                                    double.parse(value) >=
                                        minRangeSliderValue &&
                                    double.parse(value) <= _highPriceRange) {
                                  setState(() {
                                    _lowPriceRange = double.parse(value);
                                  });
                                } else {
                                  setState(() {
                                    _lowPriceRange = minRangeSliderValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(44),
                        ),

                        /// TextField for the 'MAX' price input field
                        Flexible(
                          child: Container(
                            width: ScreenUtil().setWidth(96),
                            child: TextField(
                              controller: _maxSalaryController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: kMSearchDrawerTextStyle,
                              keyboardType: TextInputType.number,
                              focusNode: _maxPriceFocusNode,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kMarketPrimaryColor),
                                ),
                                hintText: 'MAX',
                                hintStyle: kMSearchDrawerTextStyle,
                                errorText:
                                    isMaxValid ? null : 'Shit not working',
                              ),
                              onSubmitted: (value) {
                                _maxPriceFocusNode.unfocus();
                              },
                              onChanged: (value) {
                                if (value == null || value == '') {
                                  setState(() {
                                    _highPriceRange = maxRangeSliderValue;
                                  });
                                } else if (double.parse(value) <=
                                        maxRangeSliderValue &&
                                    double.parse(value) >=
                                        minRangeSliderValue &&
                                    double.parse(value) >= _lowPriceRange) {
                                  setState(() {
                                    _highPriceRange = double.parse(value);
                                  });
                                } else {
                                  setState(() {
                                    _highPriceRange = maxRangeSliderValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RangeSlider for the 'Price Range'
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RangeSlider(
                      activeColor: kMarketSecondaryColor,
                      inactiveColor: Color(0xffB9BEC5),
                      values: RangeValues(_lowPriceRange, _highPriceRange),
                      divisions: 50,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _lowPriceRange = values.start.roundToDouble();
                          _highPriceRange = values.end.roundToDouble();
                          _minSalaryController.text =
                              values.start.toInt().toString();
                          _maxSalaryController.text =
                              values.end.toInt().toString();
                        });
                      },
                      min: minRangeSliderValue,
                      max: maxRangeSliderValue,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Divider(
                color: kShade,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
              child: Text(
                'Job Category',
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(18.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: fullTimeCheckboxValue,
                        activeColor: Colors.transparent,
                        checkColor: Colors.red,
                        onChanged: (bool? val) {
                          print(val);
                          setState(() {
                            disableFilter = false;
                            fullTimeCheckboxValue = val;
                          });
                        },
                      ),
                      Text(
                        'Full Time',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: partTimeCheckboxValue,
                        activeColor: Colors.transparent,
                        checkColor: Colors.red,
                        onChanged: (bool? val) {
                          print(val);
                          setState(() {
                            disableFilter = false;
                            partTimeCheckboxValue = val;
                          });
                        },
                      ),
                      Text(
                        'Part Time',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: contractCheckboxValue,
                    activeColor: Colors.transparent,
                    checkColor: Colors.red,
                    onChanged: (bool? val) {
                      print(val);
                      setState(() {
                        disableFilter = false;
                        contractCheckboxValue = val;
                      });
                    },
                  ),
                  Text(
                    'Contract',
                    style: new TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Divider(
                color: kShade,
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO: check if the filter values are empty
                //TODO: checking if the job category boxes were checked
                if (fullTimeCheckboxValue == false &&
                    partTimeCheckboxValue == false &&
                    contractCheckboxValue == false) {
                  setState(() {
                    disableFilter = true;
                  });
                  Fluttertoast.showToast(
                      msg: "Job Category Field Was Not Checked",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                } else {
                  setState(() {
                    disableFilter = false;
                  });
                  //TODO: perform the filter
                  if (jobLocation != null) {
                    print('location query');
                    professionalLocationQuery();
                    setState(() {
                      jobLocation = null;
                    });
                  }

                  /// performing filter when location and date  values are not present
                  else {
                    print('normal query');
                    normalProfessionalFilter();
                  }
                  //TODO: remove the drawer context
                  changeFilterColor();
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ProfFilterPage(
                              filteredProfStream: filteredProfStream)));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: disableFilter == true ? Colors.black : Colors.red,
                ),
                // margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: ScreenUtil().setHeight(50.0),
                margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      disableFilter == true
                          ? 'FILTER DISABLED'
                          : 'APPLY FILTERS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("images/jobs/filter.png"),
                      )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
