import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/alumni/color/colors.dart';

class AlumniCards extends StatefulWidget {
  final String? cardName;

  AlumniCards({this.cardName});

  @override
  _AlumniCardsState createState() => _AlumniCardsState();
}

class _AlumniCardsState extends State<AlumniCards> {
  String? fromYearPostG;
  String? toYearPostG;

  @override
  void initState() {
    fromYearPostG = "From";
    toYearPostG = "To";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.cardName!,
                  style: TextStyle(
                    color: kALightGrey,
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: kALightGrey,
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
                    color: fromYearPostG == "From" ? kALightGrey : kAOrangeRed,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  //TODO: From when.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        fromYearPostG!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          color: kAWhite,
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
                            fromYearPostG = fromYear!.year.toString();
                          });
                        },
                        child: Icon(
                          Icons.date_range,
                          color: kAWhite,
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
                    color: toYearPostG == "To" ? kALightGrey : kAOrangeRed,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  //TODO: To when.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        toYearPostG!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontFamily: 'Rajdhani',
                          fontWeight: FontWeight.bold,
                          color: kAWhite,
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

                          setState(() {
                            toYearPostG = toYear!.year.toString();
                          });
                        },
                        child: Icon(
                          Icons.date_range,
                          color: kAWhite,
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
