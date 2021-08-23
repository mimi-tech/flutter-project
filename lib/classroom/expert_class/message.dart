import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_appbar.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_btn.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_titles.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';

import 'package:sparks/classroom/expert_class/uploading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class ExpertMessage extends StatefulWidget {
  @override
  _ExpertMessageState createState() => _ExpertMessageState();
}

class _ExpertMessageState extends State<ExpertMessage> {
  TextEditingController _congratulationMessage = TextEditingController();
  TextEditingController _message = TextEditingController();

  List<String> _amount = [
    'Free',
    '10.99',
    '19.99',
    '49.99',
    '50.99'
  ]; // Option 2
  String? _selectedAmount; // Option 2
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: ExpertAppBar(),
            body: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      spacer(),

                      spacer(),
                      ExpertTitle(
                        title: kClassAmt,
                      ),
                      spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlineButton(
                            onPressed: () {},
                            child: Text('USD',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBlackcolor,
                                    fontSize: kFontsize.sp,
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(30),
                          ),
                          Container(
                            child: DropdownButton(
                              hint: Text(kSCourseAmount,
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kBlackcolor,
                                      fontSize: kFontsize.sp,
                                    ),
                                  )), // Not necessary for Option 1
                              value: _selectedAmount,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  _selectedAmount = newValue;
                                });
                              },
                              items: _amount.map((amount) {
                                return DropdownMenuItem(
                                  child: Text(amount,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kBlackcolor,
                                          fontSize: kFontsize.sp,
                                        ),
                                      )),
                                  value: amount,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      ///welcome message

                      spacer(),

                      ExpertTitle(
                        title: kExpertWelcome,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: _message,
                          maxLength: 200,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            ExpertConstants.welcome = value;
                          },
                        ),
                      ),
                      spacer(),

                      ///Congratulatory message

                      spacer(),

                      ExpertTitle(
                        title: kExpertCongratulatory,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextField(
                          controller: _congratulationMessage,
                          maxLength: 200,
                          maxLines: null,
                          style: UploadVariables.uploadfontsize,
                          decoration: ExpertConstants.keyDecoration,
                          onChanged: (String value) {
                            ExpertConstants.cong = value;
                          },
                        ),
                      ),
                      spacer(),

                      ExpertBtn(
                        next: () {
                          nextPage();
                        },
                        bgColor: kExpertColor,
                      ),

                      spacer(),
                    ],
                  ),
                ),
              ),
            )));
  }

  void nextPage() {
    if (_selectedAmount == null) {
      Fluttertoast.showToast(
          msg: kSCoursePriceError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((ExpertConstants.welcome == null) ||
        (ExpertConstants.welcome == '')) {
      Fluttertoast.showToast(
          msg: kExpertWelcome,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else if ((ExpertConstants.cong == null) || (ExpertConstants.cong == '')) {
      Fluttertoast.showToast(
          msg: kExpertCongratulatory,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    } else {
      setState(() {
        ExpertConstants.amount = _selectedAmount;
      });
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.topToBottom, child: ExpertUpload()));
    }
  }
}
