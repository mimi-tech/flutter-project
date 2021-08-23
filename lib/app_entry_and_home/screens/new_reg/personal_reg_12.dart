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
import 'package:sparks/app_entry_and_home/screens/profile_reg/interest_dialog.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg12 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg12({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg12State createState() => _PersonalReg12State();
}

class _PersonalReg12State extends State<PersonalReg12>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offset;
  List<String?>? listOfInterest;
  List<String>? listOfInterestFromDialog = [];
  late List<Widget> areaOfInterest;
  String? selectedInterest;

  //TODO: Create a dialog for selecting interests.
  Widget interestsDialog() {
    Dialog interestsDialog = Dialog(
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
                  /*InterestDialog(
                interest: CustomFunctions().interestObject(
                  Specialties().specialities(highSchoolCoursesAsset,
                      fullOccupationsAsset, fullUniversityCoursesAsset),
                ),
              ),*/ // ---- this was the old interest object ----
                  InterestDialog(
                interest: CustomFunctions().newInterestObject(mainOccupation),
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
                    SharedPreferences prefsInt =
                        await SharedPreferences.getInstance();
                    List<String>? int1 =
                        prefsInt.getStringList("AreaOfInterest");
                    if ((int1 == null) || (int1.isEmpty)) {
                      print("Empty");
                      Navigator.pop(
                        context,
                        prefsInt.getStringList("AreaOfInterest"),
                      );
                    } else if ((int1 != null) || (int1.isNotEmpty)) {
                      print("Not Empty");

                      prefsInt.clear();
                      Navigator.pop(
                        context,
                        int1,
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
    return interestsDialog;
  }

  //TODO: Create an interest chip.
  Widget interestChip(String? areaOfInt) {
    InterestModel lModel = InterestModel(interest: areaOfInt);

    Widget chip = Padding(
      padding: const EdgeInsets.all(3.0),
      child: Chip(
        backgroundColor: kP_Chip_Colour,
        label: Text(
          lModel.interest!,
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
            int hobbyId = listOfInterest!.indexOf(lModel.interest);
            listOfInterest!.removeAt(hobbyId);
            areaOfInterest.clear();

            //TODO: Rebuild the language chip.
            for (String? int in listOfInterest!) {
              areaOfInterest.add(interestChip(int));
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

    listOfInterest = [];

    areaOfInterest = [];
    selectedInterest = null;
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
                          kExperts_info_rem,
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
                              //TODO: Display page info.
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                  ),
                                  child: Center(
                                    child: Text(
                                      kSelect_Area_int,
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
                              //TODO: Displays user's area(s) of interest.
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
                                      //TODO: Display user's spoken language(s) as a chip.
                                      children: areaOfInterest.isNotEmpty
                                          ? areaOfInterest.toList()
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
                                                    kMy_interest,
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
                              //TODO: Display selected area of interest(s).
                              GestureDetector(
                                //TODO: Click to select your area of interest.
                                onTap: () async {
                                  listOfInterestFromDialog = await showDialog(
                                    context: this.context,
                                    builder: (context) => WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: interestsDialog(),
                                    ),
                                  );

                                  if ((listOfInterestFromDialog == null) ||
                                      (listOfInterestFromDialog!.isEmpty)) {
                                    //TODO: Do nothing if listOfInterest is null or empty.
                                    print("----------------------");
                                  } else if ((listOfInterestFromDialog !=
                                          null) ||
                                      (listOfInterestFromDialog!.isNotEmpty)) {
                                    listOfInterest!
                                        .addAll(listOfInterestFromDialog!);
                                    print(listOfInterest);
                                    setState(() {
                                      if (areaOfInterest.isEmpty) {
                                        for (String? chosenInt
                                            in listOfInterest!) {
                                          selectedInterest = chosenInt;
                                          areaOfInterest.add(
                                            interestChip(selectedInterest),
                                          );
                                        }
                                      } else if (areaOfInterest.isNotEmpty) {
                                        print("My list is not empty ");
                                        areaOfInterest.clear();
                                        for (String? chosenInt
                                            in listOfInterest!) {
                                          selectedInterest = chosenInt;
                                          areaOfInterest.add(
                                            interestChip(selectedInterest),
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
                                      kSelect_interest,
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
                                  //TODO: validate the list of interest and see if it is empty or not.
                                  if ((listOfInterest == null) ||
                                      (listOfInterest!.isEmpty)) {
                                    Fluttertoast.showToast(
                                        msg: kArea_err,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: kLight_orange,
                                        textColor: kWhiteColour,
                                        fontSize: kVerifying_size.sp);
                                  } else {
                                    //TODO: Store the user's area of interest
                                    GlobalVariables.areaOfInterest =
                                        listOfInterest;

                                    //TODO: Get all the industries associated with all interests selected by the user.
                                    List<String> associatedIndustries =
                                        Specialties.myIndustries(
                                            listOfInterest);

                                    //TODO: Store user's associated industries.
                                    GlobalVariables.userIndustries =
                                        associatedIndustries;

                                    print(GlobalVariables.userIndustries);

                                    setState(() {
                                      //TODO: Go to the thirteenth page (Personal Account)
                                      widget.pageController.animateToPage(
                                        widget.currentPage.floor(),
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
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
