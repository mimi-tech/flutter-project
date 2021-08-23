import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_dialog_tv/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sparks/classroom/contents/playingvideo.dart';

import 'package:video_player/video_player.dart';

import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/uploadprogressbar.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<String> videoSelected = [];

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);

    return Column(
      children: <Widget>[
/*class showing the uploading progress*/
        UploadingProgress(),

        ///upload video details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                UploadVariables.url == null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setWidth(110),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: klistnmber,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                kUploading,
                                style: TextStyle(
                                  fontSize: kFontsize.sp,
                                  color: kUploadingcolor,
                                  fontFamily: 'Rajdhani',
                                ),
                              ),
                            ),
                            Text(
                              kContbelow,
                              style: TextStyle(
                                fontSize: kFontsize.sp,
                                color: kWhitecolor,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        //constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(150),maxHeight: ScreenUtil().setHeight(150),),
                        width: ScreenUtil().setWidth(200),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: ShowUploadedVideo(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        UploadVariables.url!),
                                looping: false,
                              ),
                            ),
                            Center(
                                child: ButtonTheme(
                              shape: CircleBorder(),
                              height: ScreenUtil().setHeight(100),
                              child: RaisedButton(
                                  color: Colors.transparent,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                  child: GestureDetector(
                                      onTap: () {
                                        UploadVariables.videoUrlSelected =
                                            UploadVariables.url;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayingVideos()));
                                      },
                                      child: Icon(Icons.play_arrow, size: 40))),
                            ))
                          ],
                        ),
                      )

                /*ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(150),minHeight: ScreenUtil().setHeight(20),),

                  child: ShowUploadedVideo(
                    videoPlayerController: VideoPlayerController.network(UploadVariables.url),
                    looping: false,
                  ),
                ),*/
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(kVideolink,
                        style: TextStyle(
                          fontSize: kFontsize.sp,
                          color: kBlackcolor2,
                          fontFamily: 'Rajdhani',
                        )),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(Icons.content_copy)
                  ],
                ),

                ///video link

                SizedBox(
                  height: 5.0,
                ),

                ///file name
                Text(kFilename,
                    style: TextStyle(
                      fontSize: kFontsize.sp,
                      color: klistnmber,
                      fontFamily: 'RajdhaniMedium',
                    )),

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ScreenUtil().setWidth(150),
                    minHeight: ScreenUtil().setHeight(10),
                  ),
                  child: AutoSizeText(UploadVariables.uploadedVideoName,
                      softWrap: true,
                      maxLines: 2,
                      minFontSize: kFontsize.sp,
                      style: TextStyle(
                        fontSize: kFontsize.sp,
                        color: klistnmber,
                        fontFamily: 'Rajdhani',
                      )),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
