import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class HobbyDialog extends StatefulWidget {
  final List<HobbiesModel>? hobbies;

  HobbyDialog({this.hobbies});

  @override
  _HobbyDialogState createState() => _HobbyDialogState();
}

class _HobbyDialogState extends State<HobbyDialog> {
  List<HobbiesModel>? searchHobbies = [];
  late List<String?> myHobbies;
  bool? hobbiesSelected;
  int? numberOfHobbiesSelected;

  //TODO: Create a language list tile.
  Widget _hobbyTile(int position) {
    return Card(
      child: ListTile(
        trailing: Checkbox(
          value: searchHobbies![position].isChecked,
          activeColor: kProfile,
          onChanged: (value) {},
        ),
        leading: Icon(
          Icons.directions_run,
        ),
        title: Text(
          searchHobbies![position].hobby!,
          style: TextStyle(
            color: kBlackColour,
            fontFamily: 'Rajdhani',
            fontSize: kFontSizeAnonynousUser.sp,
          ),
        ),
        selected: false,
        //TODO: select and deselect a language.
        onTap: () async {
          searchHobbies![position].isChecked!
              ? searchHobbies![position].isChecked = false
              : searchHobbies![position].isChecked = true;
          if (searchHobbies![position].isChecked == true) {
            setState(() {
              myHobbies.add(searchHobbies![position].hobby);
              numberOfHobbiesSelected = myHobbies.length;
            });
          } else {
            setState(() {
              myHobbies.remove(searchHobbies![position].hobby);
              numberOfHobbiesSelected = myHobbies.length;
            });
          }
          //TODO: Store the language selected list in a shared preference.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("AllChosenHobbies", myHobbies as List<String>);
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
                      Icons.directions_run,
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
                    hintText: kSearch_Hobby,
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
                      searchHobbies = widget.hobbies!.where((HobbiesModel hob) {
                        var hobbyChoice = hob.hobby!.toLowerCase();
                        return hobbyChoice.contains(search.toLowerCase());
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
                      numberOfHobbiesSelected.toString(),
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
    searchHobbies = widget.hobbies;
    hobbiesSelected = false;
    myHobbies = [];
    numberOfHobbiesSelected = myHobbies.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchHobbies!.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return position != 0 ? _hobbyTile(position - 1) : _searchTextField();
      },
    );
  }
}
