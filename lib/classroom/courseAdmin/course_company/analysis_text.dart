import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AnalysisText extends StatefulWidget {
  AnalysisText({
    required this.seenDaily,
    required this.verifyDaily,
    required this.seenWeekly,
    required this.verifyWeekly,
    required this.seenMonthly,
    required this.verifyMonthly,
    required this.seenYearly,
    required this.verifyYearly,
  });

  final String seenDaily;
  final String verifyDaily;
  final String seenWeekly;
  final String verifyWeekly;
  final String seenMonthly;
  final String verifyMonthly;
  final String seenYearly;
  final String verifyYearly;

  @override
  _AnalysisTextState createState() => _AnalysisTextState();
}

class _AnalysisTextState extends State<AnalysisText> {
  double iconSize = 40;

  List months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'Octobar',
    'Novermber',
    'December'
  ];
  static var now = new DateTime.now();
  var currentMon = now.month;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: Container(
        margin: EdgeInsets.all(10),
        child: Table(
          border: TableBorder.all(),
          columnWidths: {
            0: FractionColumnWidth(.4),
          },
          children: [
            TableRow(children: [
              Column(children: [
                Icon(
                  Icons.account_box,
                  size: iconSize,
                ),
                Text(
                  kPeriod,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kMaincolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Column(children: [
                Icon(
                  Icons.settings,
                  size: iconSize,
                ),
                Text(
                  kSeen,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kMaincolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Column(children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: iconSize,
                ),
                Text(
                  kVerify,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kMaincolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  kDaily,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kExpertColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.seenDaily,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.verifyDaily,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  kWeekly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kExpertColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.seenWeekly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.verifyWeekly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  months[currentMon - 1],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kExpertColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.seenMonthly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.verifyMonthly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  '$kYear ${DateTime.now().year}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kExpertColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.seenYearly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingSize),
                child: Text(
                  widget.verifyYearly,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rajdhani(
                    fontSize: kFontsize.sp,
                    color: kBlackcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ])
          ],
        ),
      ))
    ]);
  }
}
