import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LanguageDialog extends StatefulWidget {
  final List<LanguageModel>? languages;

  LanguageDialog({this.languages});

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  List<LanguageModel>? searchLang = [];
  List<String?> mySpokenLang = [];
  bool? langSelected;
  int? numberOfLanguagesSelected;

  //TODO: Create a language list tile.
  Widget _languageTile(int position) {
    return Card(
      child: ListTile(
        trailing: Checkbox(
          value: searchLang![position].isChecked,
          activeColor: kProfile,
          onChanged: (value) {},
        ),
        leading: Icon(
          Icons.language,
        ),
        title: Text(
          searchLang![position].languageName!,
          style: TextStyle(
            color: kBlackColour,
            fontFamily: 'Rajdhani',
            fontSize: kFontSizeAnonynousUser.sp,
          ),
        ),
        selected: false,
        //TODO: select and deselect a language.
        onTap: () async {
          searchLang![position].isChecked!
              ? searchLang![position].isChecked = false
              : searchLang![position].isChecked = true;
          if (searchLang![position].isChecked == true) {
            setState(() {
              mySpokenLang.add(searchLang![position].languageName);
              numberOfLanguagesSelected = mySpokenLang.length;
            });
          } else {
            setState(() {
              mySpokenLang.remove(searchLang![position].languageName);
              numberOfLanguagesSelected = mySpokenLang.length;
            });
          }
          //TODO: Store the language selected list in a shared preference.
          SharedPreferences prefsLang = await SharedPreferences.getInstance();
          prefsLang.setStringList(
              "AllChosenLanguages", mySpokenLang as List<String>);
        },
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
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
                    hintText: kSearch_languages,
                    hintStyle: TextStyle(
                      fontFamily: 'Rajdhani',
                      color: kHintColor,
                      fontSize: kFontSizeAnonynousUser.sp,
                    ),
                  ),
                  onChanged: (search) {
                    //TODO: Search for spoken language.
                    search = search.toLowerCase();
                    setState(() {
                      searchLang =
                          widget.languages!.where((LanguageModel lang) {
                        var langChoice = lang.languageName!.toLowerCase();
                        return langChoice.contains(search.toLowerCase());
                      }).toList();
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
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Badge(
                  badgeColor: kResendColor,
                  badgeContent: Center(
                    child: Text(
                      numberOfLanguagesSelected.toString(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    searchLang = widget.languages;
    langSelected = false;
    mySpokenLang = [];
    numberOfLanguagesSelected = mySpokenLang.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchLang!.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return position != 0 ? _languageTile(position - 1) : _searchTextField();
      },
    );
  }
}
