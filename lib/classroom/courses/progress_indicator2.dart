import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:sparks/classroom/courses/constants.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:sparks/app_entry_and_home/strings/strings.dart';

class CourseSecondUploadingProgress extends StatefulWidget {
  @override
  _CourseSecondUploadingProgressState createState() =>
      _CourseSecondUploadingProgressState();
}

class _CourseSecondUploadingProgressState
    extends State<CourseSecondUploadingProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //ToDo:showing the progress bar
        if (Constants.uploadImageTask != null)
          StreamBuilder<TaskSnapshot>(
              stream: Constants.uploadImageTask!.snapshotEvents,
              builder: (BuildContext context,
                  AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
                Widget? subtitle;
                Widget? prog;

                if (asyncSnapshot.hasData) {
                  final TaskSnapshot event = asyncSnapshot.data!;

                  double _progress = event.bytesTransferred.toDouble() /
                      event.totalBytes.toDouble();

                  prog = CircularPercentIndicator(
                    // width: MediaQuery.of(context).size.width - 50,
                    radius: 60.0,
                    lineWidth: 5.0,

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

                    progressColor: kSsprogresscompleted,
                    backgroundColor: kSsprogressbar,
                  );
                } else {
                  subtitle = Constants.uploadImageTask!.snapshot.state ==
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
                return Constants.uploadImageTask!.snapshot.state ==
                        TaskState.success
                    ? Text(
                        'Image Complete',
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kSsprogresscompleted,
                          fontFamily: 'Rajdhani',
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: subtitle,
                          ),
                          Container(
                            child: prog,
                          ),
                          Offstage(
                            offstage: Constants
                                    .uploadImageTask!.snapshot.state !=
                                TaskState
                                    .running, // !Constants.uploadImageTask.isInProgress
                            child: GestureDetector(
                              child: Icon(Icons.pause),
                              onTap: () => Constants.uploadImageTask!.pause(),
                            ),
                          ),
                          Offstage(
                            offstage: Constants
                                    .uploadImageTask!.snapshot.state !=
                                TaskState
                                    .paused, // !Constants.uploadImageTask.isPaused
                            child: GestureDetector(
                              child: Icon(Icons.file_upload),
                              onTap: () => Constants.uploadImageTask!.resume(),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(30.0),
                          ),
                          Offstage(
                            offstage: Constants
                                    .uploadImageTask!.snapshot.state ==
                                TaskState
                                    .success, // Constants.uploadImageTask.isComplete
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
                                        height: ScreenUtil().setHeight(80),
                                        width: ScreenUtil().setHeight(80),
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18.0, left: 18.0, right: 18.0),
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
                                  padding: const EdgeInsets.only(top: 30.0),
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
                                                new BorderRadius.circular(4.0),
                                            side:
                                                BorderSide(color: klistnmber)),
                                      ),
                                      SizedBox(
                                        width: kBackspace,
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Constants.uploadImageTask!.cancel();
                                          setState(() {
                                            Constants.uploadImageTask = null;
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                          });
                                          Navigator.pop(context);
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
                                                new BorderRadius.circular(4.0),
                                            side:
                                                BorderSide(color: klistnmber)),
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
    );
  }
}
/*LinearProgressIndicator(

                            valueColor:
                                AlwaysStoppedAnimation<Color>(kSsprogresscompleted),
                            value: _progress,
                            backgroundColor: kSsprogressbar,
                          ),*/
