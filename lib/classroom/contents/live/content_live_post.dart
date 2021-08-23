import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';

import 'package:sparks/classroom/contents/live/icons.dart';
import 'package:sparks/classroom/contents/live_posts/no_content.dart';
import 'package:sparks/classroom/progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparks/classroom/contents/appbar.dart';
import 'package:sparks/classroom/contents/appbar2.dart';
import 'package:sparks/classroom/contents/appbar3.dart';
import 'package:sparks/classroom/contents/drawer.dart';
import 'package:sparks/classroom/contents/edit_content.dart';
import 'package:sparks/classroom/contents/live/delete_dialog.dart';
import 'package:sparks/classroom/contents/live/text.dart';
import 'package:sparks/classroom/contents/live/text2.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/contents/top_app.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';
import 'package:sparks/classroom/uploadvideo/playlistscreen.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';

import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class LiveContent extends StatefulWidget {
  final TargetPlatform? platform;

  LiveContent({Key? key, this.platform}) : super(key: key);

  @override
  _LiveContentState createState() => _LiveContentState();
}

class _LiveContentState extends State<LiveContent> {
  bool _publishModal = false;
  bool progress = false;
  var itemsData = [];
  var _documents = [];

  var items = [];

  bool _loadMoreProgress = false;
  late var _lastDocument;
  DocumentSnapshot? result;
  bool moreData = false;
  String? filter;

  List<String> selectedDocument = <String>[];
  ReceivePort _port = ReceivePort();

  getLocalPath() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
  //TextEditingController searchController =  TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    getLocalPath();
    //ToDo:search filtering

    //searchItems.addAll(searchTitle);
    UploadVariables.searchController.addListener(() {
      setState(() {
        filter = UploadVariables.searchController.text;
      });
    });

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    //UploadVariables.searchController = null;

    itemsData.clear();
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
  Widget? _buildActionForTask(_TaskInfo task) {
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

  bool longPressTapped = false;
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < itemsData.length; i++) {
      myTasks.add(
          _TaskInfo(name: itemsData[i]['title'], link: itemsData[i]['vido']));

      myItems.add(_ItemHolder(name: itemsData[i]['title'], task: myTasks[i]));
    }

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
              GetSelectedCard.selectedCard.isEmpty
                  ? SilverAppBarSecond(
                      tutorialColor: kStabcolor,
                      coursesColor: kBlackcolor,
                      expertColor: kBlackcolor,
                      eventsColor: kBlackcolor,
                      publishColor: kBlackcolor,
                    )
                  : SilverAppBarThird(
                      listPlaylist: () {
                        _addListPlaylist();
                      },
                      listDownload: () {
                        _addListDownload();
                      },
                      listDelete: () {
                        _addListDelete();
                      },
                    ),
              //SilverAppBarThird(),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    child: Column(children: <Widget>[
                  itemsData.length == 0 && progress == false
                      ? Center(child: ProgressIndicatorState())
                      : itemsData.length == 0 && progress == true
                          ? NoContentCreated(
                              title: kNoContentTitle,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _documents.length,
                              itemBuilder: (context, int index) {
                                return filter == null || filter == ""
                                    ? GestureDetector(
                                        onLongPress: () {
                                          _selectDoc(context, _documents[index],
                                              index);

                                          longPressTapped = true;
                                        },
                                        onTap: () {
                                          _tapDoc(context, _documents[index],
                                              index);
                                        },
                                        child: Card(
                                          color: GetSelectedCard.selectedCard
                                                  .contains(index)
                                              ? Colors.yellow
                                              : kWhitecolor,
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
                                            //ToDo:displaying the icons
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    ShowIcons(
                                                      //ToDo:Edit content
                                                      edit: () {
                                                        editContentPost(
                                                            context,
                                                            _documents[index],
                                                            index);
                                                      },

                                                      playlist: () {
                                                        UploadVariables
                                                                .selectedVideo =
                                                            itemsData[index]
                                                                ['vido'];
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PlaylistScreen()));
                                                      },

                                                      //ToDo:deleting of document
                                                      delete: () {
                                                        Navigator.pop(context);
                                                        _onTapItem(context,
                                                            _documents[index]);
                                                      },
                                                      //ToDo:Downloading a video
                                                      download: () async {
                                                        Navigator.pop(context);
                                                        UploadVariables
                                                                .downloadVideoUrl =
                                                            itemsData[index]
                                                                ['vido'];
                                                        _onSelected(index);

                                                        downloadTasks.add(
                                                            myTasks[index]);
                                                        _addListDownload();

                                                        //_singleDownload(myTasks[index], index);
                                                      },
                                                      //ToDo:Copying link

                                                      copyLink: () {
                                                        Clipboard.setData(ClipboardData(
                                                            text: 'https://sparksuniverse.com/' +
                                                                itemsData[index]
                                                                    ['vi_id']));
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

                                                    SizedBox(width: 2.0),
                                                    //ToDo:Display the live videos

                                                    Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          itemsData[index]
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
                                                                          VideoPlayerController.network(itemsData[index]
                                                                              [
                                                                              'vido']),
                                                                      looping:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Image.network(
                                                                  itemsData[
                                                                          index]
                                                                      ['tmb'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.35,
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          80),
                                                                ),
                                                          Center(
                                                              child: ButtonTheme(
                                                                  shape: CircleBorder(),
                                                                  height: ScreenUtil().setHeight(50),
                                                                  child: RaisedButton(
                                                                      color: Colors.transparent,
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            UploadVariables.videoUrlSelected =
                                                                                itemsData[index]['vido'];
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                          },
                                                                          child: Icon(Icons.play_arrow, size: 40)))))
                                                        ]),

