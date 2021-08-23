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

import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/classroom/contents/course_widget/add.dart';
import 'package:sparks/classroom/contents/course_widget/add_sections.dart';
import 'package:sparks/classroom/contents/course_widget/divider.dart';
import 'package:sparks/classroom/contents/course_widget/edit_lecture_video.dart';
import 'package:sparks/classroom/contents/course_widget/section_attachment_edit.dart';

import 'package:sparks/classroom/contents/course_widget/lecture_models.dart';
import 'package:sparks/classroom/contents/course_widget/section_icons.dart';
import 'package:sparks/classroom/contents/edit_appbar.dart';
import 'package:sparks/classroom/contents/live/courses.dart';

import 'package:sparks/classroom/contents/live/delete_dialog.dart';

import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:video_player/video_player.dart';

class SectionEdit extends StatefulWidget {
  final List<Section> currentSections;
  final Course currentLectures;
  final int currentIndexOfLectures;
  final String? lectureName;

  SectionEdit({
    required this.currentLectures,
    required this.currentIndexOfLectures,
    required this.currentSections,
    required this.lectureName,
  });

  @override
  _SectionEditState createState() => _SectionEditState(
        currentLectures: currentLectures,
        currentIndexOfLectures: currentIndexOfLectures,
        currentSections: currentSections,
      );
}

class _SectionEditState extends State<SectionEdit> {
  List<Section>? currentSections;
  Course? currentLectures;
  int? currentIndexOfLectures;

  _SectionEditState({
    this.currentLectures,
    this.currentIndexOfLectures,
    this.currentSections,
  });

  TextEditingController _controller = TextEditingController();
  ReceivePort _port = ReceivePort();
  bool checkController = false;

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

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
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

  var itemsData = [];

  List<_TaskInfo> myTasks = [];
  List<_ItemHolder> myItems = [];

  List<_TaskInfo> downloadTasks = [];

  late String _localPath;

  bool longPressTapped = false;
  var items = [];

