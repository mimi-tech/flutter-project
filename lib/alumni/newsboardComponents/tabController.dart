import 'package:flutter/material.dart';
import 'package:sparks/alumni/strings.dart';

class TabController extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(text: kAppBarSchools),
    Tab(text: kAppBarActivities),
    Tab(text: kAppBarNewsBoard),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            final String label = tab.text!.toLowerCase();
            return Center(
              child: Text(
                'This is the $label tab',
                style: const TextStyle(fontSize: 36),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