                                                    SizedBox(
                                                      width: 5.0,
                                                    ),

                                                    //ToDo:live text display
                                                    LiveText(
                                                        title: itemsData[index]
                                                            ['title'],
                                                        desc: itemsData[index]
                                                            ['desc'],
                                                        rate: itemsData[index]
                                                            ['rate'],
                                                        date: itemsData[index]
                                                            ['date'],
                                                        views: itemsData[index]
                                                            ['views']),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),

                                                //ToDo:displaying the linear progress bar

                                                _buildActionForTask(
                                                    myTasks[index])!,

                                                myTasks[index].status ==
                                                            DownloadTaskStatus
                                                                .running ||
                                                        myTasks[index].status ==
                                                            DownloadTaskStatus
                                                                .paused
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
                                                        color:
                                                            kAshthumbnailcolor,
                                                        thickness: kThickness,
                                                      ),

                                                //ToDo:Displaying the live text second
                                                LiveTextSecond(
                                                  visibility: itemsData[index]
                                                      ['visi'],
                                                  aLimit: itemsData[index]
                                                      ['age'],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : '${itemsData[index]}'
                                            .toLowerCase()
                                            .contains(filter!.toLowerCase())
                                        ? Card(
                                            color: GetSelectedCard.selectedCard
                                                    .contains(index)
                                                ? Colors.yellow
                                                : kWhitecolor,
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
                                              //ToDo:displaying the icons
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      ShowIcons(
                                                        //ToDo:Edit content
                                                        edit: () {
                                                          editContentPost(
                                                              context,
                                                              _documents[index],
                                                              index);
                                                        },

                                                        playlist: () {
                                                          UploadVariables
                                                                  .selectedVideo =
                                                              itemsData[index]
                                                                  ['vido'];
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PlaylistScreen()));
                                                        },

                                                        //ToDo:deleting of document
                                                        delete: () {
                                                          Navigator.pop(
                                                              context);
                                                          _onTapItem(
                                                              context,
                                                              _documents[
                                                                  index]);
                                                        },
                                                        //ToDo:Downloading a video
                                                        download: () async {
                                                          Navigator.pop(
                                                              context);
                                                          UploadVariables
                                                                  .downloadVideoUrl =
                                                              itemsData[index]
                                                                  ['vido'];
                                                          _onSelected(index);

                                                          downloadTasks.add(
                                                              myTasks[index]);
                                                          _addListDownload();

                                                          //_singleDownload(myTasks[index], index);
                                                        },
                                                        //ToDo:Copying link

                                                        copyLink: () {
                                                          Clipboard.setData(ClipboardData(
                                                              text: 'https://sparksuniverse.com/' +
                                                                  itemsData[
                                                                          index]
                                                                      [
                                                                      'vi_id']));
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),

                                                      SizedBox(width: 5.0),
                                                      //ToDo:Display the live videos

                                                      Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: <Widget>[
                                                            itemsData[index]
                                                                        ['tmb']
                                                                    .isEmpty
                                                                ? Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.3,
                                                                    child:
                                                                        ShowUploadedVideo(
                                                                      videoPlayerController:
                                                                          VideoPlayerController.network(itemsData[index]
                                                                              [
                                                                              'vido']),
                                                                      looping:
                                                                          false,
                                                                    ),
                                                                  )
                                                                : Image.network(
                                                                    itemsData[
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
                                                                  height: ScreenUtil().setHeight(50),
                                                                  shape: CircleBorder(),
                                                                  child: RaisedButton(
                                                                      color: Colors.transparent,
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            UploadVariables.videoUrlSelected =
                                                                                itemsData[index]['vido'];
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingVideos()));
                                                                          },
                                                                          child: Icon(Icons.play_arrow, size: 40)))),
                                                            )
                                                          ]),

                                                      SizedBox(
                                                        height: 10.0,
                                                      ),

                                                      //ToDo:live text display
                                                      LiveText(
                                                          title:
                                                              itemsData[index]
                                                                  ['title'],
                                                          desc: itemsData[index]
                                                              ['desc'],
                                                          rate: itemsData[index]
                                                              ['rate'],
                                                          date: itemsData[index]
                                                              ['date'],
                                                          views:
                                                              itemsData[index]
                                                                  ['views']),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15.0,
                                                  ),

                                                  //ToDo:displaying the linear progress bar

                                                  _buildActionForTask(
                                                      myTasks[index])!,

                                                  myTasks[index].status ==
                                                              DownloadTaskStatus
                                                                  .running ||
                                                          myTasks[index]
                                                                  .status ==
                                                              DownloadTaskStatus
                                                                  .paused
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
                                                            value: myTasks[
                                                                        index]
                                                                    .progress! /
                                                                100,
                                                          ),
                                                        )
                                                      : Divider(
                                                          color:
                                                              kAshthumbnailcolor,
                                                          thickness: kThickness,
                                                        ),

                                                  //ToDo:Displaying the live text second
                                                  LiveTextSecond(
                                                    visibility: itemsData[index]
                                                        ['visi'],
                                                    aLimit: itemsData[index]
                                                        ['age'],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                              }),
                  progress == true ||
                          _loadMoreProgress == true ||
                          _documents.length < UploadVariables.limit
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
                ]))
              ]))
            ])));
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('sessionContent')
        .doc(GlobalVariables.loggedInUserObject.id)
        .collection('userSessionUploads')
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(UploadVariables.limit)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
      for (DocumentSnapshot result in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(result);
          itemsData.add(result.data());

          moreData = false;
        });
      }
    }
  }

  Future<void> _getData() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(GlobalVariables.loggedInUserObject.id)
          .collection('userSessionUploads')
          .orderBy('ts', descending: true)
          .limit(UploadVariables.limit)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          progress = true;
        });
      } else {
        for (DocumentSnapshot document in documents) {
          setState(() {
            _documents.add(document);
            itemsData.add(document.data());

            // PageConstants.getCompanies.clear();
          });
        }
      }
    } catch (e) {
      // return CircularProgressIndicator();
    }

