import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sparks/Alumni/color/colors.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/contents/playingvideo.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/golive/validator.dart';
import 'package:sparks/classroom/uploadvideo/widgets/fadeheading.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/SchoolAdmin/admin_bottomAppbar.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

class SchoolAnnouncement extends StatefulWidget {
  @override
  _SchoolAnnouncementState createState() => _SchoolAnnouncementState();
}

class _SchoolAnnouncementState extends State<SchoolAnnouncement> {
  var _documents = [];

  var itemsData = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  bool _loadMoreProgress = false;
  bool moreData = false;
  late var _lastDocument;
  bool progress = false;
  String? title;
  String get fileImagePaths => 'studentsResult/${DateTime.now()}';
  bool _publishModal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAnnouncement();
  }

  File? imageUrl;
  String imagePath = '';
  String? imUrl;

  String? vUrl;
  File? videoUrl;
  String videoPath = '';
  late UploadTask uploadTask;
  String filePath = 'studentsAnnouncement/${DateTime.now()}';

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: AdminBottomBar(
              homeColor: kWhitecolor,
              newsColor: kAYellow,
              recordColor: kWhitecolor,
            ),
            body: ModalProgressHUD(
              inAsyncCall: _publishModal,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageUrl != null
                            ? BtnBorder(
                            next: () {
                              setState(() {
                                imageUrl = null;
                                imagePath = '';
                              });
                            },
                            title: kAnnRemoveImage,
                            bgColor: kGreyLightShade)
                            : BtnBorder(
                            next: () {
                              _selectImage();
                            },
                            title: kAnnPix,
                            bgColor: kGreyLightShade),
                        videoUrl != null
                            ? BtnBorder(
                            next: () {
                              setState(() {
                                videoUrl = null;
                                videoPath = '';
                              });
                            },
                            title: kAnnRemoveVideo,
                            bgColor: kMaincolor)
                            : BtnBorder(
                            next: () {
                              _selectVideo();
                            },
                            title: kAnnVideo,
                            bgColor: kMaincolor),
                      ],
                    ),
                    space(),
                    Text(
                      imagePath,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: kExpertColor,
                          fontSize: kFontSize14.sp,
                        ),
                      ),
                    ),
                    Text(
                      videoPath,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: kExpertColor,
                          fontSize: kFontSize14.sp,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Description',
                          style: GoogleFonts.rajdhani(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kHintColor,
                              fontSize: kFontsize.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _title,
                          maxLines: null,
                          maxLength: 1000,
                          cursorColor: (kMaincolor),
                          textCapitalization: TextCapitalization.sentences,
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kTopicDecoration,
                          onSaved: (String? value) {
                            title = value;
                          },
                          validator: Validator.validateSchUn,
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        postAnnouncement();
                      },
                      color: kExpertColor,
                      child: Text(
                        kSchoolStudentNoAssignment1,
                        style: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhitecolor,
                            fontSize: kFontSize14.sp,
                          ),
                        ),
                      ),
                    ),
                    space(),
                    itemsData.length == 0 && progress == false
                        ? Center(child: PlatformCircularProgressIndicator())
                        : itemsData.length == 0 && progress == true
                        ? Text('No announcement ')
                        : space(),
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _documents.length,
                        itemBuilder: (context, int index) {
                          return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(children: <Widget>[
                                Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Message',
                                            style: GoogleFonts.rajdhani(
                                              decoration:
                                              TextDecoration.underline,
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: klistnmber,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                minHeight: ScreenUtil().setHeight(
                                                    constrainedReadMoreHeight),
                                              ),
                                              child: ReadMoreText(
                                                itemsData[index]['msg'],
                                                //doc.data['desc'],
                                                trimLines: 4,
                                                colorClickableText: Colors.pink,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' .. ^',
                                                trimExpandedText: ' ^',
                                                style: GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kFbColor,
                                                    fontSize: kFontsize.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Date',
                                            style: GoogleFonts.rajdhani(
                                              decoration:
                                              TextDecoration.underline,
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: klistnmber,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            DateFormat().format(DateTime.parse(
                                                itemsData[index]['ts'])),
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: klistnmber,
                                                fontSize: kFontSize14.sp,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'By',
                                            style: GoogleFonts.rajdhani(
                                              decoration:
                                              TextDecoration.underline,
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: klistnmber,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                                            style: GoogleFonts.rajdhani(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kMaincolor,
                                                fontSize: kFontsize.sp,
                                              ),
                                            ),
                                          ),
                                          itemsData[index]['img'] == null
                                              ? Text('')
                                              : ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(
                                                kSocialVideoCurve),
                                            child:
                                            FadeInImage.assetNetwork(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                              image:
                                              ('${itemsData[index]['img']}'
                                                  .toString()),
                                              placeholder:
                                              'images/classroom/user.png',
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              itemsData[index]['vido'] == null
                                                  ? Text(
                                                'No Video',
                                                style:
                                                GoogleFonts.rajdhani(
                                                  textStyle: TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    color: kExpertColor,
                                                    fontSize:
                                                    kFontsize.sp,
                                                  ),
                                                ),
                                              )
                                                  : GestureDetector(
                                                onTap: () {
                                                  UploadVariables
                                                      .videoUrlSelected =
                                                  itemsData[index]
                                                  ['vido'];
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                          PageTransitionType
                                                              .fade,
                                                          child:
                                                          PlayingVideos()));
                                                },
                                                child: Text(
                                                  kWatchVideo,
                                                  style: GoogleFonts
                                                      .rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      color: kExpertColor,
                                                      fontSize:
                                                      kFontsize.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  if (itemsData[index]['ass'] ==
                                                      true) {
                                                    _blockMessage(index);
                                                  } else {
                                                    _unBlockMessage(index);
                                                  }
                                                },
                                                color: itemsData[index]
                                                ['ass'] ==
                                                    true
                                                    ? kLightGreen
                                                    : kFbColor,
                                                child: Text(
                                                  itemsData[index]['ass'] ==
                                                      true
                                                      ? 'Block'
                                                      : 'Unblock',
                                                  style: GoogleFonts.rajdhani(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: kWhitecolor,
                                                      fontSize: kFontSize14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                              ]));
                        }),
                    progress == true ||
                        _loadMoreProgress == true ||
                        _documents.length < SchClassConstant.streamCount
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
                  ]),
                ),
              ),
            )));
  }

  Future<void> getAnnouncement() async {
    _documents.clear();
    itemsData.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("schoolAnnouncement")
        .doc(SchClassConstant.schDoc['schId'])
        .collection('announcement')
        .orderBy('ts', descending: true)
        .limit(SchClassConstant.streamCount)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());
        });
      }
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("schoolAnnouncement")
        .doc(SchClassConstant.schDoc['schId'])
        .collection('announcement')
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(SchClassConstant.streamCount)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;
        });
      }
    }
  }

  Future<void> postAnnouncement() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      //post assignment
      setState(() {
        _publishModal = true;
      });
