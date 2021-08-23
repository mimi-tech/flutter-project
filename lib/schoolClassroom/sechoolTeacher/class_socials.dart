import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/Course_message.dart';
import 'package:sparks/classroom/courses/course_appbar.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/expert_class/expert_constants/expert_variables.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/teachers_bottom.dart';
import 'package:sparks/schoolClassroom/sechoolTeacher/upload_lessons.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/course_promotion_indicator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class SocialClasses extends StatefulWidget {
  @override
  _SocialClassesState createState() => _SocialClassesState();
}

class _SocialClassesState extends State<SocialClasses> {
  String get filePaths => 'lessons/${DateTime.now()}';

  bool videoSuccess = false;

  Widget space() {
    return
      SizedBox(height: MediaQuery
          .of(context)
          .size
          .height * 0.05,);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
selectedRadio = 1;

  }

  String? video;
  String? thumbnail;
  String? note;
  File? videoUrl;

  File? imageNote;
  String get fileImagePaths => 'teachersThumbnail/${DateTime.now()}';
  String get videoPaths => 'teachersVideo/${DateTime.now()}';
  String get notePaths => 'teachersNote/${DateTime.now()}';
  Future getVideo() async {

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.video,
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    String _path = file.path;
    // String _path = file.toString();

    String fileName = _path.split('/').last;

    int fileSize = file.lengthSync();
    if (fileSize <= kSVideoSize) {
      setState(() {
        videoUrl = file;
        videoSuccess = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }




  /*for the video thumbnail*/

  File? imageURI;

  Future getImageFromGallery() async {
    File file;
    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.image,
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    //ToDo: send to fireBase storage
    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageURI = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }


  //getting class note



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title =  TextEditingController();
  TextEditingController _section =  TextEditingController();
  bool progress = false;
 late UploadTask uploadTask;


  int? selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = klistnmber;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

      body: ModalProgressHUD(
          inAsyncCall: progress,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(kExtraClassText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: klistnmber,
                          fontSize:kFontsize.sp,
                        ),
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    RaisedButton(
                      color: videoUrl == null?kOfflineColor:klistnmber,
                      disabledColor: kBlackcolor,
                      autofocus: true,
                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getVideo();
                        },
                      child: Text(videoUrl == null?kUploadText4:'Edit Video',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
                              fontSize:kFontsize.sp,
                            ),
                          )
                      ),
                    ),
                    RaisedButton(
                      color: imageURI == null?kOfflineColor:klistnmber,
                      disabledColor: kBlackcolor,
                      autofocus: true,
                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getImageFromGallery();},
                      child: Text(imageURI == null?kSchoolUpload1:'Edit thumbnail',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
                              fontSize:kFontsize.sp,
                            ),
                          )
                      ),
                    ),

                  ],
                ),


        videoUrl == null?Text(''):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space(),
            videoUrl == null?UploadText(title:kUploadText): ShowPickedFiles(title: 'Video',titleText: videoUrl.toString(),),
            space(),

            imageURI == null?UploadText(title:kUploadText1): ShowPickedFiles(title: 'Thumbnail',titleText: imageURI.toString(),),
            space(),


                ]),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      FadeHeading(title: 'Extra curricular class title',),

                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextFormField(
                          controller: _title,
                          maxLength: 100,
                          maxLines: null,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            Constants.kSCourseLectureTitle = value;
                          },
                          onChanged: (String value) {
                            Constants.kSCourseLectureTitle = value;
                          },
                          validator: Validator.validateTitle,

                        ),
                      ),

                      FadeHeading(title: 'Extra curricular description',),

                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: TextFormField(
                          controller: _section,
                          maxLength: 100,
                          maxLines: null,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            Constants.kSCourseLectureSections = value;
                          },
                          onChanged: (String value) {
                            Constants.kSCourseLectureSections = value;
                          },
                          validator: Validator.validateDesc,

                        ),
                      ),



                    ],
                  ),
                ),

                space(),

                FadeHeading(
                  title: kSchoolStudent7,
                ),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: selectedRadio,
                            activeColor: kBlackcolor,
                            onChanged: (dynamic val) {
                              setSelectedRadio(val);

                              setState(() {
                                radioColor1 = kBlackcolor;
                                radioColor2 = klistnmber;
                              });
                            },
                          ),
                          Text('Yes',
                            style: GoogleFonts.rajdhani(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: radioColor1,
                                fontSize:kFontsize.sp,
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
                              activeColor: kBlackcolor,
                              onChanged: (dynamic val) {
                                setSelectedRadio(val);

                                setState(() {
                                  radioColor2 = kBlackcolor;
                                  radioColor1 = klistnmber;
                                });

                              },
                            ),
                            Text('No',
                              style: GoogleFonts.rajdhani(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: radioColor2,
                                  fontSize:kFontsize.sp,
                                ),
                              ),

                            ),
                          ])]),

                videoUrl == null ? Text(''): Container(

                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      imageURI == null ?Center(
                        child: ShowUploadedVideo(
                          videoPlayerController: VideoPlayerController.file(videoUrl!),
                          looping: false,
                        ),
                      )

                      /* Center(
                            child: ButtonTheme(
                              shape: CircleBorder(),
                              height: ScreenUtil().setHeight(100),
                              child: RaisedButton(
                                  color: Colors.transparent,
                                  textColor: Colors.white,
                                  onPressed: () {getVideo();},
                                  child: Icon(Icons.play_arrow, size: 40)),
                            )),*/



                          :Image.file(imageURI!,
                        fit: BoxFit.cover,
                        width:MediaQuery.of(context).size.width,
                        //height: ScreenUtil().setHeight(80),
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
                                        UploadVariables.videoFileSelected = videoUrl;
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayingFileVideos()));
                                      },
                                      child: Icon(Icons.play_arrow, size: 40)))))

                    ],
                  ),


                ),
                ///Next button
                SizedBox(height: MediaQuery.of(context).size.width * 0.15,),

                Btn(next: (){ nextScreen();},bgColor: kFbColor,title: 'Upload',),

                SizedBox(height: ScreenUtil().setHeight(10)),



              ],
            ),
          ),


        ),
      ),
    );
  }



  Future<void> nextScreen() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      try{
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          progress = true;
        });

        if (videoUrl != null){
          //upload video
          //upload video
          Reference ref = FirebaseStorage.instance.ref().child(videoPaths);
          uploadTask = ref.putFile(
            videoUrl!,
            SettableMetadata(
              contentType: 'video.mp3',
            ),
          );

          final TaskSnapshot downloadUrl = (await uploadTask);
          video = (await downloadUrl.ref.getDownloadURL());

          //check if thumbnail was selected

          if (imageURI != null) {
            Reference ref =
            FirebaseStorage.instance.ref().child(fileImagePaths);
            Constants.courseThumbnail = ref.putFile(
              imageURI!,
              SettableMetadata(
                contentType: 'images.jpg',
              ),
            );

            final TaskSnapshot downloadUrl = (await Constants.courseThumbnail!);
            thumbnail = (await downloadUrl.ref.getDownloadURL());
          }




          putToDatabase();





        }else{
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title:'Please upload your social video');
        }
      }catch(e){
        setState(() {
          progress = false;
        });
        SchClassConstant.displayToastError(title:kError);

      }
    }
  }

  void putToDatabase(){
    var sk = _title.text.substring(0,1).toUpperCase();
    DocumentReference docRefs =  FirebaseFirestore.instance.collection('socialClass').doc(SchClassConstant.schDoc['schId']).collection('schoolSocials').doc();


    docRefs.set({
      'tfn':SchClassConstant.schDoc['tc'],
      'sn':SchClassConstant.schDoc['name'],
      'schId':SchClassConstant.schDoc['schId'],
      'tsId':SchClassConstant.schDoc['pin'],
      'tId':SchClassConstant.schDoc['id'],
      'tsl':SchClassConstant.schDoc['lv'],
      'tcl':SchClassConstant.isLecturer?SchClassConstant.schDoc['dept']:SchClassConstant.schDoc['class'],
      'tsn':'${GlobalVariables.loggedInUserObject.nm!['fn']} ${GlobalVariables.loggedInUserObject.nm!['ln']}',
      'curs':SchClassConstant.isLecturer?SchClassConstant.schDoc['curs']:'',
      'sk':sk,
      'tmb':thumbnail,
      'title':_title.text.trim(),
      'desc':_section.text.trim(),
      'vid':video,
      'ts':DateTime.now().toString(),
      'like':0,
      'comm':0,
      'view':0,
      'down':0,
      'id':docRefs.id,
      'ass':selectedRadio == 1?true:false,


    });
    teacherIsUploadingLesson(SchClassConstant.schDoc);
    SchClassConstant.displayBotToastCorrect(title:'Uploaded successfully');

    setState(() {
      progress = false;
    });

  }


  void teacherIsUploadingLesson(DocumentSnapshot doc) {

    //tell the management that this teacher has uploaded an extra curricula lesson
    if(SchClassConstant.isLecturer){
      ///if this is a campus teacher

      FirebaseFirestore.instance.collection('schoolTutors')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('tutors')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic ec = value.data()!['ec'] == null?0:value.data()!['ec'];
        dynamic ed =  value.data()!['ed'] == null?0:value.data()!['ed'];
        dynamic ew =  value.data()!['ew'] == null?0:value.data()!['ew'];
        dynamic  em =  value.data()!['em'] == null?0:value.data()!['em'];
        dynamic ey =  value.data()!['ey'] == null?0:value.data()!['ey'];


        FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
          'ec':ec + 1,
          'ed': value.data()!['wky'] == Jiffy().week?ew + 1:1,
          'em':value.data()!['mth'] == DateTime.now().month?em + 1:1,
          'ey':value.data()!['yr'] == DateTime.now().year?ey + 1:1,
          'lot':DateTime.now().toString(),
          'eyr':DateTime.now().year,
          'emth':DateTime.now().month,
          'eday':DateTime.now().day,
          'ewky':Jiffy().week,

        },SetOptions(merge:  true));


        campusTeacherAnalysis(doc);


      });




    }else{
      ///if this is a high school teacher

      FirebaseFirestore.instance.collection('teachers')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('schoolTeachers')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic ec = value.data()!['ec'] == null?0:value.data()!['ec'];
        dynamic ed =  value.data()!['ed'] == null?0:value.data()!['ed'];
        dynamic ew =  value.data()!['ew'] == null?0:value.data()!['ew'];
        dynamic  em =  value.data()!['em'] == null?0:value.data()!['em'];
        dynamic ey =  value.data()!['ey'] == null?0:value.data()!['ey'];



        FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
          'uc':ec + 1,
          'ud': value.data()!['day'] == DateTime.now().day?ed + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?ew + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?em + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?ey + 1:1,
          'eyr':DateTime.now().year,
          'emth':DateTime.now().month,
          'eday':DateTime.now().day,
          'ewky':Jiffy().week,

        },SetOptions(merge:  true));

        campusTeacherAnalysis(doc);
      });


    }

  }






  Future<void> campusTeacherAnalysis(DocumentSnapshot doc) async {
    ///Daily Analysis
    final snapShot = await FirebaseFirestore.instance.collection('campusAnalysisDaily')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('daily').doc('${DateTime.now().day}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
        .get();

    if (snapShot == null || !snapShot.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisDaily')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('daily')
          .doc('${DateTime.now().day}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .set({

        'ts':DateTime.now().toString(),
        'ec':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],

      },SetOptions(merge:  true));


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisDaily')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('daily')
          .doc('${DateTime.now().day}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('dailyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])

          .get().then((resultData) {
        resultData.reference.set({
          'ec': resultData.data()!['ec'] == null?1:resultData.data()!['ec'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],

        },SetOptions(merge: true));
      });
    }

    ///Weekly Analysis


    final snapShotWeekly = await FirebaseFirestore.instance.collection('campusAnalysisWeekly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('weekly').doc('${Jiffy().week}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();

    if (snapShotWeekly == null || !snapShotWeekly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisWeekly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('weekly').doc('${Jiffy().week}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id']) .set({


        'ec':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'wk':Jiffy().week,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
      },SetOptions(merge:  true));


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisWeekly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('weekly').doc('${Jiffy().week}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('weeklyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .get().then((resultData) {
        resultData.reference.set({
          'ec': resultData.data()!['ec'] == null?1:resultData.data()!['ec'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });

    }

    ///Monthly analysis

    final snapShotMonthly = await FirebaseFirestore.instance.collection('campusAnalysisMonthly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('monthly').doc('${DateTime.now().month}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id']).get();

    if (snapShotMonthly == null || !snapShotMonthly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisMonthly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('monthly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id']) .set({
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'mth':DateTime.now().month,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'ec':1
      });


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisMonthly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('monthly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('monthlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])
          .get().then((resultData) {
        resultData.reference.set({
          'ec': resultData.data()!['ec'] == null?1:resultData.data()!['ec'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }




    ///Yearly analysis

    final snapShotYearly = await FirebaseFirestore.instance.collection('campusAnalysisYearly')
        .doc('${DateTime.now().year}')
        .collection('periods')
        .doc('${DateTime.now().month}')
        .collection('yearly').doc('${DateTime.now().month}')
        .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
        .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])        .get();

    if (snapShotYearly == null || !snapShotYearly.exists) {

      FirebaseFirestore.instance.collection('campusAnalysisYearly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('yearly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .set({

        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],

        'ec':1
      });


    }else{
      FirebaseFirestore.instance.collection('campusAnalysisYearly')
          .doc('${DateTime.now().year}')
          .collection('periods')
          .doc('${DateTime.now().month}')
          .collection('yearly').doc('${DateTime.now().month}')
          .collection('schoolAnalysis').doc(SchClassConstant.schDoc['schId'])
          .collection('yearlyTeachersAnalysis').doc(SchClassConstant.schDoc['id'])          .get().then((resultData) {
        resultData.reference.set({
          'ec': resultData.data()!['ec'] == null?1:resultData.data()!['ec'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }



  }
}