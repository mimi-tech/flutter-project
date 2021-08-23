import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class AlumniCardsComm extends StatefulWidget {
  final String? cardName;

  AlumniCardsComm({this.cardName});

  @override
  _AlumniCardsCommState createState() => _AlumniCardsCommState();
}

class _AlumniCardsCommState extends State<AlumniCardsComm> {
  String? fromYearComm;
  String? toYearComm;
  late List<String?> fromTo;

  @override
  void initState() {
    fromYearComm = "From";
    toYearComm = "To";
    fromTo = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.init(
//      context,
//      width: MediaQuery.of(context).size.width,
//      height: MediaQuery.of(context).size.height,
//      allowFontScaling: true,
//    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.cardName!,
                      style: TextStyle(
                        color: kButton_disabled,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold,
                        fontSize: kFontSizeAnonynousUser.sp,
                      ),
                    ),
                  ),
                  GestureDetector(
                    //TODO: Reset the year picker
                    onTap: () {
                      setState(() {
                        fromTo.clear();
                        fromYearComm = "From";
                        toYearComm = "To";
                      });
                    },

                    child: fromTo.isEmpty
                        ? Text("")
                        : Icon(
                            Icons.delete_forever,
                            color: kProfile,
                          ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: kBorder_colour,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.035,
                    right: MediaQuery.of(context).size.width * 0.025,
                  ),
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.0,
                  ),
                  width: MediaQuery.of(context).size.width * 0.36,
                  height: MediaQuery.of(context).size.height * 0.045,
                  decoration: BoxDecoration(
                    color: fromYearComm == "From" ? kButton_disabled : kProfile,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        fromYearComm!,
                        style: TextStyle(
                          fontSize: kFontSizeAnonynousUser.sp,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          color: kWhiteColour,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? fromYear = await showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(DateTime.now().year + 10),
                            initialDatePickerMode: DatePickerMode.year,
                            theme: ThemeData(primarySwatch: Colors.deepOrange),
                            borderRadius: 16,
                          );
                          setState(() {
                            fromYearComm = fromYear!.year.toString();
                          });
                        },
                        child: Icon(
                          Icons.date_range,
                          color: kWhiteColour,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.035,
                    right: MediaQuery.of(context).size.width * 0.025,
                  ),
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0,
                    right: MediaQuery.of(context).size.width * 0.03,
                  ),
                  width: MediaQuery.of(context).size.width * 0.36,
                  height: MediaQuery.of(context).size.height * 0.045,
                  decoration: BoxDecoration(
                    color: toYearComm == "To" ? kButton_disabled : kProfile,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        toYearComm!,
                        style: TextStyle(
                          fontSize: kFontSizeAnonynousUser.sp,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          color: kWhiteColour,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? toYear = await showRoundedDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(DateTime.now().year + 10),
                            initialDatePickerMode: DatePickerMode.year,
                            theme: ThemeData(primarySwatch: Colors.deepOrange),
                            borderRadius: 16,
                          );

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          setState(() {
                            toYearComm = toYear!.year.toString();

                            //TODO: Add the dates to a list.
                            fromTo.add(widget.cardName);
                            fromTo.add(fromYearComm);
                            fromTo.add(toYearComm);

                            //TODO: Store the map in a shared preference.
                            prefs.setStringList(
                                "Community", fromTo as List<String>);
                          });
                        },
                        child: Icon(
                          Icons.date_range,
                          color: kWhiteColour,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
