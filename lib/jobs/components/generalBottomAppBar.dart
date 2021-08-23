import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_bottom_menu.dart';
import 'package:sparks/app_entry_and_home/screens/create_profile.dart';

class CustomBottomAppBar extends StatefulWidget {
  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SparksButtonAppBarMenu(
                  menuIcon: "images/home.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CreateSparksProfile()));
                  },
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/social.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {},
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/alumni.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {},
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/market.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {
                    setState(() {});
                  },
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/work.svg",
                  menuItemColor: kBottom_menu_items_active,
                  menuPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: kLight_orange,
      elevation: 20.0,
    );
  }
}

/// For company Bottom App BaseTapGestureRecognizer

class CustomCompanyBottomAppBar extends StatefulWidget {
  @override
  _CustomCompanyBottomAppBar createState() => _CustomCompanyBottomAppBar();
}

class _CustomCompanyBottomAppBar extends State<CustomCompanyBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.065,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SparksButtonAppBarMenu(
                  menuIcon: "images/app_entry_and_home/home.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CreateSparksProfile(
                            //accountName: "Personal"
                            ),
                      ),
                    );
                  },
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/app_entry_and_home/social.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {},
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/app_entry_and_home/new_images/school.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {},
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/app_entry_and_home/market.svg",
                  menuItemColor: kBottom_menu_items_in_active,
                  menuPressed: () {},
                ),
                SparksButtonAppBarMenu(
                  menuIcon: "images/app_entry_and_home/work.svg",
                  menuItemColor: kBottom_menu_items_active,
                  menuPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: kLight_orange,
      elevation: 20.0,
    );
  }
}
