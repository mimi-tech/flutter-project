import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_bottom_menu.dart';
import 'package:sparks/app_entry_and_home/screens/create_profile.dart';

class BottomAppbarFull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: kToolbarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SparksButtonAppBarMenu(
              menuIcon: "images/app_entry_and_home/home.svg",
              menuItemColor: kBottom_menu_items_in_active,
              menuPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CreateSparksProfile(accountName: "Personal"),
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
              menuItemColor: kBottom_menu_items_active,
              menuPressed: () {},
            ),
            SparksButtonAppBarMenu(
              menuIcon: "images/app_entry_and_home/work.svg",
              menuItemColor: kBottom_menu_items_in_active,
              menuPressed: () {},
            ),
          ],
        ),
      ),
      shape: CircularNotchedRectangle(),
      color: kLight_orange,
      elevation: 20.0,
    );
  }
}
