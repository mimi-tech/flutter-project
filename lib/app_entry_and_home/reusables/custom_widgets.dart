import 'dart:io';

// import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CustomWidgets extends StatefulWidget {
  //variables declarations and initializations.
  static String yearPicked = "";
  static String postgraduate = "";

  //TODO: Create a list of language model and add it to the language model list.
  Iterable<LanguageModel> languageAssets(List<String> languages) sync* {
    for (int i = 0; i < languages.length; i++) {
      LanguageModel lModel =
          LanguageModel(languageName: languages[i], isChecked: false);
    }
  }

  //TODO: Display a calender picker widget for alumni.
  static Widget alumniDatePicker(BuildContext context, double marginLeft,
      double marginRight, String hintText) {
    Widget alumniDatePicker = Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.035,
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * marginLeft,
        right: MediaQuery.of(context).size.width * marginRight,
      ),
      width: MediaQuery.of(context).size.width * 0.36,
      height: MediaQuery.of(context).size.height * 0.045,
      decoration: BoxDecoration(
        color: kButton_disabled,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(hintText),
    );

    return alumniDatePicker;
  }

  //TODO: Display Alumni card creator
  static Widget alumniCardCreator(BuildContext context, String cardName) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  cardName,
                  style: TextStyle(
                    color: kButton_disabled,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                    fontSize: kFontSizeAnonynousUser.sp,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: kBorder_colour,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomWidgets.alumniDatePicker(
                    context, 0.03, 0.0, kAlumni_from),
                CustomWidgets.alumniDatePicker(context, 0.0, 0.03, kAlumni_to),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  _CustomWidgetsState createState() => _CustomWidgetsState();
}

class _CustomWidgetsState extends State<CustomWidgets> {
  String _valueSelected = "";
  File? _selectedFile;

