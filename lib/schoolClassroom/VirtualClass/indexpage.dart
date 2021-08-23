
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/date_time_picker_widget2.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/VirtualClass/e_class.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/VirtualClass/CallPage.dart';
import 'package:sparks/schoolClassroom/VirtualClass/streaming_const.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/schoolPost/e-class-secondAppbar.dart';
import 'package:sparks/schoolClassroom/schoolPost/postSliverAppbarSearch.dart';
import 'package:sparks/schoolClassroom/studentFolder/searchE-class.dart';
import 'package:sparks/schoolClassroom/studentFolder/students_tab.dart';
enum SingingCharacter { Now, Schedule }
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
late String id;
  final _courseName = TextEditingController();
  final _topic = TextEditingController();
  final _items = TextEditingController();
  bool _publishModal = false;
  late int selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = kRadio_color;
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }
@override
  void initState() {
    // TODO: implement initState

    super.initState();
    selectedRadio = 1;
  }

  @override
  void dispose() {
    // dispose input controller
    _courseName.dispose();
    _topic.dispose();
    _items.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StuAppBar(),
      body:ModalProgressHUD(
        inAsyncCall: _publishModal,
        child: CustomScrollView(slivers: <Widget>[
          ActivityAppBer(
          activitiesColor: kTextColor,
          classColor: kStabcolor1,
          newsColor: kTextColor,
        ),
        EClassSliverAppBar(
          liveBgColor: klistnmber,
          liveColor: kWhitecolor,
          missedClassBgColor: Colors.transparent,
          missedClassColor: klistnmber,
          recordsBgColor: Colors.transparent,
          recordsColor: klistnmber,
          assessmentBgColor: Colors.transparent,
          assessmentColor: klistnmber,

        ),
        EClassSliverAppBarSearch(
          scheduleColor: kIconColor2,
          scheduledClassColor: klistnmber,
          attendedColor: klistnmber,
          searchTap: (){},
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Text(kClassWelcome,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                fontSize: kFontsize.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),

                child: Column(
                  children: [

                    FormTitle(title: kClassTopic2),

                    Row(
                      children: <Widget>[

                        Expanded(
                            child: TextField(
                              controller: _courseName,
                              autocorrect: true,
                              maxLength: 50,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                            ))
                      ],
                    ),
                    SizedBox(height: 30,),
                    FormTitle(title: kClassTopic3),
                    Row(
                      children: <Widget>[

                        Expanded(
                            child: TextField(
                              controller: _topic,
                              autocorrect: true,
                              maxLength: 100,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                            ))
                      ],
                    ),

                    SizedBox(height: 30,),
                    FormTitle(title: kClassTopic4),
                    Row(
                      children: <Widget>[

                        Expanded(
                            child: TextField(
                              controller: _items,
                              autocorrect: true,
                              maxLength: 200,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: (kMaincolor),
                              style: UploadVariables.uploadfontsize,
                              decoration: Constants.kTopicDecoration,
                            ))
                      ],
                    ),
                    SizedBox(height: 30,),
                    FormTitle(title: kEClassTime),

                    ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Radio(
                                value: 1,
                                groupValue: selectedRadio,
                                activeColor: kFbColor,
                                onChanged: (dynamic val) {
                                  setSelectedRadio(val);
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  setState(() {
                                    radioColor1 = kBlackcolor;
                                    radioColor2 = kRadio_color;
                                  });
                                },
                              ),
                              Text('Now',
                                style: GoogleFonts.rajdhani(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: radioColor1,
                                    fontSize: kFontsize.sp,
                                  ),
                                ),

                              ),
                            ],
                          ),
                          Row(
                              children: <Widget>[
                                Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  activeColor: kFbColor,
                                  onChanged: (dynamic val) {
                                    setSelectedRadio(val);
                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }


                                    setState(() {
                                      radioColor2 = kBlackcolor;
                                      radioColor1 = kRadio_color;
                                    });
                                    //open the calender


                                  },
                                ),
                                Text('Schedule',
                                  style: GoogleFonts.rajdhani(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: radioColor2,
                                      fontSize: kFontsize.sp,
                                    ),
                                  ),

                                ),
                              ])]),
                    selectedRadio == 2?DateTimePickerWidget2(title: '',):Text(''),
                    SizedBox(height: 30,),
                    selectedRadio == 2?
                    Btn(next: (){saveClass();}, title: 'Save Class', bgColor: kExpertColor)
                        :Btn(next: onJoin, title: 'Join', bgColor: kFbColor),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
        ]),
                ),
        ]),
      ));




  }

  Future<void> onJoin() async {

    if ((_courseName.text.isNotEmpty) || (_topic.text.isNotEmpty) || (_items.text.isNotEmpty)) {
      // Enter the video streaming page after permission is granted
      await _handleCameraAndMic();
      //save the scheduled eClass
      setState(() {
        _publishModal = true;
      });
      try{
        DocumentReference  docRef = FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses').doc();
        docRef.set({
          'schId':SchClassConstant.schDoc['schId'],
          'cn':_courseName.text,
          'tp':_topic.text,
          'items':_items.text,
          'sk':_courseName.text.substring(0,1).toUpperCase(),

          'tsn':SchClassConstant.schDoc['tc'],
          'tcId':SchClassConstant.schDoc['id'],
          'lv':SchClassConstant.schDoc['lv'],
          'cl':SchClassConstant.schDoc['cl'],
          'name':SchClassConstant.schDoc['name'],
          'act':true,
          'id':docRef.id,
          'ts':DateTime.now().toString(),
          'dd':Variables.selectedDate.toString(),
          'close':false,
          'ass':true,
          'mis':0,
          'att':0,
          'day':DateTime.now().day,
          'mth':DateTime.now().month,


        });
        //getting the docRef id of the eClass;
        id = docRef.id;
        videoId = docRef.id;
        setState(() {
          _publishModal = false;
        });
      }catch(e){
        setState(() {
          _publishModal = false;
        });
        SchClassConstant.displayToastError(title: kError);
      }
      // Enter the video streaming page
      await Navigator.push(context, MaterialPageRoute(builder: (context) => CallPage(
        channelName: channelName,
        role: role,
        id:id,
        topic:_topic.text,
        items: _items.text,
        courseName: _courseName.text,
      ),
        ),
      );


    }else{
      Fluttertoast.showToast(
          msg: 'Please fill out fields correcting',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

// Set permission
  Future<void> _handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
  }

  void saveClass() {
    //save the scheduled eClass
    setState(() {
      _publishModal = true;
    });
try{
    DocumentReference  docRef = FirebaseFirestore.instance.collection('savedClasses').doc(SchClassConstant.schDoc['schId']).collection('savedOnlineClasses').doc();
        docRef.set({
      'schId':SchClassConstant.schDoc['schId'],
      'cn':_courseName.text,
      'tp':_topic.text,
      'items':_items.text,
      'tsn':SchClassConstant.schDoc['tc'],
      'lv':SchClassConstant.schDoc['lv'],
      'cl':SchClassConstant.schDoc['cl'],
      'act':false,
      'tcId':SchClassConstant.schDoc['id'],
      'id':docRef.id,
          'name':SchClassConstant.schDoc['name'],
      'ass':true,
          'sk':_courseName.text.substring(0,1).toUpperCase(),
      'ts':DateTime.now().toString(),
      'dd':Variables.selectedDate.toString(),
       'close':false,
          'mis':0,
          'att':0,
          'day':DateTime.now().day,
          'mth':DateTime.now().month,


    }).then((value){
          setState(() {
            _publishModal = false;
          });

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentsEClasses(),),);
          SchClassConstant.displayToastCorrect(title: 'Saved successfully');
        });
  }catch(e){
  setState(() {
    _publishModal = false;
  });
  SchClassConstant.displayToastError(title: kError);
  }
  }
}


class FormTitle extends StatelessWidget {
  FormTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.rajdhani(
        textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: kBlackcolor,
        fontSize: kFontsize.sp,
    ),
    ));
  }
}
//786657280

//257793
//iva-kerluke