//check if school is attaching images or videos or both
      if ((imageUrl == null) && (videoUrl == null)) {
        _postMe();
      } else {
        print(imageUrl);
        //Post the image to storage
        if (imageUrl != null) {
          Reference ref = FirebaseStorage.instance.ref().child(filePath);

          uploadTask = ref.putFile(imageUrl!);
          SettableMetadata(
            contentType: 'images.jpg',
          );
          final TaskSnapshot downloadUrl = await uploadTask;
          imUrl = await downloadUrl.ref.getDownloadURL();
        }

        //Post the video to storage
        if (videoUrl != null) {
          Reference ref = FirebaseStorage.instance.ref().child(filePath);

          uploadTask = ref.putFile(videoUrl!);
          SettableMetadata(
            contentType: 'video.mp4',
          );
          final TaskSnapshot downloadUrl = await uploadTask;
          vUrl = await downloadUrl.ref.getDownloadURL();
        }

        _postMe();
      }
    }
  }

  void _blockMessage(int index) {
    FirebaseFirestore.instance
        .collection('schoolAnnouncement')
        .doc(itemsData[index]['schId'])
        .collection('announcement')
        .doc(itemsData[index]['id'])
        .set({
      'ass': false,
    }, SetOptions(merge: true));
    getAnnouncement();
  }

  void _unBlockMessage(int index) {
    FirebaseFirestore.instance
        .collection('schoolAnnouncement')
        .doc(itemsData[index]['schId'])
        .collection('announcement')
        .doc(itemsData[index]['id'])
        .set({'ass': true, 'ts': DateTime.now().toString()},
        SetOptions(merge: true));
    getAnnouncement();
  }

  Future<void> _selectImage() async {
    // imageUrl =
    //     await FilePicker.getFile(type: FileType.image, allowCompression: true);

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    ) as Future<FilePickerResult>);

    File file = File(result.files.single.path!);

    imageUrl = file;

    if (imageUrl == null) {
      SchClassConstant.displayToastError(title: 'No image was picked');
    } else {
      setState(() {
        imagePath = imageUrl!.path;
      });
    }
  }

  Future<void> _selectVideo() async {
    // videoUrl =
    //     await FilePicker.getFile(type: FileType.video, allowCompression: true);

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    ) as Future<FilePickerResult>);

    File file = File(result.files.single.path!);

    videoUrl = file;

    if (videoUrl == null) {
      SchClassConstant.displayToastError(title: 'No video was picked');
    } else {
      setState(() {
        videoPath = videoUrl!.path;
      });
    }
  }

  void _postMe() {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('schoolAnnouncement')
          .doc(SchClassConstant.schDoc['schId'])
          .collection('announcement')
          .doc();
      docRef.set({
        'id': docRef.id,
        'ts': DateTime.now().toString(),
        'schId': SchClassConstant.schDoc['schId'],
        'msg': title,
        'fn': SchClassConstant.schDoc['fn'],
        'ln': SchClassConstant.schDoc['ln'],
        'ass': true,
        'img': imUrl,
        'vido': vUrl
      });

      setState(() {
        _publishModal = false;
        _title.clear();
        videoUrl = null;
        videoPath = '';
        imageUrl = null;
        imagePath = '';
      });
      getAnnouncement();
      SchClassConstant.displayToastCorrect(title: kPostSuccess);
    } catch (e) {
      setState(() {
        _publishModal = false;
      });
      SchClassConstant.displayToastError(title: kError);
    }
  }
}
