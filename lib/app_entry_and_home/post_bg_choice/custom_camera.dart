import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/camera-button.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/rounded_button.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/switch_icon.dart';
import 'package:sparks/app_entry_and_home/post_bg_choice/thumbnail_widget.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class CustomCamera extends StatefulWidget {
  @override
  _CustomCameraState createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? cameraController;
  TabController? tabController;
  String? videoPath;
  VoidCallback? videoPlayerListener;
  String? imagePath;
  late List<CameraDescription> cameras;
  bool isPermitted = false;
  bool isPictureMode = true;
  bool hasStartedRecording = false;
  Stopwatch watch = new Stopwatch();
  Timer? timer;
  bool startStop = true;
  String elapsedTime = '';
  late int startTime1;
  int i1 = 0;
  double seconds1 = 0;
  double minutes1 = 0;
  VideoPlayerController? _videoPlayerController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future oldGetCameras() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future getCameras() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController!.initialize().then((_) {
      setState(() {
        isPermitted = true;
      });
    });
  }

  //TODO: This function makes the camera selected by the user the active one.
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    cameraController!.addListener(() {
      if (mounted) setState(() {});
      if (cameraController!.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController!.value.errorDescription}');
      }
    });

    try {
      await cameraController!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //TODO: This function returns a picture from the selected camera.
  Future<String?> takePicture({bool video = false}) async {
    if (!cameraController!.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    Directory extDir;
    extDir = await getTemporaryDirectory();

    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    int seconds = DateTime.now().second;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await cameraController!
          .takePicture(); // await cameraController.takePicture(filePath)
    } on CameraException catch (e) {
      //_showCameraException(e); ......
      return null;
    }
    int after = DateTime.now().second;
    print("Time taken in ${after - seconds}seconds");

    //TODO: Store the image taken in a file
    File cFile = File(filePath);
    setState(() {
      GlobalVariables.imageFromCamera = cFile; // holds the image/video file
      GlobalVariables.cameraImageOrVideo =
          filePath; // holds the string representation of the image/video file
    });

    cameraController!.dispose();

    if (!video)
      setState(() {
        imagePath = filePath;
      });
    else {
      imagePath = filePath;
    }

    Navigator.pop(context, {"MainFile": cFile, "AbsoluteFilePath": filePath});

    return filePath;
  }

  //TODO: Handles camera exception
  void _showCameraException(CameraException e) {
    print(e.code + e.description!);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  //TODO: Displays custom buttons on the bottom of the navigation bar inside camera preview. To be implemented soon
  Widget getOptionsWidget() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        leading: CloseButton(),
        actions: <Widget>[
          /*IconButton(
              icon: Icon(Icons.flash_off),
              onPressed: () {
                showInSnackBar("Flash not implemented yet");
              }),
          IconButton(
              icon: Icon(Icons.brightness_2),
              onPressed: () {
                showInSnackBar("Feature not implemented");
              }),*/
        ],
      ),
      bottomNavigationBar: getCameraButtonRow(),
    );
  }

  Widget _cameraPreviewWidgetPrevious() {
    final size = MediaQuery.of(context).size;
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Transform.scale(
        scale: cameraController!.value.aspectRatio / size.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
        ),
      );
    }
  }

  //TODO: This is displayed when a camera is not selected/activated
  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Transform.scale(
        scale: (cameraController!.value.aspectRatio / size.aspectRatio),
        child: Center(
          child: AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
        ),
      );
    }
  }

  //TODO: This function generates a thumbnail
  Widget _getThumbnail() {
    return ThumbnailWidget(
      imagePath: imagePath,
      size: 36.0,
    );
  }

  //TODO: This function helps the user to switch camera. Eg From front camera to back camera
  Widget _getCameraSwitch() {
    return SwitchIcon(
      size: 24.0,
      onTap: () {
        if (cameraController != null &&
            !cameraController!.value.isRecordingVideo) {
          CameraLensDirection direction =
              cameraController!.description.lensDirection;
          CameraLensDirection required = direction == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front;
          for (CameraDescription cameraDescription in cameras) {
            if (cameraDescription.lensDirection == required) {
              onNewCameraSelected(cameraDescription);
              return;
            }
          }
        }
      },
    );
  }

  Widget getCameraButtonRow() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        isPictureMode
            ? CameraButton(takePicture: takePicture)
            : IconButton(
                iconSize: 64,
                icon: (cameraController != null && !hasStartedRecording) ||
                        !cameraController!.value.isRecordingPaused
                    ? Icon(Icons.play_arrow, color: Colors.deepOrangeAccent)
                    : Icon(Icons.pause, color: Colors.deepOrangeAccent),
                color: Colors.blue,
                onPressed: () {
                  if (cameraController != null &&
                      cameraController!.value.isInitialized &&
                      !hasStartedRecording) {
                    startOrStop();
                    onVideoRecordButtonPressed();

                    setState(() {
                      timer1();
                      hasStartedRecording = true;
                    });
                  } else if (cameraController != null &&
                      cameraController!.value.isInitialized &&
                      cameraController!.value.isRecordingVideo) {
                    if (cameraController!.value.isRecordingPaused) {
                      startOrStop();
                      onResumeButtonPressed();
                    } else {
                      startOrStop();
                      onPauseButtonPressed();
                    }
                  }
                }),
        !isPictureMode && hasStartedRecording
            ? Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Text(
                        elapsedTime, // '00:00'
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      ),
                      SizedBox(height: 20.0),
                      IconButton(
                          iconSize: 64,
                          icon: const Icon(Icons.stop),
                          color: Colors.red,
                          onPressed: () {
                            if (cameraController != null &&
                                cameraController!.value.isInitialized &&
                                cameraController!.value.isRecordingVideo) {
                              stopWatch();
                              onStopButtonPressed();
                            }
                          }),
                    ],
                  ),
                ],
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //_getThumbnail(),
              Expanded(
                child: Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(
                        text: "Camera",
                      ),
                      Tab(
                        text: "Video",
                      ),
                    ],
                    indicatorColor: Colors.red,
                    indicatorWeight: 3.0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: tabController,
                    onTap: (index) {
                      if (index == 0) {
                        setState(() {
                          isPictureMode = true;
                        });
                        //showInSnackBar("Sorry video not supported yet.");
                      } else if (index == 1) {
                        setState(() {
                          isPictureMode = false;
                        });
                      }
                    },
                  ),
                ),
              ),
              _getCameraSwitch()
            ],
          ),
        ),
      ],
    );
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside = $startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  startOrStop() {
    print("bool startstop = $startStop");
    if (startStop == true) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void timer1() {
    Timer.periodic(Duration(microseconds: 1000), (_) {
      if (i1 == 0) {
        startTime1 = DateTime.now().millisecondsSinceEpoch;
      }

      i1++;

      int millis = DateTime.now().millisecondsSinceEpoch - startTime1 + 1;
      seconds1 = millis / 1000;

      setState(() {
        minutes1 = seconds1 / 60;
        seconds1 = seconds1 % 60;
      });
    }).cancel();
  }

  //TODO: Starts to record a video when the video button is clicked
  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String? filePath) {
      if (mounted)
        setState(() {
          print("Starting recording");
        });
      if (filePath != null) {
        showInSnackBar('Saving video to $filePath');
      }
    });
  }

  //TODO: Stops video recording
  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted)
        setState(() {
          print("stop recording");
        });

      File videoFile = File(videoPath!);

      _videoPlayerController = VideoPlayerController.file(
        videoFile,
      );

      _videoPlayerController!.addListener(() {
        if (_videoPlayerController!.value.isInitialized) {
          /* Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
              StoryCreateScreen(isVideo: true, videoPath: videoPath,
                  duration: _videoPlayerController.value.duration.inSeconds.toString())));*/
        }
      });

      _videoPlayerController!.initialize();
      Navigator.pop(
          context, {"MainFile": videoFile, "AbsoluteFilePath": videoPath});

      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  //TODO: Display the thumbnail of the captured image or video.
  Widget _localThumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _videoPlayerController == null && imagePath == null
                ? Container()
                : SizedBox(
                    child: (_videoPlayerController == null)
                        ? Image.file(File(imagePath!))
                        : Container(
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.size != null
                                          ? _videoPlayerController!
                                              .value.aspectRatio
                                          : 1.0,
                                  child: VideoPlayer(_videoPlayerController!)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.pink)),
                          ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  //TODO: Starts the recording of a video
  Future<String?> startVideoRecording() async {
    if (!cameraController!.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await cameraController!
          .startVideoRecording(); //await cameraController.startVideoRecording(filePath)
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  //TODO: Stops the recording
  Future<void> stopVideoRecording() async {
    if (!cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController!.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    //await _startVideoPlayer();
  }

  //TODO: Pause video recording
  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  //TODO: Resume recording if paused.
  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  //TODO: This function puts a video recording in pause mode/state
  Future<void> pauseVideoRecording() async {
    if (!cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController!.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  //TODO: This function resumes a video recording in pause mode/state
  Future<void> resumeVideoRecording() async {
    if (!cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController!.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  //TODO: request for permission
  Future<Map<Permission, PermissionStatus>> requestForPermission() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone
    ].request();

    return permissions;
  }

  //TODO: Grant the following permission
  Future getPermissions() async {
    Map<Permission, PermissionStatus> permissions =
        await requestForPermission();

    if (permissions[Permission.storage] == PermissionStatus.granted &&
        permissions[Permission.camera] == PermissionStatus.granted &&
        permissions[Permission.microphone] == PermissionStatus.granted) {
      setState(() {
        isPermitted = true;
      });
      await getCameras();
    } else {
      await requestForPermission();
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance!.addObserver(this);

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    WidgetsBinding.instance!.removeObserver(this);
    cameraController!.dispose();
    //timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ///https://github.com/flutter/flutter/issues/39109
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        onNewCameraSelected(cameraController!.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: !isPermitted
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Camera Permission Not Given",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: RoundedButton(
                      "Give Permissions",
                      onTap: () {
                        getPermissions();
                      },
                    ),
                  )
                ],
              )
            : Stack(
                children: <Widget>[
                  _cameraPreviewWidget(),
                  getOptionsWidget(),
                ],
              ),
      ),
    );
  }
}
