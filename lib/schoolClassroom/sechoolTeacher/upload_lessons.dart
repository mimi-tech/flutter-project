import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:readmore/readmore.dart';
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
import 'package:sparks/classroom/uploadvideo/widgets/showuploadedvideo.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
class TeachersUpload extends StatefulWidget {
  @override
  _TeachersUploadState createState() => _TeachersUploadState();
}

class _TeachersUploadState extends State<TeachersUpload> {
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
  String? slides;
  String? srt;


  Future getVideo() async {

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.video,
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    String _path = file.path;
    // String _path = file.toString();

    String fileName = _path.split('/').last;

    //ToDo: send to fireBase storage
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
    // File file = await FilePicker.getFile(
    //   type: FileType.image,
    // );

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

  File? imageNote;
  String get fileImagePaths => 'teachersThumbnail/${DateTime.now()}';
  String get videoPaths => 'teachersVideo/${DateTime.now()}';
  String get notePaths => 'teachersNote/${DateTime.now()}';
  String get slidePaths => 'teachersSlide/${DateTime.now()}';
  String get srtPaths => 'srtNote/${DateTime.now()}';
  Future getNote() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageNote = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  ///for slide

  File? imageSlide;

  Future getSlideFromGallery() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['ppt'],
    // );

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["ppt"]) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    //ToDo: send to fireBase storage
    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageSlide = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  ///for srt

  File? imageSrt;

  Future getSrtFromGallery() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.custom,
    //   allowedExtensions: ['srt'],
    // );

    File file;

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["srt"],
    ) as Future<FilePickerResult>);

    file = File(result.files.single.path!);

    //ToDo: send to fireBase storage
    int fileSize = file.lengthSync();
    if (fileSize <= kSFileSize) {
      setState(() {
        imageSrt = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _section = TextEditingController();
  bool progress = false;
  late UploadTask uploadTask;

  int? selectedRadio;
  Color radioColor1 = kBlackcolor;
  Color radioColor2 = klistnmber;

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ModalProgressHUD(
          inAsyncCall: progress,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(kSchoolUpload3,
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
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 5.0,

                  children: [
                    RaisedButton(
                      color: videoUrl == null?kOfflineColor:klistnmber,

                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getVideo();
                        },
                      child: Text(videoUrl == null?kSchoolUpload4:'Edit video',
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
                             fontSize: kFontsize.sp,
                            ),
                          )
                      ),
                    ),
                    RaisedButton(
                      color: imageNote == null?kOfflineColor:klistnmber,

                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getNote();},
                      child: Text(imageNote == null?kSchoolUpload2:'Edit note',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
                             fontSize: kFontsize.sp,
                            ),
                          )
                      ),
                    ),
                    RaisedButton(
                      color: imageSlide == null?kOfflineColor:klistnmber,
                      disabledColor: kBlackcolor,
                      autofocus: true,
                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getSlideFromGallery();},
                      child: Text(imageSlide == null?'Add slide':'Edit slide',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
                             fontSize: kFontsize.sp,
                            ),
                          )
                      ),
                    ),


                    ///Adding srt

                    RaisedButton(
                      color: imageSrt == null?kOfflineColor:klistnmber,
                      disabledColor: kBlackcolor,
                      autofocus: true,
                      onPressed: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        getSrtFromGallery();},
                      child: Text(imageSrt == null?'Add srt':'Edit srt',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kWhitecolor,
                             fontSize: kFontsize.sp,
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

                    imageNote == null?UploadText(title:kUploadText2): ShowPickedFiles(title: 'Note',titleText: imageNote.toString(),),
                    space(),

                    imageSlide == null?UploadText(title:kUploadText4): ShowPickedFiles(title: 'Slide',titleText: imageSlide.toString(),),
                    space(),

                    imageSrt == null?UploadText(title:kUploadText3): ShowPickedFiles(title: 'Video srt',titleText: imageSrt.toString(),),

                  ],
                ),

                ///Adding slide




                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      FadeHeading(title: 'lecture title',),

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

                      FadeHeading(title: 'lecture description',),

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
                                  fontSize: kFontsize.sp,
                                ),
                              ),

                            ),
                          ])]),

                videoUrl == null ? Text(''): Container(
                  //width:MediaQuery.of(context).size.width,

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
                          ))*/



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
       print('bbbbbbbbbbbb');
       Reference ref =
       FirebaseStorage.instance.ref().child(fileImagePaths);
       Constants.courseThumbnail = ref.putFile(
         imageURI!,
         SettableMetadata(
           contentType: 'images.jpg',
         ),
       );

       final TaskSnapshot downloadUrl = await Constants.courseThumbnail!;
       thumbnail = await downloadUrl.ref.getDownloadURL();
     }

     if (imageSlide != null) {
       print('bbbbbbbbbbbb');
       Reference ref = FirebaseStorage.instance.ref().child(slidePaths);
       Constants.courseThumbnail = ref.putFile(
         imageSlide!,
         SettableMetadata(
           contentType: 'slides.ppt',
         ),
       );

       final TaskSnapshot downloadUrl = await Constants.courseThumbnail!;
       slides = await downloadUrl.ref.getDownloadURL();
     }

     if (imageSrt != null) {
       Reference ref = FirebaseStorage.instance.ref().child(srtPaths);
       Constants.courseThumbnail = ref.putFile(
         imageSrt!,
         SettableMetadata(
           contentType: 'srt.ppt',
         ),
       );

       final TaskSnapshot downloadUrl = await Constants.courseThumbnail!;
       srt = await downloadUrl.ref.getDownloadURL();
     }

     //check if note was selected
     if (imageNote != null) {
       print('yyyyy$imageNote');
       //upload note
       Reference ref = FirebaseStorage.instance.ref().child(notePaths);
       uploadTask = ref.putFile(
         imageNote!,
         SettableMetadata(
           contentType: 'note.pdf',
         ),
       );

       final TaskSnapshot downloadUrl = await uploadTask;
       note = await downloadUrl.ref.getDownloadURL();
     }

        putToDatabase();





    }else{
      setState(() {
        progress = false;
      });
      SchClassConstant.displayToastError(title:'Please upload your lectures video');
    }
  }catch(e){
  print('tttt$e');
  setState(() {
    progress = false;
  });
  SchClassConstant.displayToastError(title:kError);

}
  }
}

