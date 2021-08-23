import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/class/add_class_section.dart';
import 'package:sparks/classroom/contents/class/edit_class_attachmnet.dart';
import 'package:sparks/classroom/contents/class/edit_class_video.dart';

import 'package:sparks/classroom/contents/class/replace_section.dart';
import 'package:sparks/classroom/contents/class/replace_dialog.dart';
import 'package:sparks/classroom/contents/class/edit_expert_appbar.dart';
import 'package:sparks/classroom/contents/class/expert_edit_constants.dart';
import 'package:sparks/classroom/contents/course_widget/add.dart';
import 'package:sparks/classroom/contents/course_widget/divider.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:sparks/classroom/contents/class/expert_models.dart';

class EditSections extends StatefulWidget {
  @override
  _EditSectionsState createState() => _EditSectionsState();
}

class _EditSectionsState extends State<EditSections> {
  var itemsData = [];
  List<dynamic> classVideos = <dynamic>[];
  List<int> items = <int>[];
  var _documents = [];

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }

  Widget spaceWidth() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _descController = TextEditingController();

  bool checkController = false;

  bool descController = false;

  bool isDescUpdating = false;
  bool isUpdating = false;
  bool _publishModal = false;

  ReceivePort _port = ReceivePort();

  getLocalPath() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClassData();
    getLocalPath();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    //UploadVariables.searchController.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      /*if (debug) {
        print('UI Isolate Callback: $data');
      }*/
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      final task = downloadTasks.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
    print(progress);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId!);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void _resumeDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return Container();
      /*return new RawMaterialButton(
        onPressed: () {
          //_requestDownload(task);
        },
        child: new Icon(Icons.file_download),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );*/
    }

    if (task.status == DownloadTaskStatus.running) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _pauseDownload(task);
            },
            child: new Icon(
              Icons.pause,
              color: kFbColor,
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _resumeDownload(task);
            },
            child: new Icon(
              Icons.play_arrow,
              color: kSsprogresscompleted,
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      downloadTasks.removeWhere((checkTask) => checkTask.link == task.link);

      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Icon(
            Icons.check_circle,
            color: kSsprogresscompleted,
          ),
        ),
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            _cancelDownload(task);
          },
          child: Icon(
            Icons.cancel,
            color: kFbColor,
          ),
        ),
      );
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.orangeAccent,
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              _cancelDownload(task);
            },
            child: Icon(
              Icons.cancel,
              color: kFbColor,
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void _requestDownloadMultiple(List<_TaskInfo> tasks) async {
    tasks.forEach((task) async {
      print('task.link: ${task.link}');
      task.taskId = await FlutterDownloader.enqueue(
          url: task.link!,
          headers: {"auth": "test_for_sql_encoding"},
          fileName: task.name!.trim() + '.mp4',
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true);

      //downloadTasks.removeWhere( (checkTask) => checkTask.link == task.link);
    });
  }

  List<_TaskInfo> myTasks = [];
  List<_ItemHolder> myItems = [];

  List<_TaskInfo> downloadTasks = [];

  late String _localPath;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < classVideos.length; i++) {
      myTasks.add(_TaskInfo(
          name: 'Section' + (i + 1).toString() + classVideos[i]['title'],
          link: classVideos[i]['vido']));

      myItems.add(_ItemHolder(name: classVideos[i]['title'], task: myTasks[i]));
    }

    return SafeArea(
        child: Scaffold(
            appBar: EditExpertAppBar(
              detailsColor: kBlackcolor,
              videoColor: kFbColor,
            ),
            body: _documents.isEmpty
                ? ProgressIndicatorState()
                : ModalProgressHUD(
                    inAsyncCall: _publishModal,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          space(),
                          AddingLectureSections(
                              title: kSAdd + " " + 'Section',
                              add: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddClassSectionEdit(
                                        classSectionCounts:
                                            classVideos.length)));
                              }),
                          /*editing the title of the section*/

                          Column(
                            children: <Widget>[
                              checkController == false
                                  ? Text('')
                                  : Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: kHorizontal,
                                              vertical: 15.0),
                                          child: TextField(
                                            maxLines: null,
                                            controller: _controller,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Title',
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: isUpdating
                                                  ? CircularProgressIndicator()
                                                  : RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Text(
                                                        kUpdate,
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                            color: kWhitecolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                kFontsize.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      color: kFbColor,
                                                      onPressed: () {
                                                        FocusScopeNode
                                                            currentFocus =
                                                            FocusScope.of(
                                                                context);
                                                        if (!currentFocus
                                                            .hasPrimaryFocus) {
                                                          currentFocus
                                                              .unfocus();
                                                        }
                                                        _updateSectionTitle();
                                                      },
                                                    ),
                                            ),
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    side: BorderSide(
                                                        color: kFbColor)),
                                                child: Text(
                                                  kCancel,
                                                  style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: kFontsize.sp,
                                                  )),
                                                ),
                                                color: kWhitecolor,
                                                onPressed: () {
                                                  setState(() {
                                                    checkController = false;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),

                          /*editing the description of the section*/

                          Column(
                            children: <Widget>[
                              descController == false
                                  ? Text('')
                                  : Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: kHorizontal,
                                              vertical: 15.0),
                                          child: TextField(
                                            maxLines: null,
                                            controller: _descController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Title',
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: isDescUpdating
                                                  ? CircularProgressIndicator()
                                                  : RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Text(
                                                        kUpdate,
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle: TextStyle(
                                                            color: kWhitecolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                kFontsize.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      color: kFbColor,
                                                      onPressed: () {
                                                        FocusScopeNode
                                                            currentFocus =
                                                            FocusScope.of(
                                                                context);
                                                        if (!currentFocus
                                                            .hasPrimaryFocus) {
                                                          currentFocus
                                                              .unfocus();
                                                        }
                                                        _updateSectionDesc();
                                                      }),
                                            ),
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    side: BorderSide(
                                                        color: kFbColor)),
                                                child: Text(
                                                  kCancel,
                                                  style: GoogleFonts.rajdhani(
                                                      textStyle: TextStyle(
                                                    color: kBlackcolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: kFontsize.sp,
                                                  )),
                                                ),
                                                color: kWhitecolor,
                                                onPressed: () {
                                                  setState(() {
                                                    descController = false;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                          Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: classVideos.length,
                                  itemBuilder: (context, int index) {
                                    return Card(
                                      elevation: 20,
                                      child: Column(
                                        children: <Widget>[
                                          space(),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: kHorizontal),
                                            alignment: Alignment.topLeft,
                                            child: Text('Section ${index + 1}',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kFbColor,
                                                    fontSize: kTwentyTwo.sp,
                                                  ),
                                                )),
                                          ),
                                          space(),
                                          spaceWidth(),
                                          Row(
                                            //mainAxisAlignment:MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: kHorizontal),
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        //height:MediaQuery.of(context).size.height * 0.25,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child:
                                                            ShowUploadedVideo(
                                                          videoPlayerController:
                                                              VideoPlayerController
                                                                  .network(classVideos[
                                                                          index]
                                                                      ['vido']),
                                                          looping: false,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: ButtonTheme(
                                                            //height: 50,
                                                            shape:
                                                                CircleBorder(),
                                                            child: RaisedButton(
                                                                color: Colors
                                                                    .transparent,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                onPressed:
                                                                    () {},
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          UploadVariables.videoUrlSelected =
                                                                              classVideos[index]['vido'];
                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                        },
                                                                        child: Icon(
                                                                            Icons
                                                                                .play_arrow,
                                                                            size:
                                                                                40)))),
                                                      )
                                                    ]),
                                              ),
                                              //spaceWidth(),
                                              /*the title of the class sections*/
                                              Column(children: <Widget>[
                                                Container(
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: ScreenUtil()
                                                          .setWidth(
                                                              constrainedReadMore),
                                                      minHeight: ScreenUtil()
                                                          .setHeight(
                                                              constrainedReadMoreHeight),
                                                    ),
                                                    child: ReadMoreText(
                                                      '${classVideos[index]['title']}',
                                                      trimLines: 2,
                                                      colorClickableText:
                                                          Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: ' ...',
                                                      trimExpandedText:
                                                          'show less',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kBlackcolor,
                                                          fontSize:
                                                              kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // spaceWidth(),
/*the description of the section class*/

                                                Container(
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxWidth: ScreenUtil()
                                                          .setWidth(
                                                              constrainedReadMore),
                                                      minHeight: ScreenUtil()
                                                          .setHeight(
                                                              constrainedReadMoreHeight),
                                                    ),
                                                    child: ReadMoreText(
                                                      '${classVideos[index]['desc']}',
                                                      trimLines: 2,
                                                      colorClickableText:
                                                          Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: ' ...',
                                                      trimExpandedText:
                                                          'show less',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kBlackcolor,
                                                          fontSize:
                                                              kFontsize.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                          space(),
                                          _buildActionForTask(myTasks[index]),

                                          myTasks[index].status ==
                                                      DownloadTaskStatus
                                                          .running ||
                                                  myTasks[index].status ==
                                                      DownloadTaskStatus.paused
                                              ? Container(
                                                  height: kThickness,
                                                  child:
                                                      LinearProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            kSsprogresscompleted),
                                                    backgroundColor:
                                                        kSsprogressbar,
                                                    value: myTasks[index]
                                                            .progress! /
                                                        100,
                                                  ),
                                                )
                                              : Divider(
                                                  color: kAshthumbnailcolor,
                                                  thickness: kThickness,
                                                ),
//
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      deleteSectionClass(
                                                          context,
                                                          _documents[index],
                                                          index);
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                                VerticalLine(),
                                                GestureDetector(
                                                    onTap: () {
                                                      replaceSectionClass(
                                                          index: index);
                                                    },
                                                    child: Text(
                                                      kReplaceSection,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                                VerticalLine(),
                                                GestureDetector(
                                                    onTap: () {
                                                      downloadClassSection(
                                                          index: index);
                                                    },
                                                    child: Text(
                                                      kDownloadSection,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                                VerticalLine(),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        checkController = true;

                                                        sectionToChangeTitleIndex =
                                                            index;

                                                        _controller.text =
                                                            classVideos[index]
                                                                ['title'];
                                                      });
                                                    },
                                                    child: Text(
                                                      kEditSectionName,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                                VerticalLine(),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        descController = true;

                                                        //sectionToChangeDescIndex = index;

                                                        _descController.text =
                                                            classVideos[index]
                                                                ['desc'];
                                                      });
                                                    },
                                                    child: Text(
                                                      kEditSectionDesc,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          space(),

                                          Divider(
                                            color: kAshthumbnailcolor,
                                            thickness: kThickness,
                                          ),
//
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .topToBottom,
                                                          child:
                                                              EditClassAttachment(
                                                            attachmentIndex:
                                                                index,
                                                            attachment:
                                                                classVideos[
                                                                        index]
                                                                    ['at'],
                                                            classVideos:
                                                                classVideos,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      classVideos[index]
                                                                  ['at'] ==
                                                              null
                                                          ? kAddSectionAttach
                                                          : kEditSectionAttach,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                                VerticalLine(),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .topToBottom,
                                                          child: EditClassVideo(
                                                            videoIndex: index,
                                                            video: classVideos[
                                                                index]['vido'],
                                                            classVideos:
                                                                classVideos,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      kEditSectionVideo,
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: kStabcolor,
                                                          fontSize:
                                                              kSlivevcrfonts.sp,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          space(),
                                        ],
                                      ),
                                    );
                                  })),
                        ],
                      ),
                    ),
                  )));
  }

  void getClassData() {
    try {
      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('classes')
          .where('id', isEqualTo: ExpertEditConstants.docId)
          .get()
          .then((value) {
        _documents.clear();
        itemsData.clear();
        classVideos.clear();

        value.docs.forEach((result) {
          setState(() {
            _documents.add(result);
            itemsData.add(result.data());
            classVideos = List.from(result.data()['class']);
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  int? sectionToChangeTitleIndex;

  _updateSectionTitle() async {
    setState(() {
      isUpdating = true;
    });

    ExpertLecture expertLecture = ExpertLecture();

    for (int i = 0; i < classVideos.length; i++) {
      if (i == sectionToChangeTitleIndex) {
        classVideos[i]['title'] = _controller.text;
      }
    }

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('classes')
          .doc(ExpertEditConstants.docId);

      //DocumentSnapshot editDoc = await documentReference.get();

      documentReference.set({
        'class': classVideos,
      }, SetOptions(merge: true)).whenComplete(() {
        getClassData();

        setState(() {
          isUpdating = false;
          checkController = false;
        });
      }).catchError((e) {
        setState(() {
          isUpdating = false;
        });

        print('Error: ${e.toString()}');
      });
    } catch (e) {
      setState(() {
        isUpdating = false;
      });

      Fluttertoast.showToast(
          msg: 'Sorry an error occured in updating section title.',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  _updateSectionDesc() async {
    setState(() {
      isDescUpdating = true;
    });

    ExpertLecture expertLecture = ExpertLecture();

    for (int i = 0; i < classVideos.length; i++) {
      if (i == sectionToChangeTitleIndex) {
        classVideos[i]['desc'] = _descController.text;
      }
    }

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('classes')
          .doc(ExpertEditConstants.docId);

      //DocumentSnapshot editDoc = await documentReference.get();

      documentReference.set({
        'class': classVideos,
      }, SetOptions(merge: true)).whenComplete(() {
        getClassData();

        setState(() {
          isDescUpdating = false;
          checkController = false;
        });
      }).catchError((e) {
        setState(() {
          isDescUpdating = false;
        });

        print('Error: ${e.toString()}');
      });
    } catch (e) {
      setState(() {
        isDescUpdating = false;
      });

      Fluttertoast.showToast(
          msg: 'Sorry an error occured in updating section descriotion.',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  Future<void> deleteSectionClass(
      BuildContext context, document, int index) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    //show delete dialog
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  DeleteDialog(oneDelete: () async {
                    List<dynamic> details = document['class'];

                    details.removeAt(index);
                    setState(() {
                      _publishModal = true;
                    });

                    await FirebaseFirestore.instance
                        .collection('sessionContent')
                        .doc(currentUser!.uid)
                        .collection('classes')
                        .doc(document.documentID)
                        .set({'class': details}, SetOptions(merge: true)).then(
                            (value) {
                      setState(() {
                        _publishModal = false;
                      });

                      Fluttertoast.showToast(
                          msg: 'Removed successfully at ${index.toString()}',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kSsprogresscompleted);
                    }).catchError((e) {
                      setState(() {
                        _publishModal = false;
                      });
                    });
                  })
                ]));
  }

  void replaceSectionClass({int? index}) {
    /*show dialog to tell the creator what lecture replace means*/

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  ClassReplaceDialog(
                      title: kReplaceText3 + 'Section ${index! + 1}',
                      oneReplace: () async {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.topToBottom,
                            child: ReplaceClassSection(
                              classVideos: classVideos,
                              sectionIndex: index,
                            ),
                          ),
                        );

                        /*  final value = await Navigator.of(context).push(

                      MaterialPageRoute(
                        builder: (context) =>
                            ReplaceLecture(),
                      ),
                    );*/

                        /* if (value != null && value == 'Done') {

                      getClassData();

                    }*/
                      })
                ]));
  }

  void downloadClassSection({required int index}) {
    _onSelected(index);

    downloadTasks.add(myTasks[index]);
    _addListDownload();
  }

  Future<void> _addListDownload() async {
    _requestDownloadMultiple(downloadTasks);
  }

  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _onSelected(int index) {
    UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {
      } else {
        items.add(index);
      }
    });
  }
}

class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String? name;
  final _TaskInfo? task;

  _ItemHolder({this.name, this.task});
}
