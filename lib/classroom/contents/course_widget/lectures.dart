import 'dart:convert';

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/course_widget/add.dart';
import 'package:sparks/classroom/contents/course_widget/add_lecture.dart';
import 'package:sparks/classroom/contents/course_widget/divider.dart';
import 'package:sparks/classroom/contents/course_widget/replace_dialog.dart';
import 'package:sparks/classroom/contents/course_widget/replace_lecture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';

import 'package:sparks/classroom/contents/course_widget/section_course_edit.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/live/courses.dart';

import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/progress_indicator.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sparks/classroom/courses/constants.dart';

import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LectureCourses extends StatefulWidget {
  @override
  _LectureCoursesState createState() => _LectureCoursesState();
}

class _LectureCoursesState extends State<LectureCourses> {
  TextEditingController _controller = TextEditingController();

  bool checkController = false;
  bool isUpdating = false;
  var itemsData = [];
  var items = [];

  List<String> selectedDocument = <String>[];
  ReceivePort _port = ReceivePort();
  var showData = [];
  List<DocumentSnapshot> _documents = [];
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

    getLocalPath();

    getData();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port1');

    //UploadVariables.searchController.dispose();

    itemsData.clear();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port1');
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
    IsolateNameServer.removePortNameMapping('downloader_send_port1');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port1')!;
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

  /* Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    //await _prepare();
    setState(() {});
  }
*/
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

