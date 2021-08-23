import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/reusables/sparks_bottom_menu.dart';
import 'package:sparks/market/utilities/market_const.dart';

class AddingToCartBottomAppbar extends StatelessWidget {
  AddingToCartBottomAppbar({required this.onPressed});

  final Function onPressed;

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
              menuPressed: () {},
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
            TextButton.icon(
              onPressed: onPressed as void Function()?,
              icon: Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.white,
              ),
              label: Text(
                "Add",
                style: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: Colors.white),
              ),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(
                    color: Colors.white,
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(kMarketPrimaryColor),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(10.0),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      color: kLight_orange,
      elevation: 20.0,
    );
  }
}
