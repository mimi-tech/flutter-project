import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sparks/app_entry_and_home/reusables/home_appBar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadingProgress extends StatefulWidget {
  @override
  _UploadingProgressState createState() => _UploadingProgressState();
}

class _UploadingProgressState extends State<UploadingProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'images/classroom/back.svg',
                    width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                    height: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                  ),
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  'images/classroom/uploadvideo.svg',
                  width: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                  height: ScreenUtil().setHeight(klivebtn.roundToDouble()),
                ),
              ),

//ToDo:showing the progress bar
              if (UploadVariables.uploadTask != null)
                StreamBuilder<TaskSnapshot>(
                    stream: UploadVariables.uploadTask!.snapshotEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
                      Widget? subtitle;
                      Widget? prog;
                      Widget progtext;
                      if (asyncSnapshot.hasData) {
                        final TaskSnapshot event = asyncSnapshot.data!;
                        final TaskSnapshot snapshot = event;

                        double _progress = event.bytesTransferred.toDouble() /
                            event.totalBytes.toDouble();

                        prog = LinearPercentIndicator(
                          // width: MediaQuery.of(context).size.width - 50,
                          width: ScreenUtil().setWidth(160.0),

                          lineHeight: 15.0,
                          animationDuration: 2000,
                          percent: _progress,
                          center: Text(
                            '${(_progress * 100).toStringAsFixed(2)} %',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: kBlackcolor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rajdhani',
                            ),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: kSsprogresscompleted,
                          backgroundColor: kSsprogressbar,
                        );

                        progtext =
                            Text('${(_progress * 100).toStringAsFixed(2)} %');
                      } else {
                        subtitle = UploadVariables.uploadTask!.snapshot.state ==
                                TaskState.paused
                            ? Text('paused',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.w700,
                                ))
                            : Text('starting...',
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.w700,
                                ));
                      }
                      return UploadVariables.uploadTask!.snapshot.state ==
                              TaskState.success
                          ? Text(
                              kuploadsuccessful,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: kSsprogresscompleted,
                                fontFamily: 'Rajdhani',
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: subtitle,
                                ),
                                Container(
                                  child: prog,
                                ),
                                Offstage(
                                  offstage: UploadVariables
                                          .uploadTask!.snapshot.state !=
                                      TaskState
                                          .running, // !UploadVariables.uploadTask.isInProgress
                                  child: GestureDetector(
                                    child: Icon(Icons.pause),
                                    onTap: () =>
                                        UploadVariables.uploadTask!.pause(),
                                  ),
                                ),
                                Offstage(
                                  offstage: UploadVariables
                                          .uploadTask!.snapshot.state ==
                                      TaskState
                                          .paused, // !UploadVariables.uploadTask.isPaused
                                  child: GestureDetector(
                                    child: Icon(Icons.file_upload),
                                    onTap: () =>
                                        UploadVariables.uploadTask!.resume(),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(30.0),
                                ),
                                Offstage(
                                  offstage: UploadVariables
                                          .uploadTask!.snapshot.state ==
                                      TaskState
                                          .success, // UploadVariables.uploadTask.isComplete
                                  child: PopupMenuButton(
                                    elevation: 30.0,
                                    child: Icon(
                                      (Icons.cancel),
                                    ),
                                    itemBuilder: (context) => [
                                      ///warning icon

                                      PopupMenuItem(
                                        child: Center(
                                          child: InkWell(
                                            child: Image(
                                              image: AssetImage(
                                                  'images/classroom/warning.gif'),
                                              height:
                                                  ScreenUtil().setHeight(80),
                                              width: ScreenUtil().setHeight(80),
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0,
                                              left: 18.0,
                                              right: 18.0),
                                          child: Text(
                                            kUploadcancel,
                                            style: TextStyle(
                                              fontSize: kFontsize.sp,
                                              color: kBlackcolor,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Rajdhani',
                                            ),
                                          ),
                                        ),
                                      ),

                                      ///close btn
                                      PopupMenuItem(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Row(
                                          children: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                kClose,
                                                style: TextStyle(
                                                  fontSize: kFontsize.sp,
                                                  color: kBlackcolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Rajdhani',
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          4.0),
                                                  side: BorderSide(
                                                      color: klistnmber)),
                                            ),
                                            SizedBox(
                                              width: kBackspace,
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                UploadVariables.uploadTask!
                                                    .cancel();
                                                setState(() {
                                                  UploadVariables.uploadTask =
                                                      null;
                                                });
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeAppBarWithCustomScrollView(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                kCu,
                                                style: TextStyle(
                                                  fontSize: kFontsize.sp,
                                                  color: kFbColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Rajdhani',
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          4.0),
                                                  side: BorderSide(
                                                      color: klistnmber)),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            );
                    }),

              ///cancel upload btn
              SizedBox(
                width: kBackspace,
              ),
            ],
          ),
        ),
        Divider(
          color: kAshthumbnailcolor,
          thickness: kThickness,
        ),
      ],
    );
  }
}
/*LinearProgressIndicator(

                            valueColor:
                                AlwaysStoppedAnimation<Color>(kSsprogresscompleted),
                            value: _progress,
                            backgroundColor: kSsprogressbar,
                          ),*/