void putToDatabase(){
 var sk = _title.text.substring(0,1).toUpperCase();
  DocumentReference docRefs =  FirebaseFirestore.instance.collection('lesson').doc(SchClassConstant.schDoc['schId']).collection('schoolLessons').doc();


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
    'tmb':thumbnail,
    'note':note,
    'srt':srt,
    'slide':slides,
    'title':_title.text.trim(),
    'desc':_section.text.trim(),
    'sk':sk,
    'vid':video,
    'ts':DateTime.now().toString(),
    'like':0,
    'comm':0,
    'view':0,
    'down':0,
    'ntc':0,
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

    //tell the management that this teacher has uploaded a lesson
    if(SchClassConstant.isLecturer){
      ///if this is a campus teacher

      FirebaseFirestore.instance.collection('schoolTutors')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('tutors')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic uc = value.data()!['uc'] == null?0:value.data()!['uc'];
        dynamic ud = value.data()!['ud'] == null?0:value.data()!['ud'];
        dynamic uw = value.data()!['uw'] == null?0:value.data()!['uw'];
        dynamic  um = value.data()!['um'] == null?0:value.data()!['um'];
        dynamic uy = value.data()!['uy'] == null?0:value.data()!['uy'];


        FirebaseFirestore.instance.collection('schoolTutors').doc(SchClassConstant.schDoc['schId']).collection('tutors').doc(SchClassConstant.schDoc['id']).set({
          'uc':uc + 1,
          'ud': value.data()!['day'] == DateTime.now().day?ud + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?uw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?um + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?uy + 1:1,
          'lot':DateTime.now().toString(),
          'uyr':DateTime.now().year,
          'umth':DateTime.now().month,
          'uday':DateTime.now().day,
          'uwky':Jiffy().week,


        },SetOptions(merge:  true));


        campusTeacherAnalysis(doc);


      });




    }else{
      ///if this is a high school teacher

      FirebaseFirestore.instance.collection('teachers')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('schoolTeachers')
          .doc(SchClassConstant.schDoc['id']).get().then((value) {
        dynamic uc = value.data()!['uc'] == null?0:value.data()!['uc'];
        dynamic ud = value.data()!['ud'] == null?0:value.data()!['ud'];
        dynamic uw = value.data()!['uw'] == null?0:value.data()!['uw'];
        dynamic  um = value.data()!['um'] == null?0:value.data()!['um'];
        dynamic uy = value.data()!['uy'] == null?0:value.data()!['uy'];



        FirebaseFirestore.instance.collection('teachers').doc(SchClassConstant.schDoc['schId']).collection('schoolTeachers').doc(SchClassConstant.schDoc['id']).set({
          'uc':uc + 1,
          'ud': value.data()!['day'] == DateTime.now().day?ud + 1:1,
          'uw':value.data()!['wky'] == Jiffy().week?uw + 1:1,
          'um':value.data()!['mth'] == DateTime.now().month?um + 1:1,
          'uy':value.data()!['yr'] == DateTime.now().year?uy + 1:1,
          'uyr':DateTime.now().year,
          'umth':DateTime.now().month,
          'uday':DateTime.now().day,
          'uwky':Jiffy().week,
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

    if (!snapShot.exists) {

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
        'uc':1,
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
          'uc': resultData.data()!['uc']==null?1:resultData.data()!['uc'] + 1,
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

        'wk':Jiffy().week,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'uc':1
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
          'uc': resultData.data()!['uc']==null?1:resultData.data()!['uc'] + 1,
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

        'mth':DateTime.now().month,
        'ts':DateTime.now().toString(),
        'yr':DateTime.now().year,
        'uc':1,
        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
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
          'uc': resultData.data()!['uc']==null?1:resultData.data()!['uc'] + 1,
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

        'tId':SchClassConstant.schDoc['id'],
        'schId':SchClassConstant.schDoc['schId'],
        'yr':DateTime.now().year,
        'ts':DateTime.now().toString(),
        'uc':1
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
          'uc': resultData.data()!['uc']==null?1:resultData.data()!['uc'] + 1,
          'tId':SchClassConstant.schDoc['id'],
          'schId':SchClassConstant.schDoc['schId'],
        },SetOptions(merge: true));
      });
    }



  }

}

class ShowPickedFiles extends StatelessWidget {
  ShowPickedFiles({required this.title,required this.titleText});
  final String title;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: GoogleFonts.rajdhani(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kBlackcolor,
               fontSize: kFontsize.sp,
              ),
            )),


        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.height,
            minHeight: ScreenUtil().setHeight(10),
          ),
          child: ReadMoreText(

            titleText,

            trimLines: 1,
            colorClickableText:kStabcolor,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' ...',
            trimExpandedText: ' show less',
            style:  GoogleFonts.rajdhani(
    textStyle: TextStyle(
    fontWeight: FontWeight.normal,
    color: kBlackcolor,
   fontSize: kFontsize.sp,
    ),)
          ),
        ),

      ],
    );
  }
}


class UploadText extends StatelessWidget {
  UploadText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.rajdhani(
          textStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: kTextcolorhintcolor,
           fontSize: kFontsize.sp,
          ),
        ));
  }
}
