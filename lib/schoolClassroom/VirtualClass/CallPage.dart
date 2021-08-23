import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/schoolClassroom/VirtualClass/callpgeAppbar.dart';
import 'package:sparks/schoolClassroom/VirtualClass/cameraIcons.dart';
import 'package:sparks/schoolClassroom/VirtualClass/closeClass.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/VirtualClass/studentsInClass.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:wakelock/wakelock.dart';
class CallPage extends StatefulWidget {
  final String channelName;
  final String id;
  final ClientRole role;
  final String items;
  final String courseName;
  final String topic;
  CallPage({ required this.channelName, required this.role, required this.id, required this.items, required this.courseName, required this.topic});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
late StreamSubscription stream;


  String _platformVersion = 'Unknown';
  bool recording = false;


  @override
  void dispose() {

    super.dispose();
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    Wakelock.disable();
    timer.cancel();
    stream.cancel();
  }

  @override
  void initState() {

    super.initState();

    initialize();
    //_doRecording();
    initPlatformState();
    startTimeout();
    Wakelock.enable();
    getJoinedStudents();
  }




  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 1;
  late Timer timer;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds + currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds + currentSeconds) % 60).toString().padLeft(2, '0')}';
// get getClassPeriodTaken => '${((timerMaxSeconds + currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds + currentSeconds) % 60).toString().padLeft(2, '0')}';
  startTimeout([ int? milliseconds]) {
    var duration = interval;
   timer =  Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        //if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
   /* String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterScreenRecorder.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });*/
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    // Init the client instance
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions();
    await _engine.setVideoEncoderConfiguration(configuration);
    // Join channel
    await _engine.joinChannel(Token, widget.channelName, null, 0);
  }

  /// Create client instance
  Future<void> _initAgoraRtcEngine() async {
    RtcEngineConfig config = RtcEngineConfig(APP_ID);
    _engine = await RtcEngine.createWithConfig(config);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Event handling
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }


  /// Video view wrapper
  Widget _videoView(view){
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)
          ),
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)
            ),
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)
            ),
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)
            ),
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Boxes(iconWidgets: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? kRed : kWhitecolor,
            size: 20.0,
          ),
          iconWidgetsTapped: _onToggleMute,
          ),

          !recording
              ? Boxes(iconWidgets:Icon(
            Icons.video_call,
            color: Colors.white,
            size: 20.0,
          ),
            iconWidgetsTapped: () {_doRecording();},
          ):
          Boxes(iconWidgets:Icon(
            Icons.video_call,
            color: kRed,
            size: 20.0,
          ),
            iconWidgetsTapped: () {_stopDoingRecording();},
          ),

          Boxes(iconWidgets:Icon(
            Icons.call_end,
            color: kRed,
            size: 20.0,
          ),
            iconWidgetsTapped: () => _onCallEnd(context),
          ),

          Boxes(iconWidgets:Icon(
            Icons.switch_camera,
            color: kWhitecolor,
            size: 20.0,
          ),
            iconWidgetsTapped: _onSwitchCamera,
          ),

          Boxes(iconWidgets:Badge(
            toAnimate: false,

            padding: EdgeInsets.all(4.0),
            badgeContent: Text(attendantCount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            badgeColor: kRed,
            position: BadgePosition.bottomEnd(bottom: -12, end: -14),
            child: Icon(
              Icons.switch_camera,
              color: kWhitecolor,
              size: 20.0,
            ),
          ),
            iconWidgetsTapped:(){
              showBottomSheet(
                  backgroundColor: kBlackcolor.withOpacity(0.5),
                  context: context,

                  builder: (context) =>StudentsInClass());
            },
          ),


        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {

    if(isTeacher){
      getClassPeriodTaken = timerText;
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>CloseClass());

    }else{
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>CloseClass());

    }

  }


  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackcolor,
        appBar: CallPageAppBar(courseName: widget.courseName,timer: timerText,topic: widget.topic,),

        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: Stack(

            children: <Widget>[
              _viewRows(),
              //_panel(),
              _toolbar(),

              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CameraIcons()),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(joinedName,
                  style: GoogleFonts.rajdhani(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kMaincolor,
                      fontSize: kFontsize.sp,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void getJoinedStudents() {
    stream = FirebaseFirestore.instance.collection("joinedClassName").doc(videoId).snapshots()
        .listen((result) {

      if(result.exists){
        setState(() {
          joinedName = '${result.data()!['fn']} ${result.data()!['join']}';
        });

        Future.delayed(const Duration(seconds: 5), () async {
          setState(() {
            joinedName = '';
          });
        });
      }else {
        setState(() {
          joinedName = '';
        });
      }});}

  Future<void> _doRecording() async {
    /*setState(() {
      //changing the status bar color
      stColor = kBlackcolor;
    });
    //bool start = false;
    //await Future.delayed(const Duration(milliseconds: 1000));
    final result = await FlutterScreenRecorder.startRecording();
    print('ooooooooooooo$result');
    setState(() => recording = !recording);*/

    //return start;
  }

  _stopDoingRecording() async {
   /* final result = await FlutterScreenRecorder.stopRecording();
    print('yyyyyyyyyyyyyy$result');
    setState(() {
      recording = !recording;
    });
    print("Opening video");


  }*/
}}



class Boxes extends StatelessWidget {
  Boxes({required this.iconWidgets,required this.iconWidgetsTapped,});
  final Widget iconWidgets;
  final Function iconWidgetsTapped;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: iconWidgetsTapped as void Function(),
      child: Container(
      height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          color: kBlackcolor
        ),
        child:Center(child: iconWidgets) ,
      ),
    );
  }
}
