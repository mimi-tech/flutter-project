import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/alumni/models/alumni_user.dart';
import 'package:sparks/alumni/services/alumni_db.dart';
import 'package:sparks/alumni/utilities/show_toast_alumni.dart';
import 'package:sparks/alumni/views/school_department_view.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/market/utilities/market_mixin.dart';
import 'package:sparks/utilities/colors.dart';
import 'package:sparks/utilities/styles.dart';

class JoinAlumniForm extends StatefulWidget {
  final String? schoolId;
  final String? schoolOwnerId;
  final String schoolName;
  final String? schoolStreet;
  final String? schoolCity;
  final String? schoolLogo;

  JoinAlumniForm({
    Key? key,
    required this.schoolId,
    required this.schoolOwnerId,
    required this.schoolName,
    required this.schoolStreet,
    required this.schoolCity,
    required this.schoolLogo,
  }) : super(key: key);

  @override
  _JoinAlumniFormState createState() => _JoinAlumniFormState();
}

class _JoinAlumniFormState extends State<JoinAlumniForm> with MarketMixin {
  AlumniDB _alumniDB = AlumniDB(userId: GlobalVariables.loggedInUserObject.id);

  /// Holds the selected date. Defaults to today's date.
  DateTime selectedDate = DateTime.now();

  String _inputtedName = "";

  String _selectedSchoolDepartment = "";

  bool _hasPickedDate = false;

  bool _isSubmitButtonEnabled = true;

  void deptSelectedHandler(String dept) {
    setState(() => _selectedSchoolDepartment = dept);
  }

  /// Method that display a calendar dialog for a user to pick their "entry year"
  /// into their alma mater
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, _) {
          return Theme(
            data: ThemeData.light().copyWith(
              // primaryColor: const Color(0xff883883),
              // accentColor: kPrimaryColor,
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: _!,
          );
        },
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(1950),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        initialDatePickerMode: DatePickerMode.year,
        helpText: "Select your Entry Year");
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _hasPickedDate = true;
      });
  }

  void exploreBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top +
                24.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SchoolDepartmentView(
          prevSelectedDept: _selectedSchoolDepartment,
          chosenDepartment: deptSelectedHandler,
        ),
      ),
    );
  }

  void toastMessage(String message) {
    ShowToastAlumni.showToastMessage(
        toastMessage: message,
        bgColor: kGreyColor,
        textColor: kWhiteColor,
        gravity: ToastGravity.CENTER);
  }

  void _formValidatorHandler() {
    setState(() => _isSubmitButtonEnabled = false);

    /// All fields are empty
    if (_inputtedName.isEmpty &&
        !_hasPickedDate &&
        _selectedSchoolDepartment.isEmpty) {
      toastMessage("Fields cannot be empty");
      setState(() => _isSubmitButtonEnabled = true);

      return;
    }

    if (_inputtedName.isEmpty) {
      toastMessage("Please enter name");
      setState(() => _isSubmitButtonEnabled = true);

      return;
    }

    if (!_hasPickedDate) {
      toastMessage("Please select year of entry");
      setState(() => _isSubmitButtonEnabled = true);

      return;
    }

    if (_selectedSchoolDepartment.isEmpty) {
      toastMessage("Please select a department");
      setState(() => _isSubmitButtonEnabled = true);

      return;
    }

    _inputtedName = capitalizeFirstLetterOfWords(_inputtedName);

    AlumniUser joinSchool = AlumniUser(
      id: GlobalVariables.loggedInUserObject.id,
      accId: widget.schoolOwnerId,
      schId: widget.schoolId,
      name: _inputtedName,
      ts: DateTime.now().millisecondsSinceEpoch,
      yr: selectedDate.year,
      dept: _selectedSchoolDepartment,
    );

    print("USER ID: ${joinSchool.id}");
    print("OWNER ID: ${joinSchool.accId}");
    print("SCH ID: ${joinSchool.schId}");
    print("NAME: ${joinSchool.name}");
    print("TS: ${joinSchool.ts}");
    print("YEAR: ${joinSchool.yr}");
    print("DEPT: ${joinSchool.dept}");

    _alumniDB.joinAlumni(joinSchool).then((value) {
      print("_formValidatorHandler: Successfully joined alumni");

      /// TODO: Navigate to new page here
    }).catchError((onError) {
      print("_formValidatorHandler: $onError");
      setState(() => _isSubmitButtonEnabled = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("FROM JOIN ALUMNI: ${widget.schoolId}");
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.close,
                size: 24.0,
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.schoolName,
              style: kTextStyleFont15Bold.copyWith(color: kWhiteColor),
            ),
            Text(
              "${widget.schoolStreet}, ${widget.schoolCity}",
              style: kTextStyleFont15Regular.copyWith(
                color: kWhiteColor,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// School Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryColor,
                    value: progress.progress,
                  ),
                ),
                imageUrl: widget.schoolLogo!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    "Name",
                    style: kTextStyleFont15Bold.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),

                  TextField(
                    style: kTextStyleFont15Medium,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: kTextStyleFont15Medium.copyWith(
                        fontSize: 16.0,
                        color: kHintColor1,
                      ),
                    ),
                    onChanged: (String value) {
                      _inputtedName = value.trim();
                    },
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),

                  /// Entry Year
                  Text(
                    "Entry year",
                    style: kTextStyleFont15Bold.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        _hasPickedDate
                            ? selectedDate.year.toString()
                            : "Enter your entry year",
                        style: kTextStyleFont15Medium.copyWith(
                          fontSize: 16.0,
                          color: _hasPickedDate ? null : kHintColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),

                  /// Department
                  Text(
                    "Department",
                    style: kTextStyleFont15Bold.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Choose department clicked!!!");
                      exploreBottomSheet();
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Text(
                        _selectedSchoolDepartment.isNotEmpty
                            ? _selectedSchoolDepartment
                            : "Enter your department",
                        style: kTextStyleFont15Medium.copyWith(
                          fontSize: 16.0,
                          color: _selectedSchoolDepartment.isNotEmpty
                              ? null
                              : kHintColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),

                  SizedBox(
                    height: 36.0,
                  ),

                  /// Submit button
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: _isSubmitButtonEnabled
                            ? () => _formValidatorHandler()
                            : null,
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kPrimaryColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: kTextStyleFont15Bold.copyWith(
                              fontSize: 20.0, color: kWhiteColor),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
