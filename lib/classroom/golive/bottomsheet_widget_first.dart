import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparks/classroom/contents/live/content_live_post.dart';

import 'package:sparks/classroom/courses/course_landing_page.dart';

import 'package:sparks/classroom/expert_class/expert_landing_page.dart';

import 'package:sparks/classroom/golive/bottomsheet_widget_second.dart';
import 'package:sparks/classroom/golive/variable_live_modal.dart';
import 'package:sparks/classroom/golive/widget/users_friends_selected_list.dart';

import 'package:sparks/classroom/uploadvideo/bottomsheet_widget_first.dart';
import 'package:sparks/classroom/uploadvideo/widgets/variables.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';
import 'package:sparks/app_entry_and_home/dimens/dimens.dart';
import 'package:sparks/app_entry_and_home/strings/strings.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  String? file;
  String get filePaths => 'sessionvideos/${DateTime.now()}';
  String? _extension;

  //ToDo:uploading to fireBase
  _openFileExplorer() async {
    // File file = await FilePicker.getFile(
    //   type: FileType.video,
    // );

    File? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    String _path = file.toString();
    UploadVariables.fileName = file;
    _extension = file.toString().split('/').last;
    String fileName = _path.split('/').last;

    setState(() {
      UploadVariables.uploadedVideoName = fileName;
    });

    if (file == null) {
      Navigator.pop(context);
    } else {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => UploadVideoFirst());
    }
//ToDo: send to fireBase storage
    int fileSize = file!.lengthSync();
    if (fileSize <= kSVideoSize) {
      Reference ref = FirebaseStorage.instance.ref().child(filePaths);
      UploadVariables.uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: '$file/$_extension',
        ),
      );

      final TaskSnapshot downloadUrl = (await UploadVariables.uploadTask!);
      UploadVariables.url = (await downloadUrl.ref.getDownloadURL());
    } else {
      Fluttertoast.showToast(
          msg: kSCourseError2,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackcolor,
          textColor: kFbColor);
      Navigator.pop(context);
    }
  }

  bool _isVisible = true;
  bool fontScale = true;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /*final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'genericEmail',
    );*/

  String emailAddress = 'miriamnigeria44@gmail.com';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ufriends.litems.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, right: 4.0),
        child: Wrap(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 0.0, top: 6),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LiveContent()));
                      },
                      child: SvgPicture.asset(
                        'images/classroom/classroom_button.svg',
                        height: ScreenUtil().setHeight(60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => BottomSheetWidgetSecond());
              },
              leading: SvgPicture.asset(
                'images/classroom/video.svg',
                width: klistIcon.roundToDouble(),
                height: klistIcon.roundToDouble(),
              ),
              title: Text(kGolivetitle, style: Variables.textstylesmodal),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'images/classroom/uploadvideo.svg',
                width: klistIcon.roundToDouble(),
                height: klistIcon.roundToDouble(),
              ),
              title: Text(kselfpacedtitle, style: Variables.textstylesmodal),
              onTap: () {
                _openFileExplorer();
              },
            ),
            ListTile(
              onTap: () {
                /* Navigator.of(context).pushReplacement
                    (MaterialPageRoute(builder: (context) => CourseDescription()));*/
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CourseLandingPage()));
              },
              leading: SvgPicture.asset(
                'images/classroom/expertclass.svg',
                width: klistIcon.roundToDouble(),
                height: klistIcon.roundToDouble(),
              ),
              title: Text(kRecorded, style: Variables.textstylesmodal),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ExpertLandingPage()));
              },
              leading: SvgPicture.asset(
                'images/classroom/event.svg',
                width: klistIcon.roundToDouble(),
                height: klistIcon.roundToDouble(),
              ),
              title: Text(kExpertClass, style: Variables.textstylesmodal),
            ),

            /* ListTile(
                leading: SvgPicture.asset('images/classroom/event.svg',
                  width: klistIcon.roundToDouble(),
                  height: klistIcon.roundToDouble(),),
                title: Text(keventtitle,
                    style: Variables.textstylesmodal),
              ),*/
          ],
        ),
      ),
    );
  }
}
