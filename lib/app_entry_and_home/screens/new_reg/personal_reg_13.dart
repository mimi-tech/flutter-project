import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/list/high_school_courses.dart';
import 'package:sparks/app_entry_and_home/list/mainOccuption.dart';
import 'package:sparks/app_entry_and_home/list/occupations.dart';
import 'package:sparks/app_entry_and_home/list/speciality.dart';
import 'package:sparks/app_entry_and_home/list/university_courses_asset.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/profile_reg/specialities_dialog.dart';
import 'package:sparks/app_entry_and_home/screens/profile_reg_complete.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg13 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg13({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg13State createState() => _PersonalReg13State();
}

class _PersonalReg13State extends State<PersonalReg13>
    with TickerProviderStateMixin {
  late Animation<Offset> offset;
  late AnimationController _controller;
  List<String?>? listOfSpecialities;
  List<String>? listOfSpecialitiesFromDialog;
  late List<Widget> specialitiesCollection;
  String? selectedSpec;

  //TODO: Create a dialog for selecting specialities.
  Widget specialitiesDialog() {
    Dialog specialitiesDialog = Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.9,
        color: kWhiteColour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 9,
              child:
                  /*SpecialityDialog(
                speciality: CustomFunctions().specialityObject(
                  Specialties().specialities(highSchoolCoursesAsset,
                      fullOccupationsAsset, fullUniversityCoursesAsset),
                ),
              ),*/ // ---- this was the old speciality object ----
                  SpecialityDialog(
                speciality: CustomFunctions().specialityObject(mainOccupation),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FlatButton(
                  color: kProfile,
                  onPressed: () async {
                    SharedPreferences prefsSpec =
                        await SharedPreferences.getInstance();
                    List<String>? spec =
                        prefsSpec.getStringList("AllChosenSpeciality");
                    if ((spec == null) || (spec.isEmpty)) {
                      print("Empty");
                      Navigator.pop(
                        context,
                        prefsSpec.getStringList("AllChosenSpeciality"),
                      );
                    } else if ((spec != null) || (spec.isNotEmpty)) {
                      prefsSpec.clear();
                      Navigator.pop(
                        context,
                        spec,
                      );
                    }
                  },
                  child: Text(
                    kClose,
                    style: TextStyle(
                      color: kWhiteColour,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                      fontSize: kFont_size_18.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return specialitiesDialog;
  }

  //TODO: Create a specialities chip.
  Widget specialitiesChip(String? mySpeciality) {
    SpecialtiesModel lModel = SpecialtiesModel(specialities: mySpeciality);

    Widget chip = Padding(
      padding: const EdgeInsets.all(3.0),
      child: Chip(
        backgroundColor: kP_Chip_Colour,
        label: Text(
          lModel.specialities!,
          style: TextStyle(
            fontSize: kFontSizeAnonynousUser,
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.bold,
            color: kWhiteColour,
          ),
        ),
        deleteIconColor: kWhiteColour,
        onDeleted: () {
          setState(() {
            int specialityId = listOfSpecialities!.indexOf(lModel.specialities);
            listOfSpecialities!.removeAt(specialityId);
            specialitiesCollection.clear();

            //TODO: Rebuild the language chip.
            for (String? spec in listOfSpecialities!) {
              specialitiesCollection.add(specialitiesChip(spec));
            }
          });
        },
      ),
    );

    return chip;
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();

    listOfSpecialities = [];
    listOfSpecialitiesFromDialog = null;
    specialitiesCollection = [];
    selectedSpec = null;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //TODO: Sparks main background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/app_entry_and_home/sparksbg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: A second faded background.
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/app_entry_and_home/new_images/faded_spark_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //TODO: Content of this screen starts here.
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: SizedBox(
                          child: Image(
                            width: 200.0,
                            height: 80.0,
                            image: AssetImage(
                              'images/app_entry_and_home/new_images/sparks_new_logo.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "images/app_entry_and_home/new_images/title_bg.png",
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          kRevenue_info_label,
                          style: TextStyle(
                            fontSize: kFont_size_18.sp,
                            color: kReg_title_colour,
                            fontFamily: 'Rajdhani',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SlideTransition(
                        position: offset,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.48,
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //TODO: Display the page info.
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                  ),
                                  child: Center(
                                    child: Text(
                                      kRevenue_info_label_sub,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'RajdhaniMedium',
                                        color: kWhiteColour,
                                        fontSize: kVerifying_size.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              //TODO: Displays user's speciality.
                              Center(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                    right: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border(
                                      left: BorderSide(
                                        width: 0.5,
                                        color: kProfile,
                                      ),
                                      right: BorderSide(
                                        width: 0.5,
                                        color: kProfile,
                                      ),
                                      top: BorderSide(
                                        width: 0.5,
                                        color: kProfile,
                                      ),
                                      bottom: BorderSide(
                                        width: 0.5,
                                        color: kProfile,
                                      ),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      //TODO: Display user's specialities as a chip.
                                      children: specialitiesCollection
                                              .isNotEmpty
                                          ? specialitiesCollection.toList()
                                          : <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.28,
                                                child: Center(
                                                  child: Text(
                                                    kMy_spec,
                                                    style: TextStyle(
                                                      fontSize:
                                                          kFont_size_18.sp,
                                                      fontFamily: 'Rajdhani',
                                                      color: kHintColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              //TODO: Display Add Specialties.
                              GestureDetector(
                                onTap: () async {
                                  listOfSpecialitiesFromDialog =
                                      await showDialog(
                                    context: this.context,
                                    builder: (context) => WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: specialitiesDialog(),
                                    ),
                                  );

                                  if ((listOfSpecialitiesFromDialog == null) ||
                                      (listOfSpecialitiesFromDialog!.isEmpty)) {
                                    //TODO: Do nothing if listOfSpecialities is null or empty.
                                  } else if ((listOfSpecialitiesFromDialog !=
                                          null) ||
                                      (listOfSpecialitiesFromDialog!
                                          .isNotEmpty)) {
                                    listOfSpecialities!
                                        .addAll(listOfSpecialitiesFromDialog!);

                                    setState(() {
                                      if (specialitiesCollection.isEmpty) {
                                        for (String? chosenSpec
                                            in listOfSpecialities!) {
                                          selectedSpec = chosenSpec;
                                          specialitiesCollection.add(
                                            specialitiesChip(selectedSpec),
                                          );
                                        }
                                      } else if (specialitiesCollection
                                          .isNotEmpty) {
                                        specialitiesCollection.clear();
                                        for (String? chosenSpec
                                            in listOfSpecialities!) {
                                          selectedSpec = chosenSpec;
                                          specialitiesCollection.add(
                                            specialitiesChip(selectedSpec),
                                          );
                                        }
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    color: kProfile,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      kSelect_speciality,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          color: kWhiteColour,
                                          fontSize: kFont_size_18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          right: MediaQuery.of(context).size.width * 0.04,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            //TODO: Display progress indicator.
                            PersonalReg().createState().createProgressIndicator(
                                widget.currentPage, context),
                            //TODO: Display a circular next button.
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();

                                  User? firebaseUser =
                                      FirebaseAuth.instance.currentUser;

                                  //TODO: validate the list of languages and see if it is empty or not.
                                  if ((listOfSpecialities == null) ||
                                      (listOfSpecialities!.isEmpty)) {
                                    Fluttertoast.showToast(
                                        msg: kSpec_err,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: kLight_orange,
                                        textColor: kWhiteColour,
                                        fontSize: kVerifying_size.sp);
                                  } else {
                                    //TODO: Store the user's specialities
                                    GlobalVariables.specialities =
                                        listOfSpecialities;

                                    setState(() {
                                      //TODO: Go to the fourteenth page (Personal Account)
                                      if (firebaseUser != null) {
                                        //TODO: Create a personal account for a user who is already logged in.
                                        DatabaseService(
                                                loggedInUserID:
                                                    firebaseUser.uid)
                                            .addPersonalAccount(firebaseUser);

                                        //print("Successful");
                                        Navigator.pushNamed(
                                            context, RegistrationCompleted.id);
                                      } else {
                                        widget.pageController.animateToPage(
                                          widget.currentPage.floor(),
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kProfile,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 42.0,
                                      color: kWhiteColour,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