//ToDo:get the comments for the post from database
    try {
      FirebaseFirestore.instance
          .collection('sessionContent')
          .doc(UploadVariables.currentUser)
          .collection('userSessionUploads')
          .doc()
          .collection('comments')
          .get()
          .then((value) {
        value.docs.forEach((comm) {});
      });
    } catch (e) {
      // return CircularProgressIndicator();
    }
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
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

                      _documents.removeWhere((toRemoveDocument) =>
                          toRemoveDocument.id == document.id);

                      await FirebaseFirestore.instance
                          .collection('sessionContent')
                          .doc(currentUser.uid)
                          .collection('userSessionUploads')
                          .doc(document.id)
                          .delete();

                      _publishModal = false;

                      Timer.periodic(Duration(milliseconds: 400),
                          (Timer t) => setState(() {}));

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

  void _onSelected(int index) {
    UploadVariables.downloadIndex = index;

    setState(() {
      if (items.contains(index)) {
      } else {
        items.add(index);
      }
    });
  }

  void _selectDoc(BuildContext context, DocumentSnapshot document, int index) {
    print(_documents);
    SelectedDocuments.items.add(document.id);

    setState(() {
      if (GetSelectedCard.selectedCard.contains(index)) {
        GetSelectedCard.selectedCard.remove(index);
        selectedDocument.remove(document.id);
      } else {
        HapticFeedback.vibrate();
        UploadVariables.showSilverAppbar = false;
        GetSelectedCard.selectedCard.add(index);
        /*Add documents id*/
        selectedDocument.add(document.id);
        /*Add the videos selected*/
        UploadVideo.selectedVideo.add(itemsData[index]['vido']);
        /*add task for downloading*/
        downloadTasks.add(myTasks[index]);
      }
    });
  }

  void _tapDoc(BuildContext context, DocumentSnapshot document, int index) {
    print(document.id);
    setState(() {
      if (GetSelectedCard.selectedCard.isEmpty) {
        longPressTapped = false;
        UploadVariables.showSilverAppbar = true;
        /*clear the video list selected*/
        UploadVideo.selectedVideo.clear();
      } else if (GetSelectedCard.selectedCard.contains(index)) {
        GetSelectedCard.selectedCard.remove(index);
        selectedDocument.remove(document.id);
        /*remove the video selected*/
        UploadVideo.selectedVideo.remove(itemsData[index]['vido']);
        /*Remove task*/
        downloadTasks.remove(myTasks[index]);
      } else {
        GetSelectedCard.selectedCard.add(index);
        /*Add documents id*/
        selectedDocument.add(document.id);
        /*Add the videos selected*/
        UploadVideo.selectedVideo.add(itemsData[index]['vido']);
        /*add task for downloading*/
        downloadTasks.add(myTasks[index]);
      }
    });
  }

