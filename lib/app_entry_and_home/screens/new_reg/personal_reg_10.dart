import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/list/languages.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/screens/profile_reg/language_dialog.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class PersonalReg10 extends StatefulWidget {
  final PageController pageController;
  final double currentPage;

  PersonalReg10({
    required this.pageController,
    required this.currentPage,
  });

  @override
  _PersonalReg10State createState() => _PersonalReg10State();
}

class _PersonalReg10State extends State<PersonalReg10>
    with TickerProviderStateMixin {
  late FocusNode focus;
  late AnimationController _controller;
  late Animation<Offset> offset;
  Animation<double>? _fadeAnimation;
  List<String?>? listOfSpokenLanguages;
  List<String>? spokenLanguagesFromDialog = [];
  String? selectedLanguage;
  late List<Widget> spokenLanguage;

  //TODO: Create a language dialog that will assist the user in selecting his/her spoken language(s).
  Widget languageDialog() {
    Dialog langDialog = Dialog(
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
              child: LanguageDialog(
                languages: CustomFunctions().languageObject(languagesAsset),
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
                    SharedPreferences prefsLang =
                        await SharedPreferences.getInstance();
                    List<String>? lan =
                        prefsLang.getStringList("AllChosenLanguages");
                    if ((lan == null) || (lan.isEmpty)) {
                      print("Empty");
                      Navigator.pop(
                        context,
                        prefsLang.getStringList("AllChosenLanguages"),
                      );
                    } else if ((lan != null) || (lan.isNotEmpty)) {
                      print("Not Empty");

                      prefsLang.clear();
                      Navigator.pop(
                        context,
                        lan,
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
    return langDialog;
  }

  //TODO: Create a language chip.
  Widget languageChip(String? spokenLang) {
    LanguageModel lModel = LanguageModel(languageName: spokenLang);

    Widget chip = Padding(
      padding: const EdgeInsets.all(3.0),
      child: Chip(
        backgroundColor: kP_Chip_Colour,
        label: Text(
          lModel.languageName!,
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
            int langId = listOfSpokenLanguages!.indexOf(lModel.languageName);
            listOfSpokenLanguages!.removeAt(langId);
            spokenLanguage.clear();

            //TODO: Rebuild the language chip.
            for (String? lan in listOfSpokenLanguages!) {
              spokenLanguage.add(languageChip(lan));
            }
          });
        },
      ),
    );

    return chip;
  }

  @override
  void initState() {
    focus = FocusNode();
    focus.unfocus();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    offset = Tween<Offset>(
      begin: Offset(7.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _controller.forward();
    listOfSpokenLanguages = [];
    selectedLanguage = null;
    spokenLanguage = [];

    super.initState();
  }

  @override
  void dispose() {
    focus.dispose();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          kTell_us,
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
                height: MediaQuery.of(context).size.height * 0.12,
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
                          height: MediaQuery.of(context).size.height * 0.43,
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //TODO: Display the label: Enter spoken languages.
                              Center(
                                child: Text(
                                  kEnter_languages,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      color: kWhiteColour,
                                      fontSize: kFont_size_22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              //TODO: Displays user's spoken languages.
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
                                      children: spokenLanguage.isNotEmpty
                                          ? spokenLanguage.toList()
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
                                                    kMy_spoken_language,
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
                              //TODO: Display Add Spoken Languages.
                              GestureDetector(
                                onTap: () async {
                                  spokenLanguagesFromDialog = await showDialog(
                                    context: this.context,
                                    builder: (context) => WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: languageDialog(),
                                    ),
                                  );

                                  if ((spokenLanguagesFromDialog == null) ||
                                      (spokenLanguagesFromDialog!.isEmpty)) {
                                    //TODO: Do nothing if listOfSpokenLanguages is null or empty.

                                  } else if ((spokenLanguagesFromDialog !=
                                          null) ||
                                      (spokenLanguagesFromDialog!.isNotEmpty)) {
                                    listOfSpokenLanguages!
                                        .addAll(spokenLanguagesFromDialog!);

                                    setState(() {
                                      if (spokenLanguage.isEmpty) {
                                        for (String? chosenLang
                                            in listOfSpokenLanguages!) {
                                          selectedLanguage = chosenLang;
                                          spokenLanguage.add(
                                            languageChip(selectedLanguage),
                                          );
                                        }
                                      } else if (spokenLanguage.isNotEmpty) {
                                        spokenLanguage.clear();
                                        for (String? chosenLang
                                            in listOfSpokenLanguages!) {
                                          selectedLanguage = chosenLang;
                                          spokenLanguage.add(
                                            languageChip(selectedLanguage),
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
                                      KAdd_Spoken_Languages,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          color: kWhiteColour,
                                          fontSize: kFont_size_18.sp,
                                          fontWeight: FontWeight.w600,
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
                                  //TODO: validate the list of languages and see if it is empty or not.
                                  if ((listOfSpokenLanguages == null) ||
                                      (listOfSpokenLanguages!.isEmpty)) {
                                    Fluttertoast.showToast(
                                        msg: kLang_err,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: kLight_orange,
                                        textColor: kWhiteColour,
                                        fontSize: kVerifying_size.sp);
                                  } else {
                                    //TODO: Store the user's spoken languages.
                                    GlobalVariables.spokenLanguages =
                                        listOfSpokenLanguages;

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
                        height: MediaQuery.of(context).size.height * 0.05,
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
