import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class SelectedCard extends StatefulWidget {
  SelectedCard({
    required this.showSelectedCard,
  });
  final Widget showSelectedCard;
  @override
  _SelectedCardState createState() => _SelectedCardState();
}

class _SelectedCardState extends State<SelectedCard> {
  var items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      items.add(UploadVariables.selectedDocIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: items.contains(UploadVariables.selectedDocIndex)
          ? Colors.purple
          : kWhitecolor,
      child: widget.showSelectedCard,
    );
  }
}
