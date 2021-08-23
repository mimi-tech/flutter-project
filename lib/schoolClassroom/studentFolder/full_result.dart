import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbar.dart';
import 'package:sparks/schoolClassroom/sticky_headers.dart';
import 'package:sparks/schoolClassroom/studentFolder/student_bottombar.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
import 'package:sparks/schoolClassroom/studentFolder/viewNote.dart';
import 'package:sticky_headers/sticky_headers.dart';

class FullStudentsResult extends StatefulWidget {
  @override
  _FullStudentsResultState createState() => _FullStudentsResultState();
}

class _FullStudentsResultState extends State<FullStudentsResult> {
  bool _loadMoreProgress = false;
  bool moreData = false;
  late var _lastDocument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();

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

  var _documents = [];
  bool progress = false;

  var itemsData = [];

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading")!;

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  late String _localPath;
  Future<String> _findLocalPath() async {
    return "";
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
    return SafeArea(
        child: Scaffold(

          //bottomNavigationBar: StudentsBottomBar(),
            appBar: StuAppBar(),
            body: CustomScrollView(slivers: <Widget>[
              ActivityAppBer(
                activitiesColor: kTextColor,
                classColor: kStabcolor1,
                newsColor: kTextColor,
              ),


              SchClassConstant.isUniStudent? PostSliverStudentAppBar(
                campusBgColor: Colors.transparent,
                campusColor: klistnmber,
                deptBgColor: Colors.transparent,
                deptColor: klistnmber,
                recordsBgColor: klistnmber,
                recordsColor: kWhitecolor,
                profileBgColor: Colors.transparent,
                profileColor: klistnmber,
              ):PostSliverAppBar(
                campusBgColor: Colors.transparent,
                campusColor: klistnmber,
                deptBgColor: Colors.transparent,
                deptColor: klistnmber,
                recordsBgColor: klistnmber,
                recordsColor: kWhitecolor,
              ),


              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          itemsData.length == 0 && progress == false
                              ? Center(
                              child: PlatformCircularProgressIndicator())
                              : itemsData.length == 0 && progress == true
                              ? Text(
                              'No result found for ${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}')
                              : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _documents.length,
                              itemBuilder: (context, int index) {
                                return Container(
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Card(
                                            elevation: 5,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    itemsData[index]
                                                    ['title'],
                                                    style: GoogleFonts
                                                        .rajdhani(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: kBlackcolor,
                                                        fontSize:
                                                        kFontSize14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                        Colors
                                                            .transparent,
                                                        child: ClipOval(
                                                            child: Icon(
                                                              Icons.school,
                                                            )),
                                                      ),
                                                      title: Text(
                                                        DateFormat(
                                                            "yyyy-MM-dd hh:mma")
                                                            .format(DateTime
                                                            .parse(itemsData[
                                                        index]
                                                        [
                                                        'ts'])),
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            color:
                                                            klistnmber,
                                                            fontSize:
                                                            kFontSize14
                                                                .sp,
                                                          ),
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        itemsData[index]
                                                        ['tc'],
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color:
                                                            kExpertColor,
                                                            fontSize:
                                                            kFontSize14
                                                                .sp,
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: Stack(
                                                          children: [
                                                            Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    40),
                                                                child:
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .view_agenda),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ViewClassNote(note: itemsData[index]['re'], doc: _documents[index])));
                                                                  },
                                                                  color:
                                                                  kFbColor,
                                                                )),

                                                            Container(
                                                                margin: EdgeInsets.only(
                                                                    right:
                                                                    30),
                                                                child:
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .download_rounded),
                                                                  onPressed:
                                                                      () async {
                                                                    final id =
                                                                    await FlutterDownloader.enqueue(
                                                                      url: itemsData[index]
                                                                      [
                                                                      're'],
                                                                      savedDir:
                                                                      _localPath, //externalDir.path,
                                                                      fileName:
                                                                      '${SchClassConstant.schDoc['fn']} ${itemsData[index]['stlv']} result.pdf',
                                                                      showNotification:
                                                                      true,
                                                                      openFileFromNotification:
                                                                      true,
                                                                    );
                                                                  },
                                                                  color:
                                                                  kLightGreen,
                                                                )),
                                                            //IconButton(icon: Icon(Icons.upload_outlined), onPressed: (){},color: kLightGreen,)
                                                          ])),
                                                  Divider(),
                                                  Text(
                                                    '${itemsData[index]['stlv']} ${itemsData[index]['stcl']}',
                                                    style: GoogleFonts
                                                        .rajdhani(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: kBlackcolor,
                                                        fontSize:
                                                        kFontsize.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]));
                              }),
                          progress == true ||
                              _loadMoreProgress == true ||
                              _documents.length <
                                  SchClassConstant.streamCount
                              ? Text('')
                              : moreData == true
                              ? PlatformCircularProgressIndicator()
                              : GestureDetector(
                              onTap: () {
                                loadMore();
                              },
                              child: SvgPicture.asset(
                                'images/classroom/load_more.svg',
                              ))
                        ]),
                      ))
                ]),
              ),
            ])));
  }

  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("studentResult")
        .doc(SchClassConstant.schDoc['schId'])
        .collection('results')
        .where('stId', isEqualTo: SchClassConstant.schDoc['id'])
        .orderBy('ts', descending: true)
        .limit(SchClassConstant.streamCount)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
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
        .collection("studentResult")
        .doc(SchClassConstant.schDoc['schId'])
        .collection('results')
        .where('stId', isEqualTo: SchClassConstant.schDoc['id'])
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(SchClassConstant.streamCount)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
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
