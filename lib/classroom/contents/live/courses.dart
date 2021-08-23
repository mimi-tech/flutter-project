import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/course_widget/course_text.dart';
import 'package:sparks/classroom/contents/course_widget/icons.dart';
import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/edit_course.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/schoolClassroom/utils/tabsTitle.dart';
import 'package:video_player/video_player.dart';

import 'package:sparks/classroom/contents/taskInfo.dart';

const debug = true;

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  bool _publishModal = false;
  String? filter;
  var documentsItems = [];
  var documents = [];
  bool progress = false;
  Future<bool> _checkPermission() async {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   PermissionStatus permission = await PermissionHandler()
    //       .checkPermissionStatus(PermissionGroup.storage);
    //   if (permission != PermissionStatus.granted) {
    //     Map<PermissionGroup, PermissionStatus> permissions =
    //     await PermissionHandler()
    //         .requestPermissions([PermissionGroup.storage]);
    //     if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
    //       return true;
    //     }
    //   } else {
    //     return true;
    //   }
    // } else {
    //   return true;
    // }
    // return false;
    /// TODO: Check the code block above
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkPermission();

    getLocalPath();

    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });

    _bindBackgroundIsolate();
    getCoursesData();
    FlutterDownloader.registerCallback(downloadCallback);

    //Timer.periodic(Duration(seconds: 2), (Timer t) => setState(() {}));
    getUpdatedCourses();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    //UploadVariables.searchController = null;
  }

  List<List<List<TaskInfo>>> myTasksAtLLL = [];
  List<List<List<TaskInfo>>> myTasksVidoLLL = [];
  List<List<List<ItemHolder>>> myItemsAtLLL = [];
  List<List<List<ItemHolder>>> myItemsVidoLLL = [];

  List<TaskInfo> downloadTasksAt = [];
  List<TaskInfo> downloadTasksVido = [];

  static Map<String, TaskInfo> _taskToItem = {};

  late String _localPath;

  Course globalLectures = Course();

  ReceivePort _port = ReceivePort();

  Future<String> _findLocalPath() async {
    return "";
  }

  getLocalPath() async {
    _localPath = (await _findLocalPath());

    //_localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

//    _localPath = 'data' + Platform.pathSeparator +
//        'user' + Platform.pathSeparator + '0' +
//        Platform.pathSeparator + 'Sparks' +
//        Platform.pathSeparator + 'Download';

    print('Download Path: $_localPath');

    /*String localPath1 = _localPath + Platform.pathSeparator + 'Videos';
    String localPath2 = _localPath + Platform.pathSeparator + 'Attachments';
    final savedDir1 = Directory(localPath1);
    final savedDir2 = Directory(localPath2);
    bool hasExisted1 = await savedDir1.exists();
    if (!hasExisted1) {
      savedDir1.create();
    }
    bool hasExisted2 = await savedDir2.exists();
    if (!hasExisted2) {
      savedDir2.create();
    }*/

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
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
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int? progress = data[2];

      print('Isolate Port Listen ID $id and Status ${status.toString()}');

      if (_taskToItem[id] != null) {
        setState(() {
          _taskToItem[id]!.status = status;
          _taskToItem[id]!.progress = progress;
        });
      }

//      TaskInfo task = _taskToItem[id];
//
//      if (task != null) {
//        setState(() {
//          task.status = status;
//          task.progress = progress;
//        });
//      }

//      final task = downloadTasksVido?.firstWhere((task) => task.taskId == id);
//      if (task != null) {
//        setState(() {
//          task.status = status;
//          task.progress = progress;
//        });
//      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and progess ($progress)');
    }

    if (_taskToItem[id] != null) {
      _taskToItem[id]!.status = status;
      _taskToItem[id]!.progress = progress;

//      setState(() {
//      });

    }

    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
    //print(progress);
  }

  void _cancelDownload(TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId!);
  }

  void _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  void _resumeDownload(TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  void _retryDownload(TaskInfo task) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  bool _loadMoreProgress = false;
  var _lastDocument;
  DocumentSnapshot? result;
  bool moreData = false;

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
  Widget _buildActionForTask(TaskInfo task) {
    print('Status: ${(task.progress! / 100).toString()}');

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
      downloadTasksVido.removeWhere((checkTask) => checkTask.link == task.link);

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

  void _requestDownloadMultipleVideos({
    required List<TaskInfo> vidoTasks,
  }) async {
    vidoTasks.forEach((vidoTask) async {
      //print('task.link: ${vidoTask.link}');

      await Future.delayed(Duration(seconds: 3), () async {
        String fileHead =
            'L${vidoTask.lectureNumber} S${vidoTask.sectionNumber} ';

        vidoTask.taskId = await FlutterDownloader.enqueue(
            url: vidoTask.link!,
            headers: {"auth": "test_for_sql_encoding"},
            fileName: fileHead + vidoTask.name!.trim() + '.mp4',
            savedDir: _localPath, // + Platform.pathSeparator + 'Videos',
            showNotification: true,
            openFileFromNotification: true);

        //downloadTasks.removeWhere( (checkTask) => checkTask.link == task.link);

        setState(() {
          _taskToItem.putIfAbsent(vidoTask.taskId!, () => vidoTask);
        });
      });
    });
  }

  void _requestDownloadMultipleAttachments(
      {required List<TaskInfo> atTasks}) async {
    atTasks.forEach((atTask) async {
      //print('task.link: ${atTask.link}');

      await Future.delayed(Duration(seconds: 3), () async {
        String fileHead = 'L${atTask.lectureNumber} S${atTask.sectionNumber} ';

        atTask.taskId = await FlutterDownloader.enqueue(
            url: atTask.link!,
            headers: {"auth": "test_for_sql_encoding"},
            fileName: fileHead + atTask.name!.trim() + '.jpg',
            savedDir: _localPath, // + Platform.pathSeparator + 'Attachments',
            showNotification: true,
            openFileFromNotification: true);

        //downloadTasks.removeWhere( (checkTask) => checkTask.link == task.link);

        setState(() {
          _taskToItem.putIfAbsent(atTask.taskId!, () => atTask);
        });
      });
    });
  }

  loadToCourse({DocumentSnapshot? doc, required int index}) {
    List<dynamic> loadVideos = documents[index]['lectures'];

    // List<dynamic> loadVideos = documents[index].data()['lectures'];

    Course lectures = Course();

    int? prevLectureCount;

    int? currLectureCount;

    loadVideos.sort((a, b) {
      String printMap = json.encode(a['lecture'][0]['Lcount']);

      //print("printMap = json.encode(a['lecture'][0]['Lcount'])");

      //print('printMap: ' + printMap);

      return a['lecture'][0]['Lcount'].compareTo(b['lecture'][0]['Lcount']);
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
        prevLectureCount = loadVideos[i - 1]['lecture'][0]['Lcount'];

        currLectureCount = loadVideos[i]['lecture'][0]['Lcount'];

        int? lCount = loadVideos[i]['lecture'][0]['Lcount'];

        if (currLectureCount == prevLectureCount) {
          lectures.lectures[lCount! - 1].sections.add(sSection);

          lectures.lectures[lCount - 1].sectionLength++;
        } else {
          if (lectures.lectures.length < lCount!) {
            sLecture.index = currLectureCount;

            sLecture.sectionLength = 1;

            sLecture.sections.add(sSection);

            lectures.lectures.add(sLecture);
          } else {
            lectures.lectures[lCount].sections.add(sSection);

            lectures.lectures[lCount].sectionLength++;
          }
        }
      }
    }

    print('Number for lectures: ${lectures.lectures.length} ');
    //print('Number for sections: ${}');

    globalLectures = lectures;

    //downloadTasks.clear();
//    myTasksAt.clear();
//    myItemsAt.clear();
//    myTasksVido.clear();
//    myItemsVido.clear();

    List<List<TaskInfo>> myTasksAtLL = [];
    List<List<TaskInfo>> myTasksVidoLL = [];
    List<List<ItemHolder>> myItemsAtLL = [];
    List<List<ItemHolder>> myItemsVidoLL = [];

    for (int i = 0; i < lectures.lectures.length; i++) {
      print('Lecture number: ${i} ');

      List<TaskInfo> myTasksAtL = [];
      List<TaskInfo> myTasksVidoL = [];
      List<ItemHolder> myItemsAtL = [];
      List<ItemHolder> myItemsVidoL = [];

      for (int j = 0; j < lectures.lectures[i].sections.length; j++) {
        print('Section number: ${j}');

        myTasksAtL.add(TaskInfo(
          name: lectures.lectures[i].sections[j].title! + 'at',
          link: lectures.lectures[i].sections[j].at,
          lectureNumber: '${(i + 1).toString()}',
          sectionNumber: '${(j + 1).toString()}',
        ));

        myItemsAtL.add(ItemHolder(
            name: lectures.lectures[i].sections[j].title! + 'at',
            task: myTasksAtL[myTasksAtL.length - 1]));

        myTasksVidoL.add(TaskInfo(
          name: lectures.lectures[i].sections[j].title,
          link: lectures.lectures[i].sections[j].vido,
          lectureNumber: '${(i + 1).toString()}',
          sectionNumber: '${(j + 1).toString()}',
        ));

        myItemsVidoL.add(ItemHolder(
            name: lectures.lectures[i].sections[j].title,
            task: myTasksVidoL[myTasksVidoL.length - 1]));
      }

      myTasksAtLL.add(myTasksAtL);
      myItemsAtLL.add(myItemsAtL);
      myTasksVidoLL.add(myTasksVidoL);
      myItemsVidoLL.add(myItemsVidoL);
    }

    myTasksAtLLL.add(myTasksAtLL);
    myItemsAtLLL.add(myItemsAtLL);
    myTasksVidoLLL.add(myTasksVidoLL);
    myItemsVidoLLL.add(myItemsVidoLL);

    for (int i = 0; i < myTasksAtLLL[index].length; i++) {
      for (int j = 0; j < myTasksAtLLL[index][i].length; j++) {
        print(
            'Course ${index + 1} Attachments: Lecture ${i + 1} Section ${j + 1}');
      }
    }

    for (int i = 0; i < myTasksVidoLLL[index].length; i++) {
      for (int j = 0; j < myTasksVidoLLL[index][i].length; j++) {
        print('Course ${index + 1} Videos: Lecture ${i + 1} Section ${j + 1}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(),
        drawer: DrawerBar(),
        body: ModalProgressHUD(
            inAsyncCall: _publishModal,
            child: CustomScrollView(slivers: <Widget>[
              SilverAppBar(
                matches: kSappbarcolor,
                friends: kSappbarcolor,
                classroom: kSappbarcolor,
                content: kStabcolor1,
              ),
              SilverAppBarSecond(
                tutorialColor: kBlackcolor,
                coursesColor: kStabcolor,
                expertColor: kBlackcolor,
                eventsColor: kBlackcolor,
                publishColor: kBlackcolor,
              ),
              //SilverAppBarThird(),
              SliverList(
                  delegate: SliverChildListDelegate([
                    documents.length == 0 && progress == false
                        ? Center(child: PlatformCircularProgressIndicator())
                        : documents.length == 0 && progress == true
                        ? NoContentText(title: kNoContent)
                        : ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, int index) {
                          return filter == null || filter == ""
                              ? GestureDetector(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),
                              elevation: 20.0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: kScontentPadding1,
                                    top: kScontentPadding2,
                                    left: kScontentPadding3,
                                    right: kScontentPadding4),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CourseIcons(
                                          /*downloading all the videos*/

                                          download: () {
                                            Navigator.pop(context);
                                            //loadToCourse(doc: documents[index]);
                                            downloadAllVideos(
                                                context,
                                                documents[index],
                                                index);
                                          },

                                          downloadAttachment: () {
                                            print(
                                                'From icon tap downloadAllAttachments');
                                            downloadAllAttachments(
                                                context,
                                                documents[index],
                                                index);
                                          },

                                          //ToDo:Edit content
                                          edit: () {
                                            //Navigator.pop(context);
                                            editCourses(
                                                context,
                                                documents[index],
                                                index);
                                          },

                                          //ToDo:deleting of document
                                          delete: () {
                                            Navigator.pop(context);
                                            deleteItem(context,
                                                documents[index]);
                                          },

                                          //ToDo:Copying link
                                          copyLink: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                'https://sparksuniverse.com/' +
                                                    documentsItems[
                                                    index]
                                                    ['id']));
                                            Fluttertoast.showToast(
                                                msg: 'Copied',
                                                gravity: ToastGravity
                                                    .CENTER,
                                                toastLength: Toast
                                                    .LENGTH_SHORT,
                                                backgroundColor:
                                                klistnmber,
                                                textColor:
                                                kWhitecolor);
                                            Navigator.pop(context);
                                          },
                                        ),

                                        Stack(
                                            alignment:
                                            Alignment.center,
                                            children: <Widget>[
                                              documentsItems[index]
                                              ['tmb'] ==
                                                  'null'
                                                  ? Container(
                                                width: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width *
                                                    0.3,
                                                //height:MediaQuery.of(context).size.width * 0.5,
                                                child:
                                                ShowUploadedVideo(
                                                  videoPlayerController:
                                                  VideoPlayerController.network(
                                                      documentsItems[index]
                                                      [
                                                      'prom']),
                                                  looping:
                                                  false,
                                                ),
                                              )
                                                  : CachedNetworkImage(
                                                placeholder: (context,
                                                    url) =>
                                                    Center(
                                                        child:
                                                        PlatformCircularProgressIndicator()),
                                                errorWidget: (context,
                                                    url,
                                                    error) =>
                                                    Icon(Icons
                                                        .error),
                                                imageUrl:
                                                documentsItems[
                                                index]
                                                ['tmb'],
                                                fit: BoxFit
                                                    .cover,
                                                width: ScreenUtil()
                                                    .setWidth(
                                                    100),
                                                height: ScreenUtil()
                                                    .setHeight(
                                                    100),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.3,
                                                  child: ButtonTheme(
                                                      shape:
                                                      CircleBorder(),
                                                      height:
                                                      ScreenUtil()
                                                          .setHeight(
                                                          50),
                                                      child: RaisedButton(
                                                          color: Colors.transparent,
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                UploadVariables.videoUrlSelected =
                                                                documentsItems[index]['prom'];
                                                                Navigator.of(context)
                                                                    .push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                              },
                                                              child: Icon(Icons.play_arrow, size: 40)))))
                                            ]),
                                        SizedBox(
                                          width: 5.0,
                                        ),

                                        //ToDo:live text display
                                        LiveText(
                                          title: documentsItems[index]
                                          ['topic'],
                                          desc: documentsItems[index]
                                          ['desc'],
                                          rate: documentsItems[index]
                                          ['rate']
                                              .toString(),
                                          date: documentsItems[index]
                                          ['date'],
                                          views: documentsItems[index]
                                          ['views']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),

                                    //ToDo:displaying the linear progress bar

                                    for (int i = 0;
                                    i <
                                        myTasksAtLLL[index]
                                            .length;
                                    i++)
                                      for (int j = 0;
                                      j <
                                          myTasksAtLLL[index][i]
                                              .length;
                                      j++)
                                        Column(
                                          children: <Widget>[
                                            _taskToItem[myTasksAtLLL[
                                            index]
                                            [i][j]
                                                .taskId] !=
                                                null
                                                ? _buildActionForTask(
                                                _taskToItem[
                                                myTasksAtLLL[
                                                index]
                                                [i][j]
                                                    .taskId]!)
                                                : Container(),

//                                          _buildActionForTask(
//                                              myTasksAt[index][i]),

                                            _taskToItem[myTasksAtLLL[
                                            index]
                                            [i][j]
                                                .taskId] !=
                                                null
                                                ? _taskToItem[myTasksAtLLL[index][i][j]
                                                .taskId]!
                                                .status ==
                                                DownloadTaskStatus
                                                    .running ||
                                                _taskToItem[myTasksAtLLL[index][i][j]
                                                    .taskId]!
                                                    .status ==
                                                    DownloadTaskStatus
                                                        .paused

//                                          myTasksAt[index][i].status ==
//                                              DownloadTaskStatus.running ||
//                                              myTasksAt[index][i].status ==
//                                                  DownloadTaskStatus.paused

                                                ? Container(
                                              height:
                                              kThickness,
                                              child:
                                              LinearProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    kSsprogresscompleted),
                                                backgroundColor:
                                                kSsprogressbar,
                                                value: _taskToItem[myTasksAtLLL[index][i][j].taskId]!
                                                    .progress! /
                                                    100,
//                                              value: myTasksAt[index][i]
//                                                  .progress / 100,
                                              ),
                                            )
                                                : Container()
                                                : Container(),

//                                          Divider(
//                                            color: kAshthumbnailcolor,
//                                            thickness: kThickness,
//                                          ),
                                          ],
                                        ),

                                    for (int i = 0;
                                    i <
                                        myTasksVidoLLL[index]
                                            .length;
                                    i++)
                                      for (int j = 0;
                                      j <
                                          myTasksVidoLLL[index][i]
                                              .length;
                                      j++)
                                        Column(
                                          children: <Widget>[
                                            _taskToItem[myTasksVidoLLL[
                                            index]
                                            [i][j]
                                                .taskId] !=
                                                null
                                                ? _buildActionForTask(
                                                _taskToItem[
                                                myTasksVidoLLL[
                                                index]
                                                [i][j]
                                                    .taskId]!)
                                                : Container(),

//                                          _buildActionForTask(
//                                              myTasksVido[index][i]),

                                            _taskToItem[myTasksVidoLLL[
                                            index]
                                            [i][j]
                                                .taskId] !=
                                                null
                                                ? _taskToItem[myTasksVidoLLL[index][i][j]
                                                .taskId]!
                                                .status ==
                                                DownloadTaskStatus
                                                    .running ||
                                                _taskToItem[myTasksVidoLLL[index][i][j]
                                                    .taskId]!
                                                    .status ==
                                                    DownloadTaskStatus
                                                        .paused

//                                          myTasksVido[index][i].status ==
//                                              DownloadTaskStatus.running ||
//                                              myTasksVido[index][i].status ==
//                                                  DownloadTaskStatus.paused

                                                ? Container(
                                              height:
                                              kThickness,
                                              child:
                                              LinearProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    kSsprogresscompleted),
                                                backgroundColor:
                                                kSsprogressbar,
                                                value: _taskToItem[myTasksVidoLLL[index][i][j].taskId]!
                                                    .progress! /
                                                    100,
//                                              value: myTasksVido[index][i]
//                                                  .progress / 100,
                                              ),
                                            )
                                                : Container()
                                                : Container(),

//                                          Divider(
//                                            color: kAshthumbnailcolor,
//                                            thickness: kThickness,
//                                          ),
                                          ],
                                        ),

                                    //ToDo:Displaying the live text second
                                    CourseText(
                                        visibility: documentsItems[
                                        index]
                                        ['verified'] ==
                                            true
                                            ? 'Verified'
                                            : 'Not Verified',
                                        aLimit: documentsItems[index]
                                        ['age'],
                                        amount: documentsItems[index]
                                        ['amt']),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : '${documents[index]}'
                              .toLowerCase()
                              .contains(filter!.toLowerCase())
                              ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            elevation: 20.0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: kScontentPadding1,
                                  top: kScontentPadding2,
                                  left: kScontentPadding3,
                                  right: kScontentPadding4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CourseIcons(
                                        //ToDo:Edit content
                                        edit: () {
                                          editCourses(
                                              context,
                                              documents[index],
                                              index);
                                        },
                                        download: () {
                                          downloadAllVideos(
                                              context,
                                              documents[index],
                                              index);
                                        },
                                        downloadAttachment: () {
                                          print(
                                              'From icon tap downloadAllAttachments');
                                          downloadAllAttachments(
                                              context,
                                              documents[index],
                                              index);
                                        },
                                        //ToDo:deleting of document
                                        delete: () {
                                          Navigator.pop(context);
                                          deleteItem(context,
                                              documents[index]);
                                        },

                                        //ToDo:Copying link
                                        copyLink: () {
                                          Clipboard.setData(ClipboardData(
                                              text: 'https://sparksuniverse.com/' +
                                                  documentsItems[
                                                  index]
                                                  ['id']));
                                          Fluttertoast.showToast(
                                              msg: 'Copied',
                                              gravity:
                                              ToastGravity
                                                  .CENTER,
                                              toastLength: Toast
                                                  .LENGTH_SHORT,
                                              backgroundColor:
                                              klistnmber,
                                              textColor:
                                              kWhitecolor);
                                          Navigator.pop(context);
                                        },
                                      ),

                                      Stack(children: <Widget>[
                                        documentsItems[index]
                                        ['tmb'] ==
                                            'null'
                                            ? Container(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width *
                                              0.3,
                                          //height:MediaQuery.of(context).size.width * 0.5,
                                          child: Center(
                                            child:
                                            ShowUploadedVideo(
                                              videoPlayerController:
                                              VideoPlayerController.network(
                                                  documentsItems[index]
                                                  [
                                                  'prom']),
                                              looping:
                                              false,
                                            ),
                                          ),
                                        )
                                            : CachedNetworkImage(
                                          placeholder: (context,
                                              url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context,
                                              url,
                                              error) =>
                                              Icon(Icons
                                                  .error),
                                          imageUrl:
                                          documentsItems[
                                          index]
                                          ['tmb'],
                                          fit: BoxFit.cover,
                                          width:
                                          ScreenUtil()
                                              .setWidth(
                                              100),
                                          height:
                                          ScreenUtil()
                                              .setHeight(
                                              100),
                                        ),
                                        Center(
                                            child: ButtonTheme(
                                                shape:
                                                CircleBorder(),
                                                height:
                                                ScreenUtil()
                                                    .setHeight(
                                                    50),
                                                child:
                                                RaisedButton(
                                                    color: Colors
                                                        .transparent,
                                                    textColor:
                                                    Colors
                                                        .white,
                                                    onPressed:
                                                        () {},
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          UploadVariables.videoUrlSelected =
                                                          documentsItems[index]['prom'];
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                        },
                                                        child: Icon(Icons.play_arrow, size: 40)))))
                                      ]),
                                      SizedBox(
                                        width: 5.0,
                                      ),

                                      //ToDo:live text display
                                      LiveText(
                                        title:
                                        documentsItems[index]
                                        ['topic'],
                                        desc:
                                        documentsItems[index]
                                        ['desc'],
                                        rate:
                                        documentsItems[index]
                                        ['rate']
                                            .toString(),
                                        date:
                                        documentsItems[index]
                                        ['date'],
                                        views:
                                        documentsItems[index]
                                        ['views']
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),

                                  //ToDo:Displaying the live text second
                                  CourseText(
                                      visibility:
                                      documentsItems[index]
                                      ['verified'],
                                      aLimit:
                                      documentsItems[index]
                                      ['age'],
                                      amount:
                                      documentsItems[index]
                                      ['amt']),
                                ],
                              ),
                            ),
                          )
                              : Container();
                        })
                  ]))
            ])));
  }

  void deleteItem(BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            children: <Widget>[
              DeleteDialog(oneDelete: () async {
                if (UploadVariables.monVal == true) {
                  Navigator.pop(context);
                  _publishModal = true;
                  User currentUser = FirebaseAuth.instance.currentUser!;

                  await FirebaseFirestore.instance
                      .collection('sessionContent')
                      .doc(currentUser.uid)
                      .collection('courses')
                      .doc(document.id)
                      .delete();

                  _publishModal = false;

                  Fluttertoast.showToast(
                      msg: kSdeletedsuuccessfully,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: kBlackcolor,
                      textColor: kSsprogresscompleted);
                } else {
                  Fluttertoast.showToast(
                      msg: kuncheckwarning,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: kBlackcolor,
                      textColor: kFbColor);
                }
              })
            ]));
  }

  void editCourses(BuildContext context, DocumentSnapshot document, int index) {
    Constants.docId = document.id;
    Constants.courseEditThumbnail = document['tmb'];
    Constants.courseVerify = document['verified'];

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditCourses()));
  }

  /*downloading all the videos*/
  void downloadAllVideos(
      BuildContext context, DocumentSnapshot document, int index) {
//    downloadTasksAt.clear();
//    downloadTasksVido.clear();

    //downloadTasksAt.clear();
    downloadTasksVido.clear();

    for (int i = 0; i < myTasksVidoLLL[index].length; i++) {
      for (int j = 0; j < myTasksVidoLLL[index][i].length; j++) {
        //downloadTasksAt.add(myTasksAtLLL[index][i][j]);
        downloadTasksVido.add(myTasksVidoLLL[index][i][j]);
      }
    }

    _requestDownloadMultipleVideos(
      vidoTasks: downloadTasksVido,
      //atTasks: downloadTasksAt,
    );

    setState(() {});
  }

  void downloadAllAttachments(
      BuildContext context, DocumentSnapshot document, int index) {
//    downloadTasksAt.clear();
//    downloadTasksVido.clear();
    print('downloadAllAttachments documentID: ' + document.id);

    downloadTasksAt.clear();
    //downloadTasksVido.clear();

    for (int i = 0; i < myTasksAtLLL[index].length; i++) {
      for (int j = 0; j < myTasksAtLLL[index][i].length; j++) {
        downloadTasksAt.add(myTasksAtLLL[index][i][j]);
        //downloadTasksVido.add(myTasksVidoLLL[index][i][j]);

      }
    }

    _requestDownloadMultipleAttachments(
      //vidoTasks: downloadTasksVido,
      atTasks: downloadTasksAt,
    );

    setState(() {});
  }

  Future<void> getCoursesData() async {
    FirebaseFirestore.instance
        .collection('sessionContent')
        .doc(UploadVariables.currentUser)
        .collection('courses')
        .orderBy('dt', descending: true)
        .limit(UploadVariables.limit)
        .get()
        .then((value) {
      int i = 0;
      documents.clear();
      documentsItems.clear();

      value.docs.forEach((result) {
        setState(() {
          documents.add(result);
          documentsItems.add(result.data());
        });

        loadToCourse(doc: result, index: i);

        i++;
      });
    });
  }

/*get the courses that has been modified*/
  void getUpdatedCourses() {
    var now = new DateTime.now();
    FirebaseFirestore.instance
        .collectionGroup("courses")
        .snapshots()
        .listen((result) {
      result.docChanges.forEach((res) {
        if (res.type == DocumentChangeType.modified) {
          /*send to database the course updated*/
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection("ModifiedCourses")
              .doc(res.doc.data()!['id']);
          documentReference.set({'id': res.doc.data()!['id'], 'date': now});

          //update the course to updated
          FirebaseFirestore.instance
              .collectionGroup('courses')
              .where('id', isEqualTo: res.doc.data()!['id'])
              .get()
              .then((value) {
            value.docs.forEach((result) {
              result.reference.update({
                'up': true,
              });
            });
          });

          print(res.doc.data()!['fn']);
        } else {
          print('none modified');
        }
      });
    });
  }
}