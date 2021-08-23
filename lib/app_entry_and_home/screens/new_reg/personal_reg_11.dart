import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/list/hobbies.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/profile_reg/hobby_dialog.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg11 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg11({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg11State createState() => _PersonalReg11State();
}

class _PersonalReg11State extends State<PersonalReg11>
    with TickerProviderStateMixin {
  List<String?> listOfHobbies = [];
  List<String>? listOfHobbiesFromDialog = [];
  List<Widget> favouriteHobbies = [];
  String? selectedHobby;
  late AnimationController _controller;
  late Animation<Offset> offset;

  //TODO: Creates a dialog for selecting hobbies.
  Widget hobbiesDialog() {
    Dialog useDialog = Dialog(
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
              child: HobbyDialog(
                hobbies: CustomFunctions().hobbyObject(hobbiesAsset),
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
                    SharedPreferences prefsHob =
                        await SharedPreferences.getInstance();
                    List<String>? hob1 =
                        prefsHob.getStringList("AllChosenHobbies");

                    if ((hob1 == null) || (hob1.isEmpty)) {
                      Navigator.pop(
                        context,
                        prefsHob.getStringList("AllChosenHobbies"),
                      );
                    } else if ((hob1 != null) || (hob1.isNotEmpty)) {
                      prefsHob.clear();
                      Navigator.pop(
                        context,
                        hob1,
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
    return useDialog;
  }

  //TODO: Create a hobbies chip.
  Widget hobbyChip(String? favouriteHobby) {
    HobbiesModel lModel = HobbiesModel(hobby: favouriteHobby);

    Widget chip = Padding(
      padding: const EdgeInsets.all(3.0),
      child: Chip(
        backgroundColor: kP_Chip_Colour,
        label: Text(
          lModel.hobby!,
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
            int hobbyId = listOfHobbies.indexOf(lModel.hobby);
            listOfHobbies.removeAt(hobbyId);
            favouriteHobbies.clear();

            //TODO: Rebuild the language chip.
            for (String? hob in listOfHobbies) {
              favouriteHobbies.add(hobbyChip(hob));
            }
          });
        },
      ),
    );

    return chip;
  }

  @override
  void initState() {
    selectedHobby = null;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();

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
                              //TODO: Display the label: What's your hobby.
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                  ),
                                  child: Center(
                                    child: Text(
                                      kSelect_hobby_sub_info,
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
                              //TODO: Displays user's hobbies.
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
                                      //TODO: Display user's hobbies as a chip.
                                      children: favouriteHobbies.isNotEmpty
                                          ? favouriteHobbies.toList()
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
                                                    kMy_hobby,
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
                              //TODO: Display Add Your Hobbies.
                              GestureDetector(
                                onTap: () async {
                                  listOfHobbiesFromDialog = await showDialog(
                                    context: this.context,
                                    builder: (context) => WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: hobbiesDialog(),
                                    ),
                                  );

                                  if ((listOfHobbiesFromDialog == null) ||
                                      (listOfHobbiesFromDialog!.isEmpty)) {
                                    //TODO: Do nothing if listOfHobbiesFromDialog is null or empty.
                                  } else if ((listOfHobbiesFromDialog !=
                                          null) ||
                                      (listOfHobbiesFromDialog!.isNotEmpty)) {
                                    listOfHobbies
                                        .addAll(listOfHobbiesFromDialog!);
                                    print(listOfHobbies);
                                    setState(() {
                                      if (favouriteHobbies.isEmpty) {
                                        for (String? chosenHob
                                            in listOfHobbies) {
                                          selectedHobby = chosenHob;
                                          favouriteHobbies.add(
                                            hobbyChip(selectedHobby),
                                          );
                                        }
                                      } else if (favouriteHobbies.isNotEmpty) {
                                        print("My list is not empty ");
                                        favouriteHobbies.clear();
                                        for (String? chosenHob
                                            in listOfHobbies) {
                                          selectedHobby = chosenHob;
                                          favouriteHobbies.add(
                                            hobbyChip(selectedHobby),
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
                                      kSelect_hobby_label,
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
                                  //TODO: validate the list of languages and see if it is empty or not.
                                  if ((listOfHobbies == null) ||
                                      (listOfHobbies.isEmpty)) {
                                    Fluttertoast.showToast(
                                        msg: kHob_err,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: kLight_orange,
                                        textColor: kWhiteColour,
                                        fontSize: kVerifying_size.sp);
                                  } else {
                                    //TODO: Store the user's hobbies.
                                    GlobalVariables.hobbies = listOfHobbies;

                                    setState(() {
                                      //TODO: Go to the eleventh page (Personal Account)
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
