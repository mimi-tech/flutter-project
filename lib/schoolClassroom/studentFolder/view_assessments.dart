import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class ViewAssessment extends StatefulWidget {
  ViewAssessment({required this.note,required this.doc});
  final DocumentSnapshot doc;
  final dynamic note;
  @override
  _ViewAssessmentState createState() => _ViewAssessmentState();
}

class _ViewAssessmentState extends State<ViewAssessment> {

  int progress = 0;


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

    });


    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();

  }


  late String _localPath;
  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    print('Download Path: $_localPath');


    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Class note'.toUpperCase(),
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kWhitecolor,
                fontSize: kFontsize.sp,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                 Align(
                  alignment: Alignment.topRight,
                  child: RaisedButton(onPressed: () async {
                    final status = await Permission.storage.request();

                    if (status.isGranted) {
                      // final externalDir = await getExternalStorageDirectory();
                      Map<String, dynamic> data = widget.doc.data() as Map<String, dynamic>;
                      final id = await FlutterDownloader.enqueue(
                        url:data['note'],
                        savedDir: _localPath,//externalDir.path,
                        fileName: '${data['curs']} assessment.pdf',
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                      //updateNoteDownload();

                    } else {
                      print("Permission denied");
                    }
                  },
                    color: kFbColor,
                    child: Text('Download'.toUpperCase(),
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kWhitecolor,
                          fontSize: kFontsize.sp,
                        ),
                      ),
                    ),
                  ),
                ),


                PDF.network(

                  widget.note,
                  placeHolder: Center(child: CircularProgressIndicator()),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  Future<void> updateNoteDownload() async {
    try{
      //check if student have downloaded this lesson note
      final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup('noteAssessment')
          .where('id', isEqualTo: widget.doc['id'])
          .where('pin', isEqualTo: SchClassConstant.schDoc['pin'])

          .get();

      final List < DocumentSnapshot > documents = result.docs;

      if (documents.length == 0) {

        //update the lesson note download count

        FirebaseFirestore.instance.collection('teachersAssessment').doc(
            widget.doc['schId']).collection('assessments').doc(
            widget.doc['id']).get()
            .then((resultNote) {
          dynamic totalNoteDownload = resultNote.data()!['ntc'] + 1;

          resultNote.reference.set({
            'ntc': totalNoteDownload,

          }, SetOptions(merge: true));
        });
        print('jjjj');

        //push lesson to liked lessons
        FirebaseFirestore.instance.collection('studentsNoteAssessment').doc(widget.doc['schId']).collection('noteAssessment').add({
          'id':widget.doc['id'],
          'pin':SchClassConstant.schDoc['pin'],
          'fn':SchClassConstant.schDoc['fn'],
          'ln':SchClassConstant.schDoc['ln'],
          'ts':DateTime.now().toString(),


        });

      }}catch(e){
      print(e);
    }
  }

}

