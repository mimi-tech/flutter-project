import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class SpecialityDialog extends StatefulWidget {
  final List<SpecialtiesModel>? speciality;

  SpecialityDialog({this.speciality});

  @override
  _SpecialityDialogState createState() => _SpecialityDialogState();
}

class _SpecialityDialogState extends State<SpecialityDialog> {
  List<SpecialtiesModel>? searchSpeciality = [];
  late List<String?> mySpeciality;
  bool? specialitySelected;
  int? numberOfSpecialitySelected;

  //TODO: Create a language list tile.
  Widget _hobbyTile(int position) {
    return Card(
      child: ListTile(
        trailing: Checkbox(
          value: searchSpeciality![position].isChecked,
          activeColor: kProfile,
          onChanged: (value) {},
        ),
        leading: Icon(
          Icons.work,
        ),
        title: Text(
          searchSpeciality![position].specialities!,
          style: TextStyle(
            color: kBlackColour,
            fontFamily: 'Rajdhani',
            fontSize: kFontSizeAnonynousUser.sp,
          ),
        ),
        selected: false,
        //TODO: select and deselect a speciality.
        onTap: () async {
          searchSpeciality![position].isChecked!
              ? searchSpeciality![position].isChecked = false
              : searchSpeciality![position].isChecked = true;
          if (searchSpeciality![position].isChecked == true) {
            setState(() {
              mySpeciality.add(searchSpeciality![position].specialities);
              numberOfSpecialitySelected = mySpeciality.length;
            });
          } else {
            setState(() {
              mySpeciality.remove(searchSpeciality![position].specialities);
              numberOfSpecialitySelected = mySpeciality.length;
            });
          }
          //TODO: Store the specialities selected list in a shared preference.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList(
              "AllChosenSpeciality", mySpeciality as List<String>);
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
                      Icons.work,
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
                    hintText: kSearch_Speciality,
                    hintStyle: TextStyle(
                      fontFamily: 'Rajdhani',
                      color: kHintColor,
                      fontSize: kFontSizeAnonynousUser.sp,
                    ),
                  ),
                  onChanged: (search) {
                    //TODO: Search for specialities.
                    search = search.toLowerCase();
                    setState(() {
                      searchSpeciality =
                          widget.speciality!.where((SpecialtiesModel spec) {
                        var specChoice = spec.specialities!.toLowerCase();
                        return specChoice.contains(search.toLowerCase());
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
                      numberOfSpecialitySelected.toString(),
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
    searchSpeciality = widget.speciality;
    specialitySelected = false;
    mySpeciality = [];
    numberOfSpecialitySelected = mySpeciality.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchSpeciality!.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return position != 0 ? _hobbyTile(position - 1) : _searchTextField();
      },
    );
  }
}
