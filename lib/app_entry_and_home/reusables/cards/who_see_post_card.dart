import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class WhoSeePostCard extends StatefulWidget {
  final String sparKGroup;
  final int? sparkGroupSize;
  bool? checked;
  Function? isChecked;
  bool? isSelected;

  WhoSeePostCard({
    required this.sparKGroup,
    required this.sparkGroupSize,
    this.checked,
    this.isChecked,
    this.isSelected,
  });

  @override
  _WhoSeePostCardState createState() => _WhoSeePostCardState();
}

class _WhoSeePostCardState extends State<WhoSeePostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        secondary: ClipOval(
          child: Container(
            width: 50.0,
            height: 50.0,
            color: kProfile,
            child: Icon(
              Icons.group,
              color: kWhitecolor,
            ),
          ),
        ),
        title: Text(
          widget.sparKGroup,
          style: Theme.of(context).textTheme.headline6!.apply(
                fontSizeFactor: 0.6,
                fontWeightDelta: 2,
              ),
        ),
        subtitle: Text(
          widget.sparkGroupSize.toString(),
        ),
        activeColor: kProfile,
        checkColor: kWhitecolor,
        selected: widget.isSelected!,
        value: widget.checked,
        onChanged: widget.isChecked as void Function(bool?)?,
      ),
    );
  }
}
