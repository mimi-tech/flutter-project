import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class CompanyAccountEntry extends StatefulWidget {
  @override
  _CompanyAccountEntryState createState() => _CompanyAccountEntryState();
}

class _CompanyAccountEntryState extends State<CompanyAccountEntry> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: RaisedButton(
              onPressed: (){

              },
              color: Colors.black,
              child: Text('CREATE A COMPANY ACCOUNT',
                style:GoogleFonts.rajdhani(
                  textStyle:TextStyle(
                      fontSize:ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
