import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/cusom_functions/custom_functions.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/models/account_gateway.dart';
import 'package:sparks/app_entry_and_home/screens/new_reg/personal_reg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/market/screens/market_product_listing.dart';

class MarketHomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountGateWay = Provider.of<AccountGateWay>(context, listen: false);

    /// Rebuild the section called manage account
    Widget managingUsersAccount() {
      Widget mA;

      mA = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.allMyAccountTypes, accountGateWay.id),
      );

      return mA;
    }

    /// Displays all the accounts and show the one that is active
    Widget settingActiveAcct() {
      Widget activeAcct = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: CustomFunctions.userAccountManager(
            context, GlobalVariables.updatedAcct, accountGateWay.id),
      );

      return activeAcct;
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, MarketProductListing.id);
              },
              color: Colors.yellowAccent,
              child: Text('Create Products'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  kManageAcc,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontSize: kFont_size.sp,
                      color: kLight_orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, PersonalReg.id);
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                  iconSize: 40.0,
                  padding: EdgeInsets.all(0.0),
                  color: kLight_orange,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //TODO: Display all the account a user has and show the account that is active.
            GlobalVariables.updatedAcct.isEmpty
                ? managingUsersAccount()
                : settingActiveAcct(),
          ],
        ),
      ),
    );
  }
}