  //TODO: Create a FilterChip.
  Iterable<Widget> customWidgets(
      List<String> collect, List<String> choice) sync* {
    for (String item in collect) {
      yield Padding(
        padding: const EdgeInsets.all(3.0),
        child: FilterChip(
          selectedColor: kProfile_reg_button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Rajdhani',
            color: kBlackColour,
            fontWeight: FontWeight.bold,
          ),
          label: Text(item),
          selected: choice.contains(item),
          onSelected: (bool isSelected) {
            setState(() {
              isSelected
                  ? choice.add(item)
                  : choice.removeWhere((String name) {
                      return name == item;
                    });
            });
          },
        ),
      );
    }
  }

  //TODO: Create a choiceChip.
  Iterable<Widget> customChoiceWidgets(
      List<String> collect, String choice) sync* {
    for (String item in collect) {
      yield Padding(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          selectedColor: kProfile_reg_button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Rajdhani',
            color: kBlackColour,
            fontWeight: FontWeight.bold,
          ),
          label: Text(item),
          selected: choice == item,
          onSelected: (bool isSelected) {
            setState(() {
              isSelected ? choice = item : choice = "";
            });
          },
        ),
      );
    }
  }

  //TODO: A dialog displaying a warning message to the user.
  Widget warningDialog(BuildContext context) {
    AlertDialog warning = AlertDialog(
      title: Text(
        kWarning_message,
        style: TextStyle(
          color: kProfile,
          fontWeight: FontWeight.bold,
          fontFamily: 'Rajdhani',
          fontSize: kFont_size_18.sp,
        ),
      ),
      content: Text(
        kWarning_content,
        style: TextStyle(
          color: kBlackColour,
          fontSize: kFontSizeAnonynousUser.sp,
          fontFamily: 'Rajdhani',
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              kWarning_action,
              style: TextStyle(
                fontSize: kFont_size_18.sp,
                fontFamily: 'Rajdhani',
                color: kBlackColour,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    return warning;
  }

  //TODO: Create a Dialog.
  Widget customDialog(
      BuildContext context, List<String> collections, String key) {
    String itemSelect;

    Dialog customDialog = Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          color: kWhiteColour,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.all(0.0),
              //   child: DropDownField(
              //     value: itemSelect,
              //     hintText: kDropDownHint,
              //     itemsVisibleInDropdown: 9,
              //     hintStyle: TextStyle(
              //       fontFamily: 'Rajdhani',
              //       fontSize: kFontSizeAnonynousUser.sp,
              //     ),
              //     strict: false,
              //     items: collections,
              //     textStyle: TextStyle(
              //       fontFamily: 'Rajdhani',
              //       fontWeight: FontWeight.bold,
              //       fontSize: kFontSizeAnonynousUser.sp,
              //     ),
              //     onValueChanged: (itemSelected) {
              //       key == "qualification"
              //           ? _saveSelectedQualification(itemSelected)
              //           : _saveSelectedLanguages(itemSelected);
              //     },
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                child: FlatButton(
                  color: kProfile,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    Navigator.pop(
                      context,
                      prefs.getString(key),
                    );
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
            ],
          ),
        ),
      ),
    );

    return customDialog;
  }

  //TODO: Create a language dialog that will assist the user in selecting his/her spoken language.
  Widget languageDialog(BuildContext context,
      List<LanguageModel> filterLanguageList, List<String> languageSelected) {
    List<LanguageModel> languageList = filterLanguageList;
    List<LanguageModel> newData = [];

    Dialog langDialog = Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.9,
        color: kWhiteColour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: kHintColor,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.language,
                              size: kFont_size_22.sp,
                              color: kHintColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kHintColor,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kHintColor,
                              ),
                            ),
                            hintText: "Language Search",
                            hintStyle: TextStyle(
                              fontFamily: 'Rajdhani',
                              color: kHintColor,
                              fontSize: kFontSizeAnonynousUser.sp,
                            ),
                          ),
                          onChanged: (search) {
                            //TODO: Search for spoken language.
                            setState(() {
                              print(search);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: ListView.builder(
                itemCount: filterLanguageList.length,
                shrinkWrap: true,
                itemBuilder: (context, position) {
                  return _listView(filterLanguageList, position);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FlatButton(
                  color: kProfile,
                  onPressed: () async {},
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

  _listView(List<LanguageModel> filterLanguageList, int position) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.language,
        ),
        title: Text(
          filterLanguageList[position].languageName!,
          style: TextStyle(
            color: kBlackColour,
            fontFamily: 'Rajdhani',
            fontSize: kFontSizeAnonynousUser.sp,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  //TODO: Save the qualification the user selected from the list of qualification.
  _saveSelectedQualification(String qualification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("qualification", qualification);
  }

  //TODO: Save the languages the user selected from the list of languages.
  _saveSelectedLanguages(String languages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("languages", languages);
  }

  //TODO: Create a TextFormField.
  Widget customTextFormField(String fieldHint) {
    String? customFormField;

    return TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: kButton_disabled,
      style: TextStyle(
        color: kHintColor,
        fontFamily: 'Rajdhani',
        fontSize: kFontSizeAnonynousUser.sp,
      ),
      decoration: InputDecoration(
        hintText: fieldHint,
        hintStyle: TextStyle(
          fontSize: kFontSizeAnonynousUser.sp,
          fontFamily: 'Rajdhani',
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: kButton_disabled,
          ),
        ),
      ),
      onSaved: (valueEntered) {
        customFormField = valueEntered;
      },
    );
  }

  //TODO: DropdownForm widget.
  Widget customDropDownForm(
      List<Map<String, String>> dropDownData, String hintText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
    );
  }

  //TODO: Creates a list of scrollable content based on the tab clicked.
  Widget tabContent(int tabIndex) {
    Widget contentView;

    switch (tabIndex) {
      case 0:
        contentView = Text("Job Content view");
        break;
      case 1:
        contentView = Text("Professionals Content view");
        break;
      case 2:
        contentView = Text("Employments Content view");
        break;
      case 3:
        contentView = Text("Companies Content view");
        break;
      default:
        contentView = Text("Job Content view");
    }

    return contentView;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
