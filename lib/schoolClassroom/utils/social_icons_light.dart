import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

class SocialIconsLight extends StatefulWidget {
  SocialIconsLight({
    required this.views,
    required this.comments,
    required this.rating,
    required this.like,
    required this.share,
    required this.viewsNumber,
    required this.commentsNumber,
    required this.ratingNumber,
    required this.likeNumber,
    required this.shareNumber,
    required this.saveUrl,
    required this.saveName,
  });
  final Function views;
  final Function comments;
  final Function rating;
  final Function like;
  final Function share;

  final dynamic viewsNumber;
  final dynamic commentsNumber;
  final dynamic ratingNumber;
  final dynamic likeNumber;
  final dynamic shareNumber;
  final dynamic saveUrl;
  final dynamic saveName;

  @override
  _SocialIconsLightState createState() => _SocialIconsLightState();
}

class _SocialIconsLightState extends State<SocialIconsLight> {
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading")!;

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/
    });

    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();
  }

  late String _localPath;
  Future<String> _findLocalPath() async {
    return "";
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: widget.views as void Function()?,
          child: Row(
            children: [
              SvgPicture.asset('images/classroom/views.svg'),
              //IconButton(icon:SvgPicture.asset('images/classroom/views.svg'), onPressed:widget.views,),
              Text(
                widget.viewsNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.comments as void Function()?,
          child: Row(
            children: [
              SvgPicture.asset('images/classroom/comment.svg'),
              // IconButton(icon:SvgPicture.asset('images/classroom/comment.svg'), onPressed: widget.comments,),
              Text(
                widget.commentsNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.rating as void Function()?,
          child: Row(
            children: [
              SvgPicture.asset('images/classroom/star.svg'),
              //IconButton(icon:SvgPicture.asset('images/classroom/star.svg'), onPressed: widget.rating,),
              Text(
                widget.ratingNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.like as void Function()?,
          child: Row(
            children: [
              Icon(Icons.thumb_up, color: kMaincolor),
              //IconButton(icon:(Icon(Icons.thumb_up,color: kMaincolor)), onPressed: widget.like,),
              Text(
                widget.likeNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.share as void Function()?,
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: kMaincolor,
              ),
              // IconButton(icon:Icon(Icons.share,color: kMaincolor,), onPressed: widget.share,),
              Text(
                widget.shareNumber,
                style: GoogleFonts.rajdhani(
                  fontSize: 12.sp,
                  color: kFooterLabelTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.save_alt,
            color: kMaincolor,
          ),
          onPressed: () async {
            final status = await Permission.storage.request();

            if (status.isGranted) {
              // final externalDir = await getExternalStorageDirectory();

              final id = await FlutterDownloader.enqueue(
                url: widget.saveUrl,
                savedDir: _localPath, //externalDir.path,
                fileName: '${widget.saveName}.mp4',
                showNotification: true,
                openFileFromNotification: true,
              );
            } else {
              print("Permission denied");
            }
          },
        ),
      ],
    );
  }
}
