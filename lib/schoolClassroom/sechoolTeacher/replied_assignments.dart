import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StudentsRepliedAssessment extends StatefulWidget {
  StudentsRepliedAssessment({required this. doc});
  final DocumentSnapshot doc;
  @override
  _StudentsRepliedAssessmentState createState() => _StudentsRepliedAssessmentState();
}

class _StudentsRepliedAssessmentState extends State<StudentsRepliedAssessment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      /* setState(() {
        progress = message[2];
      });*/

    });


    FlutterDownloader.registerCallback(downloadingCallback);
    getLocalPath();
  }
  var _documents = <DocumentSnapshot>[];
  bool progress = false;

  var itemsData = <dynamic>[];


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }


  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;


  late String _localPath;
  Future<String> _findLocalPath() async {
    /*final directory = defaultTargetPlatform == TargetPlatform.android
        ? await DownloadsPathProvider
        .downloadsDirectory //getDownloadsDirectory()//getApplicationDocumentsDirectory()//getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;*/


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
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                      children: [
                        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                        itemsData.length == 0 && progress == true ? Text('No assignment submitted'):

                        StickyHeader(
                            header:  SchoolHeader(title: 'Submitted assignments'.toUpperCase()),


                            content:ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _documents.length,
                                itemBuilder: (context, int index) {

                                  return Container(


                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                        Card(
                                        elevation: 5,
                                        child: Column(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewClassNote(note:itemsData[index]['url'],doc:_documents[index])));

                                                    },
                                                    child: PDF.network(itemsData[index]['url'],
                                                      placeHolder: Center(child: CircularProgressIndicator()),
                                                      height: MediaQuery.of(context).size.height * 0.15,
                                                      width:MediaQuery.of(context).size.width * 0.3,

                                                    ),
                                                  ),

                                                  SizedBox(width: 5,),

                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            maxWidth: ScreenUtil().setWidth(200),
                                                            minHeight: ScreenUtil().setHeight(constrainedReadMoreHeight),
                                                          ),
                                                          child: ReadMoreText(widget.doc['title'],
                                                            //doc.data['desc'],
                                                            trimLines: 1,
                                                            colorClickableText: Colors.pink,
                                                            trimMode: TrimMode.Line,
                                                            trimCollapsedText: ' .. ^',
                                                            trimExpandedText: ' ^',
                                                            style: GoogleFonts.rajdhani(
                                                              textStyle: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: kFbColor,
                                                                fontSize: kFontsize.sp,
                                                              ),

                                                            ),
                                                          ),
                                                        ),),

                                                      Text('${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kExpertColor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),

                                                      ),

                                                      Text('${itemsData[index]['cl']}',
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: kMaincolor,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),

                                                      ),

                                                      Text(Variables.dateFormat.format(DateTime.parse(itemsData[index]['ts'])),
                                                        style: GoogleFonts.rajdhani(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: klistnmber,
                                                            fontSize: kFontSize14.sp,
                                                          ),
                                                        ),

                                                      ),
                                                    ],
                                                  ),


                                                ],
                                              ),
                                            ),







                                          ],
                                        ),
                                      )


                                          ]
                                      ));
                                })



                        ),

                        progress == true || _loadMoreProgress == true
                            || _documents.length < SchClassConstant.streamCount
                            ?Text(''):
                        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                            onTap: (){loadMore();},
                            child: SvgPicture.asset('images/classroom/load_more.svg',))

                      ]

                  ),
                )
            )
        )
    );
  }

  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("submittedAssignment").doc(SchClassConstant.schDoc['schId']).collection('assignment')
        .where('aid', isEqualTo: widget.doc['id'])
        .where('lv', isEqualTo: widget.doc['lv'])
        .where('cl', isEqualTo: widget.doc['cl'])

        .orderBy('ts',descending: true)
        .limit(SchClassConstant.streamCount)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          _documents.add(document);
          itemsData.add(document.data());


        });



      }
    }
  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("submittedAssignment").doc(SchClassConstant.schDoc['schId']).collection('assignment')
        .where('aid', isEqualTo: widget.doc['id'])
        .where('lv', isEqualTo: widget.doc['lv'])
        .where('cl', isEqualTo: widget.doc['cl'])

        .orderBy('ts',descending: true).

    startAfterDocument(_lastDocument).limit(SchClassConstant.streamCount)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;


        });
      }
    }
  }
}
