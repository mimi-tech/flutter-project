import 'package:flutter/material.dart';
import 'package:sparks/utilities/styles.dart';

class CategorySublistCard extends StatelessWidget {
  final Map<String, dynamic> sublistItems;
  final Function(String) getStringValue;

  CategorySublistCard(
      {required this.sublistItems, required this.getStringValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sublistItems["title"],
          style: kTextStyleFont15Medium.copyWith(fontSize: 14.0),
        ),
        Card(
          elevation: 5.0,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ...sublistItems["list"].map(
                (listTitle) => ListTile(
                  onTap: () {
                    getStringValue(listTitle);
                  },
                  title: Text(
                    listTitle,
                    style: kTextStyleFont15Bold.copyWith(fontSize: 16.0),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
