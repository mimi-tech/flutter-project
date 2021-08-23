import 'package:flutter/material.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';


class Send extends StatefulWidget {
  @override
  _SendState createState() =>
      _SendState();
}

@override
class _SendState extends State<Send> {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print(ucontacts.lcontacts.length);
        Navigator.pop(context);

        },
      child: Icon(Icons.check,
          color:kWhitecolor, size: 40),
      backgroundColor: kFbColor,
    );

  }


}