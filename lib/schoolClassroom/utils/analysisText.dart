import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class AnalysisTextSchool extends StatelessWidget {
  AnalysisTextSchool({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return  Text(title,
      style: GoogleFonts.rajdhani(

        textStyle: TextStyle(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
          color: kBlackcolor,
          fontSize: kFontsize.sp,
        ),
      ),

    );
  }
}

class ShowRichTextAnalysis extends StatelessWidget {
  ShowRichTextAnalysis(
      {required this.title, required this.titleText, required this.color});

  final String title;

  final String titleText;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$title: ',
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: kSlivevcr,
            fontSize: kFontSize14.sp,
          ),
        ),
        children: <TextSpan>[
          TextSpan(
            text: titleText,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: kFontSize14.sp,

              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AnalysisTableSchool extends StatelessWidget {

  AnalysisTableSchool({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,
    required this.text7,
    required this.text8,
    required this.text9,
    required this.text10,

    required this.text11,
    required this.text12,
    required this.text13,
    required this.text14,
    required this.text15,
    required this.text16,
    required this.text17,
    required this.text18,
    required this.text19,
    required this.text20,

    required this.text21,
    required this.text22,
    required this.text23,
    required this.text24,
    required this.text25,

  });
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;
  final String text7;
  final String text8;
  final String text9;
  final String text10;

  final String text11;
  final String text12;
  final String text13;
  final String text14;
  final String text15;
  final String text16;
  final String text17;
  final String text18;
  final String text19;
  final String text20;

  final String text21;
  final String text22;
  final String text23;
  final String text24;
  final String text25;
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(

            children:[

          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,

            columnWidths: const <int, TableColumnWidth> {
              0: const FixedColumnWidth(100),

            },
            border: TableBorder.all(
                color: Colors.black.withOpacity(0.5),
                style: BorderStyle.solid,
                width: 1),
            children: [
              TableRow( children: [
                TableTextTitle(title: 'Title',),
                TableTextTitle(title: 'D',),
                TableTextTitle(title: 'W',),
                TableTextTitle(title: 'M',),
                TableTextTitle(title: 'Y',),

              ]),
              TableRow(

                  children: [

                TableTextFirstTitle(title: text1,),
                TableTextSubTitle(title: text2,),
                TableTextSubTitle(title: text3,),
                TableTextSubTitle(title: text4,),
                TableTextSubTitle(title: text5,),
              ]),
              TableRow( children: [
                TableTextFirstTitle(title: text6,),
                TableTextSubTitle(title: text7,),
                TableTextSubTitle(title: text8,),
                TableTextSubTitle(title: text9,),
                TableTextSubTitle(title: text10,),
              ]),
              TableRow( children: [
                TableTextFirstTitle(title: text11,),
                TableTextSubTitle(title: text12,),
                TableTextSubTitle(title: text13,),
                TableTextSubTitle(title: text14,),
                TableTextSubTitle(title: text15,),
              ]),


              TableRow( children: [
                TableTextFirstTitle(title: text16,),
                TableTextSubTitle(title: text17,),
                TableTextSubTitle(title: text18,),
                TableTextSubTitle(title: text19,),
                TableTextSubTitle(title: text20,),
              ]),

              TableRow( children: [
                TableTextFirstTitle(title: text21,),
                TableTextSubTitle(title: text22,),
                TableTextSubTitle(title: text23,),
                TableTextSubTitle(title: text24,),
                TableTextSubTitle(title: text25,),
              ]),
            ],
          ),
        ])
    );

  }
}



class TableTextTitle extends StatelessWidget {
  TableTextTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title,
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: kBlackcolor,
          fontSize: kFontSize14.sp,
        ),
        )),
      ),
    );
  }
}

class TableTextSubTitle extends StatelessWidget {
  TableTextSubTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: kIconColor,
              fontSize: kFontSize14.sp,
            ),
          )),
    );
  }
}


class TableTextFirstTitle extends StatelessWidget {
  TableTextFirstTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: kExpertColor,
              fontSize: kFontSize14.sp,
            ),
          )),
    );
  }
}