//Adding to playlist
  void _addListPlaylist() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PlaylistScreen()));
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

  _addListDelete() {
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
                      setState(() {
                        _publishModal = true;
                      });

                      try {
                        User? currentUser = FirebaseAuth.instance.currentUser;

                        for (int i = 0; i < selectedDocument.length; i++) {
                          _documents.removeWhere((toRemoveDocument) =>
                              toRemoveDocument.id == selectedDocument[i]);
                          FirebaseFirestore.instance
                              .collection('sessionContent')
                              .doc(currentUser!.uid)
                              .collection('userSessionUploads')
                              .doc(selectedDocument[i])
                              .delete()
                              .then((onValue) {});
                        }

                        setState(() {
                          _publishModal = false;
                        });
                        Timer.periodic(Duration(milliseconds: 400),
                            (Timer t) => setState(() {}));

                        Fluttertoast.showToast(
                            msg: kSdeletedsuuccessfully,
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: kBlackcolor,
                            textColor: kSsprogresscompleted);
                      } catch (e) {
                        setState(() {
                          _publishModal = false;
                        });
                        print(e);
                      }
                    }
                  })
                ]));
  }
//ToDo: This is getting the document items of the particular document that needs to be edited

  void editContentPost(
      BuildContext context, DocumentSnapshot document, int index) {
    UploadVariables.cThumbnail = itemsData[index]['tmb'];
    UploadVariables.cTitle = itemsData[index]['title'];
    UploadVariables.cDesc = itemsData[index]['desc'];
    UploadVariables.cVideo = itemsData[index]['vido'];
    UploadVariables.cDocumentId = document.id;
    UploadVariables.cVisibility = itemsData[index]['visi'];
    UploadVariables.cLimit = itemsData[index]['alimit'];
    UploadVariables.cAge = itemsData[index]['age'];

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditContentPost()));
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