  int currentIndex = 0; // index at the section to be edited

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.currentSections.length; i++) {
      myTasks.add(_TaskInfo(
          name: widget.currentSections[i].title,
          link: widget.currentSections[i].vido));

      myItems.add(
          _ItemHolder(name: widget.currentSections[i].title, task: myTasks[i]));
    }

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(50.0),
                margin: EdgeInsets.symmetric(vertical: 10),
                width: ScreenUtil().setWidth(200.0),
                child: Card(
                  elevation: 20.0,
                  child: Center(
                    child: Text(
                        'Lecture ${(currentIndexOfLectures! + 1).toString()}',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kFbColor,
                            fontSize: kTwentyTwo.sp,
                          ),
                        )),
                  ),
                ),
              ),
              AddingLectureSections(
                  title: kSAdd + " " + ' A Section  ',
                  add: () {
                    print(currentSections!.length);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddSectionEdit(
                            lectureCount: currentIndexOfLectures! + 1,
                            sectionCounts: currentSections!.length,
                            lectureName: widget.lectureName)));
                  }),
              checkController == false
                  ? Text('')
                  : Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kHorizontal, vertical: 15.0),
                          child: TextField(
                            maxLines: null,
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter Title',
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isUpdating
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Text(
                                        kUpdate,
                                        style: GoogleFonts.rajdhani(
                                            textStyle: TextStyle(
                                          color: kWhitecolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: kFontsize.sp,
                                        )),
                                      ),
                                      color: kFbColor,
                                      onPressed: _updateTitle,
                                    ),
                            ),
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    side: BorderSide(color: kFbColor)),
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
              ListView.builder(
                itemCount: currentSections!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int index) {
                  return buildSection(index: index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({required int index}) {
    return SingleChildScrollView(
      child: Container(
        //height:ScreenUtil().setHeight(150),

        child: Card(
            elevation: 20,
            child: Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Column(
                      children: <Widget>[
                        Text('Section ${index + 1}',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kFbColor,
                                fontSize: kTwentyTwo.sp,
                              ),
                            )),
                        Stack(alignment: Alignment.center, children: <Widget>[
                          Container(
                            //height:MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ShowUploadedVideo(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                      widget.currentSections[index].vido!),
                              looping: false,
                            ),
                          ),
                          Container(
                            //height:MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ButtonTheme(
                                //height: 50,
                                shape: CircleBorder(),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    child: GestureDetector(
                                        onTap: () {
                                          UploadVariables.videoUrlSelected =
                                              widget
                                                  .currentSections[index].vido;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayingVideos()));
                                        },
                                        child:
                                            Icon(Icons.play_arrow, size: 40)))),
                          )
                        ]),
                      ],
                    ),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(150),
                        minHeight: ScreenUtil().setHeight(10),
                      ),
                      child: ReadMoreText(
                        widget.currentSections[index].title!,
                        trimLines: 2,
                        colorClickableText: kFbColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' ...',
                        trimExpandedText: 'show les',
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kBlackcolor,
                            fontSize: kFontsize.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //ToDo:displaying the linear progress bar

                _buildActionForTask(myTasks[index]),

                myTasks[index].status == DownloadTaskStatus.running ||
                        myTasks[index].status == DownloadTaskStatus.paused
                    ? Container(
                        height: 4,
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              kSsprogresscompleted),
                          backgroundColor: kSsprogressbar,
                          value: myTasks[index].progress! / 100,
                        ),
                      )
                    : Divider(
                        color: Colors.transparent,
                        thickness: kThickness,
                      ),

                IntrinsicHeight(
                  child: Row(
                    //alignment: WrapAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /*displaying the icons for section editing*/

                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditLectureAttachment(
                                  currentSections: currentSections,
                                  currentLectures: currentLectures,
                                  currentIndexOfLectures:
                                      currentIndexOfLectures,
                                  sectionCount: 'Section ${index + 1}',
                                  sectionCountInt: index,
                                  attachment: widget.currentSections[index].at,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            widget.currentSections[index].at == ''
                                ? 'Add Attachment'
                                : 'Edit Attachment',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kStabcolor,
                                fontSize: kSlivevcrfonts2.sp,
                              ),
                            ),
                          )),
                      VerticalLine(),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditLectureVideo(
                                      currentSections: currentSections,
                                      currentLectures: currentLectures,
                                      currentIndexOfLectures:
                                          currentIndexOfLectures,
                                      sectionCount: 'Section ${index + 1}',
                                      sectionCountInt: index,
                                      video:
                                          widget.currentSections[index].vido),
                                ),
                              );
                            });
                          },
                          child: Text(
                            'Edit Video',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kStabcolor,
                                fontSize: kSlivevcrfonts2.sp,
                              ),
                            ),
                          )),
                      VerticalLine(),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              checkController = true;
                              currentIndex = index;
                              _controller.text =
                                  widget.currentSections[index].title!;
                            });
                          },
                          child: Text(
                            'Edit name',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kStabcolor,
                                fontSize: kSlivevcrfonts2.sp,
                              ),
                            ),
                          )),
                      VerticalLine(),
                      GestureDetector(
                          onTap: () {
                            delete(index: index);
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kStabcolor,
                                fontSize: kSlivevcrfonts2.sp,
                              ),
                            ),
                          )),
                      VerticalLine(),
                      GestureDetector(
                          onTap: () {
                            //UploadVariables.downloadVideoUrl = itemsData[index]['vido'];
                            _onSelected(index);

                            downloadTasks.add(myTasks[index]);
                            _addListDownload();
                          },
                          child: Text(
                            'Download',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kStabcolor,
                                fontSize: kSlivevcrfonts2.sp,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
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

    Course copyLectures = currentLectures!;
    Course editedLectures = Course();
    List<Section> globalEditedSections = [];

    for (int i = 0; i < copyLectures.lectures.length; i++) {
      Lecture editedLecture = Lecture();
      List<Section> editedSections = [];

      for (int j = 0; j < copyLectures.lectures[i].sections.length; j++) {
        if (!((i == widget.currentIndexOfLectures) && (j == index))) {
          // if not the section we want to delete (index) add the other sections
          // if not the current lecture that needs a section deleted
          // if both are false at the same time

          editedSections.add(copyLectures.lectures[i].sections[j]);
        }
      }

      if (editedSections.length != 0) {
        editedLecture.sections.addAll(editedSections);
        editedLectures.lectures.add(editedLecture);
        //editedLectures.lectures[i].sections.addAll(editedSections); // before

      }

      if (i == widget.currentIndexOfLectures) {
        globalEditedSections = editedSections;
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
                  DeleteDialog(oneDelete: () {
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
                              setState(() {
                                currentSections = globalEditedSections;
                              });

                              Navigator.pop(context, 'Done');
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

  download({int? index}) {}

  bool isUpdating = false;
/*updating the title of section*/
  void _updateTitle() async {
    setState(() {
      isUpdating = true;
    });

    // will use currentIndex
    User currentUser = FirebaseAuth.instance.currentUser!;

    Course copyLectures = currentLectures!;
    Course editedLectures = Course();
    List<Section> globalEditedSections = [];

    for (int i = 0; i < copyLectures.lectures.length; i++) {
      Lecture editedLecture = Lecture();
      List<Section> editedSections = [];

      for (int j = 0; j < copyLectures.lectures[i].sections.length; j++) {
        if ((i == widget.currentIndexOfLectures) && (j == currentIndex)) {
          copyLectures.lectures[i].sections[j].title = _controller.text;
          editedSections.add(copyLectures.lectures[i].sections[j]);
        } else {
          editedSections.add(copyLectures.lectures[i].sections[j]);
        }
      }

      if (editedSections.length != 0) {
        editedLecture.sections.addAll(editedSections);
        editedLectures.lectures.add(editedLecture);
        //editedLectures.lectures[i].sections.addAll(editedSections); // before

      }

      if (i == widget.currentIndexOfLectures) {
        globalEditedSections = editedSections;
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
          currentSections = globalEditedSections;
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
