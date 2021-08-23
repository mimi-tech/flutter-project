import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/profile_reg_model.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class InterestDialog extends StatefulWidget {
  final List<InterestModel>? interest;

  InterestDialog({this.interest});

  @override
  _InterestDialogState createState() => _InterestDialogState();
}

class _InterestDialogState extends State<InterestDialog> {
  List<InterestModel>? searchInterest = [];
  late List<String?> myInterest;
  bool? interestSelected;
  int? numberOfInterestSelected;

  //TODO: Create an interest list tile.
  Widget _interestTile(int position) {
    return Card(
      child: ListTile(
        trailing: Checkbox(
          value: searchInterest![position].isChecked,
          activeColor: kProfile,
          onChanged: (value) {},
        ),
        leading: Icon(
          Icons.work,
        ),
        title: Text(
          searchInterest![position].interest!,
          style: TextStyle(
            color: kBlackColour,
            fontFamily: 'Rajdhani',
            fontSize: kFontSizeAnonynousUser.sp,
          ),
        ),
        selected: false,
        //TODO: select and deselect an interest.
        onTap: () async {
          searchInterest![position].isChecked!
              ? searchInterest![position].isChecked = false
              : searchInterest![position].isChecked = true;
          if (searchInterest![position].isChecked == true) {
            setState(() {
              myInterest.add(searchInterest![position].interest);
              numberOfInterestSelected = myInterest.length;
            });
          } else {
            setState(() {
              myInterest.remove(searchInterest![position].interest);
              numberOfInterestSelected = myInterest.length;
            });
          }
          //TODO: Store the interest selected list in a shared preference.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("AreaOfInterest", myInterest as List<String>);
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
                    //TODO: Search for interest.
                    search = search.toLowerCase();
                    setState(() {
                      searchInterest =
                          widget.interest!.where((InterestModel intr) {
                        var specChoice = intr.interest!.toLowerCase();
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
                      numberOfInterestSelected.toString(),
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
    searchInterest = widget.interest;
    interestSelected = false;
    myInterest = [];
    numberOfInterestSelected = myInterest.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchInterest!.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return position != 0 ? _interestTile(position - 1) : _searchTextField();
      },
    );
  }
}