  Widget? _buildActionForTaskIdea(
      {required int lectureIndex, required int sectionIndex}) {
    int start = 0;
    int end = 0;

    start = myTasks.indexWhere((element) =>
        globalLectures.lectures[lectureIndex].sections[0].vido == element.link);
    end = start + globalLectures.lectures[lectureIndex].sections.length;

    print('start: ${start.toString()}');
    print('start + sectionIndex : ${(start + sectionIndex).toString()}');
    print(
        'myTasks[start + sectionIndex].name: ${myTasks[start + sectionIndex].name}');

    _TaskInfo task = myTasks[start + sectionIndex];

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
      return null;
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

  Course globalLectures = Course();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: UpdateCourse(),
        appBar: EditAppBar(
          detailsColor: kBlackcolor,
          videoColor: kStabcolor,
          updateColor: kBlackcolor,
          addColor: kBlackcolor,
          publishColor: kBlackcolor,
        ),
        body: _documents.length == 0
            ? ProgressIndicatorState()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    AddingLectureSections(
                        title: kSAdd + " " + kSCourseLecture,
                        add: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddLectureEdit()));
                        }),
                    SingleChildScrollView(
                      child: Column(
                        children: _documents.map((doc) {
                          List<dynamic> loadVideos = doc['lectures'];

                          Course lectures = Course();

                          int? prevLectureCount;

                          int? currLectureCount;

                          loadVideos.sort((a, b) {
                            String printMap =
                                json.encode(a['lecture'][0]['Lcount']);

                            print(
                                "printMap = json.encode(a['lecture'][0]['Lcount'])");

                            print('printMap: ' + printMap);

                            return a['lecture'][0]['Lcount']
                                .compareTo(b['lecture'][0]['Lcount']);
                          });

                          for (int i = 0; i < loadVideos.length; i++) {
                            List<dynamic> section = loadVideos[i]['lecture'];

                            Lecture sLecture = Lecture();

                            Section sSection = Section();

                            sSection.vido = section[0]['vido'];
                            sSection.sectionCount = section[0]['Sc'];
                            sSection.title = section[0]['title'];
                            sSection.at = section[0]['at'];
                            sSection.name = section[0]['name'];
                            sSection.lCount = section[0]['Lcount'];

                            if (i == 0) {
                              currLectureCount = section[0]['Lcount'];

                              sLecture.index = currLectureCount;

                              sLecture.sectionLength = 1;

                              sLecture.sections.add(sSection);

                              lectures.lectures.add(sLecture);
                            } else {
                              prevLectureCount =
                                  loadVideos[i - 1]['lecture'][0]['Lcount'];

                              currLectureCount =
                                  loadVideos[i]['lecture'][0]['Lcount'];

                              int? lCount =
                                  loadVideos[i]['lecture'][0]['Lcount'];

                              if (currLectureCount == prevLectureCount) {
                                lectures.lectures[lCount! - 1].sections
                                    .add(sSection);

                                lectures.lectures[lCount - 1].sectionLength++;
                              } else {
                                if (lectures.lectures.length < lCount!) {
                                  sLecture.index = currLectureCount;

                                  sLecture.sectionLength = 1;

                                  sLecture.sections.add(sSection);

                                  lectures.lectures.add(sLecture);
                                } else {
                                  lectures.lectures[lCount].sections
                                      .add(sSection);

                                  lectures.lectures[lCount].sectionLength++;
                                }
                              }
                            }
                          }

                          globalLectures = lectures;

                          //downloadTasks.clear();
                          myTasks.clear();
                          myItems.clear();

                          for (int i = 0; i < lectures.lectures.length; i++) {
                            for (int j = 0;
                                j < lectures.lectures[i].sections.length;
                                j++) {
                              myTasks.add(_TaskInfo(
                                  name: lectures.lectures[i].sections[j].title,
                                  link: lectures.lectures[i].sections[j].vido));

                              myItems.add(_ItemHolder(
                                  name: lectures.lectures[i].sections[j].title,
                                  task: myTasks[myTasks.length - 1]));
                            }
                          }

                          return Column(children: <Widget>[
                            /*editing the name of the lecture*/

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
                                                                  .circular(
                                                                      6.0),
                                                        ),
                                                        child: Text(
                                                          kUpdate,
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                                  textStyle:
                                                                      TextStyle(
                                                            color: kWhitecolor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                kFontsize.sp,
                                                          )),
                                                        ),
                                                        color: kFbColor,
                                                        onPressed: () =>
                                                            _updateLectureName(
                                                          course: lectures,
                                                        ),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            Container(
                              child: ListView.builder(
                                  itemCount: lectures.lectures.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    //return Text('we are here');

                                    return Container(
                                      child: GestureDetector(
                                        onTap: () async {
                                          final value =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => SectionEdit(
                                                currentSections: lectures
                                                    .lectures[index].sections,
                                                currentLectures: lectures,
                                                currentIndexOfLectures: index,
                                                lectureName: lectures
                                                    .lectures[index]
                                                    .sections[0]
                                                    .name,
                                              ),
                                            ),
                                          );

                                          if (value != null &&
                                              value == 'Done') {
                                            getData();
                                          }
                                        },
                                        child: Card(
                                            elevation: 20,
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 20),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    SectionEdit(
                                                              currentSections:
                                                                  lectures
                                                                      .lectures[
                                                                          index]
                                                                      .sections,
                                                              currentLectures:
                                                                  lectures,
                                                              currentIndexOfLectures:
                                                                  index,
                                                              lectureName:
                                                                  lectures
                                                                      .lectures[
                                                                          index]
                                                                      .sections[
                                                                          0]
                                                                      .name,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                              'Lecture ${index + 1}',
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kFbColor,
                                                                  fontSize:
                                                                      kTwentyTwo
                                                                          .sp,
                                                                ),
                                                              )),
                                                          SizedBox(height: 20),
                                                          CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.12,
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                            imageUrl: Constants
                                                                .courseEditThumbnail!,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(children: <Widget>[
                                                      Container(
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: ScreenUtil()
                                                                .setWidth(
                                                                    constrainedReadMore),
                                                            minHeight: ScreenUtil()
                                                                .setHeight(
                                                                    constrainedReadMoreHeight),
                                                          ),
                                                          child: ReadMoreText(
                                                            '${lectures.lectures[index].sections[0].name}',
                                                            trimLines: 2,
                                                            colorClickableText:
                                                                Colors.pink,
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimCollapsedText:
                                                                ' ...',
                                                            trimExpandedText:
                                                                'show less',
                                                            style: GoogleFonts
                                                                .rajdhani(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    kBlackcolor,
                                                                fontSize:
                                                                    kFontsize
                                                                        .sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                                //ToDo:displaying the linear progress bar

                                                Column(
                                                  children: <Widget>[
                                                    _buildActionForTask(
                                                        myTasks[0]), // before
                                                    //_buildActionForTask(lectureIndex: index, sectionIndex: sectionIndex),

                                                    myTasks[0].status ==
                                                                DownloadTaskStatus
                                                                    .running ||
                                                            myTasks[0].status ==
                                                                DownloadTaskStatus
                                                                    .paused
                                                        ? Container(
                                                            height: 4,
                                                            child:
                                                                LinearProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      kSsprogresscompleted),
                                                              backgroundColor:
                                                                  kSsprogressbar,
                                                              value: myTasks[0]
                                                                      .progress! /
                                                                  100,
                                                            ),
                                                          )
                                                        : Divider(
                                                            color:
                                                                kAshthumbnailcolor,
                                                            thickness:
                                                                kThickness,
                                                          ),
//
                                                  ],
                                                ),

                                                IntrinsicHeight(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                            onTap: () {
                                                              delete(
                                                                  index: index);
                                                            },
                                                            child: Text(
                                                              'Delete',
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kStabcolor,
                                                                  fontSize:
                                                                      kSlivevcrfonts
                                                                          .sp,
                                                                ),
                                                              ),
                                                            )),
                                                        VerticalLine(),
                                                        GestureDetector(
                                                            onTap: () {
                                                              replaceLecture(
                                                                  index: index);
                                                            },
                                                            child: Text(
                                                              kReplaceLecture,
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kStabcolor,
                                                                  fontSize:
                                                                      kSlivevcrfonts
                                                                          .sp,
                                                                ),
                                                              ),
                                                            )),
                                                        VerticalLine(),
                                                        GestureDetector(
                                                            onTap: () {
                                                              //_onSelected(index);

                                                              //downloadTasks.clear();

                                                              int start = 0;
                                                              int end = 0;

                                                              start = myTasks.indexWhere((element) =>
                                                                  lectures
                                                                      .lectures[
                                                                          index]
                                                                      .sections[
                                                                          0]
                                                                      .title ==
                                                                  element.name);
                                                              end = start +
                                                                  lectures
                                                                      .lectures[
                                                                          index]
                                                                      .sections
                                                                      .length;

                                                              for (int i =
                                                                      start;
                                                                  i < end;
                                                                  i++) {
                                                                downloadTasks
                                                                    .add(
                                                                        myTasks[
                                                                            i]);
                                                              }

                                                              _addListDownload();
                                                            },
                                                            child: Text(
                                                              'Download',
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kStabcolor,
                                                                  fontSize:
                                                                      kSlivevcrfonts
                                                                          .sp,
                                                                ),
                                                              ),
                                                            )),
                                                        VerticalLine(),
                                                        GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                checkController =
                                                                    true;

                                                                lectureToChangeNameIndex =
                                                                    index;

                                                                _controller
                                                                        .text =
                                                                    lectures
                                                                        .lectures[
                                                                            index]
                                                                        .sections[
                                                                            0]
                                                                        .name!;
                                                              });
                                                            },
                                                            child: Text(
                                                              'Edit name',
                                                              style: GoogleFonts
                                                                  .rajdhani(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kStabcolor,
                                                                  fontSize:
                                                                      kSlivevcrfonts
                                                                          .sp,
                                                                ),
                                                              ),
                                                            )),
                                                      ]),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _onSelected(int index) {
    //UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {
      } else {
        items.add(index);
      }
    });
  }

  //ToDo:Downloading videos in a list
  Future<void> _addListDownload() async {
    _requestDownloadMultiple(downloadTasks);
  }

  Future<String> _findLocalPath() async {
    final directory = defaultTargetPlatform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as Future<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  delete({int? index}) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    Course editedLectures = Course();

    for (int i = 0; i < globalLectures.lectures.length; i++) {
      if (i != index) {
        editedLectures.lectures.add(globalLectures.lectures[i]);
      }
    }

    List<Map> editedLecturesLM = [];
    List<int> lC = [];

    for (int i = 0; i < editedLectures.lectures.length; i++) {
      for (int j = 0; j < editedLectures.lectures[i].sections.length; j++) {
        Map editedLecture = {
          'lecture': ([
            {
              'vido': editedLectures.lectures[i].sections[j].vido,
              'Sc': editedLectures.lectures[i].sections[j].sectionCount,
              'title': editedLectures.lectures[i].sections[j].title,
              'at': editedLectures.lectures[i].sections[j].at,
              'name': editedLectures.lectures[i].sections[j].name,
              'Lcount': i + 1,
            }
          ])
        };

        editedLecturesLM.add(editedLecture);
      }

      lC.add(i + 1);
    }

    bool shouldDeleteCourse = false; //

    if (editedLectures.lectures.length == 0) {
      shouldDeleteCourse = true;
    }

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  DeleteDialog(oneDelete: () async {
                    try {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection("sessionContent")
                          .doc(currentUser!.uid)
                          .collection('courses')
                          .doc(Constants.docId);

                      //DocumentSnapshot editDoc = await documentReference.get();

                      if (shouldDeleteCourse) {
                        documentReference.delete().whenComplete(() {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Courses()));
                          // TODO toast to alert user that course is delete
                        }).catchError((e) {
                          Navigator.pop(context);

                          print('Error: ${e.toString()}');
                        });
                      } else {
                        documentReference.set({
                          'Lc': lC,
                          'lectures': editedLecturesLM,
                        }, SetOptions(merge: true)).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('sessionContent')
                              .doc(UploadVariables.currentUser)
                              .collection('courses')
                              .where('id', isEqualTo: Constants.docId)
                              .get()
                              .then((value) {
                            value.docs.forEach((result) {
                              Navigator.pop(context);

                              _documents.clear();
                              showData.clear();

                              setState(() {
                                _documents.add(result);
                                showData.add(result.data());
                              });
                            });
                          });
                        }).catchError((e) {
                          Navigator.pop(context);

                          print('Error: ${e.toString()}');
                        });
                      }
                    } catch (e) {
                      setState(() {});

                      Navigator.pop(context);

                      Fluttertoast.showToast(
                          msg: 'Sorry an error occured',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: kBlackcolor,
                          textColor: kFbColor);
                    }
                  })
                ]));
  }

  void getData() {
    try {
      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('courses')
          .where('id', isEqualTo: Constants.docId)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          setState(() {
            _documents.clear();
            showData.clear();
            _documents.add(result);
            showData.add(result.data());
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  /*replacing lecture*/
  void replaceLecture({int? index}) async {
    /*show dialog to tell the creator what lecture replace means*/

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  ReplaceDialog(
                      title: kReplaceText3 + 'Lecture ${index! + 1}',
                      oneReplace: () async {
                        Navigator.pop(context);
                        Course toEditLectures = Course();

                        for (int i = 0;
                            i < globalLectures.lectures.length;
                            i++) {
                          toEditLectures.lectures
                              .add(globalLectures.lectures[i]);
                        }

                        final value = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReplaceLecture(
                              currentIndexOfLectures: index,
                              toEditLectures: toEditLectures,
                            ),
                          ),
                        );

                        if (value != null && value == 'Done') {
                          getData();
                        }
                      })
                ]));
  }

  int? lectureToChangeNameIndex;

  void _updateLectureName({required Course course}) async {
    setState(() {
      isUpdating = true;
    });

    // will use currentIndex
    User currentUser = FirebaseAuth.instance.currentUser!;

    Course copyLectures = course;
    Course editedLectures = Course();

    for (int i = 0; i < copyLectures.lectures.length; i++) {
      Lecture editedLecture = Lecture();
      List<Section> editedSections = [];

      for (int j = 0; j < copyLectures.lectures[i].sections.length; j++) {
        if (i == lectureToChangeNameIndex) {
          copyLectures.lectures[i].sections[j].name = _controller.text;
          editedSections.add(copyLectures.lectures[i].sections[j]);
        } else {
          editedSections.add(copyLectures.lectures[i].sections[j]);
        }
      }

      if (editedSections.length != 0) {
        editedLecture.sections.addAll(editedSections);
        editedLectures.lectures.add(editedLecture);
      }
    }

    List<Map> editedLecturesLM = [];
    List<int> lC = [];

    for (int i = 0; i < editedLectures.lectures.length; i++) {
      for (int j = 0; j < editedLectures.lectures[i].sections.length; j++) {
        Map editedLecture = {
          'lecture': ([
            {
              'vido': editedLectures.lectures[i].sections[j].vido,
              'Sc': j + 1,
              'title': editedLectures.lectures[i].sections[j].title,
              'at': editedLectures.lectures[i].sections[j].at,
              'name': editedLectures.lectures[i].sections[j].name,
              'Lcount': i + 1,
            }
          ])
        };

        editedLecturesLM.add(editedLecture);
      }

      lC.add(i + 1);
    }

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("sessionContent")
          .doc(currentUser.uid)
          .collection('courses')
          .doc(Constants.docId);

      //DocumentSnapshot editDoc = await documentReference.get();

      documentReference.set({
        'Lc': lC,
        'lectures': editedLecturesLM,
      }, SetOptions(merge: true)).whenComplete(() {
        setState(() {
          isUpdating = false;
          checkController = false;
        });

        getData();
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
          msg: 'Sorry an error occured',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
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
