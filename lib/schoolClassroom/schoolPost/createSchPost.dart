import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/static_variables/static_variables.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';
import 'package:sparks/classroom/courses/constants.dart';
import 'package:sparks/classroom/courses/next_button.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/schoolClassroom/schClassConstant.dart';

import 'package:sparks/schoolClassroom/schoolPost/postViewers.dart';
import 'package:sparks/schoolClassroom/schoolPost/reelsCamera.dart';

class CreateSchoolPost extends StatefulWidget {
  @override
  _CreateSchoolPostState createState() => _CreateSchoolPostState();
}

class _CreateSchoolPostState extends State<CreateSchoolPost> {
  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
    );
  }

  Color btnColor = klistnmber;
  List<Color> bgColor = [
    kBg1,
    kBg2,
    kBg3,
    kBg4,
    kBg5,
    kBg6,
    kBg7,
    kBg8,
    kBg9,
    kBg10,
  ];
  Color fillColor = kBg1;
  List<Widget> getColors() {
    List<Widget> list = [];
    for (var i = 0; i < bgColor.length; i++) {
      Widget w = Column(
        children: [
          GestureDetector(
            onTap: () => getFillColor(i),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: bgColor[i],
                  borderRadius: BorderRadius.circular(4.0)),
            ),
          ),
          space(),
        ],
      );
      list.add(w);
    }
    return list;
  }

  void getFillColor(int i) {
    setState(() {
      fillColor = bgColor[i];
    });
  }

  String? post;
  String contentPath = '';
  TextEditingController _post = TextEditingController();
  TextEditingController _title = TextEditingController();
  String? title;
  bool progress = false;
  List<File> result = <File>[];
  List<String>? imagesUrl = <String>[];
  File? content;
  String? contentUrl;
  late UploadTask uploadTask;
  String filePath = 'studentsPostFiles/${DateTime.now()}';
  bool showTextField = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kSappbarbacground,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Post',
                    style: GoogleFonts.rajdhani(
                      fontSize: kFontsize.sp,
                      fontWeight: FontWeight.bold,
                      color: kWhitecolor,
                    ),
                  ),
                  BtnWhiteTextColor(
                      next: () {
                        _createSchPost();
                      },
                      title: 'Post',
                      bgColor: btnColor)
                ],
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: progress,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space(),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                GlobalVariables.loggedInUserObject.pimg!,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${SchClassConstant.schDoc['fn']} ${SchClassConstant.schDoc['ln']}'
                                    .toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  fontSize: kFontsize.sp,
                                  fontWeight: FontWeight.bold,
                                  color: kBlackcolor,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlineButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => PostViewers());
                                    },
                                    icon: SvgPicture.asset(
                                        'images/classroom/world.svg'),
                                    label: Text(
                                      SchClassConstant.radioItem,
                                      style: GoogleFonts.rajdhani(
                                        fontSize: kFontsize.sp,
                                        fontWeight: FontWeight.bold,
                                        color: kBlackcolor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      space(),
                      content == null && result.length != 0
                          ? Text(
                        'You have selected ${result.length} pictures',
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          fontWeight: FontWeight.bold,
                          color: kExpertColor,
                        ),
                      )
                          : Text(
                        contentPath,
                        style: GoogleFonts.rajdhani(
                          fontSize: kFontsize.sp,
                          fontWeight: FontWeight.w500,
                          color: kExpertColor,
                        ),
                      ),
                      Wrap(
                        spacing: 3.0,
                        children: [
                          RaisedButton.icon(
                            onPressed: () {
                              getVideoPix();
                            },
                            color: kBlackcolor,
                            icon:
                            SvgPicture.asset('images/classroom/video.svg'),
                            label: Text(
                              'Content',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                              ),
                            ),
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              getMultiPix();
                            },
                            color: kBlackcolor,
                            icon: Icon(
                              Icons.image,
                              color: kFbColor,
                            ),
                            label: Text(
                              'Pictures',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                              ),
                            ),
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: SchoolReelsCamera()));
                            },
                            color: kBlackcolor,
                            icon: Icon(
                              Icons.tv_outlined,
                              color: kFbColor,
                            ),
                            label: Text(
                              'Reels',
                              style: GoogleFonts.rajdhani(
                                fontSize: kFontsize.sp,
                                fontWeight: FontWeight.bold,
                                color: kWhitecolor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      space(),
                      Visibility(
                        visible: showTextField,
                        child: TextField(
                          controller: _title,
                          maxLength: 50,
                          maxLines: null,
                          autocorrect: true,
                          cursorColor: (kMaincolor),
                          style: UploadVariables.uploadfontsize,
                          decoration: Constants.kPostDecoration,
                          onChanged: (String value) {
                            title = value;
                          },
                        ),
                      ),
                      space(),
                      Container(
                        child: TextField(
                          cursorColor: kWhitecolor,
                          controller: _post,
                          autocorrect: true,
                          maxLines: 7,
                          maxLength: 250,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.rajdhani(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: kWhitecolor,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'Share your idea',
                              hintStyle: GoogleFonts.rajdhani(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: kHintColor,
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                  borderRadius:
                                  BorderRadius.circular(kPlaylistborder)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent))),
                          onChanged: (value) {
                            post = value;
                            setState(() {
                              result.clear();
                              content = null;
                              contentPath = '';
                            });

                            if ((_post.text.isEmpty) &&
                                (result == null) &&
                                (content == null)) {
                              setState(() {
                                btnColor = klistnmber;
                                showTextField = false;
                              });
                            } else {
                              setState(() {
                                btnColor = kSelectbtncolor;
                                showTextField = false;
                              });
                            }
                          },
                        ),
                      ),
                      space(),
                      Wrap(
                        spacing: 12.0,
                        children: getColors(),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> _createSchPost() async {
    if ((_post.text.isEmpty) && (result.length == 0) && (content == null)) {
      SchClassConstant.displayToastError(title: kPostError);
    } else {
      setState(() {
        progress = true;
      });
      if (result.length == 0) {
        try {
          if (content != null) {
            Reference ref = FirebaseStorage.instance.ref().child(filePath);

            uploadTask = ref.putFile(content!);
            SettableMetadata(
              contentType: 'images.jpg',
            );
            final TaskSnapshot downloadUrl = await uploadTask;
            contentUrl = await downloadUrl.ref.getDownloadURL();
          }
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('schoolPost')
              .doc(SchClassConstant.schDoc['schId'])
              .collection('campusPost')
              .doc();

          docRef.set({
            'ts': DateTime.now().toString(),
            'uid': GlobalVariables.loggedInUserObject.id,
            'fn': SchClassConstant.schDoc['fn'],
            'ln': SchClassConstant.schDoc['ln'],
            'pimg': GlobalVariables.loggedInUserObject.pimg,
            'dept': SchClassConstant.schDoc['dept'],
            'lv': SchClassConstant.schDoc['lv'],
            'sk': SchClassConstant.schDoc['fn']
                .toString()
                .substring(0, 1)
                .toUpperCase(),
            'stId': SchClassConstant.schDoc['id'],
            'id': docRef.id,
            'schId': SchClassConstant.schDoc['schId'],
            'mpix': false,
            'txt': content == null ? true : false,
            'msg': content == null ? _post.text.trim() : null,
            'vido': content == null ? null : contentUrl,
            'bg': fillColor.value.toString(),
            'pix': null,
            'pub': SchClassConstant.radioItem == kPublic2 ? true : false,
            'title': _title.text.trim(),
            'view': 0,
            'com': 0,
            'share': 0,
            'like': 0
          });

          setState(() {
            progress = false;
            _title.clear();
            contentPath = '';
            imagesUrl = null;
            contentUrl = null;
            result.clear();
          });
          SchClassConstant.displayToastCorrect(title: 'Posted successfully');
        } catch (e) {
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: kError);
        }
      } else {
        //it is a multi image

        try {
          // _uploadMultiImages();
          if (result.isNotEmpty) {
            for (int i = 0; i < result.length; i++) {
              Reference ref = FirebaseStorage.instance.ref().child(filePath);

              uploadTask = ref.putFile(result[i]);
              SettableMetadata(
                contentType: 'images.jpg',
              );
              final TaskSnapshot downloadUrl = await uploadTask;
              String url = await downloadUrl.ref.getDownloadURL();

              imagesUrl!.add(url);
            }
          }
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('schoolPost')
              .doc(SchClassConstant.schDoc['schId'])
              .collection('campusPost')
              .doc();

          docRef.set({
            'ts': DateTime.now().toString(),
            'uid': GlobalVariables.loggedInUserObject.id,
            'fn': SchClassConstant.schDoc['fn'],
            'ln': SchClassConstant.schDoc['ln'],
            'pimg': GlobalVariables.loggedInUserObject.pimg,
            'dept': SchClassConstant.schDoc['dept'],
            'lv': SchClassConstant.schDoc['lv'],
            'sk': SchClassConstant.schDoc['fn']
                .toString()
                .substring(0, 1)
                .toUpperCase(),
            'stId': SchClassConstant.schDoc['id'],
            'id': docRef.id,
            'schId': SchClassConstant.schDoc['schId'],
            'mpix': true,
            'txt': null,
            'msg': null,
            'pix': imagesUrl,
            'ct': imagesUrl!.length,
            'bg': fillColor.value.toString(),
            'pub': SchClassConstant.radioItem == kPublic2 ? true : false,
            'title': _title.text.trim(),
            'view': 0,
            'com': 0,
            'share': 0,
            'like': 0,
          });
          setState(() {
            progress = false;
            _title.clear();
            contentPath = '';
            imagesUrl = null;
            contentUrl = null;
            result.clear();
          });
          SchClassConstant.displayToastCorrect(title: 'Posted successfully');
        } catch (e) {
          setState(() {
            progress = false;
          });
          SchClassConstant.displayToastError(title: kError);
        }
      }
    }
  }

  Future<void> getVideoPix() async {
    setState(() {
      _post.clear();
    });

    // content =
    //     await FilePicker.getFile(type: FileType.video, allowCompression: true);

    FilePickerResult result = await (FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    ) as Future<FilePickerResult>);

    content = File(result.files.single.path!);

    if (content == null) {
      SchClassConstant.displayToastError(title: 'No video was picked');
    } else {
      // User canceled the picker
      setState(() {
        contentPath = content!.path;
        btnColor = kSelectbtncolor;
        showTextField = true;
      });
    }
  }

  Future<void> getMultiPix() async {
    setState(() {
      _post.clear();
      content = null;
      result.clear();
    });

    // result = await FilePicker.getMultiFile(
    //     type: FileType.image, allowCompression: true);

    FilePickerResult result2 = await (FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
      type: FileType.image,
    ) as Future<FilePickerResult>);

    result = result2.paths.map((path) => File(path!)).toList();

    if (result.length == 0) {
      SchClassConstant.displayToastError(title: 'No image was picked');
    } else {
      // User canceled the picker
      setState(() {});
      setState(() {
        btnColor = kSelectbtncolor;
        showTextField = true;
      });
    }
  }
}
