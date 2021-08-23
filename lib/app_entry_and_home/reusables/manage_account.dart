import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class ManageAccount extends StatefulWidget {
  final String? accountName;
  final bool? activeAccount;
  final Function accountClicked;

  ManageAccount({
    required this.accountName,
    required this.activeAccount,
    required this.accountClicked,
  });

  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.accountClicked as void Function()?,
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Text(
                widget.accountName!,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontSize: kFont_size_18.sp,
                    color: kBlackColour,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.activeAccount == false ? "" : "Active",
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontSize: kFont_size_18.sp,
                    color: kOnline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
