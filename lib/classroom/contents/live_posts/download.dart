import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class DownloadVideo extends StatefulWidget {
  @override
  _DownloadVideoState createState() => _DownloadVideoState();
}

class _DownloadVideoState extends State<DownloadVideo> {

  double _progress = 0;
  String _progressText = '';
  CancelToken token = CancelToken();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future ( () async {
      //ToDo:Get the index of video that is downloading
      final appDocDir = await Directory.systemTemp.createTemp();
      String savePath = appDocDir.path + "/temp.mp4";

      try {
        Response response = await Dio().download(
          UploadVariables.downloadVideoUrl!, savePath,
          onReceiveProgress: (rec, total) {
          setState(() {
            _progress = (rec / total);
            _progressText = ((rec / total * 100).toStringAsFixed(0) + "%");
          });
          },
          cancelToken: token,);
        if(token.isCancelled == true){
          Fluttertoast.showToast(
              msg: kDownloadproblem,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        }
        if (response.statusCode == 402) {
          Fluttertoast
              .showToast(
              msg: kDownloadSuccess,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kFbColor);
        } else {
          Fluttertoast
              .showToast(
              msg: kDownloadSuccess,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackcolor,
              textColor: kSsprogresscompleted);
        }
        final result = await ImageGallerySaver.saveFile(savePath);
        print(result);
      } catch (e){
        print(e);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child:Text(_progressText,),

        ),
        Container(
          margin:EdgeInsets. symmetric(vertical:10.0),
          width: double.infinity,
          child: LinearPercentIndicator(
            animation: false,
            lineHeight: 3.0,
            animationDuration: 2000,
            percent: _progress,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: kSsprogresscompleted,
            backgroundColor: kSsprogressbar,

          ),
        ),
      ],
    );
  }
}

